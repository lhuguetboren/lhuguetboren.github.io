@echo off
chcp 65001 > nul
echo 🛠️ Creando estructura del proyecto con Vite, React 19 y envío de mensajes por REST...

REM Crear carpetas
mkdir server
mkdir client

REM Crear archivo del servidor
echo const express = require("express"); > server\index.js
echo const http = require("http"); >> server\index.js
echo const WebSocket = require("ws"); >> server\index.js
echo const cors = require("cors"); >> server\index.js
echo. >> server\index.js
echo const app = express(); >> server\index.js
echo const port = 4000; >> server\index.js
echo. >> server\index.js
echo app.use(cors()); >> server\index.js
echo app.use(express.json()); >> server\index.js
echo. >> server\index.js
echo const server = http.createServer(app); >> server\index.js
echo const wss = new WebSocket.Server({ server }); >> server\index.js
echo. >> server\index.js
echo wss.on("connection", (ws) => { >> server\index.js
echo   console.log("Cliente conectado"); >> server\index.js
echo   ws.on("close", () => { >> server\index.js
echo     console.log("Cliente desconectado"); >> server\index.js
echo   }); >> server\index.js
echo }); >> server\index.js
echo. >> server\index.js
echo app.post("/api/message", (req, res) => { >> server\index.js
echo   const ^{ message ^} = req.body; >> server\index.js
echo   if (!message^) return res.status(400).json(^{ error: "Mensaje vacío" ^}); >> server\index.js
echo. >> server\index.js
echo   wss.clients.forEach((client) => { >> server\index.js
echo     if (client.readyState === WebSocket.OPEN) { >> server\index.js
echo       client.send(message); >> server\index.js
echo     } >> server\index.js
echo   }); >> server\index.js
echo   res.json(^{ status: "Mensaje enviado" ^}); >> server\index.js
echo }); >> server\index.js
echo. >> server\index.js
echo server.listen(port, () => { >> server\index.js
echo   console.log(`Servidor escuchando en http://localhost:${port}`); >> server\index.js
echo }); >> server\index.js
