const express = require('express');
const qr = require('qr-image');
const fs = require('fs')

module.exports = (db) => {
  const router = express.Router();

  router.post('/crear-qr', function(req, res, next) {
    const texto=req.body.ced
    const qr_svg = qr.image(texto, { type: 'png' });
    const qr_path = `./qr_codes/${Date.now()}.png`;  
    qr_svg.pipe(fs.createWriteStream(qr_path));
    return qr_path;
  });

  router.post('/validar_usuario', async function(req, res, next) {
    let usu = req.body.ced
    let val = JSON.stringify(req.body.val)
    console.log(val)
    console.log(req.body)
    await db.insumo.validar_usuario(usu,val)
    .then(direccion => { 
        res.json(direccion);
    })
    .catch(err => {
        console.log(err)
       // res.status(500).send('Error al obtener usuarios',err);
    });
});


  return router;
};