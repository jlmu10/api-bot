var express = require('express');

module.exports = (db) => {
  const router = express.Router();

  router.get('/', function(req, res, next) {
      db.insumo.direccion.find()
      .then(direccion => {  // Ejemplo de consulta
          res.json(direccion);
      })
      .catch(err => {
          res.status(500).send('Error al obtener usuarios');
      });
  });

  router.post('/validarUsuario', function(req, res, next) {
    db.insumo.direccion.find()
    .then(direccion => {  // Ejemplo de consulta
        res.json(direccion);
    })
    .catch(err => {
        res.status(500).send('Error al obtener usuarios');
    });
});


  return router;
};