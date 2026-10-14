/* el Dml nos permite manipular la base de datos en 4
acciones Crea, consultar, modificar, eliminar
Realizar consultas con select con filtros orden y
limites
4567
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
    