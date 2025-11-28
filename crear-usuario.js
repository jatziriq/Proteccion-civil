// crear_usuarios.js
// Script para crear usuarios con contraseñas hasheadas correctamente
// Ejecuta: node crear_usuarios.js

const bcrypt = require('bcrypt');
const mysql = require('mysql2/promise');

const usuarios = [
    { nombre: 'Admin Sistema', email: 'admin@ucol.mx', password: 'password123', rol: 'admin' },
    { nombre: 'Juan Técnico', email: 'tecnico@ucol.mx', password: 'password123', rol: 'tecnico' },
    { nombre: 'María Brigadista', email: 'brigadista@ucol.mx', password: 'password123', rol: 'brigadista' },
    { nombre: 'Pedro Capacitador', email: 'capacitador@ucol.mx', password: 'password123', rol: 'capacitador' },
    { nombre: 'Ana Usuario', email: 'usuario@ucol.mx', password: 'password123', rol: 'usuario' },
    { nombre: 'José Brigadista', email: 'jose.brig@ucol.mx', password: 'password123', rol: 'brigadista' }
];

async function crearUsuarios() {
    const connection = await mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: '123456',
        database: 'proteccion_civil'
    });

    console.log('🔐 Generando contraseñas hasheadas...\n');

    try {
        // Limpiar tabla de usuarios
        await connection.execute('DELETE FROM usuarios');
        console.log('✅ Tabla usuarios limpiada\n');

        // Insertar usuarios con contraseñas correctas
        for (const usuario of usuarios) {
            const hashedPassword = await bcrypt.hash(usuario.password, 10);
            
            await connection.execute(
                'INSERT INTO usuarios (nombre, email, password, rol) VALUES (?, ?, ?, ?)',
                [usuario.nombre, usuario.email, hashedPassword, usuario.rol]
            );

            console.log(`✅ Usuario creado: ${usuario.email} (${usuario.rol})`);
            console.log(`   Password: ${usuario.password}`);
            console.log(`   Hash: ${hashedPassword}\n`);
        }

        console.log('\n🎉 ¡Todos los usuarios creados exitosamente!\n');
        console.log('📋 Usuarios disponibles:');
        console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        usuarios.forEach(u => {
            console.log(`Email: ${u.email.padEnd(25)} | Password: ${u.password} | Rol: ${u.rol}`);
        });
        console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    } catch (error) {
        console.error('❌ Error:', error.message);
    } finally {
        await connection.end();
    }
}

crearUsuarios();