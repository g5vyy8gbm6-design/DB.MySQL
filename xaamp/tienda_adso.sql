-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 27-10-2026 a las 22:57:57
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tienda_adso`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login` (IN `p_nombre_usuario` VARCHAR(50), IN `p_password` VARCHAR(100), OUT `p_resultado` VARCHAR(100))   BEGIN
DECLARE v_id INT DEFAULT NULL;
DECLARE v_hash CHAR (64);  
DECLARE v_salt CHAR (32); 
DECLARE v_bloqueado BOOLEAN;
DECLARE v_intentos INT;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_id = NULL;

SELECT id_usuario, password_hash, salt, bloqueado, intentos_fallidos
INTO v_id, v_hash, v_salt, v_bloqueado, v_intentos
FROM usuarios
WHERE nombre_usuario = p_nombre_usuario AND activo = true; 

IF v_id IS NULL THEN

    SET p_resultado = 'Usuario o contraseña incorrectos';


ELSEIF v_bloqueado THEN 
SET p_resultado = "usuario Bloqueado. contacte al administrador";

ELSEIF v_hash = SHA2(CONCAT(v_salt, p_password), 256) THEN
UPDATE usuarios 
SET intentos_fallidos = 0, ultimo_acceso = NOW()
WHERE id_usuario = v_id;
SET p_resultado = "Acceso concedido";

ELSE
UPDATE usuarios
SET intentos_fallidos = v_intentos + 1,
bloqueado = (v_intentos +1 >= 3) 
WHERE id_usuario = v_id;
SET p_resultado = "Usuario o contraseña incorrectos";
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_usuario` (IN `p_nombre_usuario` VARCHAR(50), IN `p_email` VARCHAR(100), IN `p_password` VARCHAR(100), IN `p_rol` VARCHAR(20), IN `p_id_cliente` INT)   BEGIN
    DECLARE v_salt CHAR(32);

IF CHAR_LENGTH(p_password) < 8
OR CAST(p_password AS BINARY) = CAST(LOWER(p_password) AS BINARY)
OR p_password NOT REGEXP '[0-9]' THEN 
SIGNAL SQLSTATE "45000"
SET MESSAGE_TEXT = "la contraseña debe tener minimo 8 , caracteres, una mayuscula y un numero";
END IF;

SET v_salt = LEFT(SHA2(CONCAT(UUID(), RAND(), NOW(6)), 256), 32);

INSERT INTO usuarios (id_cliente, nombre_usuario, email, password_hash, salt, rol)
VALUES (p_id_cliente, 
        p_nombre_usuario,
        p_email, 
        SHA2(CONCAT(v_salt, p_password), 256), 
        v_salt,
         p_rol);

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id_categoria` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id_categoria`, `nombre`, `descripcion`) VALUES
(1, 'tecnologia', 'Computadores, perisfericos, accesorios'),
(2, 'Hogar', 'Electrodomesticos y articulos para el hogar'),
(3, 'Papeleria', 'utiles escolares y de oficina'),
(4, 'Deportes', 'Implementos deportivos'),
(5, 'Juguetes', 'Categoria nueva, aun sin productos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL,
  `tipo_de_documento` varchar(3) NOT NULL DEFAULT 'CC',
  `numero_de_documento` decimal(12,2) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telefono` varchar(50) DEFAULT NULL,
  `ciudad` varchar(50) NOT NULL,
  `fecha_de_registro` datetime NOT NULL DEFAULT current_timestamp()
) ;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `tipo_de_documento`, `numero_de_documento`, `nombre`, `apellido`, `email`, `telefono`, `ciudad`, `fecha_de_registro`) VALUES
(1, 'CC', 1001001001.00, 'Ana Maria', 'Gomez Ruiz', 'ana.gomez@correo.com', '3001112233', 'Medellin', '2026-10-14 17:02:57'),
(2, 'CC', 1002002002.00, 'Carlos Andres', 'Perez Diaz', 'carlos.perez@correo.com', '30022223344', 'Bogota', '2026-10-14 17:02:57'),
(3, 'CC', 1003003003.00, 'Luisa Fernanda', 'Martinez Rios', 'luisa.martinez@correo.com', '30023334455', 'Cali', '2026-10-14 17:02:57'),
(4, 'TI', 1004004004.00, 'Juan David', 'Restrepo Toro', 'juan.restrepo@correo.com', '3034445566', 'Medellin', '2026-10-14 17:02:57'),
(5, 'CE', 1005005005.00, 'Valentina', 'Herrera Lopez', 'valentina.herrera@correo.com', '3045556677', 'Barranquilla', '2026-10-14 17:02:57'),
(6, 'CC', 1006006006.00, 'Santiago', 'Ramirez Castro', 'santiago.ramirez@correo.com', '3056667788', 'Bogota', '2026-10-14 17:02:57'),
(7, 'CC', 1007007007.00, 'Daniela', 'Ospina Vargas', 'daniela.ospina@correo.com', '3067778899', 'Medellin', '2026-10-14 17:02:57'),
(8, 'CC', 1008008008.00, 'Mateo', 'Londoño Giraldo', 'mateo.londoño@correo.com', NULL, 'Pereria', '2026-10-14 17:02:57');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_pedido`
--

CREATE TABLE `detalle_pedido` (
  `id_detalle` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` varchar(30) NOT NULL,
  `precio_unitario` decimal(12,2) NOT NULL
) ;

--
-- Volcado de datos para la tabla `detalle_pedido`
--

INSERT INTO `detalle_pedido` (`id_detalle`, `id_pedido`, `id_producto`, `cantidad`, `precio_unitario`) VALUES
(1, 1, 1, '1', 2500000.00),
(2, 1, 2, '2', 45000.00),
(3, 2, 4, '2', 650000.00),
(4, 2, 3, '1', 45000.00),
(5, 3, 8, '10', 8500.00),
(6, 3, 9, '2', 45000.00),
(7, 4, 5, '1', 220000.00),
(8, 4, 7, '2', 60000.00),
(10, 6, 6, '1', 3100000.00),
(11, 6, 2, '2', 45000.00),
(12, 7, 1, '1', 2500000.00),
(13, 7, 4, '1', 65000.00),
(14, 7, 2, '1', 45000.00),
(15, 8, 10, '5', 15000.00),
(16, 8, 8, '20', 8500.00),
(17, 9, 3, '2', 180000.00),
(18, 9, 7, '1', 60000.00),
(19, 10, 11, '2', 2500000.00),
(20, 10, 9, '3', 22000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direcciones_envio`
--

CREATE TABLE `direcciones_envio` (
  `id_direccion` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `direccion` varchar(100) NOT NULL,
  `barrio` varchar(100) DEFAULT NULL,
  `ciudad` varchar(100) NOT NULL,
  `es_principal` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id_pedido` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `fecha_pedido` datetime NOT NULL DEFAULT current_timestamp(),
  `estado` varchar(20) NOT NULL DEFAULT 'Pendiente',
  `total` decimal(12,2) NOT NULL DEFAULT 0.00
) ;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`id_pedido`, `id_cliente`, `fecha_pedido`, `estado`, `total`) VALUES
(1, 1, '2026-08-01 10:15:00', 'PAGADO', 2590000.00),
(2, 2, '2026-08-03 14:30:00', 'ENVIADO', 1345000.00),
(3, 1, '2026-08-10 09:00:00', 'ENVIADO', 175000.00),
(4, 3, '2026-08-15 16:45:00', 'PAGADO', 340000.00),
(6, 5, '2026-09-02 08:10:00', 'PENDIENTE', 3190000.00),
(7, 6, '2026-09-05 19:00:00', 'PAGADO', 2610000.00),
(8, 2, '2026-09-12 12:00:00', 'PAGADO', 245000.00),
(9, 7, '2026-09-20 17:30:00', 'ENVIADO', 420000.00),
(10, 3, '2026-09-28 10:05:00', 'PENDIENTE', 5066000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_proveedor` int(11) DEFAULT NULL,
  `nombre` varchar(100) NOT NULL,
  `precio` decimal(12,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `fecha_registrada` datetime NOT NULL DEFAULT current_timestamp()
) ;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `id_categoria`, `id_proveedor`, `nombre`, `precio`, `stock`, `activo`, `fecha_registrada`) VALUES
(1, 1, 1, 'Portatil lenovo Ideapad', 2500000.00, 15, 1, '2026-10-14 15:40:46'),
(2, 1, 1, 'Mouse Inalambrico', 4500.00, 120, 1, '2026-10-14 15:40:46'),
(3, 1, 1, 'Teclado Mecanico', 180000.00, 40, 1, '2026-10-14 15:40:46'),
(4, 1, 1, 'Monitor 24 pulgadas', 650000.00, 25, 1, '2026-10-14 15:40:46'),
(5, 2, 2, 'Licuadora Oster', 220000.00, 30, 1, '2026-10-14 15:40:46'),
(6, 2, 2, 'Juegos de ollas', 310000.00, 18, 1, '2026-10-14 15:40:46'),
(7, 2, 2, 'Laparas led', 60000.00, 75, 1, '2026-10-14 15:40:46'),
(8, 3, 3, 'Cuaderno 100 hojas', 8500.00, 500, 1, '2026-10-14 15:40:46'),
(9, 3, 3, 'Resma de papel carta', 22000.00, 200, 1, '2026-10-14 15:40:46'),
(10, 3, 3, 'Kit de marcadores', 15000.00, 150, 1, '2026-10-14 15:40:46'),
(11, 4, NULL, 'Balon de futbol', 89250.00, 60, 1, '2026-10-14 15:40:46'),
(12, 4, NULL, 'Bicicleta estatica', 126000.00, 5, 1, '2026-10-14 15:40:46');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_proveedor` int(11) NOT NULL,
  `nit` varchar(30) NOT NULL,
  `razon_social` varchar(30) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `email` varchar(30) NOT NULL,
  `ciudad` varchar(30) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id_proveedor`, `nit`, `razon_social`, `telefono`, `email`, `ciudad`, `activo`) VALUES
(1, '1009009009', 'Proveedor 1', '3076667788', 'proveedor1@correo.com', 'Medellin', 1),
(2, '1009009010', 'Proveedor 2', '3077778899', 'proveedor2@correo.com', 'Bogota', 1),
(3, '1009009011', 'Proveedor 3', '3078889900', 'proveedor3@correo.com', 'Cali', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `nombre_usuario` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password_hash` char(64) NOT NULL,
  `salt` char(32) NOT NULL,
  `rol` varchar(20) NOT NULL DEFAULT 'CLIENTE',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `intentos_fallidos` int(11) NOT NULL DEFAULT 0,
  `bloqueado` tinyint(1) NOT NULL DEFAULT 0,
  `ultimo_acceso` datetime DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp()
) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id_categoria`),
  ADD UNIQUE KEY `uq_categoria_nombre` (`nombre`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`),
  ADD UNIQUE KEY `uq_clientes_documento` (`numero_de_documento`),
  ADD UNIQUE KEY `uq_clientes_email` (`email`),
  ADD KEY `idx_clientes_ciudad` (`ciudad`);

--
-- Indices de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `fk_detalle_pedidos` (`id_pedido`),
  ADD KEY `fk_detalle_productos` (`id_producto`);

--
-- Indices de la tabla `direcciones_envio`
--
ALTER TABLE `direcciones_envio`
  ADD PRIMARY KEY (`id_direccion`),
  ADD KEY `fk_direciones_envio_clientes` (`id_cliente`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id_pedido`),
  ADD KEY `fk_pedidos_clientes` (`id_cliente`),
  ADD KEY `idx_pedidos_fecha` (`fecha_pedido`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `fk_productos_categorias` (`id_categoria`),
  ADD KEY `idx_productos_nombre` (`nombre`),
  ADD KEY `fk_productos_proveedores` (`id_proveedor`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id_proveedor`),
  ADD UNIQUE KEY `uq_proveedor_nit` (`nit`),
  ADD UNIQUE KEY `uq_proveedor_email` (`email`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `uq_usuarios_nombre` (`nombre_usuario`),
  ADD UNIQUE KEY `uq_usuarios_email` (`email`),
  ADD KEY `fk_usuarios_clientes` (`id_cliente`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `direcciones_envio`
--
ALTER TABLE `direcciones_envio`
  MODIFY `id_direccion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id_pedido` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id_proveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD CONSTRAINT `fk_detalle_pedidos` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_detalle_productos` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);

--
-- Filtros para la tabla `direcciones_envio`
--
ALTER TABLE `direcciones_envio`
  ADD CONSTRAINT `fk_direciones_envio_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `fk_pedidos_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `fk_productos_categorias` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_productos_proveedores` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
