-- EN LA INSTANCIA PRINCIPAL (Primary):

-- 1. Crear función que simula escrituras constantes
CREATE OR REPLACE FUNCTION registro_consultas_continuo() 
RETURNS VOID AS $$
BEGIN
    -- Simular registro de consultas cada segundo
    INSERT INTO consulta (medico_id, paciente_id, diagnostico, tratamiento, costo)
    SELECT 
        (RANDOM() * 2 + 1)::INT,
        (RANDOM() * 2 + 1)::INT,
        'Consulta automatizada',
        'Tratamiento estándar',
        (RANDOM() * 100 + 20)::NUMERIC(10,2)
    FROM generate_series(1, 5);
END;
$$ LANGUAGE plpgsql;

-- 2. Insertar algunas consultas
SELECT registro_consultas_continuo();

-- 3. Verificar que hay datos
SELECT COUNT(*) FROM consulta;