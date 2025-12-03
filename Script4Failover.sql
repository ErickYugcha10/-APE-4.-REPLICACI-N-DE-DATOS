-- 8. ANTES del failover - Insertar registro marcado
INSERT INTO prueba_replicacion (accion, zona_escritura) 
VALUES ('ANTES del Failover', inet_server_addr()::TEXT);

-- Anota la hora exacta
SELECT NOW(), pg_current_wal_lsn();


-- 9. DESPUÉS del failover - Reconecta y verifica
-- Deberías reconectarte automáticamente

INSERT INTO prueba_replicacion (accion, zona_escritura) 
VALUES ('DESPUÉS del Failover', inet_server_addr()::TEXT);

-- 10. Ver la evidencia completa
SELECT 
    id,
    accion,
    timestamp_escritura,
    zona_escritura,
    timestamp_escritura - LAG(timestamp_escritura) OVER (ORDER BY id) as tiempo_entre_escrituras
FROM prueba_replicacion
ORDER BY id DESC
LIMIT 10;