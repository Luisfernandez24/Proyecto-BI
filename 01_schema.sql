-- ============================================================
-- PROYECTO BI - GRUPO 9
-- ============================================================

DROP SCHEMA IF EXISTS hotel_ops CASCADE;
CREATE SCHEMA hotel_ops;
SET search_path TO hotel_ops;

-- ============================================================
-- 1) CATÁLOGOS / MAESTROS
-- ============================================================

CREATE TABLE pais (
    id_pais BIGSERIAL PRIMARY KEY,
    nombre_pais VARCHAR(100) NOT NULL UNIQUE,
    codigo_iso2 CHAR(2) UNIQUE,
    codigo_iso3 CHAR(3) UNIQUE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ciudad (
    id_ciudad BIGSERIAL PRIMARY KEY,
    id_pais BIGINT NOT NULL REFERENCES pais(id_pais),
    nombre_ciudad VARCHAR(120) NOT NULL,
    provincia_estado VARCHAR(120),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_ciudad UNIQUE (id_pais, nombre_ciudad, provincia_estado)
);

CREATE TABLE tipo_propiedad (
    id_tipo_propiedad BIGSERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE propiedad (
    id_propiedad BIGSERIAL PRIMARY KEY,
    codigo_propiedad VARCHAR(20) NOT NULL UNIQUE,
    nombre_propiedad VARCHAR(150) NOT NULL,
    id_tipo_propiedad BIGINT NOT NULL REFERENCES tipo_propiedad(id_tipo_propiedad),
    categoria_estrellas SMALLINT NOT NULL CHECK (categoria_estrellas BETWEEN 1 AND 5),
    id_ciudad BIGINT NOT NULL REFERENCES ciudad(id_ciudad),
    direccion VARCHAR(255),
    telefono VARCHAR(30),
    email VARCHAR(120),
    fecha_apertura DATE,
    total_habitaciones_planificadas INTEGER NOT NULL CHECK (total_habitaciones_planificadas > 0),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tipo_habitacion (
    id_tipo_habitacion BIGSERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    capacidad_minima SMALLINT NOT NULL CHECK (capacidad_minima > 0),
    capacidad_maxima SMALLINT NOT NULL CHECK (capacidad_maxima >= capacidad_minima),
    tarifa_rack_base NUMERIC(12,2) NOT NULL CHECK (tarifa_rack_base >= 0),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE habitacion (
    id_habitacion BIGSERIAL PRIMARY KEY,
    id_propiedad BIGINT NOT NULL REFERENCES propiedad(id_propiedad),
    id_tipo_habitacion BIGINT NOT NULL REFERENCES tipo_habitacion(id_tipo_habitacion),
    numero_habitacion VARCHAR(20) NOT NULL,
    piso VARCHAR(20),
    zona VARCHAR(50),
    vista VARCHAR(50),
    tarifa_rack_actual NUMERIC(12,2) NOT NULL CHECK (tarifa_rack_actual >= 0),
    estado_operativo VARCHAR(20) NOT NULL CHECK (
        estado_operativo IN ('DISPONIBLE','MANTENIMIENTO','FUERA_SERVICIO','BLOQUEADA')
    ),
    fecha_ultima_renovacion DATE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_habitacion UNIQUE (id_propiedad, numero_habitacion)
);

CREATE TABLE canal_reserva (
    id_canal_reserva BIGSERIAL PRIMARY KEY,
    nombre_canal VARCHAR(80) NOT NULL UNIQUE,
    categoria_canal VARCHAR(30) NOT NULL CHECK (
        categoria_canal IN ('OTA','DIRECTO_WEB','AGENCIA','CALL_CENTER','WALK_IN','CORPORATIVO','OTRO')
    ),
    proveedor VARCHAR(100),
    comision_pct NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (comision_pct BETWEEN 0 AND 100),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE segmento_cliente (
    id_segmento_cliente BIGSERIAL PRIMARY KEY,
    nombre_segmento VARCHAR(60) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE motivo_viaje (
    id_motivo_viaje BIGSERIAL PRIMARY KEY,
    nombre_motivo VARCHAR(60) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE rango_etario (
    id_rango_etario BIGSERIAL PRIMARY KEY,
    nombre_rango VARCHAR(30) NOT NULL UNIQUE,
    edad_min SMALLINT NOT NULL CHECK (edad_min >= 0),
    edad_max SMALLINT NOT NULL CHECK (edad_max >= edad_min),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE genero (
    id_genero BIGSERIAL PRIMARY KEY,
    nombre_genero VARCHAR(30) NOT NULL UNIQUE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tipo_documento (
    id_tipo_documento BIGSERIAL PRIMARY KEY,
    nombre_tipo VARCHAR(40) NOT NULL UNIQUE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE metodo_pago (
    id_metodo_pago BIGSERIAL PRIMARY KEY,
    nombre_metodo VARCHAR(50) NOT NULL UNIQUE,
    categoria_metodo VARCHAR(30) NOT NULL CHECK (
        categoria_metodo IN ('EFECTIVO','TARJETA','TRANSFERENCIA','BILLETERA','CORPORATIVO','OTRO')
    ),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE temporada (
    id_temporada BIGSERIAL PRIMARY KEY,
    nombre_temporada VARCHAR(30) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    prioridad_precio SMALLINT NOT NULL DEFAULT 1,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE servicio_complementario (
    id_servicio BIGSERIAL PRIMARY KEY,
    codigo_servicio VARCHAR(20) NOT NULL UNIQUE,
    nombre_servicio VARCHAR(80) NOT NULL UNIQUE,
    categoria_servicio VARCHAR(50) NOT NULL CHECK (
        categoria_servicio IN ('RESTAURANTE','SPA','TOUR','TRASLADO','ESTACIONAMIENTO','LAVANDERIA','MINIBAR','OTRO')
    ),
    precio_base NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (precio_base >= 0),
    requiere_reserva BOOLEAN NOT NULL DEFAULT FALSE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE estado_reserva (
    id_estado_reserva BIGSERIAL PRIMARY KEY,
    nombre_estado VARCHAR(30) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 2) ENTIDADES PRINCIPALES
-- ============================================================

CREATE TABLE huesped (
    id_huesped BIGSERIAL PRIMARY KEY,
    codigo_huesped VARCHAR(30) NOT NULL UNIQUE,
    id_tipo_documento BIGINT REFERENCES tipo_documento(id_tipo_documento),
    numero_documento VARCHAR(60),
    nombres VARCHAR(120) NOT NULL,
    apellidos VARCHAR(120) NOT NULL,
    fecha_nacimiento DATE,
    edad_registrada SMALLINT CHECK (edad_registrada IS NULL OR edad_registrada BETWEEN 0 AND 120),
    id_rango_etario BIGINT REFERENCES rango_etario(id_rango_etario),
    id_genero BIGINT REFERENCES genero(id_genero),
    id_pais_nacionalidad BIGINT REFERENCES pais(id_pais),
    email VARCHAR(120),
    telefono VARCHAR(30),
    id_segmento_cliente BIGINT NOT NULL REFERENCES segmento_cliente(id_segmento_cliente),
    id_motivo_viaje BIGINT REFERENCES motivo_viaje(id_motivo_viaje),
    es_recurrente BOOLEAN NOT NULL DEFAULT FALSE,
    cantidad_estadias_previas INTEGER NOT NULL DEFAULT 0 CHECK (cantidad_estadias_previas >= 0),
    fecha_registro DATE NOT NULL DEFAULT CURRENT_DATE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_huesped_documento UNIQUE (id_tipo_documento, numero_documento)
);

CREATE TABLE reserva (
    id_reserva BIGSERIAL PRIMARY KEY,
    codigo_reserva VARCHAR(30) NOT NULL UNIQUE,
    id_propiedad BIGINT NOT NULL REFERENCES propiedad(id_propiedad),
    id_huesped_titular BIGINT NOT NULL REFERENCES huesped(id_huesped),
    id_canal_reserva BIGINT NOT NULL REFERENCES canal_reserva(id_canal_reserva),
    id_estado_reserva BIGINT NOT NULL REFERENCES estado_reserva(id_estado_reserva),
    id_metodo_pago_garantia BIGINT REFERENCES metodo_pago(id_metodo_pago),
    fecha_reserva TIMESTAMP NOT NULL,
    fecha_checkin_programado DATE NOT NULL,
    fecha_checkout_programado DATE NOT NULL,
    fecha_checkin_real TIMESTAMP,
    fecha_checkout_real TIMESTAMP,
    adultos SMALLINT NOT NULL DEFAULT 1 CHECK (adultos >= 0),
    ninos SMALLINT NOT NULL DEFAULT 0 CHECK (ninos >= 0),
    infantes SMALLINT NOT NULL DEFAULT 0 CHECK (infantes >= 0),
    cantidad_habitaciones SMALLINT NOT NULL DEFAULT 1 CHECK (cantidad_habitaciones > 0),
    descuento_pct NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (descuento_pct BETWEEN 0 AND 100),
    observaciones TEXT,
    monto_habitacion_bruto NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (monto_habitacion_bruto >= 0),
    monto_descuento NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (monto_descuento >= 0),
    monto_habitacion_neto NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (monto_habitacion_neto >= 0),
    monto_servicios NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (monto_servicios >= 0),
    monto_impuestos NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (monto_impuestos >= 0),
    monto_total_reserva NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (monto_total_reserva >= 0),
    anticipacion_dias INTEGER GENERATED ALWAYS AS ((fecha_checkin_programado - CAST(fecha_reserva AS DATE))) STORED,
    estadia_noches_programadas INTEGER GENERATED ALWAYS AS ((fecha_checkout_programado - fecha_checkin_programado)) STORED,
    fecha_cancelacion TIMESTAMP,
    motivo_cancelacion VARCHAR(255),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_fechas_reserva CHECK (fecha_checkout_programado > fecha_checkin_programado),
    CONSTRAINT chk_fechas_reales CHECK (
        fecha_checkout_real IS NULL
        OR fecha_checkin_real IS NULL
        OR fecha_checkout_real >= fecha_checkin_real
    )
);

CREATE TABLE reserva_habitacion (
    id_reserva_habitacion BIGSERIAL PRIMARY KEY,
    id_reserva BIGINT NOT NULL REFERENCES reserva(id_reserva) ON DELETE CASCADE,
    id_habitacion BIGINT NOT NULL REFERENCES habitacion(id_habitacion),
    tarifa_noche_bruta NUMERIC(12,2) NOT NULL CHECK (tarifa_noche_bruta >= 0),
    descuento_pct NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (descuento_pct BETWEEN 0 AND 100),
    tarifa_noche_neta NUMERIC(12,2) NOT NULL CHECK (tarifa_noche_neta >= 0),
    cantidad_noches INTEGER NOT NULL CHECK (cantidad_noches > 0),
    subtotal_bruto NUMERIC(14,2) NOT NULL CHECK (subtotal_bruto >= 0),
    subtotal_descuento NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (subtotal_descuento >= 0),
    subtotal_neto NUMERIC(14,2) NOT NULL CHECK (subtotal_neto >= 0),
    cantidad_huespedes_asignados SMALLINT NOT NULL DEFAULT 1 CHECK (cantidad_huespedes_asignados > 0),
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_reserva_habitacion UNIQUE (id_reserva, id_habitacion)
);

CREATE TABLE reserva_huesped (
    id_reserva_huesped BIGSERIAL PRIMARY KEY,
    id_reserva BIGINT NOT NULL REFERENCES reserva(id_reserva) ON DELETE CASCADE,
    id_huesped BIGINT NOT NULL REFERENCES huesped(id_huesped),
    es_titular BOOLEAN NOT NULL DEFAULT FALSE,
    es_hospedado BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_reserva_huesped UNIQUE (id_reserva, id_huesped)
);

CREATE TABLE factura (
    id_factura BIGSERIAL PRIMARY KEY,
    numero_factura VARCHAR(40) NOT NULL UNIQUE,
    id_reserva BIGINT NOT NULL REFERENCES reserva(id_reserva),
    fecha_emision TIMESTAMP NOT NULL,
    subtotal NUMERIC(14,2) NOT NULL CHECK (subtotal >= 0),
    impuesto NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (impuesto >= 0),
    descuento_total NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (descuento_total >= 0),
    total NUMERIC(14,2) NOT NULL CHECK (total >= 0),
    moneda VARCHAR(10) NOT NULL DEFAULT 'USD',
    estado_factura VARCHAR(20) NOT NULL CHECK (estado_factura IN ('EMITIDA','PAGADA','ANULADA','PARCIAL')),
    observaciones TEXT,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE detalle_factura (
    id_detalle_factura BIGSERIAL PRIMARY KEY,
    id_factura BIGINT NOT NULL REFERENCES factura(id_factura) ON DELETE CASCADE,
    tipo_concepto VARCHAR(20) NOT NULL CHECK (tipo_concepto IN ('HABITACION','SERVICIO','OTRO')),
    referencia_origen VARCHAR(50),
    descripcion_concepto VARCHAR(255) NOT NULL,
    cantidad NUMERIC(12,2) NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(12,2) NOT NULL CHECK (precio_unitario >= 0),
    descuento_monto NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (descuento_monto >= 0),
    impuesto_monto NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (impuesto_monto >= 0),
    subtotal_linea NUMERIC(14,2) NOT NULL CHECK (subtotal_linea >= 0),
    total_linea NUMERIC(14,2) NOT NULL CHECK (total_linea >= 0),
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pago (
    id_pago BIGSERIAL PRIMARY KEY,
    id_factura BIGINT NOT NULL REFERENCES factura(id_factura),
    id_metodo_pago BIGINT NOT NULL REFERENCES metodo_pago(id_metodo_pago),
    fecha_pago TIMESTAMP NOT NULL,
    monto_pago NUMERIC(14,2) NOT NULL CHECK (monto_pago > 0),
    moneda VARCHAR(10) NOT NULL DEFAULT 'USD',
    referencia_pago VARCHAR(80),
    estado_pago VARCHAR(20) NOT NULL CHECK (estado_pago IN ('APLICADO','PENDIENTE','RECHAZADO','ANULADO')),
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE consumo_servicio (
    id_consumo_servicio BIGSERIAL PRIMARY KEY,
    id_reserva BIGINT NOT NULL REFERENCES reserva(id_reserva),
    id_huesped BIGINT REFERENCES huesped(id_huesped),
    id_servicio BIGINT NOT NULL REFERENCES servicio_complementario(id_servicio),
    fecha_consumo TIMESTAMP NOT NULL,
    cantidad NUMERIC(12,2) NOT NULL DEFAULT 1 CHECK (cantidad > 0),
    precio_unitario NUMERIC(12,2) NOT NULL CHECK (precio_unitario >= 0),
    descuento_monto NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (descuento_monto >= 0),
    impuesto_monto NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (impuesto_monto >= 0),
    subtotal NUMERIC(14,2) NOT NULL CHECK (subtotal >= 0),
    total NUMERIC(14,2) NOT NULL CHECK (total >= 0),
    estado_consumo VARCHAR(20) NOT NULL CHECK (estado_consumo IN ('REGISTRADO','FACTURADO','ANULADO')),
    observaciones TEXT,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bloque_habitacion (
    id_bloque_habitacion BIGSERIAL PRIMARY KEY,
    id_habitacion BIGINT NOT NULL REFERENCES habitacion(id_habitacion),
    fecha_inicio TIMESTAMP NOT NULL,
    fecha_fin TIMESTAMP NOT NULL,
    motivo_bloqueo VARCHAR(100) NOT NULL,
    tipo_bloqueo VARCHAR(30) NOT NULL CHECK (
        tipo_bloqueo IN ('MANTENIMIENTO','LIMPIEZA_PROFUNDA','RESERVA_INTERNA','FUERA_SERVICIO','OTRO')
    ),
    observaciones TEXT,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_bloque_habitacion_fechas CHECK (fecha_fin > fecha_inicio)
);

CREATE TABLE calendario_temporada (
    id_calendario_temporada BIGSERIAL PRIMARY KEY,
    id_propiedad BIGINT REFERENCES propiedad(id_propiedad),
    id_temporada BIGINT NOT NULL REFERENCES temporada(id_temporada),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_cal_temporada_fechas CHECK (fecha_fin >= fecha_inicio)
);

-- ============================================================
-- 3) ÍNDICES
-- ============================================================

CREATE INDEX idx_propiedad_ciudad ON propiedad(id_ciudad);
CREATE INDEX idx_habitacion_propiedad ON habitacion(id_propiedad);
CREATE INDEX idx_habitacion_tipo ON habitacion(id_tipo_habitacion);
CREATE INDEX idx_huesped_segmento ON huesped(id_segmento_cliente);
CREATE INDEX idx_huesped_nacionalidad ON huesped(id_pais_nacionalidad);
CREATE INDEX idx_huesped_motivo ON huesped(id_motivo_viaje);
CREATE INDEX idx_reserva_propiedad ON reserva(id_propiedad);
CREATE INDEX idx_reserva_huesped_titular ON reserva(id_huesped_titular);
CREATE INDEX idx_reserva_canal ON reserva(id_canal_reserva);
CREATE INDEX idx_reserva_estado ON reserva(id_estado_reserva);
CREATE INDEX idx_reserva_fecha_reserva ON reserva(fecha_reserva);
CREATE INDEX idx_reserva_checkin_prog ON reserva(fecha_checkin_programado);
CREATE INDEX idx_reserva_checkout_prog ON reserva(fecha_checkout_programado);
CREATE INDEX idx_reserva_cancelacion ON reserva(fecha_cancelacion);
CREATE INDEX idx_reserva_habitacion_reserva ON reserva_habitacion(id_reserva);
CREATE INDEX idx_reserva_habitacion_habitacion ON reserva_habitacion(id_habitacion);
CREATE INDEX idx_reserva_huesped_reserva ON reserva_huesped(id_reserva);
CREATE INDEX idx_reserva_huesped_huesped ON reserva_huesped(id_huesped);
CREATE INDEX idx_factura_reserva ON factura(id_reserva);
CREATE INDEX idx_pago_factura ON pago(id_factura);
CREATE INDEX idx_consumo_reserva ON consumo_servicio(id_reserva);
CREATE INDEX idx_consumo_huesped ON consumo_servicio(id_huesped);
CREATE INDEX idx_consumo_servicio ON consumo_servicio(id_servicio);
CREATE INDEX idx_consumo_fecha ON consumo_servicio(fecha_consumo);
CREATE INDEX idx_bloque_habitacion_habitacion ON bloque_habitacion(id_habitacion);
CREATE INDEX idx_calendario_temporada_propiedad_fecha
    ON calendario_temporada(id_propiedad, fecha_inicio, fecha_fin);

-- ============================================================
-- 4) TRIGGER DE AUDITORÍA
-- ============================================================

CREATE OR REPLACE FUNCTION hotel_ops.fn_set_fecha_actualizacion()
RETURNS TRIGGER AS $$
BEGIN
    NEW.fecha_actualizacion = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT table_name
        FROM information_schema.columns
        WHERE table_schema = 'hotel_ops'
          AND column_name = 'fecha_actualizacion'
    LOOP
        EXECUTE format(
            'DROP TRIGGER IF EXISTS trg_%I_fecha_actualizacion ON hotel_ops.%I;',
            r.table_name, r.table_name
        );

        EXECUTE format(
            'CREATE TRIGGER trg_%I_fecha_actualizacion
             BEFORE UPDATE ON hotel_ops.%I
             FOR EACH ROW
             EXECUTE FUNCTION hotel_ops.fn_set_fecha_actualizacion();',
            r.table_name, r.table_name
        );
    END LOOP;
END
$$;

