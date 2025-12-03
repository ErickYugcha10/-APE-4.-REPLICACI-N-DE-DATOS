-- 4. Ejecutar MERGE para sincronizar pacientes
MERGE INTO paciente AS target
USING paciente_staging AS source
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET 
        nombre = source.nombre,
        telefono = source.telefono,
        direccion = source.direccion,
        fecha_registro = CASE 
            WHEN target.nombre != source.nombre THEN NOW() 
            ELSE target.fecha_registro 
        END
WHEN NOT MATCHED THEN
    INSERT (id, nombre, fecha_nacimiento, telefono, direccion, fecha_registro)
    VALUES (source.id, source.nombre, source.fecha_nacimiento, source.telefono, source.direccion, NOW());

-- 5. Ver cambios
SELECT 
    id,
    nombre,
    telefono,
    direccion,
    fecha_registro,
    CASE 
        WHEN fecha_registro > NOW() - INTERVAL '1 minute' THEN '✅ ACTUALIZADO'
        ELSE '   Sin cambios'
    END as estado
FROM paciente
ORDER BY id;

-- 6. MERGE para CONSULTA
MERGE INTO consulta AS target
USING (
    SELECT 
        cs.*,
        p.id as paciente_existe,
        m.id as medico_existe
    FROM consulta_staging cs
    LEFT JOIN paciente p ON cs.paciente_id = p.id
    LEFT JOIN medico m ON cs.medico_id = m.id
    WHERE p.id IS NOT NULL AND m.id IS NOT NULL  -- Solo registros válidos
) AS source
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET 
        diagnostico = source.diagnostico,
        tratamiento = source.tratamiento,
        costo = source.costo
WHEN NOT MATCHED THEN
    INSERT (medico_id, paciente_id, fecha_consulta, diagnostico, tratamiento, costo)
    VALUES (source.medico_id, source.paciente_id, source.fecha_consulta, source.diagnostico, source.tratamiento, source.costo);

-- 7. Verificar resultado final
SELECT 
    c.id,
    m.nombre as medico,
    p.nombre as paciente,
    c.diagnostico,
    c.costo,
    c.fecha_consulta
FROM consulta c
JOIN medico m ON c.medico_id = m.id
JOIN paciente p ON c.paciente_id = p.id
ORDER BY c.fecha_consulta DESC
LIMIT 10;