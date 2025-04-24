import React, { useEffect, useRef, useState } from 'react';
import { MensajeChat } from '../types/MensajeChat';
import '../utils/mockSocket';

const ChatRoom: React.FC = () => {
  const [mensajes, setMensajes] = useState<MensajeChat[]>([]);
  const [input, setInput] = useState('');
  const [expulsado, setExpulsado] = useState(false);
  const ws = useRef<WebSocket | null>(null);

  useEffect(() => {
    ws.current = new WebSocket('ws://localhost:1234');

    ws.current.onmessage = (event) => {
      const data = JSON.parse(event.data);
      if (data.tipo === 'expulsion') {
        setExpulsado(true);
        ws.current?.close();
      } else if (data.tipo === 'mensaje') {
        setMensajes(prev => [...prev, data]);
      }
    };

    return () => {
      ws.current?.close();
    };
  }, []);

  const handleEnviar = () => {
    if (!ws.current || expulsado) return;

    const nuevoMensaje: MensajeChat = {
      autor: 'Yo',
      contenido: input,
      timestamp: new Date().toISOString(),
    };

    ws.current.send(JSON.stringify(nuevoMensaje));
    setInput('');
  };

  return (
    <section>
      <h2>Chat en Tiempo Real</h2>
      {expulsado ? (
        <p>🚫 Has sido expulsado del chat.</p>
      ) : (
        <>
          <div style={{ border: '1px solid #ccc', padding: '1rem', height: '200px', overflowY: 'auto' }}>
            {mensajes.map((msg, index) => (
              <p key={index}><strong>{msg.autor}:</strong> {msg.contenido}</p>
            ))}
          </div>
          <input
            type="text"
            value={input}
            onChange={e => setInput(e.target.value)}
          />
          <button onClick={handleEnviar}>Enviar</button>
        </>
      )}
    </section>
  );
};

export default ChatRoom;
