SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:                     dbo.PR_SGS_Rpt_Preruta
DESCRPCIÓN:                 Consulta reporte PreRuta
AUTOR:                      Maritza Zambrano
REQUERIMIENTO:              SP35 - Transporte
EMPRESA:                    Colegio San Jorge de Inglaterra
FECHA CREACIÓN:             01-08-2016
PARÁMETROS ENTRADA:  No Aplica
EXCEPCIONES:         No Aplica
----------------------------------------------------
MODIFICACIÓN
REQUERIMIENTO:			Reportes de Transporte
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2016-12-05
DESCRIPCIÓN				Se convierte la consulta del reporte en un SP
						Se añade para que puede seleccionar varias rutas al 
						momento de imprimir.
ID TFS:					52
----------------------------------------------------------------------------
****************************************************************************/
ALTER PROCEDURE 

	 [dbo].[PR_SGS_Rpt_Preruta] 
	
		@NumeroRuta VARCHAR(max) 

AS
BEGIN

DECLARE @Rutas TABLE 
	(
		DominioNombreRuta VARCHAR(60)
	)
INSERT INTO @Rutas
SELECT RT.Valor AS Fecha
FROM F_SGS_Split(@NumeroRuta, ',') AS RT

SELECT 
         P.Nombre 
       , P.Nivel AS Nivel
       , P.Direccion AS DIRECCION
       , PRE.direccionparadero AS Paradero
       , PRE .Orden AS NUMEROPARADERO
       , PRE.Hora AS HORA
       , ASIS.PrimerApellido + ' ' + asis.SegundoApellido + ' ' + asis.PrimerNombre + ' ' + asis.SegundoNombre AS NombreAuxiliar
	   , BR.DominioNombreRuta AS Ruta

FROM
		PersonaRuta AS PR 
		INNER JOIN busruta as BR on 
		PR.idbusruta= BR.IdBusRuta

		INNER JOIN  vw_datospersona as P on 
		PR.NumeroIdentificacionPasajero = p.NumeroIdentificacion and 
		PR.TipoIdentificacionPasajero = p.TipoIdentificacion

		INNER JOIN @Rutas AS RT ON 
		RT.DominioNombreRuta  = BR.DominioNombreRuta

		LEFT JOIN  PreRuta AS PRE  on 
		PRE.IdPersonaRuta = PR.IdPersonaRuta 

	    LEFT JOIN Persona as ASIS on 
		ASIS.TipoIdentificacion = br.TipoIdentificacionAsistente 
		AND ASIS.NumeroIdentificacion = br.NumeroIdentificacionAsistente

WHERE 
       BR.FechaCalendario = '19000101'
	   AND BR.DominioJornada ='11'
	   AND PR.Estado = 'Activo'

ORDER BY
		P.Nombre

END
GO

