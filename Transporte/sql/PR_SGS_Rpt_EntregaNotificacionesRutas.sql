SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_EntregaNotificacionesRutas.sql
DESCRIPCIÓN:			Reporte que muestra listado de estudiantes
						con dirección real e información para saber 
						si esta matriculado o no. 
					
CREACIÓN 
REQUERIMIENTO:			Reportes de Transporte
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2017-08-09
----------------------------------------------------------------------------
****************************************************************************/
ALTER PROCEDURE 

	 [dbo].[PR_SGS_Rpt_EntregaNotificacionesRutas] 
	
		@iP_NumeroRuta VARCHAR(max) 
AS
BEGIN

DECLARE @Rutas TABLE 
	(
		DominioNombreRuta VARCHAR(max)
	)
INSERT INTO @Rutas
SELECT RT.Valor AS Fecha
FROM F_SGS_Split(@iP_NumeroRuta, ',') AS RT

SELECT 
         PRE.Orden AS Paradero
	   , P.Nombre AS Nombre
       , P.Direccion As DireccionEstudiante
       , ASIS.PrimerApellido + ' ' + isNull(asis.SegundoApellido,'')  + ' ' + asis.PrimerNombre + ' ' + isNull(asis.SegundoNombre,'') AS NombreAuxiliar
	   , BR.DominioNombreRuta AS Ruta
	   , CASE
			WHEN EST.Matricula = 1 THEN CONVERT(VARCHAR(30),'Si')
			WHEN EST.Matricula = 0 THEN CONVERT(VARCHAR(30),' ')
			ELSE CONVERT(VARCHAR(30),EST.Matricula )
		END AS Matricula
FROM 
       PersonaRuta AS PR 
	   INNER JOIN BusRuta AS BR 
	   ON PR.IdBusRuta= BR.IdBusRuta
   
	   INNER JOIN @Rutas AS RT ON 
	   RT.DominioNombreRuta  = BR.DominioNombreRuta

       INNER JOIN vw_datospersona AS P 
	   ON PR.TipoIdentificacionPasajero = P.TipoIdentificacion
	   AND PR.NumeroIdentificacionPasajero = P.Numeroidentificacion

	   INNER JOIN Estudiante AS EST
	   ON P.TipoIdentificacion = EST.TipoIdentificacion 
	   AND P.NumeroIdentificacion = EST.NumeroIdentificacion 

       LEFT JOIN PreRuta AS PRE 
	   ON PRE.IdPersonaRuta = PR.IdPersonaRuta

       LEFT JOIN Persona AS ASIS 
	   ON ASIS.TipoIdentificacion= BR.TipoIdentificacionAsistente
	   AND ASIS.NumeroIdentificacion = BR.NumeroIdentificacionAsistente

WHERE
       BR.FechaCalendario = '19000101'
	   AND BR.DominioJornada ='11'
	   AND PR.Estado = 'Activo'

ORDER BY
		PRE.Orden ASC
    	,P.Nombre ASC 
END
GO


