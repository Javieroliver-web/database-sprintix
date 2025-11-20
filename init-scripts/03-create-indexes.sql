-- ========================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- ========================================

-- Usuario
CREATE INDEX idx_usuario_email ON Usuario(email);
-- El índice de activo solo si la columna existe (en tu esquema actual no vi la columna 'activo', 
-- si no existe en 01-create-schema, comenta esta línea):
-- CREATE INDEX idx_usuario_activo ON Usuario(activo) WHERE activo = TRUE;

-- Proyecto
CREATE INDEX idx_proyecto_usuario ON Proyecto(usuario_id);
CREATE INDEX idx_proyecto_estado ON Proyecto(estado);
CREATE INDEX idx_proyecto_fechas ON Proyecto(fecha_inicio, fecha_fin);

-- Tarea
CREATE INDEX idx_tarea_proyecto ON Tarea(proyecto_id);
CREATE INDEX idx_tarea_estado ON Tarea(estado);
-- Si 'prioridad' no está en tu tabla Tarea (no estaba en el Java original), comenta esta línea:
-- CREATE INDEX idx_tarea_prioridad ON Tarea(prioridad);
CREATE INDEX idx_tarea_fecha_limite ON Tarea(fecha_limite);

-- Notificacion
CREATE INDEX idx_notificacion_usuario ON Notificacion(usuario_id);
CREATE INDEX idx_notificacion_leida ON Notificacion(leida) WHERE leida = FALSE;
CREATE INDEX idx_notificacion_fecha ON Notificacion(fecha DESC);

-- Archivo
CREATE INDEX idx_archivo_proyecto ON Archivo(proyecto_id);
CREATE INDEX idx_archivo_usuario ON Archivo(usuario_id);

-- Tablas de relación
CREATE INDEX idx_usuario_proyecto_usuario ON Usuario_Proyecto(usuario_id);
CREATE INDEX idx_usuario_proyecto_proyecto ON Usuario_Proyecto(proyecto_id);
CREATE INDEX idx_tarea_asignada_usuario ON Tarea_Asignada(usuario_id);
CREATE INDEX idx_tarea_asignada_tarea ON Tarea_Asignada(tarea_id);