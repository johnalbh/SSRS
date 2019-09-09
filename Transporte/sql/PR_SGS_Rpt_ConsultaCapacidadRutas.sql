/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_ConsultaCapacidadRutas.sql
DESCRIPCIÓN:			Reporte que Consulta la capacidad de los buses 
						y los pasajeros que tiene en la mañana y en la 
						tarde. 
RESULTADO:				Listado con las siguientes columnas: 
						Dominio Nombre Ruta
	
CREACIÓN 
REQUERIMIENTO:			Reportes de Transporte
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2017-08-01
ID TFS:					53 - User Story
----------------------------------------------------------------------------
****************************************************************************/
ALTER PROCEDURE 
	 [dbo].[PR_SGS_Rpt_ConsultaCapacidadRutas] 
AS
BEGIN

SELECT 
	 CONVERT(INT,BR.DominioNombreRuta) AS NombreRuta
	,B.Placa AS Placa
	,Mar.Descripcion AS Marca
	,B.Modelo AS Modelo
	,CONVERT(INT,B.Puestos) AS Capacidad
	,CONVERT (INT, (SELECT COUNT(*) FROM PersonaRuta AS PR where IdBusRuta = BR.idBusruta and  PR.Estado = 'Activo')) AS PasajerosAM
	,CONVERT (INT,(SELECT COUNT(*) FROM PersonaRuta AS PR2 where idBusRuta = BRPM.idBusruta and PR2.Estado = 'Activo')) AS PasajerosPM
FROM BUSRUTA AS BR
	INNER JOIN BUS AS B 
ON B.IdBus = BR.IdBus
	INNER JOIN  BusRuta AS BRPM 
ON BRPM.DominioJornada = '21' 
	AND BRPM.DominioNombreRuta = BR.DominioNombreRuta 
	AND BRPM.FechaCalendario = '19000101'
INNER JOIN Dominio AS Mar
ON Mar.Dominio = 'MarcaBus'
AND B.Marca = Mar.Valor
WHERE 
	BR.FechaCalendario = '19000101' 
	AND BR.DominioJornada = '11' 
	AND BR.DominioNombreRuta NOT IN ('0','99','100')

ORDER BY 
	CONVERT(INT,BR.DominioNombreRuta) ASC
END 