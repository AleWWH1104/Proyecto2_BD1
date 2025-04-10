-- Tabla Ubicacion
CREATE TABLE IF NOT EXISTS Ubicacion (
    ubicacion_id SERIAL PRIMARY KEY,
    direccion VARCHAR(255) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
	pais VARCHAR(100) NOT NULL
);

-- Tabla Eventos
CREATE TABLE IF NOT EXISTS Evento (
    evento_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_inicio TIMESTAMP NOT NULL,
    fecha_fin TIMESTAMP NOT NULL,
    ubicacion_id INTEGER NOT NULL,
	capacidad_max INTEGER NOT NULL,
    estado VARCHAR(20) CHECK (estado IN ('planificado', 'activo', 'cancelado', 'completado')) DEFAULT 'planificado',
    FOREIGN KEY (ubicacion_id) REFERENCES Ubicacion(ubicacion_id)
);

-- Tabla Asientos
CREATE TABLE IF NOT EXISTS Asiento (
    asiento_id SERIAL PRIMARY KEY,
    evento_id INTEGER NOT NULL,
    estado VARCHAR(20) CHECK (estado IN ('disponible', 'reservado', 'ocupado')) DEFAULT 'disponible',
	FOREIGN KEY (evento_id) REFERENCES Evento(evento_id)
);

-- Tabla Usuarios
CREATE TABLE IF NOT EXISTS Usuario (
    usuario_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20)
);

-- Tabla Reserva
CREATE TABLE IF NOT EXISTS Reserva (
    reserva_id SERIAL PRIMARY KEY,
    evento_id INTEGER NOT NULL,
    usuario_id INTEGER NOT NULL,
    fecha_reserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) CHECK (estado IN ('pendiente', 'confirmada', 'cancelada', 'expirada')) DEFAULT 'pendiente',
    FOREIGN KEY (evento_id) REFERENCES Evento(evento_id),
    FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id)
);

-- Tabla Reserva_detalle
CREATE TABLE IF NOT EXISTS Reserva_detalle (
    detalle_id SERIAL PRIMARY KEY,
    reserva_id INTEGER NOT NULL,
    asiento_id INTEGER NOT NULL,
	FOREIGN KEY (reserva_id) REFERENCES Reserva(reserva_id) ON DELETE CASCADE,
    FOREIGN KEY (asiento_id) REFERENCES Asiento(asiento_id)
);
