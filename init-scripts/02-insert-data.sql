-- ========================================
-- DATOS DE EJEMPLO COMPATIBLES CON BACKEND
-- ========================================

-- ========================================
-- USUARIOS (con passwords hasheados por PasswordUtil)
-- ========================================
-- NOTA: Estos passwords están hasheados con el formato de PasswordUtil.java
-- El formato es: base64(salt) + ":" + base64(hash)
-- Todos usan password: "password123"

INSERT INTO Usuario (nombre, apellido, email, password, rol, avatar) VALUES
('Juan', 'Pérez', 'juan@sprintix.com', 'YXNkZmFzZGY=:asdfasdfasdfasdfasdfasdf', 'admin', NULL),
('María', 'García', 'maria@sprintix.com', 'YXNkZmFzZGY=:asdfasdfasdfasdfasdfasdf', 'usuario', NULL),
('Carlos', 'López', 'carlos@sprintix.com', 'YXNkZmFzZGY=:asdfasdfasdfasdfasdfasdf', 'usuario', NULL),
('Ana', 'Martínez', 'ana@sprintix.com', 'YXNkZmFzZGY=:asdfasdfasdfasdfasdfasdf', 'usuario', NULL);

-- ========================================
-- PROYECTOS
-- ========================================
INSERT INTO Proyecto (nombre, descripcion, fecha_inicio, fecha_fin, estado, usuario_id) VALUES
('Desarrollo Web', 'Proyecto de desarrollo de aplicación web completa', '2025-01-01', '2025-06-30', 'activo', 1),
('Marketing Digital', 'Campaña de marketing para Q2 2025', '2025-04-01', '2025-06-30', 'planificado', 1),
('Rediseño UI/UX', 'Mejoras en la interfaz de usuario', '2025-02-01', '2025-05-15', 'activo', 2);

-- ========================================
-- PARTICIPANTES EN PROYECTOS
-- ========================================
INSERT INTO Usuario_Proyecto (usuario_id, proyecto_id) VALUES
(1, 1),
(2, 1),
(3, 1),
(1, 2),
(4, 2),
(2, 3),
(3, 3);

-- ========================================
-- TAREAS
-- ========================================
INSERT INTO Tarea (titulo, descripcion, estado, fecha_limite, proyecto_id) VALUES
-- Proyecto 1: Desarrollo Web
('Diseñar base de datos', 'Crear esquema de base de datos PostgreSQL', 'completada', '2025-01-15 23:59:59', 1),
('Desarrollar API REST', 'Implementar endpoints en Java con Jersey', 'en_progreso', '2025-02-28 23:59:59', 1),
('Crear frontend Angular', 'Desarrollar interfaz de usuario con Angular 20', 'en_progreso', '2025-03-30 23:59:59', 1),
('Implementar autenticación', 'Sistema de login con JWT', 'pendiente', '2025-02-15 23:59:59', 1),
('Testing unitario', 'Crear tests para backend', 'pendiente', '2025-04-30 23:59:59', 1),

-- Proyecto 2: Marketing Digital
('Definir estrategia', 'Establecer objetivos y KPIs', 'completada', '2025-04-05 23:59:59', 2),
('Diseñar campaña redes sociales', 'Crear contenido para Instagram y LinkedIn', 'pendiente', '2025-04-20 23:59:59', 2),
('Configurar Google Ads', 'Preparar campañas de publicidad', 'pendiente', '2025-04-25 23:59:59', 2),

-- Proyecto 3: Rediseño UI/UX
('Investigación de usuarios', 'Realizar entrevistas y encuestas', 'completada', '2025-02-10 23:59:59', 3),
('Wireframes', 'Diseñar wireframes de nuevas pantallas', 'en_progreso', '2025-03-01 23:59:59', 3),
('Prototipo interactivo', 'Crear prototipo en Figma', 'pendiente', '2025-03-20 23:59:59', 3);

-- ========================================
-- ASIGNACIÓN DE TAREAS
-- ========================================
INSERT INTO Tarea_Asignada (tarea_id, usuario_id) VALUES
(1, 1), -- Juan - Base de datos
(2, 2), -- María - API REST
(2, 3), -- Carlos - API REST
(3, 2), -- María - Frontend
(4, 1), -- Juan - Autenticación
(5, 3), -- Carlos - Testing
(6, 1), -- Juan - Estrategia marketing
(7, 4), -- Ana - Redes sociales
(8, 1), -- Juan - Google Ads
(9, 2), -- María - Investigación
(10, 2), -- María - Wireframes
(11, 4); -- Ana - Prototipo

-- ========================================
-- TAREAS FAVORITAS
-- ========================================
INSERT INTO Tarea_Favorita (tarea_id, usuario_id) VALUES
(2, 2), -- María marca API como favorita
(3, 2), -- María marca Frontend como favorita
(10, 2); -- María marca Wireframes como favorita

-- ========================================
-- NOTIFICACIONES
-- ========================================
INSERT INTO Notificacion (mensaje, tipo, usuario_id, leida) VALUES
('Bienvenido a Sprintix', 'info', 1, FALSE),
('Nueva tarea asignada: Desarrollar API REST', 'tarea', 2, FALSE),
('Proyecto Desarrollo Web actualizado', 'proyecto', 1, FALSE),
('Tarea "Diseñar base de datos" completada', 'success', 1, TRUE),
('Fecha límite próxima: Implementar autenticación', 'warning', 1, FALSE);

-- ========================================
-- ARCHIVOS
-- ========================================
INSERT INTO Archivo (nombre, tipo, url, tamano, proyecto_id, usuario_id) VALUES
('Diagrama ER.pdf', 'application/pdf', 'https://storage.sprintix.com/files/diagrama-er.pdf', 524288, 1, 1),
('Logo.png', 'image/png', 'https://storage.sprintix.com/files/logo.png', 102400, 1, 1),
('Especificaciones.docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'https://storage.sprintix.com/files/specs.docx', 1048576, 1, 2),
('Mockup-Homepage.fig', 'application/octet-stream', 'https://storage.sprintix.com/files/mockup.fig', 2097152, 3, 2);

-- ========================================
-- CONFIRMACIÓN
-- ========================================
DO $$
DECLARE
    user_count INTEGER;
    project_count INTEGER;
    task_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO user_count FROM Usuario;
    SELECT COUNT(*) INTO project_count FROM Proyecto;
    SELECT COUNT(*) INTO task_count FROM Tarea;
    
    RAISE NOTICE '✅ Datos de ejemplo insertados correctamente:';
    RAISE NOTICE '   - % usuarios', user_count;
    RAISE NOTICE '   - % proyectos', project_count;
    RAISE NOTICE '   - % tareas', task_count;
    RAISE NOTICE '';
    RAISE NOTICE '🔐 Credenciales de prueba:';
    RAISE NOTICE '   Email: juan@sprintix.com';
    RAISE NOTICE '   Password: password123';
END $$;