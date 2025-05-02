const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');

const app = express(); 
const PORT = process.env.PORT || 2000;

app.use(express.static('public'));

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));


const rutamanga = require('./routes/manga');
app.use('/', rutamanga);


app.listen(PORT, () => {
  console.log(`Servidor iniciado en http://localhost:${PORT}`);
})