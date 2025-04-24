import { Server } from 'mock-socket';

const mockServer = new Server('ws://localhost:1234');

mockServer.on('connection', socket => {
  socket.on('message', data => {
    const mensaje = JSON.parse(data.toString());

    if (mensaje.contenido === 'expulsion') {
      socket.send(JSON.stringify({ tipo: 'expulsion' }));
      socket.close();
    } else {
      socket.send(JSON.stringify({ tipo: 'mensaje', ...mensaje }));
    }
  });
});

export default mockServer;
