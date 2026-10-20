/* el Dml nos permite manipular la base de datos en 4
acciones Crea, consultar, modificar, eliminar
Realizar consultas con select con filtros orden y
limites

joins (Inner, left, right, full emulado)
agregaaciones count sum avs min max group by, having
subconsultas
insertar datos de prurba y verificar q existen
DML = lenguaje de manipulacion de datos*/

/* Insertar datos de prueba (CRUD - C = crear)
    si se insertan datos en una tabla sedebe tener en cuenta el orden de los campos , el tipo de campos y la llave foranea
    */
    INSERT INTO categorias (nombre, descripcion)
    VALUES ("tecnologia", "computadores, perisfericos, accesorios");
    
    Hogar, Electrodomesticos y articulos para el Hogar
    Papeleria, utiles escolares y oficina
    Deportes, Implementos deportivos
    juguetes, Categioria nueva, aun sin productos

    INSERT INTO categorias (nombre, Descripcion) VALUES
    ("Hogar", "Electrodomesticos y articulos para el hogar"),
    ("Papeleria", "Utiles escolares y de oficina"),
    ("Deportes", "Implementos deportivos"),
    ("Juguetes", "Categoria nueva, aun sin productos")


--Insertar datos en una tabla con relacion

INSERT INTO productos (id_categoria, nombre, precio, stock) VALUES
    (1, "Portatil lenovo ideapad", 2500000, 15),
    (1, "Mouse Inalambrco", 45000, 120),
    (1, "Teclado mecanico", 180000,40 ),
    (1, "Monitor 24 pulgadas", 650000, 25),
    (2, "Licuadora Oster", 220000, 30),
    (2, "Juego de ollas", 310000,18 ),
    (2, "Lampara led", 60000, 75),
    (3, "Cuaderno 100 hojas", 8500, 500),
    (3, "Resma de papel carta", 220000, 200),
    (3, "Kit de marcadores", 15000,  150),
    (4, "Balon de futbol", 85000, 60),
    (4, "Bicicleta estatica", 1200000, 5);


    --Insertar datos de clientes el ultimo no tiene telefono 
    INSERT INTO clientes (tipo_documento,numero_documento,	nombres,	apellidos,	email,	telefono,	ciudad,)	 VALUES
    ("CC", "1001001001", "Ana Maria" "Gomez Ruiz", "ana.gomez@correo.com", "3001112233", "Medellin"),
    ("CC", "1002002002", "Carlos Andres" "Perez Diaz", "carlos.perez@correo.com", "3012223344", "Bogota"),
    ("CC", "1003003003", "Luisa Fernanda", "Martinez Rios", "luisa.martinez@correo.com", "3023334455", "Cali"),
    ("TI", "1004004004", "Juan David" "Restrepo toro", "juan.restrepo@correo.com", "3034445566", "Medellin"),
    ("CE", "1005005005", "Valentina" "Herrera Lopez", "valentina.herrera@correo.com", "3045556677", "Barranquilla"),
    ("CC", "1006006006", "Santiago" "Ramirez Castro", "santiago.ramirez@correo.com", "3056667788", "Bogota"),
    ("CC", "1007007007", "Daniela" "Ospina Vargas", "daniela.ospina@correo.com", "3067778899", "Medellin"),
    ("CC", "1008008008", "Mateo" "Londoño Giraldo", "Mateo.londoño@correo.com", NULL, "Pereira"),

    
    19/10/2026
    /*ajuste de tabla pedidos*/
ALTER TABLE pedidos MODIFY COLUMN total DECIMAL(12,2) NOT NULL DEFAULT 0;

ALTER TABLE PEDIDOS DROP CONSTRAINT IF EXISTS ck_pedidos_total;

ALTER TABLE pedidos ADD CONSTRAINT  ck_pedidos_total CHECK (total >= 0);


/*  pedidos vamos a realizar pedidos con 2 relaciones con clientes y productos*/
INSERT INTO pedidos (id_cliente, fecha_pedido, estado) VALUES
(1, '2026-08-01 10:15:00','PAGADO'),
(2, '2026-08-03 14:30:00','ENVIADO'),
(1, '2026-08-10 09:00:00','ENVIADO'),
(3, '2026-08-15 16:45:00','PAGADO'),
(4, '2026-08-20 11:20:00','CANCELADO'),
(5, '2026-09-02 08:10:00','PENDIENTE'),
(6, '2026-09-05 19:00:00','PAGADO'),
(2, '2026-09-12 12:00:00','PAGADO'),
(7, '2026-09-20 17:30:00','ENVIADO'),
(3, '2026-09-28 10:05:00','PENDIENTE');

/* Detalle de pedidos se maneja con 2 relaciones con productos y pedidos*/
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, precio,_unitario) VALUES
(1, 1, 1, 2500000), (1, 2, 2, 45000),
(2, 4, 12, 650000), (2, 3, 1, 45000),
(3, 8, 10, 8500), (3, 9, 2, 45000),
(4, 5, 1, 220000), (4, 7, 2, 60000),
(5, 11, 1, 85000),
(6, 6, 1, 3100000), (6, 2, 2, 45000),
(7, 1, 1, 2500000), (7, 4, 1, 650000), (7, 2, 1, 45000),
(8, 10, 5, 15000), (8, 8, 20, 8500),
(9, 3, 2, 180000), (9, 7, 1, 60000),
(10, 11, 2, 2500000), (10, 9, 3, 22000);

/* Trabajo con los datos de una base de datos */
/* Calcular el total de cada pedido con un UPDATE + colsultas correlacionada
para cada pedido "p" suma cantidad * precio de detalles*/

UPDATE pedidos p
SET p.total = (SELECT sum(d.cantidad * d.precio_unitario)
    FROM detalle_pedido d
    WHERE d.id_pedido = p.id_pedido);

    SELECT id_pedido, id_cliente, estado, total FROM pedidos;


Taller 2 DB ---------------------------------------------------------------------------------------------------------------
    /* Consultas basicas READ de una base de datos
    1 Columnas especificas con alias AS para nombrarlas mejor
    */

    SELECT nombre AS producto, precio AS precio_venta, stock AS unidades FROM productos;

    /* WHERE con operadores de comparacion y logicos AND OR NOT*/

    SELECT nombre, precio, stock
    FROM productos
    WHERE precio > 100000 AND stock >= 20;

    -- BETWEEN (rango, incluye los extremos)

    SELECT nombre, precio FROM productos
    WHERE precio BETWEEN 20000 AND 200000;

    --Lista de valores con IN
    SELECT nombres, apellidos, ciudad FROM clientes
    WHERE ciudad IN ("Medellin", "Bogota");

    -- LIKE: % cualquier cantidad de caracteres, carácter exactamente un A

SELECT nombres, apellidos, email FROM clientes
WHERE apellidos LIKE 'R%';

--IS NULLIS NOT NULL (¡NULL no se compara con =!)

SELECT nombres, apellidos FROM clientes
WHERE telefono IS NULL;

-- ORDER BY (ASC ascendente por defecto, DESC descendente)

SELECT nombre, precio FROM productos
ORDER BY precio DESC
LIMIT 3;

-- DISTINCT: valores sin repetir
SELECT DISTINCT ciudad FROM clientes ORDER BY ciudad;

-- Columnas calculadas y funciones de texto
SELECT CONCAT(nombres, apellidos) AS cliente_completo,
UPPER(ciudad) AS ciudad_mayuscula,
CHAR_LENGTH(email) AS largo_email
FROM clientes;

-- Case : logica condicional dentro de la consulta
SELECT nombre, Stock,
Case
WHEN stock < 20 THEN "Stock Bajo"
WHEN stock < 100 THEN 'Stock medio'
ELSE 'Stock alto'
END AS nivel_stock
FROM productos;

/* JOINS CONSULTAS ENTRE VARIAS TABLAS
RIGHT 3OIN: devuelve todos los registros de la tafla derecha y los registros conincidentes de la tabla izquierda
FULL JOIN: devulve todos los registros cuando hay*/


/*INNER JOIN -> solo las filas que tienen pareja en ambas tablas
LEFT JOIN > todas las de la izquierda + las parejas (o NULL)
RIGHT JOIN -> todas las de la derecha + las parejas (o NULL)
FULLJOIN -> todas las de ambas (MySQL no lo tiene: se emula con UNION)
Se usan alias cortos (p, c...) para no repetir el nombre de la tabla.
*/


--INNER JOIN: Productos con el mismo nombre en la categoría
SELECT p.nombre AS producto, c.nombre AS categoria, p.precio
FROM productos p
INNER JOIN categorias c ON c.id_categoria = p.id_categoria
ORDER BY c.nombre, p.nombre;

--INNER JOIN pedidos con el mismo nombre de cliente
SELECT pe.id_pedido, pe.fecha_pedido, pe.estado, pe.total,
	CONCAT (cl.nombres, "", cl.apellidos) AS cliente
FROM pedidos pe
INNER JOIN clientes cl ON cl.id_cliente = pe.id_cliente
ORDER BY pe.fecha_pedido;
--JOIN de 4 tablas: la "factura" detallada de cada pedido
SELECT pe.id_pedido,
CONCAT (cl.nombres, "", cl.apellidos) AS cliente,
pr.nombre AS producto,
d.cantidad,
d.precio_unitario,
d.cantidad * d.precio_unitario AS subtotal
FROM pedidos pe
INNER JOIN clientes cl ON cl.id cliente = pe.id cliente
INNER JOIN detalle_pedido d ON d.id_pedido = pe.id_pedido
INNER JOIN productos pr ON pr.id_producto = d.id_producto
ORDER BY pe.id_pedido, pr.nombre;


--LEFT JOIN TODOS LOS CLIENTES TENGAN O NO PEDIDOS
SELECT cl.nombres, cl.,apellidos, pe.id_pedido, pe.total
FROM clientes cl
LEFT JOIN pedidos pe ON pe.id_cliente = cl.id_cliente
ORDER BY cl.id_cliente;

--LEFT JOIN + IS NULL productos que nunca se han vendido
SELECT pr.nombre, pr.stock
FROM productos pr
LEFT JOIN detalle_pedido d ON d.id_producto = pr.id_producto
WHERE d.id_detalle IS NULL;


--RIGHT JOIN todas las categorias aunque no tengan productos
SELECT c.nombre AS categoria, p.nombre AS producto
FROM productos p
RIGHT JOIN categorias c ON c.id_categoria = p.id_categoria
ORDER BY c.nombre; -- juguetes debe aparecer

--FULL OUTER JOIN emulado es decir une (LEFT JOIN Y RIGHT JOIN)
SELECT c.nombre AS categoria, p.nombre AS producto
FROM categorias c LEFT JOIN productos p ON p.id_categoria = c.id_categoria
UNION
SELECT c.nombre, p.nombre
FROM categorias c RIGHT JOIN productos p ON p.id_categoria = c.id_categoria;


____________________________________________________________________________
/*FUNCIONES DE AGREGACION, GROUP BY Y HAVING
-------------------------------------------------------------------
COUNT, SUM, AVG MIN, MAX, resumen muchas filas en un solo valor.
GROUP BY => agrupa filas con el mismo valor en una columna 
 HAVING => filtra grupos (como WHERE pero para grupos).
 Regla: toda columna que no este en una funcion de agregacion debe
 ir en el GROUP BY.
*/

--Resumen general de productos 
SELECT COUNT(*) AS total_productos,
    SUM(stock) AS total_en_bodega,
    ROUND(AVG(precio), 2) AS precio_promedio,
    MIN(precio) AS precio_minimo,
    MAX(precio) AS precio_maximo
FROM productos;

--Cantidad de productos y valor del inventario por categoria
SELECT c.nombre AS categoria,
    COUNT(p.id_producto) AS categoria,
    SUM(p.id_producto) AS cantidad_productos,
    SUM(p.precio* p.stock) AS valor_inventario
    FROM categorias c
    LEFT JOIN productos p ON p.id_categoria = c.id_categoria
    GROUP BY c.nombre
    ORDER BY valor_inventario DESC;


--  TOTAL COMPRADO POR CLIENTE (SIN PEDIDOS CANCELADOS)
SELECT CONCAT(cl.nombres, " ", cl.apellidos) AS cliente,
       COUNT(pe.id_pedido) AS total_pedidos,
       SUM(pe.total) AS total_comprado
FROM clientes cl
INNER JOIN pedidos pe ON pe.id_cliente = cl.id_cliente
WHERE pe.estado <> 'CANCELADO' -- where: filtra filas antes de agrupar
GROUP BY cl.id_cliente, cl.nombres, cl.apellidos
ORDER BY total_comprado DESC;


--HAVING: clientes que han comprado mas de 1.000.000
SELECT CONCAT(cl.nombres, " ", cl.apellidos) AS cliente,
       sum(pe.total) AS total_comprado
FROM clientes cl
INNER JOIN pedidos pe ON pe.id_cliente = cl.id_cliente
WHERE pe.estado <> 'CANCELADO'
GROUP BY cl.id_cliente, cl.nombres, cl.apellidos
HAVING total_comprado > 1000000; --FILTRA LOS GRUPOS

--VENTAS POR MES
SELECT DATE_FORMAT(fecha_pedido, '%Y-%m') AS mes,
	COUNT(*) AS pedidos, 
    SUM(total) AS ventas
FROM pedidos
WHERE estado <> 'CANCELADO'
GROUP BY DATE_FORMAT(fecha_pedido, '%Y-%m') 
ORDER BY mes;

--unidades vendidas por producto
SELECT pr.nombre, SUM(d.cantidad) AS unidades_vendidas 
FROM detalle_pedido d 
INNER JOIN productos pr ON pr.id_producto = d.id_producto 
INNER JOIN pedidos pe ON pe.id_pedido = d.id_pedido
WHERE pe.estado <> 'CANCELADO' 
GROUP BY pr.id_producto, pr.nombre 
ORDER BY unidades_vendidas DESC; 

--pedidos por estado
SELECT estado, COUNT(*) AS cantidad, SUM(total) AS valor
FROM pedidos
GROUP BY estado;



_________________________________________________________________________________________________________________________
--subconsuktas una consulta dentro de otra
-- subconsultas en where (valor unico) productos mas caros que el promedio
SELECT nombre, precio
FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos);

--subconsulta con IN (listas) clientes que han hecho al menos un pedido
SELECT nombres, apellidos
FROM clientes
WHERE id_cliente IN (SELECT id_cliente FROM pedidos);

--NOT EXISTS: CATEGORIAS QUE NO TIENEN PRODUCTOS
SELECT c.nombre
FROM categorias c
WHERE NOT EXISTS (SELECT 1 FROM productos p WHERE p.id_categoria = c.id_categoria);

--subconsulta escalar en el select: numero de pedidos de cada cliente
SELECT cl.nombre, cl.apellido,
    (SELECT COUNT(*) FROM pedidos pe WHERE pe.id_cliente = cl.id_cliente) AS cantidad_pedidos
    FROM clientes cl;


--subconsulta en from (tabla derivada)promedio de compra por cliente
SELECT ROUND(AVG(t.total_cliente), 2) AS promedio_compra_por_cliente
FROM pedidos
WHERE estado <> 'CANCELADO'
GROUP BY id_cliente AS t;

/*en Mysql una tabla derivada necesita un alias (t) y no puede usar el alias en la misma consulta,
 por eso hace una subconsulta en el FROM*/

 --subconsulta correlaccionada productos mas caros que el promedio de su categoria
