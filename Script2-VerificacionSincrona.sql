-- 2. Crear tabla de prueba con timestamps precisos
CREATE TABLE prueba_replicacion (
    id SERIAL PRIMARY KEY,
    accion VARCHAR(100),
    timestamp_escritura TIMESTAMP(6) DEFAULT CLOCK_TIMESTAMP(),
    zona_escritura VARCHAR(50)
);

-- 3. Insertar datos y medir el tiempo
-- Esto se replica SÍNCRONAMENTE a la standby
INSERT INTO prueba_replicacion (accion, zona_escritura) 
VALUES ('Escritura en Primary', current_setting('cluster_name'));

-- 4. Ver el WAL (Write-Ahead Log) que se está replicando
SELECT 
    pg_current_wal_lsn() as posicion_actual,
    pg_wal_lsn_diff(pg_current_wal_lsn(), '0/0') / 1024 / 1024 as mb_escritos;

-- 5. Ver lag de replicación (debe ser casi 0)
SELECT 
    CASE 
        WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() 
        THEN 'Replicación al día' 
        ELSE 'Replicación con retraso' 
    END as estado_replicacion,
    pg_wal_lsn_diff(pg_last_wal_receive_lsn(), pg_last_wal_replay_lsn()) as bytes_pendientes;