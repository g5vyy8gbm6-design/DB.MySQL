/*los denguaje de veron de valus son los datos que nos 
permiten crear, modificar, eliminar y consultar la estructura
 de la base de datos no los datos q se registran en ella
- create crear base de datos
- alter modificar la estructura de las tablas de la base de datos
- drop eliminar base de datos o tablas
- truncate
vaciar una tabla de datos y reinicia el
contador de autoincremento
- Rename cambiar el nombre de una tabla*/

/*base de datos si existe con todo
y su contenido*/
DROP DATABASE IF EXISTS tienda_adso;


-- crear base de datos
CREATE DATABASE tienda_adso
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

--UTILIZAR base creada
USE tienda_adso;

--crear tabla categorias
CREATE TABLE categorias (
    id_categoria INT NOT NULL AUTO_INCREMENT,
    Nombre VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(255) NULL,
    CONSTRAINT 	pk_categorias PRIMARY KEY (id_categoria),
    CONSTRAINT uq_categorias_nombre UNIQUE (Nombre)
    ) ENGINE = INNODB;

    --crear tabla productos

    CREATE TABLE productos (
    id_producto INT NOT NULL AUTO_INCREMENT,
    id_categoria INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Precio DECIMAL(12,2) NOT NULL,
    STOCK INT NOT NULL DEFAULT 0,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_productos PRIMARY KEY (id_producto),
    CONSTRAINT ck_productos_precio CHECK (precio > 0),
    CONSTRAINT ck_productos_stock CHECK (stock >= 0),
    
    CONSTRAINT fk_productos_categorias FOREIGN KEY (id_categoria)
    REFERENCES categorias (id_categoria)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
    ) ENGINE = INNODB;

    --CREAR TABLA CLIENTES
    CREATE TABLE cliente (
    id_cliente INT NOT NULL AUTO_INCREMENT,
    tipo_documento VARCHAR(10) NOT NULL DEFAULT "CC",
    numero_documento VARCHAR(20) not null,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(70) NOT NULL,
    email VARCHAR(170) NOT NULL,
    Telefono VARCHAR(20) NOT NULL,
    ciudad VARCHAR(20) 	NOT NULL,
    Fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT uq_cliente_documento UNIQUE (numero_documento),
    CONSTRAINT uq_cliente_email UNIQUE (email),
    --CAMPO PARA OPCIONES DE TIPO DE DOCUMENTOS
    CONSTRAINT ck_cliente_tipo_doc CHECK (tipo_documento IN ("CC","TI","CE", "PASS"))
    ) ENGINE = INNODB

 --crear tabla pedidos
CREATE TABLE pedidos (
    id_pedido INT NOT NULL AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    Fecha_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) NOT NULL DEFAULT "Pendiente",
    total VARCHAR(60) NOT NULL DEFAULT 0,
    CONSTRAINT pk_pedidos PRIMARY KEY (id_pedido),
    CONSTRAINT ck_pedidos_estado CHECK (estado IN ("Pendiente", "pagado", "enviado", "cancelado")),
    CONSTRAINT ck_pedidos_total CHECK (total > 0),
    CONSTRAINT cfk_pedidos_clientes FOREIGN KEY (id_cliente)
    	REFERENCES clientes (id_cliente)
    	ON DELETE RESTRICT
    	ON UPDATE CASCADE
) ENGINE = INNODB
    
-- CREAR TABLA DETALLE PEDIDOS
    CREATE TABLE detalle_pedido (
    id_detalle INT NOT NULL AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    Cantidad INT NOT NULL,
    Precio_unitario DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_detalle_pedido PRIMARY KEY (id_detalle),
    CONSTRAINT ck_detalle_cantidad CHECK (cantidad > 0),
    CONSTRAINT ck_detalle_precio CHECK (precio_unitario > 0),
    CONSTRAINT uq_detalle_pedido_producto UNIQUE (id_pedido, id_producto),
    CONSTRAINT fk_detalle_pedidos FOREIGN KEY (id_pedido)
    	REFERENCES pedidos (id_pedido)
    	ON DELETE CASCADE,
CONSTRAINT fk_detalle_productos FOREIGN KEY (id_producto)
    	REFERENCES productos (id_producto)
    	ON DELETE RESTRICT
) ENGINE = INNODB

-- CREAR TABLA DE USUARIOS
CREATE TABLE usuarios (
    id_usuario INT NOT NULL AUTO_INCREMENT,
    id_cliente INT NULL,
    nombre_usuario VARCHAR(50),
    email VARCHAR(100),
    pasword_hash CHAR(64) NOT NULL,
    salt CHAR(32) NOT NULL,
    rol VARCHAR(20) NOT NULL DEFAULT"CLIENTE",
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    intentos_fallidos INT NOT NULL DEFAULT 0,
    bloqueado BOOLEAN NOT NULL DEFAULT FALSE,
    ultimo_acceso DATETIME NULL,
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_usuarios PRIMARY KEY (id_usuario),
    CONSTRAINT uq_usuarios_nombre UNIQUE (nombre_usuario),
    CONSTRAINT uq_usuarios_email UNIQUE (email),
    CONSTRAINT ck_usuarios_rol CHECK (rol IN ("ADMIN", "VENDEDOR", "CLIENTE")),
    CONSTRAINT fk_usuarios_clientes FOREIGN KEY (id_cliente)
    REFERENCES clientes (id_cliente)
    ON DELETE SET NULL
    ) ENGINE = INNODB;
    

    --MIRAR LAS TABLAS DE UNA BASE DE DATOS
    SHOW TABLES;

    --DESCRIBIR la estructura de una tabla 
    DESCRIBE productos
   

   --muestra el codigo que uso para crear una tabla
   SHOW CREATE TABLE pedidos;
   

   -- CREAR DICCIONARIO DE DATOS
SELECT Table_name, constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = "tienda_adso"
ORDER BY table_name, constraint_type


   --DICCIONARIO DE COMANDOS

   1. COMANDOS PRINCIPALES Y CONTROL 

1.1 DROP DATABASE	Elimina por completo una base de datos existente
1.2 if exists	Condición de seguridad que indica "haz esto solo si el elemento existe" para evitar errores.
1.3 create	El comando principal para crear nuevos objetos (como bases de datos o tablas).
1.4 use	Selecciona la base de datos con la que deseas trabajar.

2. CONFIGURACION Y CONDICION
    2.1 CHARACTER SET	Define la codificación de caracteres que aceptará la base de datos o tabla (permite leer tildes, eñes, etc.).
    2.2 COLLATE	Define las reglas de ordenamiento y comparación de los caracteres (por ejemplo, sensibilidad a mayúsculas y minúsculas).

3. ESTRUCTURA Y TIPOS DE DATOS 
    3.1 table	Indica que se va a definir o manipular una tabla dentro de la base de datos.
    3.2 INT	Tipo de dato numérico para números enteros.
    3.3 VARCHAR	Tipo de dato para cadenas de texto de longitud variable.
    3.4 BOOLEAN	Tipo de dato lógico que solo acepta dos valores: verdadero o falso.
    3.5 NOT NULL	Regla que indica que es obligatorio llenar el espacio (no puede estar vacío).
    3.6 DEFAULT	Asigna un valor predeterminado automático a una columna si el usuario no proporciona uno.
    3.7 salt Cadena de datos aleatorios que se añade a una contraseña antes de encriptarla para hacerla más segura frente a ataques de fuerza bruta.
    3.8 CHAR Tipo de dato para una cadena de texto de longitud fija (exactamente 64 caracteres).
4. RESTRICCIONES Y RELACIONES
    4.1 CONSTRAINT	Regla que se le aplica a una columna o tabla completa para asegurar la precisión e integridad de los datos.
    4.2 pk	PRIMARY KEY (Llave primaria).
    4.3 uq	UNIQUE (Valores únicos).
    4.4 ck	CHECK (Restricción de validación personalizada).
    4.5 fk	FOREIGN KEY (Llave foránea).
    4.6 REFERENCE	Sirve para conectar una columna de tu tabla actual con la columna de otra tabla.
    4.7 ON DELETE RESTRICT	Acción referencial que prohíbe eliminar un registro principal si tiene datos dependientes asociados.
    4.8 ON DELETE CASCADE	Acción referencial que borra automáticamente los registros dependientes si se elimina el registro principal.
    4.9 ON UPDATE CASCADE	Acción referencial que actualiza automáticamente los valores dependientes si se modifica el valor del registro principal.



    9/10/2026

    --AGREGAR UNA COLUMNA A UN TABLA EXISTENTE 
    ALTER TABLE clientes 
    ADD COLUMN fecha_nacimiento DATE NULL AFTER APELLIDOS;

    -- CAMBiAR EL TIPO / TAMAÑO DE COLUMNA 
    ALTER TABLE clientes
    MODIFY COLUM telefono VARCHAR(50) NULL;

    /*Renombrar una columna CHANGE COLUMN pide nombre viejo, NUEVO NOMBRE 
    Y la definicion de la columna completa*/

    ALTER TABLE clientes
    CHANGE COLUMN ciudad ciudad_residencia VARCHAR(50) NOT NULL;


    --LA DEVOLVEMOS A LA TABLA ORIGINAL
    ALTER TABLE clientes
    CHANGE COLUMN ciudad ciudad_residencia VARCHAR(50) NOT NULL;

--ELIMINAR UNA COLUMNA DE UNA TABLA
ALTER TABLE clientes
DROP column fecha_nacimiento

--agregar una descripcion a una tabla existente
ALTER TABLE productos
ADD CONSTRAINT uq_productos_nombre UNIQUE (nombre);

--eliminar una restriccion de una tabla existente
ALTER TABLE productos
DROP INDEX uq_productos_nombre;

--CREAR INDICES PARA BUSQUEDAS MAS RAPIDAS
CREATE INDEX idx_productos_nombre ON productos (nombre);
CREATE INDEX idx_pedidos_fecha ON pedidos (Fecha_pedido);
CREATE INDEX idx_clientes_apellidos ON clientes (apellidos, nombres); --indice compuesto por dos columnas

--mirar los indices de una tabla 
SHOW INDEX FROM productos;

--HAGA EL CODIGO PARA CREAR LA TABLA LLAMADA TABLA_PRACTICA CAMPOS ID Y DETALLE
CREATE TABLE tabla_practica (
    id INT AUTO_INCREMENT PRIMARY KEY,
    detalle VARCHAR(50)
)

--INSERTAR DATOS EN LA TABLA PRACTICA
INSERT INTO tabla_practica (detalle) VALUES ("fila 1"), ("fila 2");

--borrar todas las filas de golpe y reinicia el auto increment
TRUNCATE TABLE tabla_practica;

-- cambiar el nombre de una tabla
RENAME TABLE tabla_practica TO tabla_borrar;

--eliminar tabla
DROP TABLE tabla_borrar;



