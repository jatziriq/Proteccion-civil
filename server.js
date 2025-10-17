// server.js - Configurado para Railway
const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Servir archivos estáticos con rutas absolutas para Windows
app.use(express.static(path.join(__dirname, 'public')));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));  // 👈 Ruta absoluta

// Log para verificar las rutas
console.log('📁 Ruta public:', path.join(__dirname, 'public'));
console.log('📁 Ruta uploads:', path.join(__dirname, 'uploads'));

// Configuración de la base de datos con variables de entorno
const db = mysql.createConnection({
  host: process.env.MYSQLHOST || 'localhost',
  port: process.env.MYSQLPORT || 3306,
  user: process.env.MYSQLUSER || 'root',
  password: process.env.MYSQLPASSWORD || '123456',
  database: process.env.MYSQLDATABASE || 'proteccion_civil',
  charset: 'utf8mb4',
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : undefined
});

// Conectar a la base de datos con reintentos
function connectDB() {
  db.connect((err) => {
    if (err) {
      console.error('❌ Error conectando a MySQL:', err.message);
      console.log('🔄 Reintentando en 5 segundos...');
      setTimeout(connectDB, 5000);
      return;
    }
    console.log('✅ Conectado a MySQL exitosamente');
    console.log(`📊 Base de datos: ${process.env.MYSQLDATABASE || 'proteccion_civil'}`);
  });
}

connectDB();

// Manejar desconexiones
db.on('error', (err) => {
  console.error('❌ Error de MySQL:', err);
  if (err.code === 'PROTOCOL_CONNECTION_LOST') {
    connectDB();
  }
});

// ============ RUTA DE SALUD ============
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date(),
    database: db.state === 'authenticated' ? 'connected' : 'disconnected',
    environment: process.env.NODE_ENV || 'development'
  });
});

// Ruta raíz
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// ============ API NOVEDADES ============
app.get('/api/novedades', (req, res) => {
  const query = `
    SELECT id, titulo, resumen, contenido, categoria, fecha_publicacion, destacado
    FROM novedades 
    WHERE publicado = 1 
    ORDER BY destacado DESC, fecha_publicacion DESC
    LIMIT 10
  `;
  
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error en /api/novedades:', err);
      return res.status(500).json({ success: false, message: 'Error en la consulta', error: err.message });
    }
    res.json({ success: true, data: results });
  });
});

app.get('/api/novedades/:id', (req, res) => {
  const query = `
    SELECT id, titulo, resumen, contenido, categoria, fecha_publicacion, destacado
    FROM novedades 
    WHERE id = ? AND publicado = 1
  `;
  
  db.query(query, [req.params.id], (err, results) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'Error en la consulta', error: err.message });
    }
    if (results.length === 0) {
      return res.status(404).json({ success: false, message: 'Novedad no encontrada' });
    }
    res.json({ success: true, data: results[0] });
  });
});

// ============ API BRIGADAS ============
app.get('/api/brigadas', (req, res) => {
  const query = `
    SELECT id, nombre, descripcion, coordinador, email_coordinador, 
           telefono_coordinador, miembros_activos, requisitos, imagen_url
    FROM brigadas 
    WHERE activa = 1 
    ORDER BY nombre
  `;
  
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error en /api/brigadas:', err);
      return res.status(500).json({ success: false, message: 'Error en la consulta', error: err.message });
    }
    res.json({ success: true, data: results });
  });
});

app.post('/api/brigadas', (req, res) => {
  const { brigada_id, nombre_completo, email, telefono, n_cuenta, carrera, semestre, experiencia_previa, motivacion } = req.body;
  
  if (!brigada_id || !nombre_completo || !email || !telefono || !motivacion) {
    return res.status(400).json({ success: false, message: 'Faltan campos requeridos' });
  }
  
  const query = `
    INSERT INTO solicitudes_brigadistas 
    (nombre_completo, email, telefono, n_cuenta, carrera, semestre, 
     brigada_id, experiencia_previa, motivacion, estatus, fecha_solicitud)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'pendiente', NOW())
  `;
  
  db.query(query, [nombre_completo, email, telefono, n_cuenta, carrera, semestre, brigada_id, experiencia_previa, motivacion], (err, result) => {
    if (err) {
      console.error('Error en POST /api/brigadas:', err);
      return res.status(500).json({ success: false, message: 'Error al guardar', error: err.message });
    }
    res.status(201).json({
      success: true,
      message: 'Solicitud enviada exitosamente',
      solicitud_id: result.insertId
    });
  });
});

// ============ API CURSOS ============
app.get('/api/cursos', (req, res) => {
  const query = `
    SELECT c.id, c.titulo, c.descripcion, c.duracion_horas, c.cupo_maximo, 
           c.cupo_disponible, c.instructor, c.modalidad, c.fecha_inicio,
           c.fecha_fin, c.horario, c.costo, c.estatus,
           COUNT(ic.id) as total_inscritos
    FROM cursos c
    LEFT JOIN inscripciones_cursos ic ON c.id = ic.curso_id AND ic.estatus != 'cancelada'
    WHERE c.estatus IN ('programado', 'inscripciones_abiertas')
    GROUP BY c.id
    ORDER BY c.fecha_inicio
  `;
  
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error en /api/cursos:', err);
      return res.status(500).json({ success: false, message: 'Error en la consulta', error: err.message });
    }
    res.json({ success: true, data: results });
  });
});

app.post('/api/cursos', (req, res) => {
  const { curso_id, nombre_completo, email, telefono, n_cuenta, carrera, semestre, motivacion } = req.body;
  
  if (!curso_id || !nombre_completo || !email || !telefono || !motivacion) {
    return res.status(400).json({ success: false, message: 'Faltan campos requeridos' });
  }
  
  db.query('SELECT cupo_disponible, titulo FROM cursos WHERE id = ?', [curso_id], (err, results) => {
    if (err || results.length === 0) {
      return res.status(404).json({ success: false, message: 'Curso no encontrado' });
    }
    
    if (results[0].cupo_disponible <= 0) {
      return res.status(400).json({ success: false, message: 'No hay cupo disponible' });
    }
    
    const query = `
      INSERT INTO inscripciones_cursos 
      (curso_id, nombre_completo, email, telefono, n_cuenta, carrera, semestre, motivacion, estatus, fecha_inscripcion)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pendiente', NOW())
    `;
    
    db.query(query, [curso_id, nombre_completo, email, telefono, n_cuenta, carrera, semestre, motivacion], (err, result) => {
      if (err) {
        console.error('Error al inscribir:', err);
        return res.status(500).json({ success: false, message: 'Error al inscribir', error: err.message });
      }
      
      db.query('UPDATE cursos SET cupo_disponible = cupo_disponible - 1 WHERE id = ?', [curso_id]);
      
      res.status(201).json({
        success: true,
        message: 'Inscripción confirmada',
        curso: results[0].titulo,
        inscripcion_id: result.insertId
      });
    });
  });
});

// ============ API DOCUMENTOS ============
app.get('/api/documentos', (req, res) => {
  const query = `
    SELECT id, titulo, descripcion, categoria, tipo_documento, archivo_url, fecha_subida
    FROM documentos 
    WHERE vigente = 1 AND categoria = 'publico'
    ORDER BY fecha_subida DESC
  `;
  
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error en /api/documentos:', err);
      return res.status(500).json({ success: false, message: 'Error en la consulta', error: err.message });
    }
    res.json({ success: true, data: results });
  });
});

// ============ API CONTACTO ============
app.post('/api/contacto', (req, res) => {
  const { nombre, email, telefono, tipo, asunto, mensaje } = req.body;
  
  if (!nombre || !email || !asunto || !mensaje) {
    return res.status(400).json({ success: false, message: 'Faltan campos requeridos' });
  }
  
  const query = `
    INSERT INTO mensajes_contacto 
    (nombre, email, telefono, asunto, mensaje, tipo, estatus, fecha_envio)
    VALUES (?, ?, ?, ?, ?, ?, 'nuevo', NOW())
  `;
  
  db.query(query, [nombre, email, telefono, asunto, mensaje, tipo || 'consulta'], (err, result) => {
    if (err) {
      console.error('Error en /api/contacto:', err);
      return res.status(500).json({ success: false, message: 'Error al enviar', error: err.message });
    }
    
    res.status(201).json({
      success: true,
      message: 'Mensaje enviado exitosamente. Te responderemos pronto.',
      mensaje_id: result.insertId
    });
  });
});

// ============ API EMERGENCIAS ============
app.post('/api/emergencias', (req, res) => {
  const { nombre_solicitante, telefono, email, tipo_emergencia, nivel_urgencia, edificio, piso, numero_afectados, ubicacion_detallada, descripcion } = req.body;
  
  if (!nombre_solicitante || !telefono || !tipo_emergencia || !ubicacion_detallada || !descripcion) {
    return res.status(400).json({ success: false, message: 'Faltan campos requeridos' });
  }
  
  const folio = `EMG-${Date.now()}`;
  
  const query = `
    INSERT INTO emergencias 
    (folio, nombre_solicitante, telefono, email, ubicacion_detallada, edificio, piso, 
     tipo_emergencia, nivel_urgencia, descripcion, numero_afectados, estatus, fecha_reporte)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'reportada', NOW())
  `;
  
  db.query(query, [folio, nombre_solicitante, telefono, email, ubicacion_detallada, edificio, piso, tipo_emergencia, nivel_urgencia || 'media', descripcion, numero_afectados || 1], (err, result) => {
    if (err) {
      console.error('Error en /api/emergencias:', err);
      return res.status(500).json({ success: false, message: 'Error al reportar', error: err.message });
    }
    
    res.status(201).json({
      success: true,
      message: 'Emergencia reportada. Un equipo ha sido despachado.',
      folio: folio,
      emergencia_id: result.insertId,
      tipo: tipo_emergencia,
      nivel: nivel_urgencia || 'media'
    });
  });
});

app.get('/api/emergencias', (req, res) => {
  const query = `
    SELECT e.*, b.nombre as brigada_nombre
    FROM emergencias e
    LEFT JOIN brigadas b ON e.brigada_asignada = b.id
    ORDER BY e.fecha_reporte DESC
    LIMIT 50
  `;
  
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error en GET /api/emergencias:', err);
      return res.status(500).json({ success: false, message: 'Error en la consulta', error: err.message });
    }
    res.json({ success: true, data: results });
  });
});

// ============ API ESTADÍSTICAS ============
app.get('/api/estadisticas', (req, res) => {
  const query = `SELECT * FROM vista_estadisticas_generales`;
  
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error en /api/estadisticas:', err);
      return res.status(500).json({ success: false, message: 'Error en la consulta', error: err.message });
    }
    
    const stats = results[0] || {};
    res.json({
      success: true,
      data: {
        brigadistas_activos: stats.brigadistas_activos || 59,
        cursos_disponibles: 3,
        emergencias_activas: stats.emergencias_activas || 0,
        solicitudes_pendientes: stats.solicitudes_pendientes || 0
      }
    });
  });
});

// Manejo de errores 404
app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Ruta no encontrada' });
});

// Iniciar servidor
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Servidor corriendo en puerto ${PORT}`);
  console.log(`📊 API disponible en /api/`);
  console.log(`📁 Carpeta uploads servida en /uploads/`);  // 👈 Mensaje agregado
  console.log(`🌍 Entorno: ${process.env.NODE_ENV || 'development'}`);
  console.log(`⏰ Iniciado: ${new Date().toLocaleString()}`);
});