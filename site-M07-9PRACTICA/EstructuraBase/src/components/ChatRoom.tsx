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

  };

  const handleDescargarDocumento = () => {

  };

  return (
    <section style={{ margin: 'auto', maxWidth: '1000px', margin: '2rem auto', padding: '1rem', border: '1px solid #ddd', borderRadius: '8px', backgroundColor: '#f9fafb' }}>
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
