/*Cree la tabla "proveedores" con: id proveedor (PK autoincremental),
 nit (obligatorio y único),razon_social (obligatorio), telefono,
  email (único), ciudad y activo (booleano, por defecto TRUE).*/

CREATE TABLE proveedores (
id_proveedor INT NOT NULL AUTO_INCREMENT,
nit VARCHAR(50) NOT NULL UNIQUE,
razon_social VARCHAR(200) NOT NULL,
telefono VARCHAR(20),
email VARCHAR(170) NOT NULL,
ciudad VARCHAR(50),
activo BOOLEAN DEFAULT TRUE,
CONSTRAINT pk_provedores PRIMARY KEY (id_proveedor),
CONSTRAINT uq_proveedor_nit UNIQUE (nit),
CONSTRAINT uq_proveedor_email UNIQUE (email)
) ENGINE = INNODB;


/*Agregue a "productos" la columna id proveedor (opcional) y
 su llave foránea hacia proveedores con ON DELETE SET NULL.*/

ALTER TABLE productos
ADD COLUMN id_proveedor INT NULL,
ADD CONSTRAINT fk_productos_proveedores FOREIGN KEY (id_proveedor)
REFERENCES proveedores (id_proveedor)
ON DELETE SET NULL



/*Cree la tabla "direcciones_envio": id direccion [(PK), id cliente
(FK a clientes con ON DELETE CASCADE), direccion (obligatoria)
barrio, ciudad (obligatoria) y es principal (booleano, defecto FALSE).*/

CREATE TABLE direcciones_envio (
id_direccion INT NOT NULL AUTO_INCREMENT,
id_cliente INT NULL,
direccion VARCHAR(255) NOT NULL,
barrio VARCHAR(100), 
ciudad VARCHAR(100) NOT NULL,
es_principal BOOLEAN DEFAULT FALSE,
CONSTRAINT pk_direcciones_envio PRIMARY KEY (id_direccion),
CONSTRAINT fk_direcciones_envio_clientes FOREIGN KEY (id_cliente)
    REFERENCES 	clientes (id_cliente)
    	ON DELETE RESTRICT
    	 ON UPDATE CASCADE
    ) ENGINE = INNODB



/*Agregue a "productos" una restricción CHECK llamada
 ck_productos_precio_max que impida precios mayores a 50.000.000.*/

 ALTER TABLE productos
ADD CONSTRAINT ck_producto_precio_max CHECK (precio<=50000000);


/*Cree un índice llamado idx_clientes_ciudad sobre clientes (ciudad).*/

CREATE INDEX idx_clientes_ciudad ON clientes (ciudad);


/*Cree una tabla "pruebas' con dos columnas, renómbrela a "pruebas_old" y finalmente elimínela. 
Verifique con SHOW TABLES.*/

CREATE TABLE pruebas (
id prueba INT NOT NULL AUTO_INCREMENT,
verificacion VARCHAR(50) NOT NULL,

    CONSTRAINT pk_pruebas PRIMARY KEY (id_prueba)

) ENGINE = INOOBD


-- renombrar tabla 
RENAME TABLE pruebas TO pruebas_old;

--eliminar tabla activo
DROP TABLE pruebas_old




