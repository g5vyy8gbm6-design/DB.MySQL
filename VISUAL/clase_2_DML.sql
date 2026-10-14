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