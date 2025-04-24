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
