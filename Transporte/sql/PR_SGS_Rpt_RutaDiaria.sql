SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_RutaDiaria.sql
DESCRIPCIÓN:			SP para unir la consula de los siguientes SP
						PR_SGS_ConsultarRutaDiariaTarde,
						PR_SGS_ConsultarRutaDiariaManana
						Para poder mostrar la los estudiante en la ruta 
						tarde de una fecha seleccionado y los estudiantes
						de una ruta en la mañana siguiente con los 
						respectivos cambios.
RESULTADO:				Muestra todos los registro para jornada tarde y
						siguiente mañana con identificador de columna
						jornada 1 = Tarde y 2 = Mañana
CREACIÓN 
REQUERIMIENTO:			Reportes de Transporte
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2017-08-02
----------------------------------------------------------------------------
****************************************************************************/
ALTER PROCEDURE 
	[dbo].[PR_SGS_Rpt_RutaDiaria]    
(
	 @NumeroRuta VARCHAR(max) 
	,@Fecha DATETIME 
)
AS   
BEGIN
DECLARE  @SiguienteFecha DATE = (Select min(fecha) from calendario where fecha > @Fecha and tipodia like 'E-%')

DECLARE @Rutas TABLE 
	(
		IdRuta VARCHAR(60)
	)
DECLARE @Consulta TABLE
	(
		 Id BIGINT IDENTITY
		,Nombre VARCHAR(403)
		,Curso VARCHAR(50)
		,Direccion VARCHAR(MAX)
		,TelefonoDireccion VARCHAR(100)
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
		,Jornada INT
		,FechaSiguiente DATE
		,IdDireccionUsal INT 
		,IdDireccionDia INT
	)
INSERT INTO @Rutas
SELECT RT.Valor AS Fecha
FROM F_SGS_Split(@NumeroRuta, ',') AS RT

/* Inserción Datos de la Ruta Tarde */
INSERT INTO @Consulta
EXEC PR_SGS_ConsultarRutaDiariaTarde @NumeroRuta, @Fecha 
/* Inserción Datos de la Ruta de las Mañana del día siguiente */
INSERT INTO @Consulta
EXEC PR_SGS_ConsultarRutaDiariaManana @NumeroRuta, @Fecha 

/* Actualización de la tabla tempora @Consulta */
UPDATE @Consulta 
SET TotalRow  = (	SELECT COUNT(id) 
					FROM @Consulta AS C 					
					WHERE C.DominioNombreRutaBY = CON.DominioNombreRutaBY
					AND C.DominioNombreRutaBY = C.DominioNombreRutaPT
					AND Jornada = 1
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

