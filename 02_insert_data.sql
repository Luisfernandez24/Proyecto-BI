-- ============================================================
-- 02_insert_data.sql 
-- ============================================================

SET search_path TO hotel_ops;
SELECT setseed(0.42);

-- ============================================================
-- 0) LIMPIEZA SEGURA 
-- ============================================================

TRUNCATE TABLE
    detalle_factura,
    pago,
    consumo_servicio,
    bloque_habitacion,
    calendario_temporada,
    reserva_huesped,
    reserva_habitacion,
    factura,
    reserva,
    huesped,
    habitacion,
    propiedad,
    ciudad,
    pais,
    tipo_propiedad,
    tipo_habitacion,
    canal_reserva,
    segmento_cliente,
    motivo_viaje,
    rango_etario,
    genero,
    tipo_documento,
    metodo_pago,
    temporada,
    servicio_complementario,
    estado_reserva
RESTART IDENTITY CASCADE;

-- ============================================================
-- 1) CATÁLOGOS
-- ============================================================

INSERT INTO pais (id_pais, nombre_pais, codigo_iso2, codigo_iso3) VALUES
(1,'Costa Rica','CR','CRI'),
(2,'Estados Unidos','US','USA'),
(3,'México','MX','MEX'),
(4,'España','ES','ESP'),
(5,'Argentina','AR','ARG'),
(6,'Colombia','CO','COL'),
(7,'Panamá','PA','PAN'),
(8,'Guatemala','GT','GTM'),
(9,'Canadá','CA','CAN'),
(10,'Alemania','DE','DEU');

INSERT INTO ciudad (id_ciudad, id_pais, nombre_ciudad, provincia_estado) VALUES
(1,1,'San José','San José'),
(2,1,'Liberia','Guanacaste'),
(3,1,'Limón','Limón'),
(4,1,'Jacó','Puntarenas'),
(5,1,'La Fortuna','Alajuela'),
(6,1,'Manuel Antonio','Puntarenas'),
(7,2,'Miami','Florida'),
(8,3,'Ciudad de México','CDMX'),
(9,4,'Madrid','Madrid'),
(10,5,'Buenos Aires','Buenos Aires'),
(11,7,'Ciudad de Panamá','Panamá'),
(12,9,'Toronto','Ontario');

INSERT INTO tipo_propiedad (id_tipo_propiedad, nombre_tipo, descripcion) VALUES
(1,'Resort','Hotel vacacional con alta oferta de amenidades'),
(2,'Urbano','Hotel orientado a negocios y turismo de ciudad'),
(3,'Boutique','Hotel pequeño con enfoque premium'),
(4,'Ecohotel','Hotel con enfoque natural y sostenible');

INSERT INTO tipo_habitacion (id_tipo_habitacion, nombre_tipo, descripcion, capacidad_minima, capacidad_maxima, tarifa_rack_base) VALUES
(1,'Sencilla','Habitación individual',1,1,55.00),
(2,'Doble','Habitación doble',1,2,85.00),
(3,'Suite','Suite ejecutiva o premium',2,4,145.00),
(4,'Familiar','Habitación para grupos familiares',3,5,180.00);

INSERT INTO canal_reserva (id_canal_reserva, nombre_canal, categoria_canal, proveedor, comision_pct) VALUES
(1,'Booking','OTA','Booking Holdings',17.00),
(2,'Expedia','OTA','Expedia Group',18.00),
(3,'Web Directa','DIRECTO_WEB','Sitio Web Propio',0.00),
(4,'Agencia Mayorista','AGENCIA','Agencia Aliada',12.00),
(5,'Call Center','CALL_CENTER','Interno',0.00),
(6,'Walk In','WALK_IN','Mostrador',0.00),
(7,'Convenio Empresa','CORPORATIVO','Empresas Conveniadas',8.00);

INSERT INTO segmento_cliente (id_segmento_cliente, nombre_segmento, descripcion) VALUES
(1,'Turista','Cliente de ocio o vacaciones'),
(2,'Corporativo','Cliente de negocios'),
(3,'Familiar','Grupo familiar'),
(4,'Grupo','Reservas grupales o eventos');

INSERT INTO motivo_viaje (id_motivo_viaje, nombre_motivo, descripcion) VALUES
(1,'Vacaciones','Viaje de ocio'),
(2,'Negocios','Viaje corporativo'),
(3,'Visita Familiar','Viaje por familia'),
(4,'Evento','Congreso, boda, reunión o actividad');

INSERT INTO rango_etario (id_rango_etario, nombre_rango, edad_min, edad_max) VALUES
(1,'18-25',18,25),
(2,'26-35',26,35),
(3,'36-45',36,45),
(4,'46-60',46,60),
(5,'61+',61,99);

INSERT INTO genero (id_genero, nombre_genero) VALUES
(1,'Masculino'),
(2,'Femenino'),
(3,'No especifica');

INSERT INTO tipo_documento (id_tipo_documento, nombre_tipo) VALUES
(1,'Cédula'),
(2,'Pasaporte');

INSERT INTO metodo_pago (id_metodo_pago, nombre_metodo, categoria_metodo) VALUES
(1,'Efectivo','EFECTIVO'),
(2,'Tarjeta Crédito','TARJETA'),
(3,'Tarjeta Débito','TARJETA'),
(4,'Transferencia','TRANSFERENCIA'),
(5,'Convenio Empresa','CORPORATIVO');

INSERT INTO temporada (id_temporada, nombre_temporada, descripcion, prioridad_precio) VALUES
(1,'Alta','Mayor demanda',3),
(2,'Media','Demanda intermedia',2),
(3,'Baja','Menor demanda',1);

INSERT INTO servicio_complementario (id_servicio, codigo_servicio, nombre_servicio, categoria_servicio, precio_base, requiere_reserva) VALUES
(1,'SRV001','Restaurante','RESTAURANTE',18.00,FALSE),
(2,'SRV002','Spa','SPA',55.00,TRUE),
(3,'SRV003','Tour','TOUR',75.00,TRUE),
(4,'SRV004','Traslado','TRASLADO',28.00,TRUE),
(5,'SRV005','Estacionamiento','ESTACIONAMIENTO',10.00,FALSE),
(6,'SRV006','Lavandería','LAVANDERIA',14.00,FALSE);

INSERT INTO estado_reserva (id_estado_reserva, nombre_estado, descripcion) VALUES
(1,'Confirmada','Reserva futura aún no ejecutada'),
(2,'Cancelada','Reserva cancelada antes del check-in'),
(3,'NoShow','Cliente no se presentó'),
(4,'Completada','Estadía finalizada');

-- ============================================================
-- 2) PROPIEDADES
-- ============================================================

INSERT INTO propiedad (
    id_propiedad,
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
(1,'HTL001','Hotel Central San José',2,4,1,'Paseo Colón, San José','2222-1001','central@hotelbi.com','2017-03-15',40),
(2,'HTL002','Resort Pacífico Jacó',1,5,4,'Costanera Sur, Jacó','2222-1002','pacifico@hotelbi.com','2018-07-01',40),
(3,'HTL003','Ecohotel Arenal',4,4,5,'La Fortuna, Alajuela','2222-1003','arenal@hotelbi.com','2019-11-20',40),
(4,'HTL004','Boutique Manuel Antonio',3,5,6,'Quepos, Puntarenas','2222-1004','boutique@hotelbi.com','2020-02-10',40);

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
    DATE '2024-01-01' + (((p.id_propiedad * s.n) % 300)::INT)
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
    (CURRENT_DATE - make_interval(years => edad::INT))::DATE,
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
    DATE '2024-01-01' + ((g % 400)::INT),
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
SELECT
    p.id_propiedad,
    x.id_temporada,
    x.fecha_inicio,
    x.fecha_fin
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
) AS x(id_temporada, fecha_inicio, fecha_fin);

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
    (DATE '2025-01-15' + ((g * 18)::INT))::TIMESTAMP + INTERVAL '08:00',
    (DATE '2025-01-15' + ((g * 18 + 2)::INT))::TIMESTAMP + INTERVAL '17:00',
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
            WHEN g % 20 IN (1,2,3) THEN 2
            WHEN g % 20 = 4 THEN 3
            WHEN g % 20 IN (5,6) THEN 1
            ELSE 4
        END AS id_estado_reserva,
        ((g - 1) % 5) + 1 AS id_metodo_pago_garantia,
        (DATE '2025-01-01' + (((g * 2 + (((g - 1) % 4) + 1) * 7) % 620)::INT))::DATE AS fecha_checkin_programado,
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
    (fecha_checkin_programado - (((g % 90) + 1)::INT))::TIMESTAMP + INTERVAL '10:00',
    fecha_checkin_programado,
    fecha_checkin_programado + noches,
    CASE
        WHEN id_estado_reserva = 4 THEN fecha_checkin_programado::TIMESTAMP + INTERVAL '15:00'
        ELSE NULL
    END,
    CASE
        WHEN id_estado_reserva = 4 THEN (fecha_checkin_programado + noches)::TIMESTAMP + INTERVAL '11:00'
        ELSE NULL
    END,
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
        WHEN id_estado_reserva = 2 THEN (fecha_checkin_programado - (((g % 90) + 1)::INT))::TIMESTAMP + INTERVAL '16:00'
        ELSE NULL
    END,
    CASE
        WHEN id_estado_reserva = 2 THEN
            CASE
                WHEN g % 3 = 0 THEN 'Cambio de planes'
                WHEN g % 3 = 1 THEN 'Precio'
                ELSE 'Disponibilidad'
            END
        ELSE NULL
    END,
    TRUE
FROM base;

-- ============================================================
-- 8) RESERVA_HUESPED
-- ============================================================

INSERT INTO reserva_huesped (id_reserva, id_huesped, es_titular, es_hospedado)
SELECT id_reserva, id_huesped_titular, TRUE, TRUE
FROM reserva;

INSERT INTO reserva_huesped (id_reserva, id_huesped, es_titular, es_hospedado)
SELECT
    r.id_reserva,
    ((r.id_huesped_titular + 37 - 1) % 300) + 1,
    FALSE,
    TRUE
FROM reserva r
WHERE (r.adultos + r.ninos + r.infantes) >= 2
  AND ((r.id_huesped_titular + 37 - 1) % 300) + 1 <> r.id_huesped_titular;

INSERT INTO reserva_huesped (id_reserva, id_huesped, es_titular, es_hospedado)
SELECT
    r.id_reserva,
    ((r.id_huesped_titular + 121 - 1) % 300) + 1,
    FALSE,
    TRUE
FROM reserva r
WHERE (r.adultos + r.ninos + r.infantes) >= 3
  AND ((r.id_huesped_titular + 121 - 1) % 300) + 1 <> r.id_huesped_titular
  AND ((r.id_huesped_titular + 121 - 1) % 300) + 1 <> (((r.id_huesped_titular + 37 - 1) % 300) + 1);

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
    ROUND(rm.tarifa_rack_actual * (1 - r.descuento_pct / 100.0), 2),
    r.estadia_noches_programadas,
    ROUND(rm.tarifa_rack_actual * r.estadia_noches_programadas, 2),
    ROUND((rm.tarifa_rack_actual * r.estadia_noches_programadas) * (r.descuento_pct / 100.0), 2),
    ROUND((rm.tarifa_rack_actual * r.estadia_noches_programadas) * (1 - r.descuento_pct / 100.0), 2),
    1
FROM res_by_property r
JOIN rooms rm
  ON rm.id_propiedad = r.id_propiedad
 AND rm.rn = (((r.rn_res - 1) % rm.total_rooms) + 1);

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
    ((r.id_reserva + gs.n - 1) % 6) + 1,
    COALESCE(r.fecha_checkin_real, r.fecha_checkin_programado::TIMESTAMP + INTERVAL '15 hours') + (gs.n * INTERVAL '5 hours'),
    ((r.id_reserva + gs.n) % 3 + 1)::NUMERIC(12,2),
    sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3),
    ROUND(
        CASE
            WHEN (r.id_reserva + gs.n) % 7 = 0
                THEN ((sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3)) * (((r.id_reserva + gs.n) % 3 + 1))) * 0.10
            ELSE 0
        END
    , 2),
    ROUND(
        (
            ((sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3)) * (((r.id_reserva + gs.n) % 3 + 1)))
            -
            CASE
                WHEN (r.id_reserva + gs.n) % 7 = 0
                    THEN ((sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3)) * (((r.id_reserva + gs.n) % 3 + 1))) * 0.10
                ELSE 0
            END
        ) * 0.13
    , 2),
    ROUND(
        (
            ((sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3)) * (((r.id_reserva + gs.n) % 3 + 1)))
            -
            CASE
                WHEN (r.id_reserva + gs.n) % 7 = 0
                    THEN ((sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3)) * (((r.id_reserva + gs.n) % 3 + 1))) * 0.10
                ELSE 0
            END
        )
    , 2),
    ROUND(
        (
            (
                ((sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3)) * (((r.id_reserva + gs.n) % 3 + 1)))
                -
                CASE
                    WHEN (r.id_reserva + gs.n) % 7 = 0
                        THEN ((sc.precio_base + (((r.id_reserva + gs.n) % 4) * 3)) * (((r.id_reserva + gs.n) % 3 + 1))) * 0.10
                    ELSE 0
                END
            ) * 1.13
        )
    , 2),
    CASE WHEN r.id_estado_reserva = 4 THEN 'FACTURADO' ELSE 'REGISTRADO' END,
    'Consumo automático'
FROM reserva r
JOIN LATERAL generate_series(
    1,
    CASE
        WHEN r.id_estado_reserva = 4 THEN 1 + (r.id_reserva % 3)
        WHEN r.id_estado_reserva = 1 THEN 1
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
    ((f.id_factura - 1) % 5) + 1,
    f.fecha_emision + INTERVAL '1 day',
    f.total,
    'USD',
    'PAY-' || LPAD(f.id_factura::TEXT, 6, '0'),
    'APLICADO'
FROM factura f
WHERE f.estado_factura = 'PAGADA';

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
    ((f.id_factura) % 5) + 1,
    f.fecha_emision + INTERVAL '2 day',
    ROUND(f.total * 0.40, 2),
    'USD',
    'PPD-' || LPAD(f.id_factura::TEXT, 6, '0'),
    'PENDIENTE'
FROM factura f
WHERE f.estado_factura = 'EMITIDA';

-- ============================================================
-- 17) SINCRONIZAR SECUENCIAS
-- ============================================================

SELECT setval(pg_get_serial_sequence('pais', 'id_pais'), COALESCE((SELECT MAX(id_pais) FROM pais), 1), true);
SELECT setval(pg_get_serial_sequence('ciudad', 'id_ciudad'), COALESCE((SELECT MAX(id_ciudad) FROM ciudad), 1), true);
SELECT setval(pg_get_serial_sequence('tipo_propiedad', 'id_tipo_propiedad'), COALESCE((SELECT MAX(id_tipo_propiedad) FROM tipo_propiedad), 1), true);
SELECT setval(pg_get_serial_sequence('tipo_habitacion', 'id_tipo_habitacion'), COALESCE((SELECT MAX(id_tipo_habitacion) FROM tipo_habitacion), 1), true);
SELECT setval(pg_get_serial_sequence('canal_reserva', 'id_canal_reserva'), COALESCE((SELECT MAX(id_canal_reserva) FROM canal_reserva), 1), true);
SELECT setval(pg_get_serial_sequence('segmento_cliente', 'id_segmento_cliente'), COALESCE((SELECT MAX(id_segmento_cliente) FROM segmento_cliente), 1), true);
SELECT setval(pg_get_serial_sequence('motivo_viaje', 'id_motivo_viaje'), COALESCE((SELECT MAX(id_motivo_viaje) FROM motivo_viaje), 1), true);
SELECT setval(pg_get_serial_sequence('rango_etario', 'id_rango_etario'), COALESCE((SELECT MAX(id_rango_etario) FROM rango_etario), 1), true);
SELECT setval(pg_get_serial_sequence('genero', 'id_genero'), COALESCE((SELECT MAX(id_genero) FROM genero), 1), true);
SELECT setval(pg_get_serial_sequence('tipo_documento', 'id_tipo_documento'), COALESCE((SELECT MAX(id_tipo_documento) FROM tipo_documento), 1), true);
SELECT setval(pg_get_serial_sequence('metodo_pago', 'id_metodo_pago'), COALESCE((SELECT MAX(id_metodo_pago) FROM metodo_pago), 1), true);
SELECT setval(pg_get_serial_sequence('temporada', 'id_temporada'), COALESCE((SELECT MAX(id_temporada) FROM temporada), 1), true);
SELECT setval(pg_get_serial_sequence('servicio_complementario', 'id_servicio'), COALESCE((SELECT MAX(id_servicio) FROM servicio_complementario), 1), true);
SELECT setval(pg_get_serial_sequence('estado_reserva', 'id_estado_reserva'), COALESCE((SELECT MAX(id_estado_reserva) FROM estado_reserva), 1), true);
SELECT setval(pg_get_serial_sequence('propiedad', 'id_propiedad'), COALESCE((SELECT MAX(id_propiedad) FROM propiedad), 1), true);

-- ============================================================
-- 18) VERIFICACIÓN
-- ============================================================

-- SELECT COUNT(*) AS paises FROM pais;
-- SELECT COUNT(*) AS ciudades FROM ciudad;
-- SELECT COUNT(*) AS propiedades FROM propiedad;
-- SELECT COUNT(*) AS habitaciones FROM habitacion;
-- SELECT COUNT(*) AS huespedes FROM huesped;
-- SELECT COUNT(*) AS reservas FROM reserva;
-- SELECT COUNT(*) AS reserva_huesped FROM reserva_huesped;
-- SELECT COUNT(*) AS reserva_habitacion FROM reserva_habitacion;
-- SELECT COUNT(*) AS consumos_servicio FROM consumo_servicio;
-- SELECT COUNT(*) AS facturas FROM factura;
-- SELECT COUNT(*) AS pagos FROM pago;


UPDATE hotel_ops.huesped
SET nombres = nombres_reales.nombre,
    apellidos = nombres_reales.apellido
FROM (
    SELECT id_huesped,
           (ARRAY[
               'Carlos','Ana','Luis','Maria','Jose','Laura','Andres','Sofia','Daniel','Valeria',
               'Jorge','Camila','Fernando','Gabriela','Diego','Paula','Ricardo','Elena','Miguel','Lucia'
           ])[((id_huesped % 20) + 1)] AS nombre,

           (ARRAY[
               'Rodriguez','Gomez','Fernandez','Lopez','Martinez','Hernandez','Perez','Ramirez','Sanchez','Torres',
               'Flores','Rivera','Morales','Ortiz','Castro','Vargas','Rojas','Navarro','Mendoza','Silva'
           ])[((id_huesped % 20) + 1)] AS apellido

    FROM hotel_ops.huesped
) AS nombres_reales
WHERE hotel_ops.huesped.id_huesped = nombres_reales.id_huesped;
UPDATE hotel_ops.huesped
SET email = LOWER(nombres || '.' || apellidos || '@mail.com');
