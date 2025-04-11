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
('Miguel', 'Sanchez', 'miguel@example.com', '555-0000'),
('Pablo', 'Ramirez', 'pablo@example.com', '555-1212'),
('Elena', 'Castro', 'elena@example.com', '555-2323'),
('David', 'Ortiz', 'david@example.com', '555-3434'),
('Carmen', 'Iglesias', 'carmen@example.com', '555-4545'),
('Raul', 'Vazquez', 'raul@example.com', '555-5656'),
('Isabel', 'Santos', 'isabel@example.com', '555-6767'),
('Fernando', 'Luna', 'fernando@example.com', '555-7878'),
('Patricia', 'Reyes', 'patricia@example.com', '555-8989'),
('Jorge', 'Flores', 'jorge@example.com', '555-9090'),
('Adriana', 'Mendoza', 'adriana@example.com', '555-0101'),
('Roberto', 'Guerrero', 'roberto@example.com', '555-1122'),
('Beatriz', 'Navarro', 'beatriz@example.com', '555-2233'),
('Ricardo', 'Molina', 'ricardo@example.com', '555-3344'),
('Silvia', 'Rios', 'silvia@example.com', '555-4455'),
('Hector', 'Miranda', 'hector@example.com', '555-5566'),
('Olga', 'Cordero', 'olga@example.com', '555-6677'),
('Arturo', 'Paredes', 'arturo@example.com', '555-7788'),
('Rosa', 'Campos', 'rosa@example.com', '555-8899'),
('Felipe', 'Vega', 'felipe@example.com', '555-9900'),
('Teresa', 'Fuentes', 'teresa@example.com', '555-0011');

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


