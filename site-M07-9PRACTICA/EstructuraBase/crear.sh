#!/bin/bash

# Crear estructura de carpetas
mkdir -p src/components
mkdir -p src/pages
mkdir -p src/types

# Crear archivo de tipos
cat > src/types/MensajeChat.ts <<EOL
export type MensajeChat = {
  autor: string;
  contenido: string;
  timestamp: string;
};
EOL

# Crear componente DocumentoCompartido
cat > src/components/DocumentoCompartido.tsx <<'EOL'
import React from 'react';

type Props = {
  contenido: string;
  onChange: (texto: string) => void;
  onDescargar: () => void;
};

const DocumentoCompartido: React.FC<Props> = ({ contenido, onChange, onDescargar }) => {
  return (
    <div style={{ marginTop: '2rem' }}>
      <h3 style={{ marginBottom: '0.5rem' }}>📄 Documento Compartido</h3>
      <textarea
        value={contenido}
        onChange={e => onChange(e.target.value)}
        placeholder="Escribe algo para compartir..."
        style={{ width: '100%', height: '200px', padding: '1rem', borderRadius: '8px', border: '1px solid #ccc', fontFamily: 'monospace' }}
      />
      <button onClick={onDescargar} style={{ marginTop: '0.5rem', padding: '0.5rem 1rem', borderRadius: '6px', backgroundColor: '#2563eb', color: 'white', border: 'none' }}>
        Descargar Documento
      </button>
    </div>
  );
};

export default DocumentoCompartido;
EOL

# Crear componente ChatRoom (sin WebSocket)
cat > src/components/ChatRoom.tsx <<'EOL'
import React, { useState } from 'react';
import { MensajeChat } from '../types/MensajeChat';
import DocumentoCompartido from './DocumentoCompartido';

const ChatRoom: React.FC = () => {
  const [mensajes, setMensajes] = useState<MensajeChat[]>([]);
  const [input, setInput] = useState('');
  const [documento, setDocumento] = useState('');

  const handleEnviar = () => {
    const nuevoMensaje: MensajeChat = {
      autor: 'Yo',
      contenido: input,
      timestamp: new Date().toISOString(),
    };
    setMensajes(prev => [...prev, nuevoMensaje]);
    setInput('');
  };

  const handleDescargarChat = () => {
    const blob = new Blob(mensajes.map(m => `${m.autor}: ${m.contenido}\n`), { type: 'text/plain' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = 'chat.txt';
    link.click();
  };

  const handleDescargarDocumento = () => {
    const blob = new Blob([documento], { type: 'text/plain' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = 'documento.txt';
    link.click();
  };

  return (
    <section style={{ maxWidth: '800px', margin: '2rem auto', padding: '1rem', border: '1px solid #ddd', borderRadius: '8px', backgroundColor: '#f9fafb' }}>
      <h2 style={{ textAlign: 'center', marginBottom: '1rem' }}>💬 Chat Local</h2>
      <div style={{ border: '1px solid #ccc', borderRadius: '8px', padding: '1rem', height: '200px', overflowY: 'auto', background: '#fff', marginBottom: '1rem' }}>
        {mensajes.map((msg, index) => (
          <p key={index} style={{ margin: 0 }}><strong>{msg.autor}:</strong> {msg.contenido}</p>
        ))}
      </div>
      <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '1rem' }}>
        <input
          type="text"
          value={input}
          onChange={e => setInput(e.target.value)}
          placeholder="Escribe un mensaje..."
          style={{ flexGrow: 1, padding: '0.5rem', borderRadius: '6px', border: '1px solid #ccc' }}
        />
        <button onClick={handleEnviar} style={{ padding: '0.5rem 1rem', borderRadius: '6px', backgroundColor: '#22c55e', color: 'white', border: 'none' }}>Enviar</button>
        <button onClick={handleDescargarChat} style={{ padding: '0.5rem 1rem', borderRadius: '6px', backgroundColor: '#3b82f6', color: 'white', border: 'none' }}>Descargar Chat</button>
      </div>

      <DocumentoCompartido
        contenido={documento}
        onChange={setDocumento}
        onDescargar={handleDescargarDocumento}
      />
    </section>
  );
};

export default ChatRoom;
EOL

# Crear página ChatPage
cat > src/pages/ChatPage.tsx <<EOL
import React from 'react';
import ChatRoom from '../components/ChatRoom';

const ChatPage: React.FC = () => {
  return (
    <main>
      <ChatRoom />
    </main>
  );
};

export default ChatPage;
EOL

echo "✅ Estructura de componentes creada sin WebSocket."
