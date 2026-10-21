-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 22-10-2026 a las 00:14:28
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id_categoria` int(11) NOT NULL,
  `Nombre` varchar(50) NOT NULL,
  `Descripcion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id_categoria`, `Nombre`, `Descripcion`) VALUES
(1, 'tecnologia', 'computadores, perisfericos, accesorios'),
(2, 'Hogar', 'Electrodomesticos y articulos para el hogar'),
(3, 'Papeleria', 'Utiles escolares y de oficina'),
(4, 'Deportes', 'Implementos deportivos'),
(5, 'Juguetes', 'Categoria nueva, aun sin productos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL,
  `tipo_documento` varchar(10) NOT NULL DEFAULT 'CC',
  `numero_documento` varchar(20) NOT NULL,
  `nombres` varchar(50) NOT NULL,
  `apellidos` varchar(70) NOT NULL,
  `email` varchar(170) NOT NULL,
  `telefono` varchar(50) DEFAULT NULL,
  `ciudad` varchar(50) NOT NULL,
  `Fecha_registro` datetime NOT NULL DEFAULT current_timestamp()
) ;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `tipo_documento`, `numero_documento`, `nombres`, `apellidos`, `email`, `telefono`, `ciudad`, `Fecha_registro`) VALUES
(1, 'CC', '1001001001', 'Ana Maria', 'Gomez Ruiz', 'ana.gomez@correo.com', '3001112233', 'Medellin', '2026-10-14 17:06:41'),
(2, 'CC', '1002002002', 'Carlos Andres', 'Perez Diaz', 'carlos.perez@correo.com', '3012223344', 'Bogota', '2026-10-14 17:06:41'),
(3, 'CC', '1003003003', 'Luisa Fernanda', 'Martinez Rios', 'luisa.martinez@correo.com', '3023334455', 'Cali', '2026-10-14 17:06:41'),
(4, 'TI', '1004004004', 'Juan David', 'Restrepo toro', 'juan.restrepo@correo.com', '3034445566', 'Medellin', '2026-10-14 17:06:41'),
(5, 'CE', '1005005005', 'Valentina', 'Herrera Lopez', 'valentina.herrera@correo.com', '3045556677', 'Barranquilla', '2026-10-14 17:06:41'),
(6, 'CC', '1006006006', 'Santiago', 'Ramirez Castro', 'santiago.ramirez@correo.com', '3056667788', 'Bogota', '2026-10-14 17:06:41'),
(7, 'CC', '1007007007', 'Daniela', 'Ospina Vargas', 'daniela.ospina@correo.com', '3067778899', 'Medellin', '2026-10-14 17:06:41'),
(8, 'CC', '1008008008', 'Mateo', 'Londoño Giraldo', 'Mateo.londoño@correo.com', NULL, 'Pereira', '2026-10-14 17:06:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_pedido`
--

CREATE TABLE `detalle_pedido` (
  `id_detalle` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `Precio_unitario` decimal(12,2) NOT NULL
) ;

--
-- Volcado de datos para la tabla `detalle_pedido`
--

INSERT INTO `detalle_pedido` (`id_detalle`, `id_pedido`, `id_producto`, `Cantidad`, `Precio_unitario`) VALUES
(1, 1, 1, 1, 2500000.00),
(2, 1, 2, 2, 45000.00),
(3, 2, 4, 12, 650000.00),
(4, 2, 3, 1, 45000.00),
(5, 3, 8, 10, 8500.00),
(6, 3, 9, 2, 45000.00),
(7, 4, 5, 1, 220000.00),
(8, 4, 7, 2, 60000.00),
(9, 5, 11, 1, 85000.00),
(10, 6, 6, 1, 3100000.00),
(11, 6, 2, 2, 45000.00),
(12, 7, 1, 1, 2500000.00),
(13, 7, 4, 1, 650000.00),
(14, 7, 2, 1, 45000.00),
(15, 8, 10, 5, 15000.00),
(16, 8, 8, 20, 8500.00),
(17, 9, 3, 2, 180000.00),
(18, 9, 7, 1, 60000.00),
(19, 10, 11, 2, 2500000.00),
(20, 10, 9, 3, 22000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `direcciones_envio`
--

CREATE TABLE `direcciones_envio` (
  `id_direccion` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `direccion` varchar(255) NOT NULL,
  `barrio` varchar(100) DEFAULT NULL,
  `ciudad` varchar(100) NOT NULL,
  `es_principal` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id_pedido` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `Fecha_pedido` datetime NOT NULL DEFAULT current_timestamp(),
  `estado` varchar(20) NOT NULL DEFAULT 'Pendiente',
  `total` decimal(12,2) NOT NULL DEFAULT 0.00
) ;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`id_pedido`, `id_cliente`, `Fecha_pedido`, `estado`, `total`) VALUES
(1, 1, '2026-08-01 10:15:00', 'PAGADO', 2590000.00),
(2, 2, '2026-08-03 14:30:00', 'ENVIADO', 7845000.00),
(3, 1, '2026-08-10 09:00:00', 'ENVIADO', 175000.00),
(4, 3, '2026-08-15 16:45:00', 'PAGADO', 340000.00),
(5, 4, '2026-08-20 11:20:00', 'CANCELADO', 85000.00),
(6, 5, '2026-09-02 08:10:00', 'PENDIENTE', 3190000.00),
(7, 6, '2026-09-05 19:00:00', 'PAGADO', 3195000.00),
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
  `Nombre` varchar(100) NOT NULL,
  `Precio` decimal(12,2) NOT NULL,
  `STOCK` int(11) NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  `id_proveedor` int(11) DEFAULT NULL
) ;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `id_categoria`, `Nombre`, `Precio`, `STOCK`, `activo`, `fecha_registro`, `id_proveedor`) VALUES
(1, 1, 'Portatil lenovo ideapad', 2500000.00, 15, 1, '2026-10-14 15:37:29', NULL),
(2, 1, 'Mouse Inalambrco', 45000.00, 120, 1, '2026-10-14 15:37:29', NULL),
(3, 1, 'Teclado mecanico', 180000.00, 40, 1, '2026-10-14 15:37:29', NULL),
(4, 1, 'Monitor 24 pulgadas', 650000.00, 25, 1, '2026-10-14 15:37:29', NULL),
(5, 2, 'Licuadora Oster', 220000.00, 30, 1, '2026-10-14 15:37:29', NULL),
(6, 2, 'Juego de ollas', 310000.00, 18, 1, '2026-10-14 15:37:29', NULL),
(7, 2, 'Lampara led', 60000.00, 75, 1, '2026-10-14 15:37:29', NULL),
(8, 3, 'Cuaderno 100 hojas', 8500.00, 500, 1, '2026-10-14 15:37:29', NULL),
(9, 3, 'Resma de papel carta', 220000.00, 200, 1, '2026-10-14 15:37:29', NULL),
(10, 3, 'Kit de marcadores', 15000.00, 150, 1, '2026-10-14 15:37:29', NULL),
(11, 4, 'Balon de futbol', 89250.00, 60, 1, '2026-10-14 15:37:29', NULL),
(12, 4, 'Bicicleta estatica', 1260000.00, 5, 1, '2026-10-14 15:37:29', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_proveedor` int(11) NOT NULL,
  `nit` varchar(50) NOT NULL,
  `razon_social` varchar(200) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(170) NOT NULL,
  `ciudad` varchar(50) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `nombre_usuario` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `pasword_hash` char(64) NOT NULL,
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
  ADD UNIQUE KEY `uq_categorias_nombre` (`Nombre`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`),
  ADD UNIQUE KEY `uq_clientes_documento` (`numero_documento`),
  ADD UNIQUE KEY `uq_clientes_email` (`email`),
  ADD KEY `idx_clientes_apellidos` (`apellidos`,`nombres`),
  ADD KEY `idx_clientes_ciudad` (`ciudad`);

--
-- Indices de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD PRIMARY KEY (`id_detalle`),
  ADD UNIQUE KEY `uq_detalle_pedido_producto` (`id_pedido`,`id_producto`),
  ADD KEY `fk_detalle_productos` (`id_producto`);

--
-- Indices de la tabla `direcciones_envio`
--
ALTER TABLE `direcciones_envio`
  ADD PRIMARY KEY (`id_direccion`),
  ADD KEY `fk_direcciones_envio_clientes` (`id_cliente`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id_pedido`),
  ADD KEY `cfk_pedidos_clientes` (`id_cliente`),
  ADD KEY `idx_pedidos_fecha` (`Fecha_pedido`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `fk_productos_categorias` (`id_categoria`),
  ADD KEY `idx_productos_nombre` (`Nombre`),
  ADD KEY `fk_productos_proveedores` (`id_proveedor`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id_proveedor`),
  ADD UNIQUE KEY `nit` (`nit`),
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
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
  MODIFY `id_proveedor` int(11) NOT NULL AUTO_INCREMENT;

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
  ADD CONSTRAINT `fk_direcciones_envio_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `cfk_pedidos_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `fk_productos_categorias` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_productos_proveedores` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`) ON DELETE SET NULL;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
