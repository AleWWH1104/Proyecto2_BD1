-- Script de datos de prueba
INSERT INTO Ubicacion (direccion, ciudad, pais)
VALUES ('Avenida Central 123', 'NY', 'EEUU');

INSERT INTO Evento (nombre, descripcion, fecha_inicio, fecha_fin, ubicacion_id, capacidad_max, estado)
VALUES ('Concierto de Kpop', 'Un evento con grupos de Kpop', '2025-06-01 19:00:00', '2025-06-01 23:00:00', 1, 20, 'activo');

-- Insertar Asientos (20 asientos disponibles)
DO $$
BEGIN
    FOR i IN 1..20 LOOP
        INSERT INTO Asiento (evento_id, estado)
        VALUES (1, 'disponible');
    END LOOP;
END $$;

INSERT INTO Usuario (nombre, apellido, email, telefono) VALUES
('Ana', 'Gomez', 'ana@example.com', '555-1111'),
('Luis', 'Perez', 'luis@example.com', '555-2222'),
('Maria', 'Lopez', 'maria@example.com', '555-3333'),
('Carlos', 'Diaz', 'carlos@example.com', '555-4444'),
('Laura', 'Martinez', 'laura@example.com', '555-5555'),
('Pedro', 'Garcia', 'pedro@example.com', '555-6666'),
('Sofia', 'Ruiz', 'sofia@example.com', '555-7777'),
('Jose', 'Fernandez', 'jose@example.com', '555-8888'),
('Lucia', 'Torres', 'lucia@example.com', '555-9999'),
('Miguel', 'Sanchez', 'miguel@example.com', '555-0000');

-- Insertar 3 Reservas Iniciales (asientos 1, 2 y 3)

-- Reserva 1
INSERT INTO Reserva (evento_id, usuario_id, estado) VALUES (1, 1, 'confirmada');
INSERT INTO Reserva_detalle (reserva_id, asiento_id) VALUES (1, 1);

-- Reserva 2
INSERT INTO Reserva (evento_id, usuario_id, estado) VALUES (1, 2, 'confirmada');
INSERT INTO Reserva_detalle (reserva_id, asiento_id) VALUES (2, 2);

-- Reserva 3
INSERT INTO Reserva (evento_id, usuario_id, estado) VALUES (1, 3, 'confirmada');
INSERT INTO Reserva_detalle (reserva_id, asiento_id) VALUES (3, 3);

-- Actualizar estado de los asientos reservados
UPDATE Asiento SET estado = 'reservado' WHERE asiento_id IN (1, 2, 3);


-- Simular concurrencia
-- Supongamos que el usuario 4 y el usuario 5 intentan reservar el asiento 4 al mismo tiempo.
-- Simulación de usuario 4 reservando asiento 4
BEGIN;

-- Bloqueo del asiento (evita que otros lo reserven al mismo tiempo)
SELECT * FROM Asiento
WHERE asiento_id = 4 AND estado = 'disponible'
FOR UPDATE;

-- Verificamos si estaba disponible
-- Si sí -> Reservamos
UPDATE Asiento
SET estado = 'reservado'
WHERE asiento_id = 4;

-- Crear la reserva
INSERT INTO Reserva (evento_id, usuario_id, estado)
VALUES (1, 4, 'confirmada');

-- Obtener el id de la reserva creada
-- (en PostgreSQL sería con RETURNING o currval)
INSERT INTO Reserva_detalle (reserva_id, asiento_id)
VALUES (currval('reserva_reserva_id_seq'), 4);

COMMIT;

-- Simulación de otro usuario (usuario 5) intentando reservar el mismo asiento:
BEGIN;

-- Intento de bloqueo por usuario 5
SELECT * FROM Asiento
WHERE asiento_id = 4 AND estado = 'disponible'
FOR UPDATE;

-- Si no devuelve filas --> El asiento ya está reservado
-- Se puede manejar con control de errores o mensajes al usuario

-- Si devolviera filas (no reservado todavía):
UPDATE Asiento
SET estado = 'reservado'
WHERE asiento_id = 4;

INSERT INTO Reserva (evento_id, usuario_id, estado)
VALUES (1, 5, 'confirmada');

INSERT INTO Reserva_detalle (reserva_id, asiento_id)
VALUES (currval('reserva_reserva_id_seq'), 4);

COMMIT;

-- Resultado: Si usuario 4 ejecuta y hace COMMIT primero → usuario 5 no podrá reservar el asiento 4.










