Claro. Te dejo una base de datos Oracle completa, pensada para administrar la especialidad de Técnico en Telecomunicaciones, incluyendo:

👨‍🎓 Alumnos y cursos.
👨‍🏫 Profesores.
🏫 Taller de Electrónica y Laboratorio de Redes.
🖥️ Inventario de equipos computacionales y de redes.
🔧 Herramientas y componentes electrónicos.
📦 Control de préstamos y devoluciones.
🛠️ Mantenciones.
👤 Usuarios del sistema.
🔐 Roles y permisos.
📋 Movimientos de inventario.
📊 Auditoría básica.
👑 Administrador con permisos generales.

El código está pensado para ejecutarlo directamente en Oracle SQL Developer.

1. CREACIÓN DE TABLAS

Ejecuta primero este bloque completo.

------------------------------------------------------------
-- BASE DE DATOS
-- ESPECIALIDAD TÉCNICO EN TELECOMUNICACIONES
-- Oracle SQL Developer
------------------------------------------------------------

------------------------------------------------------------
-- 1. ROLES
------------------------------------------------------------

CREATE TABLE ROL (
    ID_ROL          NUMBER PRIMARY KEY,
    NOMBRE          VARCHAR2(50) NOT NULL,
    DESCRIPCION     VARCHAR2(200),
    
    CONSTRAINT UK_ROL_NOMBRE UNIQUE (NOMBRE)
);

------------------------------------------------------------
-- 2. PERMISOS
------------------------------------------------------------

CREATE TABLE PERMISO (
    ID_PERMISO      NUMBER PRIMARY KEY,
    NOMBRE          VARCHAR2(80) NOT NULL,
    DESCRIPCION     VARCHAR2(200),

    CONSTRAINT UK_PERMISO_NOMBRE UNIQUE (NOMBRE)
);

------------------------------------------------------------
-- 3. RELACIÓN ROL - PERMISO
------------------------------------------------------------

CREATE TABLE ROL_PERMISO (
    ID_ROL          NUMBER NOT NULL,
    ID_PERMISO      NUMBER NOT NULL,

    CONSTRAINT PK_ROL_PERMISO
        PRIMARY KEY (ID_ROL, ID_PERMISO),

    CONSTRAINT FK_RP_ROL
        FOREIGN KEY (ID_ROL)
        REFERENCES ROL(ID_ROL),

    CONSTRAINT FK_RP_PERMISO
        FOREIGN KEY (ID_PERMISO)
        REFERENCES PERMISO(ID_PERMISO)
);

------------------------------------------------------------
-- 4. CURSO
------------------------------------------------------------

CREATE TABLE CURSO (
    ID_CURSO           NUMBER PRIMARY KEY,
    NIVEL              VARCHAR2(20) NOT NULL,
    LETRA              VARCHAR2(5) NOT NULL,
    ANIO               NUMBER(4) NOT NULL,
    ESPECIALIDAD       VARCHAR2(100),
    PROFESOR_JEFE      VARCHAR2(150),
    ESTADO             VARCHAR2(20) DEFAULT 'ACTIVO',

    CONSTRAINT CK_CURSO_ESTADO
        CHECK (ESTADO IN ('ACTIVO','INACTIVO'))
);

------------------------------------------------------------
-- 5. ALUMNO
------------------------------------------------------------

CREATE TABLE ALUMNO (
    ID_ALUMNO           NUMBER PRIMARY KEY,
    RUT                 VARCHAR2(12) NOT NULL,
    DV                  CHAR(1) NOT NULL,
    NOMBRE              VARCHAR2(50) NOT NULL,
    APELLIDO_PATERNO    VARCHAR2(50) NOT NULL,
    APELLIDO_MATERNO    VARCHAR2(50),
    FECHA_NACIMIENTO    DATE,
    CORREO              VARCHAR2(100),
    TELEFONO            VARCHAR2(20),
    ID_CURSO            NUMBER,
    ESPECIALIDAD        VARCHAR2(100),
    ESTADO              VARCHAR2(20) DEFAULT 'ACTIVO',

    CONSTRAINT UK_ALUMNO_RUT UNIQUE (RUT),

    CONSTRAINT FK_ALUMNO_CURSO
        FOREIGN KEY (ID_CURSO)
        REFERENCES CURSO(ID_CURSO),

    CONSTRAINT CK_ALUMNO_ESTADO
        CHECK (ESTADO IN ('ACTIVO','INACTIVO','EGRESADO'))
);

------------------------------------------------------------
-- 6. PROFESOR
------------------------------------------------------------

CREATE TABLE PROFESOR (
    ID_PROFESOR         NUMBER PRIMARY KEY,
    RUT                 VARCHAR2(12) NOT NULL,
    DV                  CHAR(1) NOT NULL,
    NOMBRE              VARCHAR2(50) NOT NULL,
    APELLIDO_PATERNO    VARCHAR2(50) NOT NULL,
    APELLIDO_MATERNO    VARCHAR2(50),
    CORREO              VARCHAR2(100),
    TELEFONO            VARCHAR2(20),
    ESPECIALIDAD        VARCHAR2(100),
    ESTADO              VARCHAR2(20) DEFAULT 'ACTIVO',

    CONSTRAINT UK_PROFESOR_RUT UNIQUE (RUT),

    CONSTRAINT CK_PROFESOR_ESTADO
        CHECK (ESTADO IN ('ACTIVO','INACTIVO'))
);

------------------------------------------------------------
-- 7. ESPACIOS FÍSICOS
------------------------------------------------------------

CREATE TABLE ESPACIO (
    ID_ESPACIO          NUMBER PRIMARY KEY,
    NOMBRE              VARCHAR2(100) NOT NULL,
    TIPO                VARCHAR2(50),
    UBICACION           VARCHAR2(150),
    RESPONSABLE         VARCHAR2(150),
    ESTADO              VARCHAR2(20) DEFAULT 'ACTIVO',

    CONSTRAINT UK_ESPACIO_NOMBRE UNIQUE (NOMBRE),

    CONSTRAINT CK_ESPACIO_ESTADO
        CHECK (ESTADO IN ('ACTIVO','INACTIVO'))
);

------------------------------------------------------------
-- 8. CATEGORÍAS DE INVENTARIO
------------------------------------------------------------

CREATE TABLE CATEGORIA_INVENTARIO (
    ID_CATEGORIA        NUMBER PRIMARY KEY,
    NOMBRE              VARCHAR2(100) NOT NULL,
    DESCRIPCION         VARCHAR2(250),

    CONSTRAINT UK_CATEGORIA_NOMBRE UNIQUE (NOMBRE)
);

------------------------------------------------------------
-- 9. MARCAS
------------------------------------------------------------

CREATE TABLE MARCA (
    ID_MARCA            NUMBER PRIMARY KEY,
    NOMBRE              VARCHAR2(80) NOT NULL,
    DESCRIPCION         VARCHAR2(200),

    CONSTRAINT UK_MARCA_NOMBRE UNIQUE (NOMBRE)
);

------------------------------------------------------------
-- 10. ESTADO DE EQUIPOS
------------------------------------------------------------

CREATE TABLE ESTADO_EQUIPO (
    ID_ESTADO           NUMBER PRIMARY KEY,
    NOMBRE              VARCHAR2(50) NOT NULL,
    DESCRIPCION         VARCHAR2(200),

    CONSTRAINT UK_ESTADO_EQUIPO_NOMBRE UNIQUE (NOMBRE)
);

------------------------------------------------------------
-- 11. INVENTARIO
------------------------------------------------------------

CREATE TABLE INVENTARIO (
    ID_INVENTARIO       NUMBER PRIMARY KEY,
    CODIGO_INVENTARIO   VARCHAR2(30) NOT NULL,
    NOMBRE              VARCHAR2(150) NOT NULL,
    DESCRIPCION         VARCHAR2(500),

    ID_CATEGORIA        NUMBER NOT NULL,
    ID_MARCA            NUMBER,
    MODELO              VARCHAR2(100),
    NUMERO_SERIE        VARCHAR2(100),

    CANTIDAD            NUMBER DEFAULT 1 NOT NULL,

    FECHA_ADQUISICION   DATE,
    VALOR               NUMBER(12,2),

    ID_ESTADO           NUMBER NOT NULL,
    ID_ESPACIO          NUMBER,

    OBSERVACION         VARCHAR2(500),

    CONSTRAINT UK_INVENTARIO_CODIGO
        UNIQUE (CODIGO_INVENTARIO),

    CONSTRAINT UK_INVENTARIO_SERIE
        UNIQUE (NUMERO_SERIE),

    CONSTRAINT FK_INV_CATEGORIA
        FOREIGN KEY (ID_CATEGORIA)
        REFERENCES CATEGORIA_INVENTARIO(ID_CATEGORIA),

    CONSTRAINT FK_INV_MARCA
        FOREIGN KEY (ID_MARCA)
        REFERENCES MARCA(ID_MARCA),

    CONSTRAINT FK_INV_ESTADO
        FOREIGN KEY (ID_ESTADO)
        REFERENCES ESTADO_EQUIPO(ID_ESTADO),

    CONSTRAINT FK_INV_ESPACIO
        FOREIGN KEY (ID_ESPACIO)
        REFERENCES ESPACIO(ID_ESPACIO),

    CONSTRAINT CK_INVENTARIO_CANTIDAD
        CHECK (CANTIDAD >= 0),

    CONSTRAINT CK_INVENTARIO_VALOR
        CHECK (VALOR >= 0)
);

------------------------------------------------------------
-- 12. USUARIOS DEL SISTEMA
------------------------------------------------------------

CREATE TABLE USUARIO (
    ID_USUARIO          NUMBER PRIMARY KEY,
    USERNAME            VARCHAR2(50) NOT NULL,
    PASSWORD_HASH       VARCHAR2(200) NOT NULL,
    NOMBRE              VARCHAR2(150) NOT NULL,
    CORREO              VARCHAR2(100),

    ID_ROL              NUMBER NOT NULL,

    ESTADO              VARCHAR2(20) DEFAULT 'ACTIVO',
    FECHA_CREACION      DATE DEFAULT SYSDATE,

    CONSTRAINT UK_USUARIO_USERNAME
        UNIQUE (USERNAME),

    CONSTRAINT FK_USUARIO_ROL
        FOREIGN KEY (ID_ROL)
        REFERENCES ROL(ID_ROL),

    CONSTRAINT CK_USUARIO_ESTADO
        CHECK (ESTADO IN ('ACTIVO','INACTIVO'))
);

------------------------------------------------------------
-- 13. PRÉSTAMOS
------------------------------------------------------------

CREATE TABLE PRESTAMO (
    ID_PRESTAMO                 NUMBER PRIMARY KEY,

    FECHA_PRESTAMO              DATE DEFAULT SYSDATE NOT NULL,

    FECHA_DEVOLUCION_PROGRAMADA DATE,
    FECHA_DEVOLUCION_REAL       DATE,

    ID_ALUMNO                   NUMBER,
    ID_PROFESOR                 NUMBER,

    ESTADO                      VARCHAR2(30) DEFAULT 'PRESTADO',

    OBSERVACION                 VARCHAR2(500),

    CONSTRAINT FK_PRESTAMO_ALUMNO
        FOREIGN KEY (ID_ALUMNO)
        REFERENCES ALUMNO(ID_ALUMNO),

    CONSTRAINT FK_PRESTAMO_PROFESOR
        FOREIGN KEY (ID_PROFESOR)
        REFERENCES PROFESOR(ID_PROFESOR),

    CONSTRAINT CK_PRESTAMO_ESTADO
        CHECK (
            ESTADO IN
            ('PRESTADO',
             'DEVUELTO',
             'ATRASADO',
             'PERDIDO',
             'CANCELADO')
        )
);

------------------------------------------------------------
-- 14. DETALLE DE PRÉSTAMO
------------------------------------------------------------

CREATE TABLE DETALLE_PRESTAMO (
    ID_DETALLE              NUMBER PRIMARY KEY,

    ID_PRESTAMO             NUMBER NOT NULL,
    ID_INVENTARIO           NUMBER NOT NULL,

    CANTIDAD                NUMBER DEFAULT 1 NOT NULL,

    ESTADO_SALIDA           VARCHAR2(50),
    ESTADO_DEVOLUCION       VARCHAR2(50),

    OBSERVACION             VARCHAR2(500),

    CONSTRAINT FK_DETALLE_PRESTAMO
        FOREIGN KEY (ID_PRESTAMO)
        REFERENCES PRESTAMO(ID_PRESTAMO),

    CONSTRAINT FK_DETALLE_INVENTARIO
        FOREIGN KEY (ID_INVENTARIO)
        REFERENCES INVENTARIO(ID_INVENTARIO),

    CONSTRAINT CK_DETALLE_CANTIDAD
        CHECK (CANTIDAD > 0)
);

------------------------------------------------------------
-- 15. MANTENCIONES
------------------------------------------------------------

CREATE TABLE MANTENCION (
    ID_MANTENCION       NUMBER PRIMARY KEY,

    ID_INVENTARIO       NUMBER NOT NULL,

    FECHA_INGRESO       DATE DEFAULT SYSDATE NOT NULL,
    FECHA_SALIDA        DATE,

    TIPO_MANTENCION     VARCHAR2(50),

    DESCRIPCION         VARCHAR2(500),

    TECNICO_RESPONSABLE VARCHAR2(150),

    COSTO               NUMBER(12,2) DEFAULT 0,

    ESTADO              VARCHAR2(30) DEFAULT 'PENDIENTE',

    OBSERVACION         VARCHAR2(500),

    CONSTRAINT FK_MANT_INVENTARIO
        FOREIGN KEY (ID_INVENTARIO)
        REFERENCES INVENTARIO(ID_INVENTARIO),

    CONSTRAINT CK_MANT_ESTADO
        CHECK (
            ESTADO IN
            ('PENDIENTE',
             'EN_PROCESO',
             'FINALIZADA',
             'CANCELADA')
        ),

    CONSTRAINT CK_MANT_COSTO
        CHECK (COSTO >= 0)
);

------------------------------------------------------------
-- 16. MOVIMIENTOS DE INVENTARIO
------------------------------------------------------------

CREATE TABLE MOVIMIENTO_INVENTARIO (
    ID_MOVIMIENTO       NUMBER PRIMARY KEY,

    ID_INVENTARIO       NUMBER NOT NULL,

    TIPO_MOVIMIENTO     VARCHAR2(30) NOT NULL,

    FECHA_MOVIMIENTO    DATE DEFAULT SYSDATE NOT NULL,

    CANTIDAD            NUMBER DEFAULT 1 NOT NULL,

    ESPACIO_ORIGEN     NUMBER,
    ESPACIO_DESTINO    NUMBER,

    MOTIVO              VARCHAR2(300),

    ID_USUARIO          NUMBER,

    OBSERVACION         VARCHAR2(500),

    CONSTRAINT FK_MOV_INVENTARIO
        FOREIGN KEY (ID_INVENTARIO)
        REFERENCES INVENTARIO(ID_INVENTARIO),

    CONSTRAINT FK_MOV_ORIGEN
        FOREIGN KEY (ESPACIO_ORIGEN)
        REFERENCES ESPACIO(ID_ESPACIO),

    CONSTRAINT FK_MOV_DESTINO
        FOREIGN KEY (ESPACIO_DESTINO)
        REFERENCES ESPACIO(ID_ESPACIO),

    CONSTRAINT FK_MOV_USUARIO
        FOREIGN KEY (ID_USUARIO)
        REFERENCES USUARIO(ID_USUARIO),

    CONSTRAINT CK_MOV_TIPO
        CHECK (
            TIPO_MOVIMIENTO IN
            ('INGRESO',
             'SALIDA',
             'TRASLADO',
             'AJUSTE',
             'PRESTAMO',
             'DEVOLUCION',
             'BAJA')
        ),

    CONSTRAINT CK_MOV_CANTIDAD
        CHECK (CANTIDAD > 0)
);

------------------------------------------------------------
-- 17. AUDITORÍA
------------------------------------------------------------

CREATE TABLE AUDITORIA (
    ID_AUDITORIA       NUMBER PRIMARY KEY,

    ID_USUARIO         NUMBER,

    FECHA              DATE DEFAULT SYSDATE,

    TABLA_AFECTADA     VARCHAR2(100),

    OPERACION          VARCHAR2(30),

    ID_REGISTRO        NUMBER,

    DESCRIPCION        VARCHAR2(500),

    CONSTRAINT FK_AUDITORIA_USUARIO
        FOREIGN KEY (ID_USUARIO)
        REFERENCES USUARIO(ID_USUARIO)
);
2. SECUENCIAS

Ahora creamos las secuencias para generar los ID automáticamente.

------------------------------------------------------------
-- SECUENCIAS
------------------------------------------------------------

CREATE SEQUENCE SEQ_ROL
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_PERMISO
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_CURSO
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_ALUMNO
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_PROFESOR
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_ESPACIO
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_CATEGORIA
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_MARCA
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_ESTADO_EQUIPO
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_INVENTARIO
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_USUARIO
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_PRESTAMO
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_DETALLE_PRESTAMO
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_MANTENCION
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_MOVIMIENTO
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE SEQ_AUDITORIA
START WITH 1
INCREMENT BY 1;
3. DATOS INICIALES
Roles
------------------------------------------------------------
-- ROLES
------------------------------------------------------------

INSERT INTO ROL
VALUES (
    SEQ_ROL.NEXTVAL,
    'ADMINISTRADOR',
    'Acceso general al sistema'
);

INSERT INTO ROL
VALUES (
    SEQ_ROL.NEXTVAL,
    'PROFESOR',
    'Gestión de préstamos y consulta'
);

INSERT INTO ROL
VALUES (
    SEQ_ROL.NEXTVAL,
    'ENCARGADO_INVENTARIO',
    'Administración del inventario'
);

INSERT INTO ROL
VALUES (
    SEQ_ROL.NEXTVAL,
    'CONSULTA',
    'Solo consulta de información'
);

COMMIT;
4. PERMISOS
------------------------------------------------------------
-- PERMISOS
------------------------------------------------------------

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'VER_ALUMNOS',
 'Consultar alumnos');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'CREAR_ALUMNO',
 'Registrar alumnos');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'EDITAR_ALUMNO',
 'Modificar alumnos');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'ELIMINAR_ALUMNO',
 'Eliminar alumnos');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'VER_PROFESORES',
 'Consultar profesores');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'CREAR_EQUIPO',
 'Registrar equipos');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'EDITAR_EQUIPO',
 'Modificar equipos');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'ELIMINAR_EQUIPO',
 'Eliminar equipos');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'VER_INVENTARIO',
 'Consultar inventario');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'PRESTAR_EQUIPO',
 'Realizar préstamos');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'RECIBIR_EQUIPO',
 'Registrar devoluciones');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'CREAR_MANTENCION',
 'Registrar mantenciones');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'EDITAR_MANTENCION',
 'Modificar mantenciones');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'VER_REPORTES',
 'Consultar reportes');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'ADMINISTRAR_USUARIOS',
 'Administrar usuarios');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'ADMINISTRAR_ROLES',
 'Administrar roles');

INSERT INTO PERMISO VALUES
(SEQ_PERMISO.NEXTVAL, 'ADMINISTRAR_PERMISOS',
 'Administrar permisos');

COMMIT;
5. PERMISOS DEL ADMINISTRADOR

El administrador tendrá todos los permisos.

------------------------------------------------------------
-- ASIGNAR TODOS LOS PERMISOS AL ADMINISTRADOR
------------------------------------------------------------

INSERT INTO ROL_PERMISO
SELECT
    R.ID_ROL,
    P.ID_PERMISO
FROM ROL R
CROSS JOIN PERMISO P
WHERE R.NOMBRE = 'ADMINISTRADOR';

COMMIT;
6. PERMISOS DEL PROFESOR
------------------------------------------------------------
-- PERMISOS PROFESOR
------------------------------------------------------------

INSERT INTO ROL_PERMISO
SELECT R.ID_ROL, P.ID_PERMISO
FROM ROL R
JOIN PERMISO P
    ON P.NOMBRE IN (
        'VER_ALUMNOS',
        'VER_PROFESORES',
        'VER_INVENTARIO',
        'PRESTAR_EQUIPO',
        'RECIBIR_EQUIPO',
        'VER_REPORTES'
    )
WHERE R.NOMBRE = 'PROFESOR';

COMMIT;
7. PERMISOS DEL ENCARGADO DE INVENTARIO
------------------------------------------------------------
-- PERMISOS ENCARGADO INVENTARIO
------------------------------------------------------------

INSERT INTO ROL_PERMISO
SELECT R.ID_ROL, P.ID_PERMISO
FROM ROL R
JOIN PERMISO P
    ON P.NOMBRE IN (
        'VER_INVENTARIO',
        'CREAR_EQUIPO',
        'EDITAR_EQUIPO',
        'ELIMINAR_EQUIPO',
        'PRESTAR_EQUIPO',
        'RECIBIR_EQUIPO',
        'CREAR_MANTENCION',
        'EDITAR_MANTENCION',
        'VER_REPORTES'
    )
WHERE R.NOMBRE = 'ENCARGADO_INVENTARIO';

COMMIT;
8. ESPACIOS DEL ESTABLECIMIENTO
------------------------------------------------------------
-- ESPACIOS
------------------------------------------------------------

INSERT INTO ESPACIO
VALUES (
    SEQ_ESPACIO.NEXTVAL,
    'Taller de Electrónica',
    'TALLER',
    'Sector Electrónica',
    'Profesor de Especialidad',
    'ACTIVO'
);

INSERT INTO ESPACIO
VALUES (
    SEQ_ESPACIO.NEXTVAL,
    'Laboratorio de Redes',
    'LABORATORIO',
    'Sector Telecomunicaciones',
    'Profesor de Especialidad',
    'ACTIVO'
);

INSERT INTO ESPACIO
VALUES (
    SEQ_ESPACIO.NEXTVAL,
    'Bodega de Telecomunicaciones',
    'BODEGA',
    'Sector Telecomunicaciones',
    'Encargado de Inventario',
    'ACTIVO'
);

INSERT INTO ESPACIO
VALUES (
    SEQ_ESPACIO.NEXTVAL,
    'Sala de Profesores',
    'OFICINA',
    'Sector Administrativo',
    'Profesor de Especialidad',
    'ACTIVO'
);

COMMIT;
9. CATEGORÍAS
------------------------------------------------------------
-- CATEGORÍAS DE INVENTARIO
------------------------------------------------------------

INSERT INTO CATEGORIA_INVENTARIO
VALUES (
    SEQ_CATEGORIA.NEXTVAL,
    'EQUIPOS DE RED',
    'Routers, switches, access point y otros equipos de red'
);

INSERT INTO CATEGORIA_INVENTARIO
VALUES (
    SEQ_CATEGORIA.NEXTVAL,
    'COMPUTACIÓN',
    'Computadores, notebooks, servidores y periféricos'
);

INSERT INTO CATEGORIA_INVENTARIO
VALUES (
    SEQ_CATEGORIA.NEXTVAL,
    'ELECTRÓNICA',
    'Equipos e instrumentos electrónicos'
);

INSERT INTO CATEGORIA_INVENTARIO
VALUES (
    SEQ_CATEGORIA.NEXTVAL,
    'HERRAMIENTAS',
    'Herramientas utilizadas en talleres'
);

INSERT INTO CATEGORIA_INVENTARIO
VALUES (
    SEQ_CATEGORIA.NEXTVAL,
    'COMPONENTES',
    'Resistencias, condensadores, integrados y componentes'
);

INSERT INTO CATEGORIA_INVENTARIO
VALUES (
    SEQ_CATEGORIA.NEXTVAL,
    'FIBRA OPTICA',
    'Equipos y herramientas de fibra óptica'
);

INSERT INTO CATEGORIA_INVENTARIO
VALUES (
    SEQ_CATEGORIA.NEXTVAL,
    'TELEFONIA',
    'Equipamiento de telefonía y PABX'
);

INSERT INTO CATEGORIA_INVENTARIO
VALUES (
    SEQ_CATEGORIA.NEXTVAL,
    'CABLEADO',
    'Cables UTP, fibra óptica, conectores y accesorios'
);

COMMIT;
10. MARCAS
------------------------------------------------------------
-- MARCAS
------------------------------------------------------------

INSERT INTO MARCA
VALUES (SEQ_MARCA.NEXTVAL, 'Cisco',
        'Equipamiento de redes');

INSERT INTO MARCA
VALUES (SEQ_MARCA.NEXTVAL, 'TP-Link',
        'Equipamiento de redes');

INSERT INTO MARCA
VALUES (SEQ_MARCA.NEXTVAL, 'Ubiquiti',
        'Equipamiento de redes');

INSERT INTO MARCA
VALUES (SEQ_MARCA.NEXTVAL, 'Dell',
        'Equipamiento computacional');

INSERT INTO MARCA
VALUES (SEQ_MARCA.NEXTVAL, 'HP',
        'Equipamiento computacional');

INSERT INTO MARCA
VALUES (SEQ_MARCA.NEXTVAL, 'Lenovo',
        'Equipamiento computacional');

INSERT INTO MARCA
VALUES (SEQ_MARCA.NEXTVAL, 'Fluke',
        'Instrumentación');

INSERT INTO MARCA
VALUES (SEQ_MARCA.NEXTVAL, 'Arduino',
        'Plataformas electrónicas');

INSERT INTO MARCA
VALUES (SEQ_MARCA.NEXTVAL, 'Raspberry Pi',
        'Computación educativa');

INSERT INTO MARCA
VALUES (SEQ_MARCA.NEXTVAL, 'Genérica',
        'Marca genérica');

COMMIT;
11. ESTADOS DEL EQUIPAMIENTO
------------------------------------------------------------
-- ESTADOS DE EQUIPOS
------------------------------------------------------------

INSERT INTO ESTADO_EQUIPO
VALUES (
    SEQ_ESTADO_EQUIPO.NEXTVAL,
    'DISPONIBLE',
    'Equipo disponible para utilizar o prestar'
);

INSERT INTO ESTADO_EQUIPO
VALUES (
    SEQ_ESTADO_EQUIPO.NEXTVAL,
    'PRESTADO',
    'Equipo actualmente prestado'
);

INSERT INTO ESTADO_EQUIPO
VALUES (
    SEQ_ESTADO_EQUIPO.NEXTVAL,
    'EN REPARACION',
    'Equipo en proceso de reparación'
);

INSERT INTO ESTADO_EQUIPO
VALUES (
    SEQ_ESTADO_EQUIPO.NEXTVAL,
    'DANADO',
    'Equipo dañado'
);

INSERT INTO ESTADO_EQUIPO
VALUES (
    SEQ_ESTADO_EQUIPO.NEXTVAL,
    'FUERA DE SERVICIO',
    'Equipo que no puede utilizarse'
);

INSERT INTO ESTADO_EQUIPO
VALUES (
    SEQ_ESTADO_EQUIPO.NEXTVAL,
    'BAJA',
    'Equipo dado de baja'
);

INSERT INTO ESTADO_EQUIPO
VALUES (
    SEQ_ESTADO_EQUIPO.NEXTVAL,
    'PERDIDO',
    'Equipo extraviado'
);

COMMIT;
12. USUARIO ADMINISTRADOR

Para el administrador podemos almacenar inicialmente una contraseña como hash.

Por ejemplo, utilizando STANDARD_HASH.

------------------------------------------------------------
-- USUARIO ADMINISTRADOR
------------------------------------------------------------

INSERT INTO USUARIO (
    ID_USUARIO,
    USERNAME,
    PASSWORD_HASH,
    NOMBRE,
    CORREO,
    ID_ROL,
    ESTADO
)
SELECT
    SEQ_USUARIO.NEXTVAL,
    'admin',
    STANDARD_HASH('Admin123', 'SHA256'),
    'Administrador del Sistema',
    'admin@colegio.cl',
    ID_ROL,
    'ACTIVO'
FROM ROL
WHERE NOMBRE = 'ADMINISTRADOR';

COMMIT;

El usuario inicial sería:

Usuario: admin
Clave:   Admin123

Para un sistema real, esta contraseña debería cambiarse inmediatamente y la aplicación debería gestionar correctamente el almacenamiento de credenciales.

13. PROFESOR DE EJEMPLO
------------------------------------------------------------
-- PROFESOR DE EJEMPLO
------------------------------------------------------------

INSERT INTO PROFESOR (
    ID_PROFESOR,
    RUT,
    DV,
    NOMBRE,
    APELLIDO_PATERNO,
    APELLIDO_MATERNO,
    CORREO,
    TELEFONO,
    ESPECIALIDAD,
    ESTADO
)
VALUES (
    SEQ_PROFESOR.NEXTVAL,
    '11111111',
    '1',
    'Profesor',
    'Telecomunicaciones',
    'Ejemplo',
    'profesor@colegio.cl',
    '912345678',
    'Técnico en Telecomunicaciones',
    'ACTIVO'
);

COMMIT;
14. CURSOS

Podemos comenzar con cursos de ejemplo.

------------------------------------------------------------
-- CURSOS
------------------------------------------------------------

INSERT INTO CURSO (
    ID_CURSO,
    NIVEL,
    LETRA,
    ANIO,
    ESPECIALIDAD,
    PROFESOR_JEFE,
    ESTADO
)
VALUES (
    SEQ_CURSO.NEXTVAL,
    '3° MEDIO',
    'A',
    2026,
    'Técnico en Telecomunicaciones',
    'Profesor de Especialidad',
    'ACTIVO'
);

INSERT INTO CURSO (
    ID_CURSO,
    NIVEL,
    LETRA,
    ANIO,
    ESPECIALIDAD,
    PROFESOR_JEFE,
    ESTADO
)
VALUES (
    SEQ_CURSO.NEXTVAL,
    '4° MEDIO',
    'A',
    2026,
    'Técnico en Telecomunicaciones',
    'Profesor de Especialidad',
    'ACTIVO'
);

COMMIT;
15. ALUMNOS DE EJEMPLO
------------------------------------------------------------
-- ALUMNOS
------------------------------------------------------------

INSERT INTO ALUMNO (
    ID_ALUMNO,
    RUT,
    DV,
    NOMBRE,
    APELLIDO_PATERNO,
    APELLIDO_MATERNO,
    CORREO,
    ID_CURSO,
    ESPECIALIDAD,
    ESTADO
)
SELECT
    SEQ_ALUMNO.NEXTVAL,
    '22222222',
    '2',
    'Juan',
    'Pérez',
    'González',
    'juan.perez@colegio.cl',
    ID_CURSO,
    'Técnico en Telecomunicaciones',
    'ACTIVO'
FROM CURSO
WHERE NIVEL = '3° MEDIO';


INSERT INTO ALUMNO (
    ID_ALUMNO,
    RUT,
    DV,
    NOMBRE,
    APELLIDO_PATERNO,
    APELLIDO_MATERNO,
    CORREO,
    ID_CURSO,
    ESPECIALIDAD,
    ESTADO
)
SELECT
    SEQ_ALUMNO.NEXTVAL,
    '33333333',
    '3',
    'Pedro',
    'Soto',
    'Muñoz',
    'pedro.soto@colegio.cl',
    ID_CURSO,
    'Técnico en Telecomunicaciones',
    'ACTIVO'
FROM CURSO
WHERE NIVEL = '4° MEDIO';

COMMIT;
16. EQUIPAMIENTO DE RED DE EJEMPLO

Aquí podemos comenzar a registrar equipos reales del laboratorio.

------------------------------------------------------------
-- EQUIPOS DE RED
------------------------------------------------------------

INSERT INTO INVENTARIO (
    ID_INVENTARIO,
    CODIGO_INVENTARIO,
    NOMBRE,
    DESCRIPCION,
    ID_CATEGORIA,
    ID_MARCA,
    MODELO,
    NUMERO_SERIE,
    CANTIDAD,
    FECHA_ADQUISICION,
    VALOR,
    ID_ESTADO,
    ID_ESPACIO
)
SELECT
    SEQ_INVENTARIO.NEXTVAL,
    'RED-001',
    'Router',
    'Router para prácticas de configuración Cisco',
    C.ID_CATEGORIA,
    M.ID_MARCA,
    '1941',
    'SERIE-ROUTER-001',
    1,
    SYSDATE,
    150000,
    E.ID_ESTADO,
    ESP.ID_ESPACIO
FROM CATEGORIA_INVENTARIO C,
     MARCA M,
     ESTADO_EQUIPO E,
     ESPACIO ESP
WHERE C.NOMBRE = 'EQUIPOS DE RED'
AND M.NOMBRE = 'Cisco'
AND E.NOMBRE = 'DISPONIBLE'
AND ESP.NOMBRE = 'Laboratorio de Redes';


INSERT INTO INVENTARIO (
    ID_INVENTARIO,
    CODIGO_INVENTARIO,
    NOMBRE,
    DESCRIPCION,
    ID_CATEGORIA,
    ID_MARCA,
    MODELO,
    NUMERO_SERIE,
    CANTIDAD,
    FECHA_ADQUISICION,
    VALOR,
    ID_ESTADO,
    ID_ESPACIO
)
SELECT
    SEQ_INVENTARIO.NEXTVAL,
    'RED-002',
    'Switch',
    'Switch administrable para prácticas de VLAN',
    C.ID_CATEGORIA,
    M.ID_MARCA,
    'Catalyst 1000',
    'SERIE-SWITCH-001',
    1,
    SYSDATE,
    250000,
    E.ID_ESTADO,
    ESP.ID_ESPACIO
FROM CATEGORIA_INVENTARIO C,
     MARCA M,
     ESTADO_EQUIPO E,
     ESPACIO ESP
WHERE C.NOMBRE = 'EQUIPOS DE RED'
AND M.NOMBRE = 'Cisco'
AND E.NOMBRE = 'DISPONIBLE'
AND ESP.NOMBRE = 'Laboratorio de Redes';

COMMIT;
17. COMPUTADORES
------------------------------------------------------------
-- COMPUTADORES
------------------------------------------------------------

INSERT INTO INVENTARIO (
    ID_INVENTARIO,
    CODIGO_INVENTARIO,
    NOMBRE,
    DESCRIPCION,
    ID_CATEGORIA,
    ID_MARCA,
    MODELO,
    NUMERO_SERIE,
    CANTIDAD,
    FECHA_ADQUISICION,
    VALOR,
    ID_ESTADO,
    ID_ESPACIO
)
SELECT
    SEQ_INVENTARIO.NEXTVAL,
    'PC-001',
    'PC Laboratorio',
    'Computador para prácticas de redes',
    C.ID_CATEGORIA,
    M.ID_MARCA,
    'OptiPlex',
    'SERIE-PC-001',
    1,
    SYSDATE,
    450000,
    E.ID_ESTADO,
    ESP.ID_ESPACIO
FROM CATEGORIA_INVENTARIO C,
     MARCA M,
     ESTADO_EQUIPO E,
     ESPACIO ESP
WHERE C.NOMBRE = 'COMPUTACIÓN'
AND M.NOMBRE = 'Dell'
AND E.NOMBRE = 'DISPONIBLE'
AND ESP.NOMBRE = 'Laboratorio de Redes';

COMMIT;
18. HERRAMIENTAS DE ELECTRÓNICA
------------------------------------------------------------
-- HERRAMIENTAS
------------------------------------------------------------

INSERT INTO INVENTARIO (
    ID_INVENTARIO,
    CODIGO_INVENTARIO,
    NOMBRE,
    DESCRIPCION,
    ID_CATEGORIA,
    ID_MARCA,
    MODELO,
    CANTIDAD,
    FECHA_ADQUISICION,
    VALOR,
    ID_ESTADO,
    ID_ESPACIO
)
SELECT
    SEQ_INVENTARIO.NEXTVAL,
    'HER-001',
    'Multímetro Digital',
    'Instrumento para medición eléctrica',
    C.ID_CATEGORIA,
    M.ID_MARCA,
    'Multímetro Digital',
    5,
    SYSDATE,
    30000,
    E.ID_ESTADO,
    ESP.ID_ESPACIO
FROM CATEGORIA_INVENTARIO C,
     MARCA M,
     ESTADO_EQUIPO E,
     ESPACIO ESP
WHERE C.NOMBRE = 'ELECTRÓNICA'
AND M.NOMBRE = 'Fluke'
AND E.NOMBRE = 'DISPONIBLE'
AND ESP.NOMBRE = 'Taller de Electrónica';


INSERT INTO INVENTARIO (
    ID_INVENTARIO,
    CODIGO_INVENTARIO,
    NOMBRE,
    DESCRIPCION,
    ID_CATEGORIA,
    CANTIDAD,
    FECHA_ADQUISICION,
    VALOR,
    ID_ESTADO,
    ID_ESPACIO
)
SELECT
    SEQ_INVENTARIO.NEXTVAL,
    'HER-002',
    'Kit de Destornilladores',
    'Kit de herramientas para mantenimiento',
    C.ID_CATEGORIA,
    10,
    SYSDATE,
    15000,
    E.ID_ESTADO,
    ESP.ID_ESPACIO
FROM CATEGORIA_INVENTARIO C,
     ESTADO_EQUIPO E,
     ESPACIO ESP
WHERE C.NOMBRE = 'HERRAMIENTAS'
AND E.NOMBRE = 'DISPONIBLE'
AND ESP.NOMBRE = 'Taller de Electrónica';

COMMIT;
19. TRIGGER PARA REGISTRAR AUDITORÍA

Podemos registrar automáticamente determinadas operaciones realizadas sobre el inventario.

------------------------------------------------------------
-- TRIGGER DE AUDITORÍA PARA INVENTARIO
------------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_AUDITORIA_INVENTARIO
AFTER INSERT OR UPDATE OR DELETE
ON INVENTARIO
FOR EACH ROW
BEGIN

    IF INSERTING THEN

        INSERT INTO AUDITORIA (
            ID_AUDITORIA,
            TABLA_AFECTADA,
            OPERACION,
            ID_REGISTRO,
            DESCRIPCION
        )
        VALUES (
            SEQ_AUDITORIA.NEXTVAL,
            'INVENTARIO',
            'INSERT',
            :NEW.ID_INVENTARIO,
            'Nuevo equipo ingresado al inventario'
        );

    ELSIF UPDATING THEN

        INSERT INTO AUDITORIA (
            ID_AUDITORIA,
            TABLA_AFECTADA,
            OPERACION,
            ID_REGISTRO,
            DESCRIPCION
        )
        VALUES (
            SEQ_AUDITORIA.NEXTVAL,
            'INVENTARIO',
            'UPDATE',
            :NEW.ID_INVENTARIO,
            'Equipo modificado'
        );

    ELSIF DELETING THEN

        INSERT INTO AUDITORIA (
            ID_AUDITORIA,
            TABLA_AFECTADA,
            OPERACION,
            ID_REGISTRO,
            DESCRIPCION
        )
        VALUES (
            SEQ_AUDITORIA.NEXTVAL,
            'INVENTARIO',
            'DELETE',
            :OLD.ID_INVENTARIO,
            'Equipo eliminado del inventario'
        );

    END IF;

END;
/
20. VISTAS PARA CONSULTAS

Una de las ventajas de crear vistas es que después podrás conectarlas fácilmente desde Python, Java, PHP, Flask, Spring Boot o una aplicación web.

Inventario completo
CREATE OR REPLACE VIEW VW_INVENTARIO_COMPLETO AS
SELECT
    I.ID_INVENTARIO,
    I.CODIGO_INVENTARIO,
    I.NOMBRE AS EQUIPO,
    C.NOMBRE AS CATEGORIA,
    M.NOMBRE AS MARCA,
    I.MODELO,
    I.NUMERO_SERIE,
    I.CANTIDAD,
    EE.NOMBRE AS ESTADO,
    E.NOMBRE AS ESPACIO,
    I.FECHA_ADQUISICION,
    I.VALOR,
    I.OBSERVACION
FROM INVENTARIO I
JOIN CATEGORIA_INVENTARIO C
    ON I.ID_CATEGORIA = C.ID_CATEGORIA
LEFT JOIN MARCA M
    ON I.ID_MARCA = M.ID_MARCA
JOIN ESTADO_EQUIPO EE
    ON I.ID_ESTADO = EE.ID_ESTADO
LEFT JOIN ESPACIO E
    ON I.ID_ESPACIO = E.ID_ESPACIO;

Puedes probar:

SELECT *
FROM VW_INVENTARIO_COMPLETO
ORDER BY CATEGORIA, EQUIPO;
21. VISTA DE ALUMNOS
CREATE OR REPLACE VIEW VW_ALUMNOS AS
SELECT
    A.ID_ALUMNO,
    A.RUT || '-' || A.DV AS RUT_COMPLETO,
    A.NOMBRE,
    A.APELLIDO_PATERNO,
    A.APELLIDO_MATERNO,
    A.CORREO,
    A.TELEFONO,
    C.NIVEL,
    C.LETRA,
    C.ANIO,
    A.ESPECIALIDAD,
    A.ESTADO
FROM ALUMNO A
LEFT JOIN CURSO C
    ON A.ID_CURSO = C.ID_CURSO;

Consulta:

SELECT *
FROM VW_ALUMNOS
ORDER BY APELLIDO_PATERNO, APELLIDO_MATERNO;
22. VISTA DE PRÉSTAMOS
CREATE OR REPLACE VIEW VW_PRESTAMOS AS
SELECT
    P.ID_PRESTAMO,
    P.FECHA_PRESTAMO,
    P.FECHA_DEVOLUCION_PROGRAMADA,
    P.FECHA_DEVOLUCION_REAL,
    P.ESTADO,

    A.RUT || '-' || A.DV AS RUT_ALUMNO,

    A.NOMBRE || ' ' ||
    A.APELLIDO_PATERNO || ' ' ||
    NVL(A.APELLIDO_MATERNO, '') AS ALUMNO,

    I.CODIGO_INVENTARIO,
    I.NOMBRE AS EQUIPO,

    DP.CANTIDAD,
    DP.ESTADO_SALIDA,
    DP.ESTADO_DEVOLUCION

FROM PRESTAMO P

JOIN DETALLE_PRESTAMO DP
    ON P.ID_PRESTAMO = DP.ID_PRESTAMO

JOIN INVENTARIO I
    ON DP.ID_INVENTARIO = I.ID_INVENTARIO

LEFT JOIN ALUMNO A
    ON P.ID_ALUMNO = A.ID_ALUMNO;
23. CONSULTAS DE CONTROL
Cantidad de equipos por categoría
SELECT
    C.NOMBRE AS CATEGORIA,
    COUNT(I.ID_INVENTARIO) AS CANTIDAD_EQUIPOS
FROM CATEGORIA_INVENTARIO C
LEFT JOIN INVENTARIO I
    ON C.ID_CATEGORIA = I.ID_CATEGORIA
GROUP BY C.NOMBRE
ORDER BY C.NOMBRE;
Equipos por laboratorio
SELECT
    E.NOMBRE AS ESPACIO,
    COUNT(I.ID_INVENTARIO) AS EQUIPOS
FROM ESPACIO E
LEFT JOIN INVENTARIO I
    ON E.ID_ESPACIO = I.ID_ESPACIO
GROUP BY E.NOMBRE
ORDER BY E.NOMBRE;
Equipos disponibles
SELECT *
FROM VW_INVENTARIO_COMPLETO
WHERE ESTADO = 'DISPONIBLE';
Equipos en reparación
SELECT *
FROM VW_INVENTARIO_COMPLETO
WHERE ESTADO = 'EN REPARACION';
Equipos prestados
SELECT *
FROM VW_INVENTARIO_COMPLETO
WHERE ESTADO = 'PRESTADO';
Alumnos por curso
SELECT
    NIVEL,
    LETRA,
    ANIO,
    COUNT(*) AS CANTIDAD_ALUMNOS
FROM VW_ALUMNOS
WHERE ESTADO = 'ACTIVO'
GROUP BY NIVEL, LETRA, ANIO
ORDER BY NIVEL, LETRA;
24. VERIFICACIÓN FINAL

Después de ejecutar todo, puedes comprobar las tablas:

SELECT TABLE_NAME
FROM USER_TABLES
ORDER BY TABLE_NAME;

Y comprobar las vistas:

SELECT VIEW_NAME
FROM USER_VIEWS
ORDER BY VIEW_NAME;

También puedes comprobar los datos:

SELECT * FROM ROL;

SELECT * FROM PERMISO;

SELECT * FROM USUARIO;

SELECT * FROM PROFESOR;

SELECT * FROM CURSO;

SELECT * FROM ALUMNO;

SELECT * FROM ESPACIO;

SELECT * FROM CATEGORIA_INVENTARIO;

SELECT * FROM MARCA;

SELECT * FROM ESTADO_EQUIPO;

SELECT * FROM INVENTARIO;