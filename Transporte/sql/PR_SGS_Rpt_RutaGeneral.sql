SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_RutaGeneral.sql
DESCRIPCIÓN:			Reporte que muestra la ruta general es decir
						la plantilla de todos los usuarios. 
RESULTADO:				Listado con las siguientes columnas: 
						Seccion, Nivel, Curso, Apellidos, Nombres, Grupo, FechaInicio, FechaFin, Profesor,Inactivo 
						(* si el estudiante está inactivo, vacío si está activo).
						La consulta se entrega ordenada alfabéticamente por apellidos y nombres del estudiante y por nombre del grupo	
CREACIÓN 
REQUERIMIENTO:			Reportes de Transporte
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2017-08-02
----------------------------------------------------------------------------
****************************************************************************/

ALTER PROCEDURE 
	 [dbo].[PR_SGS_Rpt_RutaGeneral] 
	
		 @IdP_Jornada INT 
		,@NumeroRuta VARCHAR(MAX)

AS
BEGIN

DECLARE @Rutas TABLE 
	(
		DominioNombreRuta VARCHAR(MAX)
	)
INSERT INTO @Rutas
SELECT RT.Valor AS Fecha
FROM F_SGS_Split(@NumeroRuta, ',') AS RT

SELECT  

     P.Nombre 
   , P.Nivel
   , P.Direccion
   , P.TelefonoDireccion
   , P.CelularMadre
   , P.CelularPadre
   , PRE.direccionparadero AS Paradero
   , PRE.Orden AS NumeroParadero
   , CONVERT(varchar(15),CAST(pre.Hora AS TIME),100)  AS Hora
   ,(ISNULL(ASIS.PrimerNombre, '')  + ' ' + ISNULL(ASIS.SegundoNombre, '') + ' ' + ISNULL(ASIS.PrimerApellido, '') + ' ' + ISNULL(ASIS.SegundoApellido, '')) AS NombreAuxiliar
   , BR.DominioNombreRuta AS Ruta
   

FROM

	PersonaRuta AS PR
	INNER JOIN BusRuta AS BR 
	ON PR.IdBusRuta= BR.IdBusRuta
	AND BR.DominioJornada = @IdP_Jornada
	AND BR.FechaCalendario = '19000101'
	AND PR.Estado = 'Activo'

	INNER JOIN vw_datospersona AS P 
	ON 	PR.NumeroIdentificacionPasajero =  P.NumeroIdentificacion 
	AND pr.TipoIdentificacionPasajero = p.TipoIdentificacion

	INNER JOIN @Rutas AS RT 
	ON RT.DominioNombreRuta  = BR.DominioNombreRuta

	LEFT JOIN  PreRuta AS PRE 
	ON PRE.IdPersonaRuta = PR.IdPersonaRuta 

	LEFT JOIN Persona AS ASIS 
	ON ASIS.TipoIdentificacion = BR.TipoIdentificacionAsistente 
	AND ASIS.NumeroIdentificacion = BR.NumeroIdentificacionAsistente

ORDER BY 
       
	  PRE.Orden, P.Nombre

END
GO
