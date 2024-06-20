require('dotenv').config()
const massive = require('massive');

const db = massive({
    host: process.env.HOST, 
    port: process.env.PUERTO,
    database: process.env.DB,
    user: process.env.USU,
    password: process.env.PASS
}).then(dbInstance => {
    console.log('Conexión establecida a la db');
    return dbInstance;
}).catch(err => {
    console.error('Error al conectar a la base de datos:', err);
    throw err; 
});

module.exports = db;