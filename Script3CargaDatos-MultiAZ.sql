-- 6. Crear procedimiento que simula carga hospitalaria
CREATE OR REPLACE FUNCTION simular_consultas(num_consultas INT) 
RETURNS TABLE(consulta_id INT, tiempo_ms NUMERIC) AS $$
DECLARE
    inicio TIMESTAMP;
    fin TIMESTAMP;
    nuevo_id INT;
BEGIN
    FOR i IN 1..num_consultas LOOP
        inicio := CLOCK_TIMESTAMP();
        
        INSERT INTO consulta (medico_id, paciente_id, diagnostico, tratamiento, costo)
        VALUES (
            (RANDOM() * 2 + 1)::INT,  -- Médico aleatorio 1-3
            (RANDOM() * 2 + 1)::INT,  -- Paciente aleatorio 1-3
            'Consulta de prueba ' || i,
            'Tratamiento ' || i,
            (RANDOM() * 100 + 20)::NUMERIC(10,2)
        )
        RETURNING id INTO nuevo_id;
        
        fin := CLOCK_TIMESTAMP();
        
        consulta_id := nuevo_id;
        tiempo_ms := EXTRACT(EPOCH FROM (fin - inicio)) * 1000;
        RETURN NEXT;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- 7. Ejecutar simulación (verás que cada escritura espera la confirmación del standby)
SELECT * FROM simular_consultas(10);