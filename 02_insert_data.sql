-- ============================================================
-- 02_insert_data.sql
-- Carga sintética para proyecto BI - Grupo 9
-- Motor: PostgreSQL
-- Ejecutar DESPUÉS de 01_schema.sql
-- ============================================================

SET search_path TO hotel_ops;
SELECT setseed(0.42);

-- ============================================================
-- 1) CATÁLOGOS
-- ============================================================

INSERT INTO pais (nombre_pais, codigo_iso2, codigo_iso3) VALUES
('Costa Rica','CR','CRI'),
('Estados Unidos','US','USA'),
('México','MX','MEX'),
('España','ES','ESP'),
('Argentina','AR','ARG'),
('Colombia','CO','COL'),
('Panamá','PA','PAN'),
('Guatemala','GT','GTM'),
('Canadá','CA','CAN'),
('Alemania','DE','DEU');

INSERT INTO ciudad (id_pais, nombre_ciudad, provincia_estado) VALUES
(1,'San José','San José'),
(1,'Liberia','Guanacaste'),
(1,'Limón','Limón'),
(1,'Jacó','Puntarenas'),
(1,'La Fortuna','Alajuela'),
(1,'Manuel Antonio','Puntarenas'),
(2,'Miami','Florida'),
(3,'Ciudad de México','CDMX'),
(4,'Madrid','Madrid'),
(5,'Buenos Aires','Buenos Aires'),
(7,'Ciudad de Panamá','Panamá'),
(9,'Toronto','Ontario');

INSERT INTO tipo_propiedad (nombre_tipo, descripcion) VALUES
('Resort','Hotel vacacional con alta oferta de amenidades'),
('Urbano','Hotel orientado a negocios y turismo de ciudad'),
('Boutique','Hotel pequeño con enfoque premium'),
('Ecohotel','Hotel con enfoque natural y sostenible');

INSERT INTO tipo_habitacion (nombre_tipo, descripcion, capacidad_minima, capacidad_maxima, tarifa_rack_base) VALUES
('Sencilla','Habitación individual',1,1,55.00),
('Doble','Habitación doble',1,2,85.00),
('Suite','Suite ejecutiva o premium',2,4,145.00),
('Familiar','Habitación para grupos familiares',3,5,180.00);

INSERT INTO canal_reserva (nombre_canal, categoria_canal, proveedor, comision_pct) VALUES
('Booking','OTA','Booking Holdings',17.00),
('Expedia','OTA','Expedia Group',18.00),
('Web Directa','DIRECTO_WEB','Sitio Web Propio',0.00),
('Agencia Mayorista','AGENCIA','Agencia Aliada',12.00),
('Call Center','CALL_CENTER','Interno',0.00),
('Walk In','WALK_IN','Mostrador',0.00),
('Convenio Empresa','CORPORATIVO','Empresas Conveniadas',8.00);

INSERT INTO segmento_cliente (nombre_segmento, descripcion) VALUES
('Turista','Cliente de ocio o vacaciones'),
('Corporativo','Cliente de negocios'),
('Familiar','Grupo familiar'),
('Grupo','Reservas grupales o eventos');

INSERT INTO motivo_viaje (nombre_motivo, descripcion) VALUES
('Vacaciones','Viaje de ocio'),
('Negocios','Viaje corporativo'),
('Visita Familiar','Viaje por familia'),
('Evento','Congreso, boda, reunión o actividad');

INSERT INTO rango_etario (nombre_rango, edad_min, edad_max) VALUES
('18-25',18,25),
('26-35',26,35),
('36-45',36,45),
('46-60',46,60),
('61+',61,99);

INSERT INTO genero (nombre_genero) VALUES
('Masculino'),
('Femenino'),
('No especifica');

INSERT INTO tipo_documento (nombre_tipo) VALUES
('Cédula'),
('Pasaporte');

INSERT INTO metodo_pago (nombre_metodo, categoria_metodo) VALUES
('Efectivo','EFECTIVO'),
('Tarjeta Crédito','TARJETA'),
('Tarjeta Débito','TARJETA'),
('Transferencia','TRANSFERENCIA'),
('Convenio Empresa','CORPORATIVO');

INSERT INTO temporada (nombre_temporada, descripcion, prioridad_precio) VALUES
('Alta','Mayor demanda',3),
('Media','Demanda intermedia',2),
('Baja','Menor demanda',1);

INSERT INTO servicio_complementario (codigo_servicio, nombre_servicio, categoria_servicio, precio_base, requiere_reserva) VALUES
('SRV001','Restaurante','RESTAURANTE',18.00,FALSE),
('SRV002','Spa','SPA',55.00,TRUE),
('SRV003','Tour','TOUR',75.00,TRUE),
('SRV004','Traslado','TRASLADO',28.00,TRUE),
('SRV005','Estacionamiento','ESTACIONAMIENTO',10.00,FALSE),
('SRV006','Lavandería','LAVANDERIA',14.00,FALSE);

INSERT INTO estado_reserva (nombre_estado, descripcion) VALUES
('Confirmada','Reserva futura aún no ejecutada'),
('Cancelada','Reserva cancelada antes del check-in'),
('NoShow','Cliente no se presentó'),
('Completada','Estadía finalizada');

-- ============================================================
-- 2) PROPIEDADES
-- ============================================================

INSERT INTO propiedad (
    codigo_propiedad,
    nombre_propiedad,
    id_tipo_propiedad,
    categoria_estrellas,
    id_ciudad,
    direccion,
    telefono,
    email,
    fecha_apertura,
    total_habitaciones_planificadas
) VALUES
('HTL001','Hotel Central San José',2,4,1,'Paseo Colón, San José','2222-1001','central@hotelbi.com','2017-03-15',40),
('HTL002','Resort Pacífico Jacó',1,5,4,'Costanera Sur, Jacó','2222-1002','pacifico@hotelbi.com','2018-07-01',40),
('HTL003','Ecohotel Arenal',4,4,5,'La Fortuna, Alajuela','2222-1003','arenal@hotelbi.com','2019-11-20',40),
('HTL004','Boutique Manuel Antonio',3,5,6,'Quepos, Puntarenas','2222-1004','boutique@hotelbi.com','2020-02-10',40);

-- ============================================================
-- 3) HABITACIONES (160)
-- ============================================================

INSERT INTO habitacion (
    id_propiedad,
    id_tipo_habitacion,
    numero_habitacion,
    piso,
    zona,
    vista,
    tarifa_rack_actual,
    estado_operativo,
    fecha_ultima_renovacion
)
SELECT
    p.id_propiedad,
    CASE
        WHEN s.n BETWEEN 1 AND 10 THEN 1
        WHEN s.n BETWEEN 11 AND 25 THEN 2
        WHEN s.n BETWEEN 26 AND 35 THEN 3
        ELSE 4
    END AS id_tipo_habitacion,
    ((p.id_propiedad * 100) + s.n)::VARCHAR(20) AS numero_habitacion,
    CEIL(s.n / 10.0)::VARCHAR(20) AS piso,
    CASE WHEN s.n % 2 = 0 THEN 'Norte' ELSE 'Sur' END AS zona,
    CASE
        WHEN p.id_propiedad = 1 THEN CASE WHEN s.n % 3 = 0 THEN 'Ciudad' ELSE 'Avenida' END
        WHEN p.id_propiedad = 2 THEN CASE WHEN s.n % 3 = 0 THEN 'Mar' ELSE 'Piscina' END
        WHEN p.id_propiedad = 3 THEN CASE WHEN s.n % 3 = 0 THEN 'Volcán' ELSE 'Jardín' END
        ELSE CASE WHEN s.n % 3 = 0 THEN 'Parque' ELSE 'Bosque' END
    END AS vista,
    CASE
        WHEN s.n BETWEEN 1 AND 10 THEN 55 + (p.id_propiedad * 5)
        WHEN s.n BETWEEN 11 AND 25 THEN 85 + (p.id_propiedad * 6)
        WHEN s.n BETWEEN 26 AND 35 THEN 145 + (p.id_propiedad * 8)
        ELSE 180 + (p.id_propiedad * 10)
    END::NUMERIC(12,2) AS tarifa_rack_actual,
    'DISPONIBLE' AS estado_operativo,
    DATE '2024-01-01' + ((p.id_propiedad * s.n) % 300)
FROM propiedad p
CROSS JOIN generate_series(1, 40) AS s(n);

-- ============================================================
-- 4) HUÉSPEDES (300)
-- ============================================================

WITH base AS (
    SELECT
        g,
        (18 + ((g * 7) % 55))::SMALLINT AS edad
    FROM generate_series(1, 300) AS g
)
INSERT INTO huesped (
    codigo_huesped,
    id_tipo_documento,
    numero_documento,
    nombres,
    apellidos,
    fecha_nacimiento,
    edad_registrada,
    id_rango_etario,
    id_genero,
    id_pais_nacionalidad,
    email,
    telefono,
    id_segmento_cliente,
    id_motivo_viaje,
    es_recurrente,
    cantidad_estadias_previas,
    fecha_registro,
    activo
)
SELECT
    'HSP' || LPAD(g::TEXT, 5, '0') AS codigo_huesped,
    CASE WHEN g % 3 = 0 THEN 2 ELSE 1 END AS id_tipo_documento,
    CASE WHEN g % 3 = 0 THEN 'P-' ELSE 'C-' END || LPAD(g::TEXT, 8, '0') AS numero_documento,
    'Nombre_' || g AS nombres,
    'Apellido_' || ((g * 13) % 400 + 1) AS apellidos,
    CURRENT_DATE - make_interval(years => edad::INT),
    edad,
    (
        SELECT r.id_rango_etario
        FROM rango_etario r
        WHERE edad BETWEEN r.edad_min AND r.edad_max
        LIMIT 1
    ) AS id_rango_etario,
    ((g - 1) % 3) + 1 AS id_genero,
    ((g - 1) % 10) + 1 AS id_pais_nacionalidad,
    'huesped' || g || '@mail.com' AS email,
    '6000' || LPAD(((g * 37) % 10000)::TEXT, 4, '0') AS telefono,
    CASE
        WHEN g % 10 IN (0,1,2,3,4) THEN 1
        WHEN g % 10 IN (5,6) THEN 2
        WHEN g % 10 IN (7,8) THEN 3
        ELSE 4
    END AS id_segmento_cliente,
    CASE
        WHEN g % 10 IN (0,1,2,3,4) THEN 1
        WHEN g % 10 IN (5,6) THEN 2
        WHEN g % 10 IN (7,8) THEN 3
        ELSE 4
    END AS id_motivo_viaje,
    CASE WHEN g % 4 = 0 THEN TRUE ELSE FALSE END AS es_recurrente,
    CASE WHEN g % 4 = 0 THEN (g % 8) + 1 ELSE 0 END AS cantidad_estadias_previas,
    DATE '2024-01-01' + (g % 400),
    TRUE
FROM base;

-- ============================================================
-- 5) CALENDARIO DE TEMPORADAS POR PROPIEDAD
-- ============================================================

INSERT INTO calendario_temporada (
    id_propiedad,
    id_temporada,
    fecha_inicio,
    fecha_fin
)
SELECT p.id_propiedad, t.id_temporada, x.fecha_inicio, x.fecha_fin
FROM propiedad p
CROSS JOIN (
    VALUES
        (1, DATE '2025-01-01', DATE '2025-03-31'),
        (2, DATE '2025-04-01', DATE '2025-06-30'),
        (1, DATE '2025-07-01', DATE '2025-08-31'),
        (3, DATE '2025-09-01', DATE '2025-11-30'),
        (1, DATE '2025-12-01', DATE '2025-12-31'),
        (1, DATE '2026-01-01', DATE '2026-03-31'),
        (2, DATE '2026-04-01', DATE '2026-06-30'),
        (1, DATE '2026-07-01', DATE '2026-08-31'),
        (3, DATE '2026-09-01', DATE '2026-11-30'),
        (1, DATE '2026-12-01', DATE '2026-12-31')
) AS x(id_temporada, fecha_inicio, fecha_fin)
JOIN temporada t
    ON t.id_temporada = x.id_temporada;

-- ============================================================
-- 6) BLOQUEOS DE HABITACIÓN
-- ============================================================

INSERT INTO bloque_habitacion (
    id_habitacion,
    fecha_inicio,
    fecha_fin,
    motivo_bloqueo,
    tipo_bloqueo,
    observaciones
)
SELECT
    h.id_habitacion,
    (DATE '2025-01-15' + (g * 18))::TIMESTAMP + INTERVAL '08:00',
    (DATE '2025-01-15' + (g * 18) + 2)::TIMESTAMP + INTERVAL '17:00',
    CASE WHEN g % 2 = 0 THEN 'Mantenimiento preventivo' ELSE 'Limpieza profunda' END,
    CASE WHEN g % 2 = 0 THEN 'MANTENIMIENTO' ELSE 'LIMPIEZA_PROFUNDA' END,
    'Bloqueo programado ' || g
FROM (
    SELECT id_habitacion, row_number() OVER (ORDER BY id_habitacion) AS rn
    FROM habitacion
) h
JOIN generate_series(1, 24) AS g
    ON h.rn = g;

-- ============================================================
-- 7) RESERVAS (900)
-- ============================================================

WITH base AS (
    SELECT
        g,
        ((g - 1) % 4) + 1 AS id_propiedad,
        ((g * 7 - 1) % 300) + 1 AS id_huesped_titular,
        ((g - 1) % 7) + 1 AS id_canal_reserva,
        CASE
            WHEN g % 20 IN (1,2,3) THEN 2  -- Cancelada
            WHEN g % 20 = 4 THEN 3         -- NoShow
            WHEN g % 20 IN (5,6) THEN 1    -- Confirmada
            ELSE 4                         -- Completada
        END AS id_estado_reserva,
        ((g - 1) % 5) + 1 AS id_metodo_pago_garantia,
        (DATE '2025-01-01' + ((g * 2 + (((g - 1) % 4) + 1) * 7) % 620))::DATE AS fecha_checkin_programado,
        (1 + (g % 6))::INT AS noches,
        CASE
            WHEN g % 10 IN (0,1,2) THEN 1
            WHEN g % 10 IN (3,4,5) THEN 2
            ELSE 3
        END AS adultos,
        CASE WHEN g % 6 = 0 THEN 2 WHEN g % 4 = 0 THEN 1 ELSE 0 END AS ninos,
        CASE WHEN g % 12 = 0 THEN 1 ELSE 0 END AS infantes,
        CASE
            WHEN g % 15 = 0 THEN 15
            WHEN g % 9 = 0 THEN 10
            WHEN g % 5 = 0 THEN 5
            ELSE 0
        END::NUMERIC(5,2) AS descuento_pct
    FROM generate_series(1, 900) AS g
)
INSERT INTO reserva (
    codigo_reserva,
    id_propiedad,
    id_huesped_titular,
    id_canal_reserva,
    id_estado_reserva,
    id_metodo_pago_garantia,
    fecha_reserva,
    fecha_checkin_programado,
    fecha_checkout_programado,
    fecha_checkin_real,
    fecha_checkout_real,
    adultos,
    ninos,
    infantes,
    cantidad_habitaciones,
    descuento_pct,
    observaciones,
    monto_habitacion_bruto,
    monto_descuento,
    monto_habitacion_neto,
    monto_servicios,
    monto_impuestos,
    monto_total_reserva,
    fecha_cancelacion,
    motivo_cancelacion,
    activo
)
SELECT
    'RES' || LPAD(g::TEXT, 6, '0'),
    id_propiedad,
    id_huesped_titular,
    id_canal_reserva,
    id_estado_reserva,
    id_metodo_pago_garantia,
    (fecha_checkin_programado - ((g % 90) + 1))::TIMESTAMP + INTERVAL '10:00' AS fecha_reserva,
    fecha_checkin_programado,
    fecha_checkin_programado + noches,
    CASE
        WHEN id_estado_reserva = 4 THEN fecha_checkin_programado::TIMESTAMP + INTERVAL '15:00'
        ELSE NULL
    END AS fecha_checkin_real,
    CASE
        WHEN id_estado_reserva = 4 THEN (fecha_checkin_programado + noches)::TIMESTAMP + INTERVAL '11:00'
        ELSE NULL
    END AS fecha_checkout_real,
    adultos,
    ninos,
    infantes,
    1,
    descuento_pct,
    CASE
        WHEN id_estado_reserva = 2 THEN 'Reserva cancelada por cliente'
        WHEN id_estado_reserva = 3 THEN 'Cliente no se presentó'
        ELSE 'Reserva generada automáticamente'
    END,
    0, 0, 0, 0, 0, 0,
    CASE
        WHEN id_estado_reserva = 2 THEN (fecha_checkin_programado - ((g % 90) + 1))::TIMESTAMP + INTERVAL '16:00'
        ELSE NULL
    END AS fecha_cancelacion,
    CASE
        WHEN id_estado_reserva = 2 THEN
            CASE
                WHEN g % 3 = 0 THEN 'Cambio de planes'
                WHEN g % 3 = 1 THEN 'Precio'
                ELSE 'Disponibilidad'
            END
        ELSE NULL
    END AS motivo_cancelacion,
    TRUE
FROM base;

-- ============================================================
-- 8) RESERVA_HUESPED
-- ============================================================

-- titular
INSERT INTO reserva_huesped (
    id_reserva,
    id_huesped,
    es_titular,
    es_hospedado
)
SELECT
    r.id_reserva,
    r.id_huesped_titular,
    TRUE,
    TRUE
FROM reserva r;

-- acompañante 1
INSERT INTO reserva_huesped (
    id_reserva,
    id_huesped,
    es_titular,
    es_hospedado
)
SELECT
    r.id_reserva,
    ((r.id_huesped_titular + 37 - 1) % 300) + 1,
    FALSE,
    TRUE
FROM reserva r
WHERE (r.adultos + r.ninos + r.infantes) >= 2;

-- acompañante 2
INSERT INTO reserva_huesped (
    id_reserva,
    id_huesped,
    es_titular,
    es_hospedado
)
SELECT
    r.id_reserva,
    ((r.id_huesped_titular + 121 - 1) % 300) + 1,
    FALSE,
    TRUE
FROM reserva r
WHERE (r.adultos + r.ninos + r.infantes) >= 3;

-- ============================================================
-- 9) RESERVA_HABITACION
-- ============================================================

WITH rooms AS (
    SELECT
        h.id_habitacion,
        h.id_propiedad,
        h.tarifa_rack_actual,
        row_number() OVER (PARTITION BY h.id_propiedad ORDER BY h.id_habitacion) AS rn,
        count(*) OVER (PARTITION BY h.id_propiedad) AS total_rooms
    FROM habitacion h
),
res_by_property AS (
    SELECT
        r.id_reserva,
        r.id_propiedad,
        r.descuento_pct,
        r.estadia_noches_programadas,
        row_number() OVER (PARTITION BY r.id_propiedad ORDER BY r.id_reserva) AS rn_res
    FROM reserva r
)
INSERT INTO reserva_habitacion (
    id_reserva,
    id_habitacion,
    tarifa_noche_bruta,
    descuento_pct,
    tarifa_noche_neta,
    cantidad_noches,
    subtotal_bruto,
    subtotal_descuento,
    subtotal_neto,
    cantidad_huespedes_asignados
)
SELECT
    r.id_reserva,
    rm.id_habitacion,
    rm.tarifa_rack_actual,
    r.descuento_pct,
    ROUND(rm.tarifa_rack_actual * (1 - r.descuento_pct / 100.0), 2) AS tarifa_noche_neta,
    r.estadia_noches_programadas,
    ROUND(rm.tarifa_rack_actual * r.estadia_noches_programadas, 2) AS subtotal_bruto,
    ROUND((rm.tarifa_rack_actual * r.estadia_noches_programadas) * (r.descuento_pct / 100.0), 2) AS subtotal_descuento,
    ROUND((rm.tarifa_rack_actual * r.estadia_noches_programadas) * (1 - r.descuento_pct / 100.0), 2) AS subtotal_neto,
    1
FROM res_by_property r
JOIN rooms rm
  ON rm.id_propiedad = r.id_propiedad
 AND rm.rn = ((r.rn_res - 1) % rm.total_rooms) + 1;

-- ============================================================
-- 10) ACTUALIZAR MONTOS DE RESERVA A PARTIR DEL HOSPEDAJE
-- ============================================================

WITH room_sum AS (
    SELECT
        rh.id_reserva,
        ROUND(SUM(rh.subtotal_bruto), 2) AS bruto,
        ROUND(SUM(rh.subtotal_descuento), 2) AS descuento,
        ROUND(SUM(rh.subtotal_neto), 2) AS neto
    FROM reserva_habitacion rh
    GROUP BY rh.id_reserva
)
UPDATE reserva r
SET
    monto_habitacion_bruto = rs.bruto,
    monto_descuento = rs.descuento,
    monto_habitacion_neto = rs.neto,
    monto_impuestos = ROUND(rs.neto * 0.13, 2),
    monto_total_reserva = ROUND(rs.neto * 1.13, 2)
FROM room_sum rs
WHERE r.id_reserva = rs.id_reserva;

-- ============================================================
-- 11) CONSUMO DE SERVICIOS
-- ============================================================

INSERT INTO consumo_servicio (
    id_reserva,
    id_huesped,
    id_servicio,
    fecha_consumo,
    cantidad,
    precio_unitario,
    descuento_monto,
    impuesto_monto,
    subtotal,
    total,
    estado_consumo,
    observaciones
)
SELECT
    r.id_reserva,
    r.id_huesped_titular,
    ((r.id_reserva + gs.n - 1) % 6) + 1 AS id_servicio,
    COALESCE(r.fecha_checkin_real, r.fecha_checkin_programado::TIMESTAMP + INTERVAL '15 hours') + (gs.n * INTERVAL '5 hours') AS fecha_consumo,
    ((r.id_reserva + gs.n) % 3 + 1)::NUMERIC(12,2) AS cantidad,
    sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3) AS precio_unitario,
    ROUND(
        CASE
            WHEN (r.id_reserva + gs.n) % 7 = 0 THEN ((sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3)) * (((r.id_reserva + gs.n) % 3 + 1))) * 0.10
            ELSE 0
        END
    , 2) AS descuento_monto,
    ROUND(
        (
            ((sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3)) * (((r.id_reserva + gs.n) % 3 + 1)))
            -
            CASE
                WHEN (r.id_reserva + gs.n) % 7 = 0 THEN ((sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3)) * (((r.id_reserva + gs.n) % 3 + 1))) * 0.10
                ELSE 0
            END
        ) * 0.13
    , 2) AS impuesto_monto,
    ROUND(
        (
            ((sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3)) * (((r.id_reserva + gs.n) % 3 + 1)))
            -
            CASE
                WHEN (r.id_reserva + gs.n) % 7 = 0 THEN ((sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3)) * (((r.id_reserva + gs.n) % 3 + 1))) * 0.10
                ELSE 0
            END
        )
    , 2) AS subtotal,
    ROUND(
        (
            (
                ((sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3)) * (((r.id_reserva + gs.n) % 3 + 1)))
                -
                CASE
                    WHEN (r.id_reserva + gs.n) % 7 = 0 THEN ((sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3)) * (((r.id_reserva + gs.n) % 3 + 1))) * 0.10
                    ELSE 0
                END
            ) * 1.13
        )
    , 2) AS total,
    CASE
        WHEN r.id_estado_reserva = 4 THEN 'FACTURADO'
        ELSE 'REGISTRADO'
    END AS estado_consumo,
    'Consumo automático'
FROM reserva r
JOIN LATERAL generate_series(
    1,
    CASE
        WHEN r.id_estado_reserva = 4 THEN 1 + (r.id_reserva % 3)   -- 1 a 3 consumos si completada
        WHEN r.id_estado_reserva = 1 THEN 1                        -- 1 consumo si confirmada
        ELSE 0
    END
) AS gs(n) ON TRUE
JOIN servicio_complementario sc
  ON sc.id_servicio = ((r.id_reserva + gs.n - 1) % 6) + 1
WHERE r.id_estado_reserva IN (1,4);

-- ============================================================
-- 12) RECALCULAR MONTOS DE RESERVA INCLUYENDO SERVICIOS
-- ============================================================

WITH svc_sum AS (
    SELECT
        cs.id_reserva,
        ROUND(SUM(cs.subtotal), 2) AS subtotal_servicios,
        ROUND(SUM(cs.impuesto_monto), 2) AS impuestos_servicios,
        ROUND(SUM(cs.total), 2) AS total_servicios
    FROM consumo_servicio cs
    GROUP BY cs.id_reserva
)
UPDATE reserva r
SET
    monto_servicios = COALESCE(s.total_servicios, 0),
    monto_impuestos = ROUND((r.monto_habitacion_neto * 0.13) + COALESCE(s.impuestos_servicios, 0), 2),
    monto_total_reserva = ROUND(r.monto_habitacion_neto + (r.monto_habitacion_neto * 0.13) + COALESCE(s.total_servicios, 0), 2)
FROM svc_sum s
WHERE r.id_reserva = s.id_reserva;

-- ============================================================
-- 13) FACTURAS
-- ============================================================

WITH svc_sum AS (
    SELECT
        cs.id_reserva,
        ROUND(SUM(cs.subtotal), 2) AS subtotal_servicios,
        ROUND(SUM(cs.descuento_monto), 2) AS descuento_servicios,
        ROUND(SUM(cs.impuesto_monto), 2) AS impuesto_servicios
    FROM consumo_servicio cs
    GROUP BY cs.id_reserva
),
base AS (
    SELECT
        r.id_reserva,
        ROW_NUMBER() OVER (ORDER BY r.id_reserva) AS rn,
        r.fecha_checkout_programado::TIMESTAMP + INTERVAL '11 hours' AS fecha_emision,
        ROUND(r.monto_habitacion_neto + COALESCE(s.subtotal_servicios, 0), 2) AS subtotal,
        ROUND(r.monto_descuento + COALESCE(s.descuento_servicios, 0), 2) AS descuento_total,
        ROUND((r.monto_habitacion_neto * 0.13) + COALESCE(s.impuesto_servicios, 0), 2) AS impuesto,
        ROUND(r.monto_total_reserva, 2) AS total,
        CASE
            WHEN r.id_estado_reserva = 4 THEN 'PAGADA'
            WHEN r.id_estado_reserva = 1 THEN 'EMITIDA'
            ELSE 'ANULADA'
        END AS estado_factura
    FROM reserva r
    LEFT JOIN svc_sum s
      ON s.id_reserva = r.id_reserva
    WHERE r.id_estado_reserva IN (1,4)
)
INSERT INTO factura (
    numero_factura,
    id_reserva,
    fecha_emision,
    subtotal,
    impuesto,
    descuento_total,
    total,
    moneda,
    estado_factura,
    observaciones
)
SELECT
    'FAC' || LPAD(rn::TEXT, 6, '0'),
    id_reserva,
    fecha_emision,
    subtotal,
    impuesto,
    descuento_total,
    total,
    'USD',
    estado_factura,
    'Factura generada automáticamente'
FROM base;

-- ============================================================
-- 14) DETALLE FACTURA - HOSPEDAJE
-- ============================================================

INSERT INTO detalle_factura (
    id_factura,
    tipo_concepto,
    referencia_origen,
    descripcion_concepto,
    cantidad,
    precio_unitario,
    descuento_monto,
    impuesto_monto,
    subtotal_linea,
    total_linea
)
SELECT
    f.id_factura,
    'HABITACION',
    rh.id_reserva_habitacion::TEXT,
    'Hospedaje habitación ' || h.numero_habitacion,
    rh.cantidad_noches,
    rh.tarifa_noche_bruta,
    rh.subtotal_descuento,
    ROUND(rh.subtotal_neto * 0.13, 2),
    rh.subtotal_neto,
    ROUND(rh.subtotal_neto * 1.13, 2)
FROM factura f
JOIN reserva_habitacion rh
  ON rh.id_reserva = f.id_reserva
JOIN habitacion h
  ON h.id_habitacion = rh.id_habitacion;

-- ============================================================
-- 15) DETALLE FACTURA - SERVICIOS
-- ============================================================

INSERT INTO detalle_factura (
    id_factura,
    tipo_concepto,
    referencia_origen,
    descripcion_concepto,
    cantidad,
    precio_unitario,
    descuento_monto,
    impuesto_monto,
    subtotal_linea,
    total_linea
)
SELECT
    f.id_factura,
    'SERVICIO',
    cs.id_consumo_servicio::TEXT,
    'Servicio ' || s.nombre_servicio,
    cs.cantidad,
    cs.precio_unitario,
    cs.descuento_monto,
    cs.impuesto_monto,
    cs.subtotal,
    cs.total
FROM factura f
JOIN consumo_servicio cs
  ON cs.id_reserva = f.id_reserva
JOIN servicio_complementario s
  ON s.id_servicio = cs.id_servicio;

-- ============================================================
-- 16) PAGOS
-- ============================================================

-- pagos completos para facturas pagadas
INSERT INTO pago (
    id_factura,
    id_metodo_pago,
    fecha_pago,
    monto_pago,
    moneda,
    referencia_pago,
    estado_pago
)
SELECT
    f.id_factura,
    ((f.id_factura - 1) % 5) + 1 AS id_metodo_pago,
    f.fecha_emision + INTERVAL '1 day',
    f.total,
    'USD',
    'PAY-' || LPAD(f.id_factura::TEXT, 6, '0'),
    'APLICADO'
FROM factura f
WHERE f.estado_factura = 'PAGADA';

-- pagos parciales pendientes para facturas emitidas
INSERT INTO pago (
    id_factura,
    id_metodo_pago,
    fecha_pago,
    monto_pago,
    moneda,
    referencia_pago,
    estado_pago
)
SELECT
    f.id_factura,
    ((f.id_factura + 1 - 1) % 5) + 1 AS id_metodo_pago,
    f.fecha_emision + INTERVAL '2 day',
    ROUND(f.total * 0.40, 2),
    'USD',
    'PPD-' || LPAD(f.id_factura::TEXT, 6, '0'),
    'PENDIENTE'
FROM factura f
WHERE f.estado_factura = 'EMITIDA';

-- ============================================================
-- 17) QUERIES RÁPIDAS DE VERIFICACIÓN
-- ============================================================

-- SELECT COUNT(*) AS propiedades FROM propiedad;
-- SELECT COUNT(*) AS habitaciones FROM habitacion;
-- SELECT COUNT(*) AS huespedes FROM huesped;
-- SELECT COUNT(*) AS reservas FROM reserva;
-- SELECT COUNT(*) AS reserva_huesped FROM reserva_huesped;
-- SELECT COUNT(*) AS reserva_habitacion FROM reserva_habitacion;
-- SELECT COUNT(*) AS consumos_servicio FROM consumo_servicio;
-- SELECT COUNT(*) AS facturas FROM factura;
-- SELECT COUNT(*) AS pagos FROM pago;
