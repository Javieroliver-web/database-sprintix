-- ========================================
-- SPRINTIX DATABASE SCHEMA
-- Coincide EXACTAMENTE con las entidades JPA del backend
-- ========================================

-- ========================================
-- TABLA: Usuario
-- ========================================
CREATE TABLE IF NOT EXISTS Usuario (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol VARCHAR(50) DEFAULT 'usuario',
    avatar TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT check_email_format CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

COMMENT ON TABLE Usuario IS 'Usuarios del sistema Sprintix';
COMMENT ON COLUMN Usuario.password IS 'Contraseña hasheada con SHA-256 + salt (PasswordUtil)';

-- ========================================
-- TABLA: Proyecto
-- ========================================
CREATE TABLE IF NOT EXISTS Proyecto (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE,
    estado VARCHAR(50),
    usuario_id INTEGER NOT NULL,
    
    CONSTRAINT fk_proyecto_usuario FOREIGN KEY (usuario_id) 
        REFERENCES Usuario(id) ON DELETE CASCADE,
    CONSTRAINT check_fechas CHECK (fecha_inicio IS NULL OR fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

COMMENT ON TABLE Proyecto IS 'Proyectos creados por usuarios';
COMMENT ON COLUMN Proyecto.usuario_id IS 'Referencia al creador del proyecto';

-- ========================================
-- TABLA: Tarea
-- ========================================
CREATE TABLE IF NOT EXISTS Tarea (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    estado VARCHAR(50),
    fecha_limite TIMESTAMP,
    proyecto_id INTEGER NOT NULL,
    
    CONSTRAINT fk_tarea_proyecto FOREIGN KEY (proyecto_id) 
        REFERENCES Proyecto(id) ON DELETE CASCADE
);

COMMENT ON TABLE Tarea IS 'Tareas asociadas a proyectos';

-- ========================================
-- TABLA: Notificacion
-- ========================================
CREATE TABLE IF NOT EXISTS Notificacion (
    id SERIAL PRIMARY KEY,
    mensaje TEXT NOT NULL,
    tipo VARCHAR(50),
    leida BOOLEAN DEFAULT FALSE,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_id INTEGER NOT NULL,
    
    CONSTRAINT fk_notificacion_usuario FOREIGN KEY (usuario_id) 
        REFERENCES Usuario(id) ON DELETE CASCADE
);

COMMENT ON TABLE Notificacion IS 'Notificaciones del sistema';

-- ========================================
-- TABLA: Archivo
-- ========================================
CREATE TABLE IF NOT EXISTS Archivo (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    tipo VARCHAR(100),
    url TEXT NOT NULL,
    tamano BIGINT,
    fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    proyecto_id INTEGER NOT NULL,
    usuario_id INTEGER NOT NULL,
    
    CONSTRAINT fk_archivo_proyecto FOREIGN KEY (proyecto_id) 
        REFERENCES Proyecto(id) ON DELETE CASCADE,
    CONSTRAINT fk_archivo_usuario FOREIGN KEY (usuario_id) 
        REFERENCES Usuario(id) ON DELETE CASCADE
);

COMMENT ON TABLE Archivo IS 'Archivos adjuntos a proyectos';

-- ========================================
-- TABLA: Usuario_Proyecto (Participantes)
-- ========================================
CREATE TABLE IF NOT EXISTS Usuario_Proyecto (
    usuario_id INTEGER NOT NULL,
    proyecto_id INTEGER NOT NULL,
    
    PRIMARY KEY (usuario_id, proyecto_id),
    CONSTRAINT fk_up_usuario FOREIGN KEY (usuario_id) 
        REFERENCES Usuario(id) ON DELETE CASCADE,
    CONSTRAINT fk_up_proyecto FOREIGN KEY (proyecto_id) 
        REFERENCES Proyecto(id) ON DELETE CASCADE
);

COMMENT ON TABLE Usuario_Proyecto IS 'Relación muchos a muchos: usuarios participantes en proyectos (mappedBy = "proyectosAsignados")';

-- ========================================
-- TABLA: Tarea_Asignada
-- ========================================
CREATE TABLE IF NOT EXISTS Tarea_Asignada (
    tarea_id INTEGER NOT NULL,
    usuario_id INTEGER NOT NULL,
    
    PRIMARY KEY (tarea_id, usuario_id),
    CONSTRAINT fk_ta_tarea FOREIGN KEY (tarea_id) 
        REFERENCES Tarea(id) ON DELETE CASCADE,
    CONSTRAINT fk_ta_usuario FOREIGN KEY (usuario_id) 
        REFERENCES Usuario(id) ON DELETE CASCADE
);

COMMENT ON TABLE Tarea_Asignada IS 'Relación muchos a muchos: usuarios asignados a tareas (Usuario.tareasAsignadas)';

-- ========================================
-- TABLA: Tarea_Favorita
-- ========================================
CREATE TABLE IF NOT EXISTS Tarea_Favorita (
    tarea_id INTEGER NOT NULL,
    usuario_id INTEGER NOT NULL,
    
    PRIMARY KEY (tarea_id, usuario_id),
    CONSTRAINT fk_tf_tarea FOREIGN KEY (tarea_id) 
        REFERENCES Tarea(id) ON DELETE CASCADE,
    CONSTRAINT fk_tf_usuario FOREIGN KEY (usuario_id) 
        REFERENCES Usuario(id) ON DELETE CASCADE
);

COMMENT ON TABLE Tarea_Favorita IS 'Relación muchos a muchos: tareas marcadas como favoritas (Usuario.tareasFavoritas)';

-- ========================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- ========================================

-- Usuario
CREATE INDEX idx_usuario_email ON Usuario(email);

-- Proyecto
CREATE INDEX idx_proyecto_usuario ON Proyecto(usuario_id);
CREATE INDEX idx_proyecto_estado ON Proyecto(estado);

-- Tarea
CREATE INDEX idx_tarea_proyecto ON Tarea(proyecto_id);
CREATE INDEX idx_tarea_estado ON Tarea(estado);

-- Notificacion
CREATE INDEX idx_notificacion_usuario ON Notificacion(usuario_id);
CREATE INDEX idx_notificacion_leida ON Notificacion(leida) WHERE leida = FALSE;

-- Archivo
CREATE INDEX idx_archivo_proyecto ON Archivo(proyecto_id);
CREATE INDEX idx_archivo_usuario ON Archivo(usuario_id);

-- Tablas de relación
CREATE INDEX idx_usuario_proyecto_usuario ON Usuario_Proyecto(usuario_id);
CREATE INDEX idx_usuario_proyecto_proyecto ON Usuario_Proyecto(proyecto_id);
CREATE INDEX idx_tarea_asignada_usuario ON Tarea_Asignada(usuario_id);
CREATE INDEX idx_tarea_asignada_tarea ON Tarea_Asignada(tarea_id);

-- ========================================
-- TRIGGERS PARA ACTUALIZACIÓN AUTOMÁTICA
-- ========================================

-- Función para actualizar ultimo_acceso en Usuario
CREATE OR REPLACE FUNCTION actualizar_ultimo_acceso()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Usuario 
    SET ultimo_acceso = CURRENT_TIMESTAMP 
    WHERE id = NEW.usuario_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Opcional: Trigger para login (puedes implementarlo en el backend también)
-- CREATE TRIGGER trigger_usuario_ultimo_acceso
--     AFTER INSERT ON Sesion
--     FOR EACH ROW
--     EXECUTE FUNCTION actualizar_ultimo_acceso();