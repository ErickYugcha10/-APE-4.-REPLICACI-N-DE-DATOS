-- EN LA READ REPLICA (solo lectura):

-- 4. Verificar que es read-only
SELECT pg_is_in_recovery();  -- TRUE = es réplica

-- 5. Intentar escribir (debe fallar)
INSERT INTO paciente (nombre, fecha_nacimiento) 
VALUES ('Prueba', '2000-01-01');
-- ERROR: cannot execute INSERT in a read-only transaction

-- 6. Queries de lectura pesadas (aquí se descarga el primary)
-- Reporte: Consultas por médico
SELECT 
    m.nombre as medico,
    m.especialidad,
    COUNT(c.id) as total_consultas,
    AVG(c.costo) as costo_promedio,
    SUM(c.costo) as ingreso_total
FROM medico m
LEFT JOIN consulta c ON m.id = c.medico_id
GROUP BY m.id, m.nombre, m.especialidad
ORDER BY total_consultas DESC;

-- Reporte: Pacientes frecuentes
SELECT 
    p.nombre,
    p.telefono,
    COUNT(c.id) as num_consultas,
    MAX(c.fecha_consulta) as ultima_consulta,
    SUM(c.costo) as gasto_total
FROM paciente p
LEFT JOIN consulta c ON p.id = c.paciente_id
GROUP BY p.id, p.nombre, p.telefono
HAVING COUNT(c.id) > 0
ORDER BY num_consultas DESC;

-- 7. Verificar lag de replicación
SELECT 
    NOW() - pg_last_xact_replay_timestamp() AS replication_lag;