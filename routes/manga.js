const express = require('express');
const router = express.Router();
const db = require('../config/db');

router.get('/', async (req, res) => {
    try {
      const query = `
        SELECT
          P.idpedido,
          C.nombre AS cliente_nombre,
          C.apellido AS cliente_apellido,
          C.tipo_cliente,
          M.titulo AS manga_titulo,
          M.tipo_manga,
          M.volumen,
          P.cantidad,
          P.fecha,
          IFNULL(P.precio_unit, 0) AS precio_unit  -- Asegura que no sea NULL
        FROM pedidos P
        INNER JOIN clientes C ON P.idcliente = C.idcliente
        INNER JOIN mangas M ON P.idmanga = M.idmanga;
      `;
      const [manga] = await db.query(query);  
      
      res.render('index', { manga }); 
    } catch (error) {
      console.error("Error al obtener los pedidos: ", error);
      res.status(500).send("Error interno del servidor");
    }
  });

  

router.get('/create', async (req, res) => {
  try {
    const [clientes] = await db.query("SELECT * FROM clientes");
    const [mangas] = await db.query("SELECT * FROM mangas");
    res.render('create', { clientes, mangas });
  } catch (error) {
    console.error('Error al cargar el formulario de creación:', error);
    res.status(500).send('Ocurrió un error al cargar el formulario de creación.');
  }
});


router.post('/create', async (req, res) => {
  try {
    const { idcliente, idmanga, cantidad, precio_unit } = req.body;
    const precio_total = cantidad * precio_unit;

    await db.query(`
      INSERT INTO pedidos (idcliente, idmanga, cantidad, precio_unit, fecha)
      VALUES (?, ?, ?, ?, NOW())
    `, [idcliente, idmanga, cantidad, precio_unit]);

    
    res.redirect('/');
  } catch (error) {
    console.error('Error al crear el pedido:', error);
    res.status(500).send('Ocurrió un error al crear el pedido.');
  }
});




router.get('/edit/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    
    const [pedido] = await db.query("SELECT * FROM pedidos WHERE idpedido = ?", [id]);
    const [clientes] = await db.query("SELECT * FROM clientes");
    const [mangas] = await db.query("SELECT * FROM mangas");

    
    if (pedido.length > 0) {
      res.render('edit', { pedido: pedido[0], clientes, mangas });
    } else {
      res.status(404).send('Pedido no encontrado');
    }
  } catch (error) {
    console.error('Error al cargar el formulario de edición:', error);
    res.status(500).send('Ocurrió un error al cargar el formulario de edición.');
  }
});

router.post('/edit/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { idcliente, idmanga, cantidad, precio_unit } = req.body;

   
    const precio_total = cantidad * precio_unit;

    
    await db.query(`
      UPDATE pedidos
      SET idcliente = ?, idmanga = ?, cantidad = ?, precio_unit = ?, precio_total = ?
      WHERE idpedido = ?
    `, [idcliente, idmanga, cantidad, precio_unit, precio_total, id]);

    
    res.redirect('/');
  } catch (error) {
    console.error('Error al actualizar el pedido:', error);
    res.status(500).send('Ocurrió un error al actualizar el pedido.');
  }
});

router.get('/delete/:id', async (req, res) => {
  try {
    const { id } = req.params;
    await db.query("DELETE FROM pedidos WHERE idpedido = ?", [id]);
    res.redirect('/');
  } catch (error) {
    console.error('Error al eliminar el pedido:', error);
    res.status(500).send('Ocurrió un error al eliminar el pedido.');
  }
});





module.exports = router;