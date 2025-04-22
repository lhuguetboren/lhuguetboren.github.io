const http = require('http');
const WebSocketServer = require('websocket').server;

const server = http.createServer((req, res) => {
  res.writeHead(200);
  res.end("Servidor WebSocket amb sales");
});

const wsServer = new WebSocketServer({ httpServer: server });
const sales = {}; // Ex: { "general": [conn1, conn2], "privada": [conn3] }

wsServer.on('request', (request) => {
  const connection = request.accept(null, request.origin);
  let userInfo = { nick: null, sala: null, tipus: "usuari" };

  connection.on('message', (message) => {
    const data = JSON.parse(message.utf8Data);

    if (data.tipus === 'inici') {
      userInfo.nick = data.nick;
      userInfo.sala = data.sala;
      userInfo.tipus = data.tipusUsuari || "usuari";

      if (!sales[userInfo.sala]) sales[userInfo.sala] = [];
      sales[userInfo.sala].push({ connection, userInfo });

      broadcast(userInfo.sala, `${userInfo.nick} ha entrat a la sala`, connection);

    } else if (data.tipus === 'missatge') {
      broadcast(userInfo.sala, `${userInfo.nick}: ${data.text}`, connection);

    } else if (data.tipus === 'expulsar' && userInfo.tipus === 'moderador') {
      expulsarUsuari(userInfo.sala, data.nickExpulsat, connection);
    }
  });

  connection.on('close', () => {
    if (userInfo.sala && sales[userInfo.sala]) {
      sales[userInfo.sala] = sales[userInfo.sala].filter(c => c.connection !== connection);
      broadcast(userInfo.sala, `${userInfo.nick} ha sortit de la sala`);
    }
  });
});

function broadcast(sala, missatge, excludeConn = null) {
  if (!sales[sala]) return;
  sales[sala].forEach(({ connection }) => {
    if (connection !== excludeConn) connection.sendUTF(missatge);
  });
}

function expulsarUsuari(sala, nick, autorConn) {
  if (!sales[sala]) return;
  sales[sala].forEach(({ connection, userInfo }) => {
    if (userInfo.nick === nick) {
      connection.sendUTF(`Has estat expulsat per un moderador.`);
      connection.close();
    }
  });
}

server.listen(8089, () => {
  console.log("Servidor WS actiu al port 8089");
});
