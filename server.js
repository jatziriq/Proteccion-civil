const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'tu_clave_secreta_super_segura_cambiala_en_produccion';

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

console.log('📁 Ruta public:', path.join(__dirname, 'public'));
console.log('📁 Ruta uploads:', path.join(__dirname, 'uploads'));

// Configuración de la base de datos
const db = mysql.createConnection({
  host: 'localhost',
  port: 3306,
  user: 'root',
  password: '123456',
  database: 'proteccion_civil',
  charset: 'utf8mb4'
});

// Conectar a la base de datos
function connectDB() {
  db.connect((err) => {
    if (err) {
      console.error('❌ Error conectando a MySQL:', err.message);
      console.log('🔄 Reintentando en 5 segundos...');
      setTimeout(connectDB, 5000);
      return;
    }
    console.log('✅ Conectado a MySQL exitosamente');
    console.log(`📊 Base de datos: proteccion_civil`);
  });
}

connectDB();

db.on('error', (err) => {
  console.error('❌ Error de MySQL:', err);
  if (err.code === 'PROTOCOL_CONNECTION_LOST') {
    connectDB();
  }
});

// Middleware de autenticación
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ success: false, message: 'Token no proporcionado' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ success: false, message: 'Token inválido' });
    }
    req.user = user;
    next();
  });
};

// ============ RUTA DE SALUD ============
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date(),
    database: db.state === 'authenticated' ? 'connected' : 'disconnected',
    environment: process.env.NODE_ENV || 'development'
  });
});

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// ============ API AUTENTICACIÓN ============

// Registro de usuario
app.post('/api/auth/register', async (req, res) => {
  const { nombre, email, password, rol } = req.body;
  
  if (!nombre || !email || !password) {
    return res.status(400).json({ success: false, message: 'Faltan campos requeridos' });
  }
  
  try {
    // Verificar si el email ya existe
    db.query('SELECT id FROM usuarios WHERE email = ?', [email], async (err, results) => {
      if (err) {
        return res.status(500).json({ success: false, message: 'Error en la base de datos' });
      }
      
      if (results.length > 0) {
        return res.status(400).json({ success: false, message: 'El email ya está registrado' });
      }
      
      // Hash de la contraseña
      const hashedPassword = await bcrypt.hash(password, 10);
      
      // Insertar usuario
      const query = 'INSERT INTO usuarios (nombre, email, password, rol) VALUES (?, ?, ?, ?)';
      db.query(query, [nombre, email, hashedPassword, rol || 'usuario'], (err, result) => {
        if (err) {
          return res.status(500).json({ success: false, message: 'Error al registrar usuario' });
        }
        
        res.status(201).json({
          success: true,
          message: 'Usuario registrado exitosamente',
          user_id: result.insertId
        });
      });
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error en el servidor' });
  }
});

// Login
app.post('/api/auth/login', (req, res) => {
  const { email, password, rol } = req.body;
  
  if (!email || !password || !rol) {
    return res.status(400).json({ success: false, message: 'Email, contraseña y rol son requeridos' });
  }
  
  const query = 'SELECT * FROM usuarios WHERE email = ? AND rol = ?';
  
  db.query(query, [email, rol], async (err, results) => {
    if (err) {
      console.error('Error en login:', err);
      return res.status(500).json({ success: false, message: 'Error en la base de datos' });
    }
    
    if (results.length === 0) {
      return res.status(401).json({ 
        success: false, 
        message: 'Credenciales inválidas o rol incorrecto' 
      });
    }
    
    const user = results[0];
    
    // Verificar contraseña
    const passwordMatch = await bcrypt.compare(password, user.password);
    
    if (!passwordMatch) {
      return res.status(401).json({ success: false, message: 'Credenciales inválidas' });
    }
    
    // Generar token JWT
    const token = jwt.sign(
      { 
        id: user.id, 
        email: user.email, 
        nombre: user.nombre,
        rol: user.rol 
      },
      JWT_SECRET,
      { expiresIn: '24h' }
    );
    
    res.json({
      success: true,
      message: 'Login exitoso',
      token: token,
      user: {
        id: user.id,
        nombre: user.nombre,
        email: user.email,
        rol: user.rol
      }
    });
  });
});

// Verificar token
app.get('/api/auth/verify', authenticateToken, (req, res) => {
  res.json({
    success: true,
    user: req.user
  });
});

// ============ API USUARIOS (para admin) ============

// Listar todos los usuarios
app.get('/api/usuarios', authenticateToken, (req, res) => {
  // Solo admin puede ver todos los usuarios
  if (req.user.rol !== 'admin') {
    return res.status(403).json({ success: false, message: 'No autorizado' });
  }

  const query = 'SELECT id, nombre, email, rol, fecha_registro FROM usuarios ORDER BY fecha_registro DESC';
  
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error obteniendo usuarios:', err);
      return res.status(500).json({ success: false, message: 'Error en la consulta' });
    }
    res.json({ success: true, data: results });
  });
});

// Eliminar usuario
app.delete('/api/usuarios/:id', authenticateToken, (req, res) => {
  if (req.user.rol !== 'admin') {
    return res.status(403).json({ success: false, message: 'No autorizado' });
  }

  db.query('DELETE FROM usuarios WHERE id = ?', [req.params.id], (err) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'Error al eliminar' });
    }
    res.json({ success: true, message: 'Usuario eliminado' });
  });
});

// ============ API BRIGADISTAS ============

// Buscar brigadistas (con filtros)
app.get('/api/brigadistas/buscar', (req, res) => {
  const { nombre, brigada_id, estado, facultad } = req.query;
  
  let query = 'SELECT * FROM vista_brigadistas_completo WHERE 1=1';
  const params = [];
  
  if (nombre) {
    query += ' AND nombre_completo LIKE ?';
    params.push(`%${nombre}%`);
  }
  
  if (brigada_id) {
    query += ' AND brigada_id = ?';
    params.push(brigada_id);
  }
  
  if (estado) {
    query += ' AND estado_disponibilidad = ?';
    params.push(estado);
  }
  
  if (facultad) {
    query += ' AND facultad LIKE ?';
    params.push(`%${facultad}%`);
  }
  
  query += ' ORDER BY nombre_completo';
  
  db.query(query, params, (err, results) => {
    if (err) {
      console.error('Error en búsqueda de brigadistas:', err);
      return res.status(500).json({ success: false, message: 'Error en la búsqueda' });
    }
    res.json({ success: true, data: results });
  });
});

// Obtener brigadista específico
app.get('/api/brigadistas/:id', (req, res) => {
  const query = 'SELECT * FROM vista_brigadistas_completo WHERE id = ?';
  
  db.query(query, [req.params.id], (err, results) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'Error en la consulta' });
    }
    if (results.length === 0) {
      return res.status(404).json({ success: false, message: 'Brigadista no encontrado' });
    }
    res.json({ success: true, data: results[0] });
  });
});

// Actualizar ubicación de brigadista
app.put('/api/brigadistas/:id/ubicacion', authenticateToken, (req, res) => {
  const { latitud, longitud, ubicacion, estado } = req.body;
  
  if (!latitud || !longitud || !ubicacion || !estado) {
    return res.status(400).json({ success: false, message: 'Faltan datos de ubicación' });
  }
  
  db.query(
    'CALL sp_actualizar_ubicacion_brigadista(?, ?, ?, ?, ?)',
    [req.params.id, latitud, longitud, ubicacion, estado],
    (err) => {
      if (err) {
        console.error('Error actualizando ubicación:', err);
        return res.status(500).json({ success: false, message: 'Error al actualizar ubicación' });
      }
      res.json({ success: true, message: 'Ubicación actualizada exitosamente' });
    }
  );
});

// Obtener brigadistas en mapa (solo con ubicación)
app.get('/api/brigadistas/mapa', (req, res) => {
  const query = `
    SELECT 
      id, nombre_completo, brigada_nombre, estado_disponibilidad,
      latitud, longitud, ubicacion_actual, telefono
    FROM vista_brigadistas_completo
    WHERE latitud IS NOT NULL AND longitud IS NOT NULL
    ORDER BY estado_disponibilidad
  `;
  
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error obteniendo brigadistas para mapa:', err);
      return res.status(500).json({ success: false, message: 'Error en la consulta' });
    }
    res.json({ success: true, data: results });
  });
});

// ============ APIs EXISTENTES (mantener las que ya tienes) ============

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
      return res.status(500).json({ success: false, message: 'Error en la consulta' });
    }
    res.json({ success: true, data: results });
  });
});

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
      return res.status(500).json({ success: false, message: 'Error en la consulta' });
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
      return res.status(500).json({ success: false, message: 'Error al guardar' });
    }
    res.status(201).json({
      success: true,
      message: 'Solicitud enviada exitosamente',
      solicitud_id: result.insertId
    });
  });
});

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
      return res.status(500).json({ success: false, message: 'Error en la consulta' });
    }
    res.json({ success: true, data: results });
  });
});

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
      return res.status(500).json({ success: false, message: 'Error al enviar' });
    }
    
    res.status(201).json({
      success: true,
      message: 'Mensaje enviado exitosamente',
      mensaje_id: result.insertId
    });
  });
});

app.get('/api/estadisticas', (req, res) => {
  const query = `SELECT * FROM vista_estadisticas_generales`;
  
  db.query(query, (err, results) => {
    if (err) {
      console.error('Error en /api/estadisticas:', err);
      return res.status(500).json({ success: false, message: 'Error en la consulta' });
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
  console.log(`🔐 Sistema de autenticación activado`);
  console.log(`🗺️  API de brigadistas con mapa disponible`);
  console.log(`⏰ Iniciado: ${new Date().toLocaleString()}`);
});