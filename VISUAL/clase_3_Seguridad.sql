/*clase 3 seguridad DB
objetivo: evidenciar que las contraseñas esten ENCRIPTADAS (HASH Y SALT)
y aplicar de seguridad sobre los datos
1. hash vs cifrado
2. contraseñas con HASH + SALT (SHA2)
3. procedimiento para registrar usuarios, hacer login y cambiar clave
4. Cifrado reversible para datos sencibles (AES)
5. auditorias con TRIGGER
6. Vistas que ocultan datos sencibles
7. Usuarios y roles de MYSQL con minimo privilegio (GRANT / REVOKE)
8. Prevencion de inyecciones SQL con consultas preparadas (SQL INJECTION)*/

/* 1- HASH vs CIFRADO para contraseñas
- convierte un texto en una huella de longitud fija 
-No se puede revertir. Para validar el login se calcula el HASH de la clave escrita y se compara con el guardado
-SALT texto aleatorio distinto para cada usuario que se mezcla con la clave antes de el hash asi dos usuarios con
 la misma clave
no tendran el mismo hash y se frusta la rebunda de tablas
-CIFRADO (dos vias) para datos sencibles que hay que volver a leer 
-con una llave se cifra y con la misma llave se descifra 
*nunca guarda contraseñas en segundo plano*/

--Demostacion del texto siempre da el mismo hash
SELECT SHA2("Clave123*", 256) AS HASH_1;
SELECT SHA2("Clave123*", 256) AS HASH_2;

--Demostracion utilizando SALT misma clave salt distintos = hash distinto
SELECT SHA2(CONCAT("a1b2c3", "Clave123*"), 256) AS hash_usuario_A;
SELECT SHA2(CONCAT("a9y8x7", "Clave123*"), 256) AS hash_usuario_B;

--Generar un slat aleatorio de 32 caracteres hexadecimal
mezclamos UUID (identificador unico) + RAND() (numero al azar) + la hora con milisegundos y 
--tomamos los 32 caracteres del resultado 
--en MYSQL 8 existe HEX (RANDOM_BYTES(16)) mas robusto pero mariadb no lo tiene 
SELECT LEFT (SHA2(CONCAT(UUID(), RAND(), NOW(6)), 256),32) AS salt_aleatorio;

/* 2- LO QUE NUNCA SE DEBE HACER CON CONTRASEÑAS (solo para mostrar el riesgo)
si alguien roba la base de datos o un empleado curioso consulta la tabla veria las claves de todos
INSERT INTO usuarios (...) VALUES (..., "Miclave123, ...); --!MAL
*/
/* 3- Procedimiento almacenados de autenticacion 
-Centralizamos la logica de seguridad en procedimientos la aplicacion solo llama a estos procedimientos 
DELIMITER cambia el fin de la sentencia a // para poder usar ; dentro del procedimiento

*/

DROP PROCEDURE IF EXISTS sp_registrar_usuario;
DROP PROCEDURE IF EXISTS sp_login_usuario;
DROP PROCEDURE IF EXISTS sp_cambiar_password;

DELIMITER //
--3.1 Registrar usuario: valida la politica de contraseñas genera slat y guarda el hash
CREATE PROCEDURE sp_registrar_usuario(
    IN p_nombre_usuario VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(100),
    IN p_rol VARCHAR(20), 
    IN p_id_cliente INT
)

BEGIN
    DECLARE v_salt CHAR(32);

--Politica de contraseñas minimo 8 caracteres una mayuscula y un numero
--tiene Mayuscula si la clave es igual a su version en minuscula, no tiene 
--se compara em BYNARY por que la collation "ci" considera iguales A y a
IF CHAR_LENGTH(p_password) < 8
OR CAST(p_password AS BINARY) = CAST(LOWER(p_password) AS BINARY)
OR p_password NOT REGEXP '[0-9]' THEN 
SIGNAL SQLSTATE "45000"
SET MESSAGE_TEXT = "la contraseña debe tener minimo 8 , caracteres, una mayuscula y un numero";
END IF;

SET v_salt = LEFT(SHA2(CONCAT(UUID(), RAND(), NOW(6)), 256), 32);--genera un salt aleatorio de 32 caracteres

INSERT INTO usuarios (id_cliente, nombre_usuario, email, password_hash, salt, rol)
VALUES (p_id_cliente, 
        p_nombre_usuario,
        p_email, 
        SHA2(CONCAT(v_salt, p_password), 256), 
        v_salt,
         p_rol);

END //

--3.2 login compara hashes cuenta intentos fallidos y bloquea el 3 intento 
CREATE PROCEDURE sp_login(
    IN p_nombre_usuario VARCHAR(50),
    IN p_password VARCHAR(100)
    OUT p_resultado VARCHAR (100)

)
BEGIN
DECLARE v_id INT DEFAULT NULL;
DECLARE v_hash CHAR (64);
DECLARE v_salt CHAR (32);
DECLARE v_bloqueado BOOLEAN;
DECLARE v_intentos INT;

--Si el select no encuentra el usuario, no hay error: v_id queda NULL
DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_id = NULL;