USE [SGS]
GO
/****** Object:  StoredProcedure [dbo].[PR_SGS_ConsultarRutaDiaria]    Script Date: 16/11/2016 9:34:20 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:				dbo.PR_SGS_ConsultarRutaDiaria.sql
DESCRPCIÓN:			Creación Strored Procedures "Consulta Ruta Completa"
AUTOR:				John Alberto López Hernández
REQUERIMIENTO:		SP35 - Transporte
EMPRESA:			Colegio San Jorge de Inglaterra
FECHA CREACIÓN:		18-08-2016
PARÁMETROS ENTRADA:	No Aplica
EXCEPCIONES:		No Aplica
---------------------------------------------------------------------
MODIFICACIÓN: Se muestra la auxiliar y el bus de la ruta de hoy en 
				lugar del de la ruta usual. Verifica el orden
AUTOR: Luisa Lamprea
REQUERIMIENTO:  Error: muestra auxiliar incorrecta en el reporte
EMPRESA: Saint George's School
FECHA MODIFICACIÓN: 21-09-2016
--------------------------------------------------------------------
MODIFICACIÓN: Se agrega un LEFT JOIN, con solicitud de transporte y 
tipo de de Solicitud de transporte, para sacar la columna temporal 
o permatener y poder en el filtro del reporte agregar la condición que
solo muetsre los pernantes, para que en los cambios de domiclio, no se 
muestre como un cambio 
de paradero.

AUTOR: JOHN ALBERTO LÓPEZ HERNÁNDEZ
FECHA MODIFICACIÓN 06 Marzo de 2016
********************************************************************/


ALTER PROCEDURE 
	[dbo].[PR_SGS_ConsultarRutaDiaria]    
(
	 @NumeroRuta VARCHAR(max) 
	,@Fecha DATETIME 
	,@Jornada VARCHAR(2) 
)
AS   
BEGIN
DECLARE @Rutas TABLE 
	(
		IdRuta VARCHAR(60)
	)

DECLARE @Consulta TABLE
	(
		 Id BIGINT IDENTITY
		,Nombre VARCHAR(403)
		,Curso VARCHAR(50)
		,Direccion VARCHAR(100)
		,TelefonoDireccion VARCHAR(50)
		,CelularMadre VARCHAR(100)
		,CelularPadre VARCHAR(50)
		,DireccionParadero VARCHAR(1000)
		,Hora TIME(3)
		,NombreAuxiliar VARCHAR(max)
		,Estado VARCHAR(50)
		,NumeroDia INT NULL
		,IdSolicitudTransporte BIGINT NULL
		,Conductor VARCHAR(max)
		,Placa VARCHAR(8)
		,Capacidad INT
		,Celular VARCHAR(50)
		,NumeroParadero INT NULL
		,DominioNombreRutaBY VARCHAR(60)
		,DominioNombreRutaPT VARCHAR(60)
		,Justificacion VARCHAR(500)
		,TotalRow BIGINT  NULL
		,RutaReporte VARCHAR (60)
		,Temporal INT
	)

INSERT INTO @Rutas
SELECT RT.Valor AS Fecha
FROM F_SGS_Split(@NumeroRuta, ',') AS RT

INSERT INTO @Consulta
SELECT 
	  PER.Nombre AS Nombre
	, PER.Curso AS Curso
	, DR.Direccion +' '+ DR.DescripcionDireccion AS Direccion 
	, PER.TelefonoDireccion AS TelefonoDireccion
	, PER.CelularMadre AS CelularMadre
	, PER.CelularPadre AS CelularPadre
	, PRE.direccionparadero AS Paradero
	, CONVERT(varchar(15),CAST(pre.Hora AS TIME),100)  AS Hora
	, ASIS.PrimerApellido + ' ' + asis.SegundoApellido + ' ' + asis.PrimerNombre + ' ' + asis.SegundoNombre AS NombreAuxiliar
	, PRTHOY.Estado AS Estado
	, CAL.NumeroDia AS NumeroDia
	, ISNULL(PRTHOY.IdSolicitudTransporte, 0) AS IdSolicitudTransporte
	, B.NombreConductor + ' ' + b.ApellidoConductor AS Conductor
	, B.Placa as Placa
	, B.Puestos AS Capacidad
	, B.Celular	AS Celular
	, PRE.Orden AS NumeroParadero
	, BTHOY.DominioNombreRuta AS Ruta
    , BTUSAL.DominioNombreRuta AS Plantilla
	, (CASE WHEN PRTHOY.Justificacion IS null then ' ' else PRTHOY.Justificacion END) AS Justificación
	, NULL AS TotalRow
	, RR.IdRuta AS RutaReporte
	, TST.Temporal AS Temporal

FROM 
	PERSONARUTA AS PRTHOY 
		INNER JOIN BUSRUTA AS BTHOY 
		  ON PRTHOY.IdBusRuta = BTHOY.IdBusRuta
		  AND PRTHOY.Estado = 'Activo'
		INNER JOIN PERSONARUTA AS PRTUSAL
		   ON PRTHOY.TipoIdentificacionPasajero = PRTUSAL.TipoIdentificacionPasajero
		   AND PRTHOY.NumeroIdentificacionPasajero = PRTUSAL.NumeroIdentificacionPasajero
		INNER JOIN BUSRUTA AS BTUSAL 
			ON PRTUSAL.IdBusRuta = BTUSAL.IdBusRuta
		  AND PRTUSAL.Estado = 'Activo'
		INNER JOIN VW_DATOSPERSONA AS PER ON
			PRTHOY.NumeroIdentificacionPasajero = PER.NumeroIdentificacion and 
			PRTHOY.TipoIdentificacionPasajero = PER.TipoIdentificacion
		LEFT JOIN PRERUTA AS PRE ON
			PRTUSAL.IdPersonaRuta = PRE.IdPersonaRuta
		INNER JOIN  Direccion as DR ON 
			PRTHOY.IdDireccion= DR.IdDireccion 
		INNER JOIN CALENDARIO AS CAL ON
			CAL.fecha = BTUSAL.FechaCalendario
		INNER JOIN PERSONA AS ASIS ON 
			ASIS.TipoIdentificacion = BTHOY.TipoIdentificacionAsistente and 
			ASIS.NumeroIdentificacion = BTHOY.NumeroIdentificacionAsistente
		INNER JOIN BUS AS B ON
			B.Idbus =  BTHOY.Idbus
		INNER JOIN @Rutas AS RR ON 
			BTHOY.DominioNombreRuta = RR.IdRuta 
			OR BTUSAL.DominioNombreRuta = RR.IdRuta	
		LEFT JOIN SolicitudTransporte AS ST ON
			PRTHOY.IdSolicitudTransporte = ST.IdSolicitudTransporte
		LEFT JOIN TipoSolicitudTransporte AS TST ON
			ST.IdTipoSolicitudTransporte = TST.IdTipoSolicitudTransporte

WHERE 
	BTUSAL.FechaCalendario = '19000101'
		AND BTUSAL.DominioJornada= @Jornada 
		AND BTHOY.FechaCalendario = @Fecha
		AND BTHOY.DominioJornada like Substring(@Jornada,1,1)+ '_'
UPDATE @Consulta 
SET TotalRow  = (	SELECT COUNT(id) 
					FROM @Consulta AS C 					
					WHERE C.DominioNombreRutaBY = CON.DominioNombreRutaBY
					AND C.DominioNombreRutaBY = C.DominioNombreRutaPT
				)
FROM @Consulta AS CON
SELECT 
	* 
FROM 
	@Consulta AS CONFINAL
ORDER BY 
	 cast(RutaReporte as int) ASC
	 -- LL: este ordenamiento garantiza que el primer registro siempre corresponde a un pasajero que va en
	 -- la ruta y puede ser utlizado para los encabezados del reporte
	 ,abs(cast (RutaReporte as int) - cast (DominioNombreRutaBY as int)) 
	,NumeroParadero
END
