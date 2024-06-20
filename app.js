require('dotenv').config()
const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const indexRouter = require('./routes/index');
const db = require('./db/db')

var app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

db.then(dbInstance => { 
    app.set('db', dbInstance); 
    app.use('/', indexRouter(dbInstance)); 
    
}).catch(err => {
    console.error('Error al conectar a la base de datos:', err);
    process.exit(1); 
});
module.exports = app;