SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_EntregaNotificacionesMediasRutas.sql
DESCRIPCIÓN:			Reporte que muestra listado de estudiantes
						con dirección real e información para saber 
						si esta matriculado o no, para las media ruta tarde.
					
CREACIÓN 
REQUERIMIENTO:			Reportes de Transporte
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2017-08-09
----------------------------------------------------------------------------
****************************************************************************/
CREATE PROCEDURE 

	 [dbo].[PR_SGS_Rpt_EntregaNotificacionesMediasRutas] 
	
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
	   , BRT.DominioNombreRuta +' '+'MediaRuta' AS Ruta
	   , CASE
			WHEN EST.Matricula = 1 THEN CONVERT(VARCHAR(30),'Si')
			WHEN EST.Matricula = 0 THEN CONVERT(VARCHAR(30),' ')
			ELSE CONVERT(VARCHAR(30),EST.Matricula )
		END AS Matricula
FROM 
       PersonaRuta AS PR
	   /* Bus Ruta Mañana */
	   INNER JOIN BusRuta AS BRM
	   ON PR.IdBusRuta= BRM.IdBusRuta

	   /* Persona Ruta Tarde*/
	   INNER JOIN PersonaRuta AS PRT
	   ON PR.NumeroIdentificacionPasajero = PRT.NumeroIdentificacionPasajero 

	   /* Bus Ruta Tarde */
	   INNER JOIN BusRuta AS BRT 
	   ON PRT.IdBusRuta= BRT.IdBusRuta
   
	   INNER JOIN @Rutas AS RT ON 
	   RT.DominioNombreRuta  = BRT.DominioNombreRuta

       INNER JOIN vw_datospersona AS P 
	   ON PR.TipoIdentificacionPasajero = P.TipoIdentificacion
	   AND PR.NumeroIdentificacionPasajero = P.Numeroidentificacion

	   LEFT JOIN Estudiante AS EST
	   ON P.TipoIdentificacion = EST.TipoIdentificacion 
	   AND P.NumeroIdentificacion = EST.NumeroIdentificacion 

       LEFT JOIN PreRuta AS PRE 
	   ON PRE.IdPersonaRuta = PRT.IdPersonaRuta

       LEFT JOIN Persona AS ASIS 
	   ON ASIS.TipoIdentificacion= BRT.TipoIdentificacionAsistente
	   AND ASIS.NumeroIdentificacion = BRT.NumeroIdentificacionAsistente

WHERE
       BRT.FechaCalendario = '19000101'
	   AND BRM.FechaCalendario = '19000101'
	   AND BRT.DominioJornada = '21'
	   AND BRM.DominioJornada = '11'
	   AND BRM.DominioNombreRuta = '0'
	   AND PR.Estado = 'Activo'
	   AND PRT.Estado = 'Activo'

ORDER BY
		PRE.Orden ASC
    	,P.Nombre ASC 

END
GO



