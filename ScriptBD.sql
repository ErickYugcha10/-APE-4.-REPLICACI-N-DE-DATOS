-- Base de datos hospital
CREATE DATABASE hospital_db;
\c hospital_db

-- Tabla médicos
CREATE TABLE medico (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(50),
    telefono VARCHAR(20),
    fecha_registro TIMESTAMP DEFAULT NOW()
);

-- Tabla pacientes
CREATE TABLE paciente (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    telefono VARCHAR(20),
    direccion VARCHAR(200),
    fecha_registro TIMESTAMP DEFAULT NOW()
);

-- Tabla consultas
CREATE TABLE consulta (
    id SERIAL PRIMARY KEY,
    medico_id INTEGER REFERENCES medico(id),
    paciente_id INTEGER REFERENCES paciente(id),
    fecha_consulta TIMESTAMP DEFAULT NOW(),
    diagnostico TEXT,
    tratamiento TEXT,
    costo DECIMAL(10,2)
);

-- Datos iniciales
INSERT INTO medico (nombre, especialidad, telefono) VALUES
    ('Dr. Carlos Méndez', 'Cardiología', '0998-123-456'),
    ('Dra. Ana Flores', 'Pediatría', '0987-654-321'),
    ('Dr. Luis Rojas', 'Traumatología', '0999-888-777');

INSERT INTO paciente (nombre, fecha_nacimiento, telefono, direccion) VALUES
    ('María González', '1985-03-15', '0991-111-222', 'Ambato, Av. Cevallos'),
    ('José Pérez', '1990-07-22', '0992-333-444', 'Ambato, Ficoa'),
    ('Laura Sánchez', '2015-11-10', '0993-555-666', 'Ambato, La Merced');

INSERT INTO consulta (medico_id, paciente_id, diagnostico, tratamiento, costo) VALUES
    (1, 1, 'Hipertensión arterial', 'Enalapril 10mg', 35.00),
    (2, 3, 'Gripe común', 'Paracetamol jarabe', 25.00),
    (3, 2, 'Esguince de tobillo', 'Reposo + antiinflamatorios', 45.00);