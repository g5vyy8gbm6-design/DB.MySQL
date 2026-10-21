--TALLER 2 CLASE 2

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

