-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: proteccion_civil
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auditoria_logs`
--

DROP TABLE IF EXISTS `auditoria_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int DEFAULT NULL,
  `accion` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tabla_afectada` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registro_id` int DEFAULT NULL,
  `datos_anteriores` text COLLATE utf8mb4_unicode_ci,
  `datos_nuevos` text COLLATE utf8mb4_unicode_ci,
  `ip_origen` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_accion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_usuario` (`usuario_id`),
  KEY `idx_tabla` (`tabla_afectada`),
  KEY `idx_fecha` (`fecha_accion`),
  KEY `idx_auditoria_fecha` (`fecha_accion` DESC),
  CONSTRAINT `auditoria_logs_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios_admin` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auditoria_logs`
--

LOCK TABLES `auditoria_logs` WRITE;
/*!40000 ALTER TABLE `auditoria_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brigadas`
--

DROP TABLE IF EXISTS `brigadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `brigadas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `coordinador` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_coordinador` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono_coordinador` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `miembros_activos` int DEFAULT '0',
  `requisitos` text COLLATE utf8mb4_unicode_ci,
  `imagen_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activa` tinyint(1) DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_nombre` (`nombre`),
  KEY `idx_activa` (`activa`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brigadas`
--

LOCK TABLES `brigadas` WRITE;
/*!40000 ALTER TABLE `brigadas` DISABLE KEYS */;
INSERT INTO `brigadas` VALUES (1,'Brigada de Primeros Auxilios','Atención médica básica y estabilización de pacientes en situaciones de emergencia dentro del campus universitario.','Dr. García Martínez','pgarcia@ucol.mx','312-111-1111',12,'Curso de primeros auxilios básico, Disponibilidad de tiempo, Compromiso de capacitación continua',NULL,1,'2025-10-03 14:14:51','2025-10-03 14:14:51'),(2,'Brigada de Evacuación','Coordinación y ejecución de evacuaciones ordenadas en caso de emergencias que requieran desalojo de instalaciones.','Ing. Martínez López','martinez@universidad.edu','312-222-2222',15,'Conocimiento de instalaciones del campus, Capacidad de liderazgo, Disponibilidad inmediata',NULL,1,'2025-10-03 14:14:51','2025-10-03 14:14:51'),(3,'Brigada Contra Incendios','Prevención, detección y combate de conatos de incendio, así como capacitación en uso de extintores.','Lic. Rodríguez Pérez','lrodriguez@ucol.mx','312-333-3333',10,'Curso de combate contra incendios, Buena condición física, Edad entre 18-45 años',NULL,1,'2025-10-03 14:14:51','2025-10-03 14:14:51'),(4,'Brigada de Comunicación','Difusión de información durante emergencias y coordinación de comunicación con autoridades externas.','Lic. López Sánchez','glopez@ucol.mx','312-444-4444',8,'Habilidades de comunicación, Manejo de redes sociales, Disponibilidad de dispositivo móvil',NULL,1,'2025-10-03 14:14:51','2025-10-03 14:14:51'),(5,'Brigada de Búsqueda y Rescate','Localización y rescate de personas en situaciones de emergencia dentro de las instalaciones universitarias.','Cap. Ramírez Torres','jramirez@ucol.mx','312-555-5555',14,'Excelente condición física, Curso de rescate básico, No padecer claustrofobia',NULL,1,'2025-10-03 14:14:51','2025-10-03 14:14:51');
/*!40000 ALTER TABLE `brigadas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `configuracion_correos`
--

DROP TABLE IF EXISTS `configuracion_correos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuracion_correos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo_correo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `asunto` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cuerpo` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `variables_disponibles` text COLLATE utf8mb4_unicode_ci,
  `activo` tinyint(1) DEFAULT '1',
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tipo_correo` (`tipo_correo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuracion_correos`
--

LOCK TABLES `configuracion_correos` WRITE;
/*!40000 ALTER TABLE `configuracion_correos` DISABLE KEYS */;
INSERT INTO `configuracion_correos` VALUES (1,'confirmacion_brigadista','Solicitud Recibida - Protección Civil','Estimado(a) {nombre},\n\nHemos recibido tu solicitud para unirte a la {brigada}. Tu solicitud está siendo revisada y te contactaremos pronto.\n\nFolio: {folio}\n\nSaludos,\nProtección Civil Universitaria','{nombre}, {brigada}, {folio}',1,'2025-10-03 14:14:51'),(2,'confirmacion_curso','Inscripción Confirmada - {curso}','Estimado(a) {nombre},\n\nTu inscripción al curso \"{curso}\" ha sido confirmada.\n\nFecha inicio: {fecha_inicio}\nHorario: {horario}\nUbicación: {ubicacion}\n\nTe esperamos.\n\nSaludos,\nProtección Civil Universitaria','{nombre}, {curso}, {fecha_inicio}, {horario}, {ubicacion}',1,'2025-10-03 14:14:51'),(3,'respuesta_emergencia','Reporte de Emergencia Recibido - Folio {folio}','Estimado(a) {nombre},\n\nHemos recibido tu reporte de emergencia. Un equipo está siendo despachado a tu ubicación.\n\nFolio: {folio}\nTipo: {tipo}\nUbicación: {ubicacion}\n\nMantenemos contacto.\n\nProtección Civil Universitaria','{nombre}, {folio}, {tipo}, {ubicacion}',1,'2025-10-03 14:14:51');
/*!40000 ALTER TABLE `configuracion_correos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cursos`
--

DROP TABLE IF EXISTS `cursos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cursos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `objetivo` text COLLATE utf8mb4_unicode_ci,
  `contenido` text COLLATE utf8mb4_unicode_ci,
  `duracion_horas` int NOT NULL,
  `cupo_maximo` int DEFAULT '30',
  `cupo_disponible` int DEFAULT '30',
  `instructor` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `modalidad` enum('presencial','virtual','hibrido') COLLATE utf8mb4_unicode_ci DEFAULT 'presencial',
  `ubicacion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `horario` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `requisitos` text COLLATE utf8mb4_unicode_ci,
  `costo` decimal(10,2) DEFAULT '0.00',
  `imagen_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estatus` enum('programado','inscripciones_abiertas','en_curso','finalizado','cancelado') COLLATE utf8mb4_unicode_ci DEFAULT 'programado',
  `certificado` tinyint(1) DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `creado_por` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `creado_por` (`creado_por`),
  KEY `idx_estatus` (`estatus`),
  KEY `idx_fecha_inicio` (`fecha_inicio`),
  CONSTRAINT `cursos_ibfk_1` FOREIGN KEY (`creado_por`) REFERENCES `usuarios_admin` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cursos`
--

LOCK TABLES `cursos` WRITE;
/*!40000 ALTER TABLE `cursos` DISABLE KEYS */;
INSERT INTO `cursos` VALUES (1,'Primeros Auxilios Básico','Curso teórico-práctico sobre técnicas básicas de primeros auxilios, RCP y uso de DEA.',NULL,NULL,20,30,28,'Dr. García Martínez','presencial',NULL,'2024-11-15','2024-11-30','Lunes a Viernes 16:00-18:00',NULL,0.00,NULL,'inscripciones_abiertas',1,'2025-10-03 14:14:51',NULL),(2,'Combate de Incendios Nivel I','Capacitación en prevención, detección y combate de conatos de incendio.',NULL,NULL,16,25,25,'Bombero Ramírez','presencial',NULL,'2024-12-01','2024-12-15','Martes y Jueves 15:00-17:00',NULL,0.00,NULL,'programado',1,'2025-10-03 14:14:51',NULL),(3,'Evacuación y Punto de Reunión','Técnicas y protocolos para evacuación segura de edificios.',NULL,NULL,12,40,40,'Ing. Martínez López','hibrido',NULL,'2024-12-05','2024-12-12','Miércoles y Viernes 17:00-19:00',NULL,0.00,NULL,'programado',1,'2025-10-03 14:14:51',NULL);
/*!40000 ALTER TABLE `cursos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documentos`
--

DROP TABLE IF EXISTS `documentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `categoria` enum('publico','restringido','interno') COLLATE utf8mb4_unicode_ci DEFAULT 'publico',
  `tipo_documento` enum('manual','protocolo','reporte','guia','otro') COLLATE utf8mb4_unicode_ci DEFAULT 'otro',
  `archivo_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `archivo_nombre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tamano_bytes` bigint DEFAULT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `requiere_auth` tinyint(1) DEFAULT '0',
  `descargas` int DEFAULT '0',
  `subido_por` int DEFAULT NULL,
  `fecha_subida` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `vigente` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `subido_por` (`subido_por`),
  KEY `idx_categoria` (`categoria`),
  KEY `idx_vigente` (`vigente`),
  CONSTRAINT `documentos_ibfk_1` FOREIGN KEY (`subido_por`) REFERENCES `usuarios_admin` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documentos`
--

LOCK TABLES `documentos` WRITE;
/*!40000 ALTER TABLE `documentos` DISABLE KEYS */;
INSERT INTO `documentos` VALUES (1,'Manual de Emergencias 2024','Guía completa para el manejo de situaciones de emergencia en el campus universitario','publico','manual','/docs/manual-emergencias-2024.pdf',NULL,NULL,NULL,0,0,NULL,'2025-10-03 14:14:51','2025-10-03 14:14:51',1),(2,'Protocolo de Evacuación','Procedimientos detallados para evacuación segura de edificios y áreas del campus','publico','protocolo','/docs/protocolo-evacuacion.pdf',NULL,NULL,NULL,0,0,NULL,'2025-10-03 14:14:51','2025-10-03 14:14:51',1),(3,'Plan de Contingencia COVID-19','Medidas preventivas y protocolos de actuación ante casos de COVID-19','publico','guia','/docs/covid-19-plan.pdf',NULL,NULL,NULL,0,0,NULL,'2025-10-03 14:14:51','2025-10-03 14:14:51',1),(4,'Reporte Interno Anual 2024','Documento interno con estadísticas y análisis de actividades del año','restringido','reporte','/docs/reporte-2024.pdf',NULL,NULL,NULL,1,0,NULL,'2025-10-03 14:14:51','2025-10-03 14:14:51',1),(5,'Análisis de Riesgos del Campus','Evaluación detallada de riesgos estructurales y operacionales','restringido','reporte','/docs/analisis-riesgos.pdf',NULL,NULL,NULL,1,0,NULL,'2025-10-03 14:14:51','2025-10-03 14:14:51',1);
/*!40000 ALTER TABLE `documentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emergencias`
--

DROP TABLE IF EXISTS `emergencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emergencias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `folio` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_solicitante` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ubicacion_detallada` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `edificio` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `piso` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referencia` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_emergencia` enum('medica','incendio','evacuacion','accidente','estructural','quimica','otra') COLLATE utf8mb4_unicode_ci NOT NULL,
  `nivel_urgencia` enum('baja','media','alta','critica') COLLATE utf8mb4_unicode_ci DEFAULT 'media',
  `descripcion` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero_afectados` int DEFAULT '1',
  `estatus` enum('reportada','en_camino','atendiendo','resuelta','cancelada') COLLATE utf8mb4_unicode_ci DEFAULT 'reportada',
  `brigada_asignada` int DEFAULT NULL,
  `tiempo_respuesta` int DEFAULT NULL,
  `acciones_tomadas` text COLLATE utf8mb4_unicode_ci,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `atendido_por` int DEFAULT NULL,
  `fecha_reporte` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_atencion` timestamp NULL DEFAULT NULL,
  `fecha_resolucion` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `folio` (`folio`),
  KEY `brigada_asignada` (`brigada_asignada`),
  KEY `atendido_por` (`atendido_por`),
  KEY `idx_folio` (`folio`),
  KEY `idx_estatus` (`estatus`),
  KEY `idx_tipo` (`tipo_emergencia`),
  KEY `idx_fecha` (`fecha_reporte`),
  KEY `idx_emergencias_nivel` (`nivel_urgencia`,`estatus`),
  CONSTRAINT `emergencias_ibfk_1` FOREIGN KEY (`brigada_asignada`) REFERENCES `brigadas` (`id`) ON DELETE SET NULL,
  CONSTRAINT `emergencias_ibfk_2` FOREIGN KEY (`atendido_por`) REFERENCES `usuarios_admin` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emergencias`
--

LOCK TABLES `emergencias` WRITE;
/*!40000 ALTER TABLE `emergencias` DISABLE KEYS */;
/*!40000 ALTER TABLE `emergencias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estadisticas_vistas`
--

DROP TABLE IF EXISTS `estadisticas_vistas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estadisticas_vistas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `seccion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subseccion` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` int DEFAULT NULL,
  `ip_visitante` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_visita` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `duracion_segundos` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_seccion` (`seccion`),
  KEY `idx_fecha` (`fecha_visita`),
  KEY `idx_ip` (`ip_visitante`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estadisticas_vistas`
--

LOCK TABLES `estadisticas_vistas` WRITE;
/*!40000 ALTER TABLE `estadisticas_vistas` DISABLE KEYS */;
/*!40000 ALTER TABLE `estadisticas_vistas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inscripciones_cursos`
--

DROP TABLE IF EXISTS `inscripciones_cursos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inscripciones_cursos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curso_id` int NOT NULL,
  `nombre_completo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `n_cuenta` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `carrera` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `semestre` int DEFAULT NULL,
  `motivacion` text COLLATE utf8mb4_unicode_ci,
  `estatus` enum('pendiente','confirmada','cancelada','completada') COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  `asistencia` decimal(5,2) DEFAULT '0.00',
  `calificacion` decimal(5,2) DEFAULT NULL,
  `certificado_emitido` tinyint(1) DEFAULT '0',
  `fecha_inscripcion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_confirmacion` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_curso` (`curso_id`),
  KEY `idx_estatus` (`estatus`),
  KEY `idx_email` (`email`),
  KEY `idx_inscripciones_fecha` (`fecha_inscripcion` DESC),
  CONSTRAINT `inscripciones_cursos_ibfk_1` FOREIGN KEY (`curso_id`) REFERENCES `cursos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inscripciones_cursos`
--

LOCK TABLES `inscripciones_cursos` WRITE;
/*!40000 ALTER TABLE `inscripciones_cursos` DISABLE KEYS */;
INSERT INTO `inscripciones_cursos` VALUES (1,1,'Ana Martínez Ruiz','amartinez@ucol.mx','312-444-1111','2021567','Psicología',4,'Importante saber primeros auxilios','confirmada',0.00,NULL,0,'2025-10-03 14:14:52',NULL),(2,1,'Andrea Vargas','avargas@ucol.mx','312-555-2222','2020234','Derecho',6,'Cultura de prevención','confirmada',0.00,NULL,0,'2025-10-03 14:14:52',NULL),(3,2,'Karol Navarro','knavarro@ucol.x','312-666-3333','2022001','Arquitectura',2,'Me gusta ayudar en emergencias','pendiente',0.00,NULL,0,'2025-10-03 14:14:52',NULL);
/*!40000 ALTER TABLE `inscripciones_cursos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mensajes_contacto`
--

DROP TABLE IF EXISTS `mensajes_contacto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mensajes_contacto` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `asunto` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mensaje` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo` enum('consulta','sugerencia','queja','felicitacion','otro') COLLATE utf8mb4_unicode_ci DEFAULT 'consulta',
  `estatus` enum('nuevo','leido','respondido','cerrado') COLLATE utf8mb4_unicode_ci DEFAULT 'nuevo',
  `respuesta` text COLLATE utf8mb4_unicode_ci,
  `respondido_por` int DEFAULT NULL,
  `fecha_envio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_respuesta` timestamp NULL DEFAULT NULL,
  `ip_origen` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `respondido_por` (`respondido_por`),
  KEY `idx_estatus` (`estatus`),
  KEY `idx_fecha` (`fecha_envio`),
  CONSTRAINT `mensajes_contacto_ibfk_1` FOREIGN KEY (`respondido_por`) REFERENCES `usuarios_admin` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mensajes_contacto`
--

LOCK TABLES `mensajes_contacto` WRITE;
/*!40000 ALTER TABLE `mensajes_contacto` DISABLE KEYS */;
INSERT INTO `mensajes_contacto` VALUES (1,'Roberto Sánchez','roberto@gmail.com','312-777-4444','¿Cómo unirme a brigada?','Quisiera información sobre cómo ser parte de la brigada de primeros auxilios.','consulta','nuevo',NULL,NULL,'2025-10-03 14:14:52',NULL,NULL),(2,'Patricia Morales','patricia@gmail.com','312-888-5555','Felicitaciones','Excelente respuesta durante el simulacro de ayer. ¡Felicidades al equipo!','felicitacion','nuevo',NULL,NULL,'2025-10-03 14:14:52',NULL,NULL);
/*!40000 ALTER TABLE `mensajes_contacto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `miembros_brigadas`
--

DROP TABLE IF EXISTS `miembros_brigadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `miembros_brigadas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `solicitud_id` int DEFAULT NULL,
  `brigada_id` int NOT NULL,
  `nombre_completo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n_cuenta` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_ingreso` date NOT NULL,
  `estatus` enum('activo','inactivo','baja') COLLATE utf8mb4_unicode_ci DEFAULT 'activo',
  `horas_servicio` int DEFAULT '0',
  `certificaciones` text COLLATE utf8mb4_unicode_ci,
  `fecha_baja` date DEFAULT NULL,
  `razon_baja` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `solicitud_id` (`solicitud_id`),
  KEY `idx_estatus` (`estatus`),
  KEY `idx_brigada` (`brigada_id`),
  CONSTRAINT `miembros_brigadas_ibfk_1` FOREIGN KEY (`solicitud_id`) REFERENCES `solicitudes_brigadistas` (`id`) ON DELETE SET NULL,
  CONSTRAINT `miembros_brigadas_ibfk_2` FOREIGN KEY (`brigada_id`) REFERENCES `brigadas` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `miembros_brigadas`
--

LOCK TABLES `miembros_brigadas` WRITE;
/*!40000 ALTER TABLE `miembros_brigadas` DISABLE KEYS */;
/*!40000 ALTER TABLE `miembros_brigadas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `novedades`
--

DROP TABLE IF EXISTS `novedades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `novedades` (
  `id` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `resumen` text COLLATE utf8mb4_unicode_ci,
  `contenido` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `categoria` enum('noticia','evento','aviso','logro','comunicado') COLLATE utf8mb4_unicode_ci DEFAULT 'noticia',
  `imagen_principal` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `autor` int DEFAULT NULL,
  `vistas` int DEFAULT '0',
  `destacado` tinyint(1) DEFAULT '0',
  `publicado` tinyint(1) DEFAULT '0',
  `fecha_publicacion` timestamp NULL DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `autor` (`autor`),
  KEY `idx_publicado` (`publicado`),
  KEY `idx_categoria` (`categoria`),
  KEY `idx_fecha` (`fecha_publicacion`),
  KEY `idx_destacado` (`destacado`),
  KEY `idx_novedades_destacado` (`destacado`,`publicado`,`fecha_publicacion` DESC),
  CONSTRAINT `novedades_ibfk_1` FOREIGN KEY (`autor`) REFERENCES `usuarios_admin` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `novedades`
--

LOCK TABLES `novedades` WRITE;
/*!40000 ALTER TABLE `novedades` DISABLE KEYS */;
INSERT INTO `novedades` VALUES (1,'Gran Simulacro Nacional 2024','Participamos exitosamente en el simulacro nacional con la participación de más de 5,000 personas.','El pasado 19 de septiembre, nuestra universidad participó en el Simulacro Nacional, evacuando exitosamente a más de 5,000 personas entre estudiantes, docentes y personal administrativo. El ejercicio se completó en 8 minutos, superando nuestras expectativas. Agradecemos el compromiso de toda la comunidad universitaria.','evento',NULL,NULL,0,1,1,'2025-10-03 14:14:51','2025-10-03 14:14:51','2025-10-03 14:14:51'),(2,'Nueva Ambulancia para el Campus','Se incorpora una ambulancia totalmente equipada para atención de emergencias médicas.','Gracias al apoyo de las autoridades universitarias, ahora contamos con una ambulancia de última generación equipada con desfibrilador, camilla hidráulica y equipo de soporte vital básico. Esto reduce nuestro tiempo de respuesta en emergencias médicas.','noticia',NULL,NULL,0,1,1,'2025-10-03 14:14:51','2025-10-03 14:14:51','2025-10-03 14:14:51'),(3,'Convocatoria: Curso de Primeros Auxilios','Inscripciones abiertas para el curso de primeros auxilios nivel básico.','Se abre la convocatoria para el curso de Primeros Auxilios Básico que se impartirá del 15 al 30 de noviembre. Cupo limitado a 30 personas. Los interesados pueden inscribirse en la sección de cursos.','aviso',NULL,NULL,0,0,1,'2025-10-03 14:14:51','2025-10-03 14:14:51','2025-10-03 14:14:51');
/*!40000 ALTER TABLE `novedades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solicitudes_brigadistas`
--

DROP TABLE IF EXISTS `solicitudes_brigadistas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solicitudes_brigadistas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre_completo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `n_cuenta` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `carrera` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `semestre` int DEFAULT NULL,
  `brigada_id` int NOT NULL,
  `experiencia_previa` text COLLATE utf8mb4_unicode_ci,
  `motivacion` text COLLATE utf8mb4_unicode_ci,
  `disponibilidad_horaria` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contacto_emergencia` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono_emergencia` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estatus` enum('pendiente','en_revision','aprobado','rechazado','capacitacion') COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  `comentarios_admin` text COLLATE utf8mb4_unicode_ci,
  `fecha_solicitud` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_revision` timestamp NULL DEFAULT NULL,
  `revisado_por` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `brigada_id` (`brigada_id`),
  KEY `revisado_por` (`revisado_por`),
  KEY `idx_estatus` (`estatus`),
  KEY `idx_fecha` (`fecha_solicitud`),
  KEY `idx_email` (`email`),
  KEY `idx_solicitudes_fecha` (`fecha_solicitud` DESC),
  CONSTRAINT `solicitudes_brigadistas_ibfk_1` FOREIGN KEY (`brigada_id`) REFERENCES `brigadas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `solicitudes_brigadistas_ibfk_2` FOREIGN KEY (`revisado_por`) REFERENCES `usuarios_admin` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitudes_brigadistas`
--

LOCK TABLES `solicitudes_brigadistas` WRITE;
/*!40000 ALTER TABLE `solicitudes_brigadistas` DISABLE KEYS */;
INSERT INTO `solicitudes_brigadistas` VALUES (1,'Keiry Sainz','ksainz@ucol.mx','312-111-1234','2021001','Medicina',5,1,'Curso básico de primeros auxilios','Quiero ayudar a mi comunidad',NULL,NULL,NULL,'pendiente',NULL,'2025-10-03 14:14:52',NULL,NULL),(2,'Nereyda Pérez','nperez@ucol.mx','312-222-5678','2020145','Ingeniería Civil',7,2,'Ninguna','Me interesa la seguridad del campus',NULL,NULL,NULL,'pendiente',NULL,'2025-10-03 14:14:52',NULL,NULL),(3,'Mayte Muñoz','mmunoz@ucol.mx','312-333-9012','2022089','Comunicación',3,4,'Manejo de redes sociales','Quiero difundir cultura de prevención',NULL,NULL,NULL,'pendiente',NULL,'2025-10-03 14:14:52',NULL,NULL);
/*!40000 ALTER TABLE `solicitudes_brigadistas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios_admin`
--

DROP TABLE IF EXISTS `usuarios_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios_admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_completo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rol` enum('superadmin','admin','editor') COLLATE utf8mb4_unicode_ci DEFAULT 'editor',
  `ultimo_acceso` timestamp NULL DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_username` (`username`),
  KEY `idx_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios_admin`
--

LOCK TABLES `usuarios_admin` WRITE;
/*!40000 ALTER TABLE `usuarios_admin` DISABLE KEYS */;
INSERT INTO `usuarios_admin` VALUES (1,'admin','$2b$10$rBV2kULmFDz4G/dF8Xmj8.8nYqZKPZYxvx8d7Z0F0nYqZKPZYxvx8','Administrador Principal','admin@ucol.mx','superadmin',NULL,1,'2025-10-03 14:14:51');
/*!40000 ALTER TABLE `usuarios_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vista_cursos_inscritos`
--

DROP TABLE IF EXISTS `vista_cursos_inscritos`;
/*!50001 DROP VIEW IF EXISTS `vista_cursos_inscritos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_cursos_inscritos` AS SELECT 
 1 AS `id`,
 1 AS `titulo`,
 1 AS `fecha_inicio`,
 1 AS `cupo_maximo`,
 1 AS `cupo_disponible`,
 1 AS `total_inscritos`,
 1 AS `estatus`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vista_estadisticas_generales`
--

DROP TABLE IF EXISTS `vista_estadisticas_generales`;
/*!50001 DROP VIEW IF EXISTS `vista_estadisticas_generales`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_estadisticas_generales` AS SELECT 
 1 AS `solicitudes_pendientes`,
 1 AS `inscritos_cursos`,
 1 AS `emergencias_activas`,
 1 AS `brigadistas_activos`,
 1 AS `total_vistas_novedades`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vista_vistas_secciones`
--

DROP TABLE IF EXISTS `vista_vistas_secciones`;
/*!50001 DROP VIEW IF EXISTS `vista_vistas_secciones`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_vistas_secciones` AS SELECT 
 1 AS `seccion`,
 1 AS `total_visitas`,
 1 AS `visitantes_unicos`,
 1 AS `fecha`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vista_cursos_inscritos`
--

/*!50001 DROP VIEW IF EXISTS `vista_cursos_inscritos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_cursos_inscritos` AS select `c`.`id` AS `id`,`c`.`titulo` AS `titulo`,`c`.`fecha_inicio` AS `fecha_inicio`,`c`.`cupo_maximo` AS `cupo_maximo`,`c`.`cupo_disponible` AS `cupo_disponible`,count(`i`.`id`) AS `total_inscritos`,`c`.`estatus` AS `estatus` from (`cursos` `c` left join `inscripciones_cursos` `i` on(((`c`.`id` = `i`.`curso_id`) and (`i`.`estatus` <> 'cancelada')))) group by `c`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_estadisticas_generales`
--

/*!50001 DROP VIEW IF EXISTS `vista_estadisticas_generales`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_estadisticas_generales` AS select (select count(0) from `solicitudes_brigadistas` where (`solicitudes_brigadistas`.`estatus` = 'pendiente')) AS `solicitudes_pendientes`,(select count(0) from `inscripciones_cursos` where (`inscripciones_cursos`.`estatus` = 'confirmada')) AS `inscritos_cursos`,(select count(0) from `emergencias` where (`emergencias`.`estatus` in ('reportada','en_camino','atendiendo'))) AS `emergencias_activas`,(select count(0) from `miembros_brigadas` where (`miembros_brigadas`.`estatus` = 'activo')) AS `brigadistas_activos`,(select sum(`novedades`.`vistas`) from `novedades` where (`novedades`.`publicado` = true)) AS `total_vistas_novedades` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_vistas_secciones`
--

/*!50001 DROP VIEW IF EXISTS `vista_vistas_secciones`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_vistas_secciones` AS select `estadisticas_vistas`.`seccion` AS `seccion`,count(0) AS `total_visitas`,count(distinct `estadisticas_vistas`.`ip_visitante`) AS `visitantes_unicos`,cast(`estadisticas_vistas`.`fecha_visita` as date) AS `fecha` from `estadisticas_vistas` group by `estadisticas_vistas`.`seccion`,cast(`estadisticas_vistas`.`fecha_visita` as date) order by `fecha` desc,`total_visitas` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-05 15:31:08
