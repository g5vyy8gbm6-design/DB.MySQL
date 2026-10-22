--TALLER 2 CLASE 2

--consultar si existe la tabla proveedores y productos
SELECT * FROM proveedores;
SELECT * FROM productos;    

/*1. Inserte 3 provedores y asignelos con UPDATE: proveedor 1 y a los productos de tecnologia, proveedor 2
a hogar y proveedor 3 a papeleria*/
INSERT INTO proveedores (id_proveedor,	nit,	razon_social,	telefono, email, ciudad, activo) VALUES
(1, "1009009009", "Proveedor 1", "3076667788", "proveedor1@correo.com", "Medellin", 1),
(2, "1009009010", "Proveedor 2", "3077778899", "proveedor2@correo.com", "Bogota", 1),
(3, "1009009011", "Proveedor 3", "3078889900", "proveedor3@correo.com", "Cali", 1);

UPDATE productos
SET id_proveedor = 1
WHERE id_categoria = (SELECT id_categoria FROM categorias WHERE nombre = "Tecnologia");
UPDATE productos
SET id_proveedor = 2
WHERE id_categoria = (SELECT id_categoria FROM categorias WHERE nombre = "Hogar");
UPDATE productos
SET id_proveedor = 3
WHERE id_categoria = (SELECT id_categoria FROM categorias WHERE nombre = "Papeleria");

/*2. liste TODOS los productos con su categoria y el nombre de su
proveedor (los que no tienen proveedor deben aparecer igual) */
SELECT p.nombre AS producto,
c.nombre AS categoria,
       pr.razon_social AS proveedor
FROM productos p
LEFT JOIN categorias c ON c.id_categoria = p.id_categoria
LEFT JOIN proveedores pr ON pr.id_proveedor = p.id_proveedor
ORDER BY c.nombre, p.nombre;

/*3. Muestre el total vendido por ciudad del cliente (sin cancelados),
ordenado de mayor a menor*/
SELECT c.ciudad, SUM(dp.cantidad * dp.precio_unitario) AS total_vendido
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido
WHERE p.estado != "CANCELADO"
GROUP BY c.ciudad
ORDER BY total_vendido DESC;

/*4.¿Cual es el producto con mas unidades vendidas? (use limit)*/
SELECT p.nombre AS producto, SUM(dp.cantidad) AS unidades_vendidas
FROM productos p
JOIN detalle_pedido dp ON p.id_producto = dp.id_producto
JOIN pedidos pe ON dp.id_pedido = pe.id_pedido
WHERE pe.estado != "CANCELADO"
GROUP BY p.id_producto, p.nombre
ORDER BY unidades_vendidas DESC
LIMIT 1;

/*
5. Liste los clientes cuyo total comprado es mayor al promedio de compra por cliente (use subconsulta en el HAVING).
*/
SELECT c.id_cliente, c.nombre, SUM(dp.cantidad * dp.precio_unitario) AS total_comprado
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido
WHERE p.estado != "CANCELADO"
GROUP BY c.id_cliente, c.nombre
HAVING SUM(dp.cantidad * dp.precio_unitario) > (SELECT AVG(total) FROM (SELECT SUM(dp2.cantidad * dp2.precio_unitario) AS total
FROM clientes c2
JOIN pedidos p2 ON c2.id_cliente = p2.id_cliente
JOIN detalle_pedido dp2 ON p2.id_pedido = dp2.id_pedido
WHERE p2.estado != "CANCELADO"
GROUP BY c2.id_cliente) AS promedios);

/*6. Liste las categorías de las que NO se ha vendido ningún producto
(use NOT EXISTS) .*/
SELECT c.nombre AS categoria
FROM categorias c
WHERE NOT EXISTS (
    SELECT 1
    FROM productos p
    JOIN detalle_pedido dp ON p.id_producto = dp.id_producto
    JOIN pedidos pe ON dp.id_pedido = pe.id_pedido
    WHERE p.id_categoria = c.id_categoria
    AND pe.estado != "CANCELADO"
);

/*7. Dentro de una transacción suba 10% el precio de los productos de Papelería,
consulte el resultado y deshaga el cambio con ROLLBACK.*/
START TRANSACTION;
UPDATE productos
SET precio = ROUND(precio * 1.10, 0)
WHERE id_categoria = (SELECT id_categoria FROM categorias WHERE nombre = "Papeleria");

ROLLBACK;
--CONSULTAR RESULTADO
SELECT * FROM productos WHERE id_categoria = (SELECT id_categoria FROM categorias WHERE nombre = "Papeleria");



/*8. Elimine los pedidos CANCELADOS y verifique que su detalle también se eliminó (ON DELETE CASCADE).*/
SELECT * FROM pedidos WHERE estado = "CANCELADO";
SELECT * FROM detalle_pedido WHERE id_pedido IN (SELECT id_pedido FROM pedidos WHERE

       DELETE FROM pedidos WHERE estado = "CANCELADO";

SELECT * FROM detalle_pedido WHERE id_pedido NOT IN (SELECT id_pedido FROM pedidos);

