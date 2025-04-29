#!/bin/bash

echo "🛠️ Creando estructura del proyecto con Vite, React 19 y envío de mensajes por REST..."

# Crear carpetas
mkdir -p server
mkdir -p client

# Crear archivo del servidor
cat <<EOF > server/index.js
const express = require("express");
const http = require("http");
const WebSocket = require("ws");
const cors = require("cors");

const app = express();
const port = 4000;

app.use(cors());
app.use(express.json());

const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

// WebSocket solo para emitir mensajes
wss.on("connection", (ws) => {
  console.log("Cliente conectado");
  ws.on("close", () => {
    console.log("Cliente desconectado");
  });
});

// Endpoint para enviar mensaje a todos los WebSocket conectados
app.post("/api/message", (req, res) => {
  const { message } = req.body;
  if (!message) return res.status(400).json({ error: "Mensaje vacío" });

  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(message);
    }
  });

  res.json({ sent: true });
});

server.listen(port, () => {
  console.log(\`Servidor escuchando en http://localhost:\${port}\`);
});
EOF

# Crear cliente Vite
echo "📦 Creando frontend con Vite..."
npm create vite@latest client -- --template react-ts

cd client
npm install
npm install react@next react-dom@next

# Reemplazar App.tsx para enviar por REST
cat <<EOF > src/App.tsx
import React, { useEffect, useState } from "react";

const App: React.FC = () => {
  const [socket, setSocket] = useState<WebSocket | null>(null);
  const [messages, setMessages] = useState<string[]>([]);
  const [input, setInput] = useState("");

  useEffect(() => {
    const ws = new WebSocket("ws://localhost:4000");

    ws.onopen = () => console.log("Conectado al WebSocket");
    ws.onmessage = (event) => {
      setMessages((prev) => [...prev, event.data]);
    };

    setSocket(ws);
    return () => ws.close();
  }, []);

  const sendMessage = async () => {
    if (!input) return;
    await fetch("http://localhost:4000/api/message", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: input }),
    });
    setInput("");
  };

  return (
    <div>
      <h1>Chat REST → WebSocket</h1>
      <input value={input} onChange={(e) => setInput(e.target.value)} placeholder="Escribe un mensaje" />
      <button onClick={sendMessage}>Enviar</button>
      <div>
        {messages.map((msg, i) => (
          <p key={i}>{msg}</p>
        ))}
      </div>
    </div>
  );
};

export default App;
EOF

# Instalar dependencias del servidor
cd ../server
echo "📦 Instalando dependencias del servidor..."
npm init -y
npm install express ws cors

echo "✅ Proyecto listo para usar: mensajes se envían por REST y se reciben por WebSocket"
echo "➡️ Ejecuta 'node server/index.js' para iniciar el backend"
echo "➡️ Ejecuta 'cd client && npm run dev' para iniciar el frontend"