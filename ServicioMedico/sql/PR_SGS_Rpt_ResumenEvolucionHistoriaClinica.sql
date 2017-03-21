SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_ResumenEvolucionHistoriaClinica.sql
DESCRIPCIÓN:			Muestra el resumen de una evolución para construir
						el reporte de la Historia Clínica. 
RESULTADO:				Listado con las siguientes columnas: 
						Muestra Todas las columnas de la tabla evolución 
						y diagnóstico con código y diagnóstico.
CREACIÓN 
REQUERIMIENTO:			Reportes de Servicio Médico
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2017-03-17
----------------------------------------------------------------------------
****************************************************************************/
CREATE PROCEDURE 
	 [dbo].[PR_SGS_Rpt_ResumenEvolucionHistoriaClinica] 
	 	 
	 @idP_TipoDocumentoPersona varchar(30)
	,@ndP_NumeroDocumentoPersona varchar(50)
AS
BEGIN

SELECT 
	ROW_NUMBER()Over(Order By NewId()) AS NumEvolucion
	,CONVERT (varchar(10),EV.FechaIngreso,103) AS FechaIngreso
	,EV.HoraInicio AS HoraInicio
	,EV.HoraFin AS HorarioFin
    ,dbo.F_SGS_CalcularEdadAniosMeses(EV.Edad) AS Edad
	,EV.Talla AS Talla
	,EV.Peso AS Peso
	,EV.ClasificacionTriage AS ClasificacionTriage
	,EV.FrecuenciaCardiaca AS FrecuenciaCardiaca
	,EV.FrecuenciaRespiratoria AS FrecuenciaRespiratoria
	,EV.SaturacionOxigeno AS SaturacionOxigeno
	,EV.Temperatura AS Temperatura
	,EV.TensionArterial AS TensionArterial
	,EV.IMC AS IMC
	,EV.MotivoConsulta AS MotivoConsulta
	,EV.EnfermedadActual AS EnfermedadActual
	,EV.ValoracionEnfermeria AS ValoracionEnfermeria
	/* Revisón por Sistemas */
	,CASE
		WHEN EV.EstSistemasGenerales = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstSistemasGenerales = 'RF' THEN CONVERT(VARCHAR(30),'Referenciado')
		ELSE CONVERT(VARCHAR(30),EV.EstSistemasGenerales)
		END AS EstSistemasGenerales
	,EV.ObsSistemasGenerales AS ObsSistemasGenerales
	,CASE
		WHEN EV.EstPielAnexos = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstPielAnexos = 'RF' THEN CONVERT(VARCHAR(30),'Referenciado')
		ELSE CONVERT(VARCHAR(30),EV.EstPielAnexos)
		END AS EstPielAnexos
	,EV.ObsPielAnexos AS ObsPielAnexos
	,CASE
		WHEN EV.EstOcular = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstOcular = 'RF' THEN CONVERT(VARCHAR(30),'Referenciado')
		ELSE CONVERT(VARCHAR(30),EV.EstOcular)
		END AS EstOcular
	,EV.ObsOcular AS ObsOcular
	,CASE
		WHEN EV.EstAuditivo = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstAuditivo = 'RF' THEN CONVERT(VARCHAR(30),'Referenciado')
		ELSE CONVERT(VARCHAR(30),EV.EstAuditivo)
		END AS EstAuditivo
	,EV.ObsAuditivo AS ObsAuditivo
	,CASE
		WHEN EV.EstRespiratorio = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstRespiratorio  = 'RF' THEN CONVERT(VARCHAR(30),'Referenciado')
		ELSE CONVERT(VARCHAR(30),EV.EstRespiratorio )
		END AS EstRespiratorio 
	,EV.ObsRespiratorio AS ObsRespiratorio
	,CASE
		WHEN EV.EstCardiovascular  = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstCardiovascular   = 'RF' THEN CONVERT(VARCHAR(30),'Referenciado')
		ELSE CONVERT(VARCHAR(30),EV.EstCardiovascular  )
		END AS EstCardiovascular  
	,EV.ObsCardiovascular AS ObsCardiovascular
	,CASE
		WHEN EV.EstDigestivo = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstDigestivo   = 'RF' THEN CONVERT(VARCHAR(30),'Referenciado')
		ELSE CONVERT(VARCHAR(30),EV.EstDigestivo  )
		END AS EstDigestivo
	,EV.ObsDigestivo AS ObsDigestivo
	,CASE
		WHEN EV.EstGenitoUrinario = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstGenitoUrinario   = 'RF' THEN CONVERT(VARCHAR(30),'Referenciado')
		ELSE CONVERT(VARCHAR(30),EV.EstGenitoUrinario )
		END AS EstGenitoUrinario
	,EV.ObsGenitoUrinario AS ObsGenitoUrinario
	,CASE
		WHEN EV.EstEndocrino = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstEndocrino   = 'RF' THEN CONVERT(VARCHAR(30),'Referenciado')
		ELSE CONVERT(VARCHAR(30),EV.EstEndocrino )
		END AS EstEndocrino
	,EV.ObsEndocrino AS ObsEndocrino
	,CASE
		WHEN EV.EstHematologicoLinfatico = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstHematologicoLinfatico   = 'RF' THEN CONVERT(VARCHAR(30),'Referenciado')
		ELSE CONVERT(VARCHAR(30),EV.EstHematologicoLinfatico )
		END AS EstHematologicoLinfatico
	,EV.ObsHematologicoLinfatico AS ObsHematologicoLinfatico
	,CASE
		WHEN EV.EstNeurologicoPsiquiatrico = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstNeurologicoPsiquiatrico   = 'RF' THEN CONVERT(VARCHAR(30),'Referenciado')
		ELSE CONVERT(VARCHAR(30),EV.EstNeurologicoPsiquiatrico )
		END AS EstNeurologicoPsiquiatrico
	,EV.ObsNeurologicoPsiquiatrico AS ObsNeurologicoPsiquiatrico
	,CASE
		WHEN EV.EstOsteomuscular= 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstOsteomuscular   = 'RF' THEN CONVERT(VARCHAR(30),'Referenciado')
		ELSE CONVERT(VARCHAR(30),EV.EstOsteomuscular )
		END AS EstOsteomuscular
	,EV.ObsOsteomuscular AS ObsOsteomuscular
	/** Revisión Por órganos **/
	,CASE
		WHEN EV.EstAnexoPielOrgano = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstAnexoPielOrgano = 'NM' THEN CONVERT(VARCHAR(30),'Normal')
		WHEN EV.EstAnexoPielOrgano = 'NE' THEN CONVERT(VARCHAR(30),'No Explorado')
		WHEN EV.EstAnexoPielOrgano = 'AN' THEN CONVERT(VARCHAR(30),'Anormal')
		ELSE CONVERT(VARCHAR(30),EV.EstAnexoPielOrgano )
		END AS EstAnexoPielOrgano
	,EV.ObsAnexoPielOrgano AS ObsAnexoPielOrgano 
	,CASE
		WHEN EV.EstAspectoGeneral = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstAspectoGeneral = 'NM' THEN CONVERT(VARCHAR(30),'Normal')
		WHEN EV.EstAspectoGeneral = 'NE' THEN CONVERT(VARCHAR(30),'No Explorado')
		WHEN EV.EstAspectoGeneral = 'AN' THEN CONVERT(VARCHAR(30),'Anormal')
		ELSE CONVERT(VARCHAR(30),EV.EstAspectoGeneral)
		END AS EstAspectoGeneral
	,EV.ObsAspectoGeneral AS ObsAspectoGeneral
	,CASE
		WHEN EV.EstCabeza = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstCabeza = 'NM' THEN CONVERT(VARCHAR(30),'Normal')
		WHEN EV.EstCabeza = 'NE' THEN CONVERT(VARCHAR(30),'No Explorado')
		WHEN EV.EstCabeza = 'AN' THEN CONVERT(VARCHAR(30),'Anormal')
		ELSE CONVERT(VARCHAR(30),EV.EstCabeza)
		END AS EstCabeza
	,EV.ObsCabeza AS ObsCabeza
	,CASE
		WHEN EV.EstOjos = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstOjos = 'NM' THEN CONVERT(VARCHAR(30),'Normal')
		WHEN EV.EstOjos = 'NE' THEN CONVERT(VARCHAR(30),'No Explorado')
		WHEN EV.EstOjos = 'AN' THEN CONVERT(VARCHAR(30),'Anormal')
		ELSE CONVERT(VARCHAR(30),EV.EstOjos)
		END AS EstOjos
	,EV.ObsOjos AS ObsOjos
	,CASE
		WHEN EV.EstOidos = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstOidos = 'NM' THEN CONVERT(VARCHAR(30),'Normal')
		WHEN EV.EstOidos = 'NE' THEN CONVERT(VARCHAR(30),'No Explorado')
		WHEN EV.EstOidos = 'AN' THEN CONVERT(VARCHAR(30),'Anormal')
		ELSE CONVERT(VARCHAR(30),EV.EstOidos)
		END AS EstOidos
	,EV.ObsOidos AS ObsOidos
	,CASE
		WHEN EV.EstNariz = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstNariz = 'NM' THEN CONVERT(VARCHAR(30),'Normal')
		WHEN EV.EstNariz = 'NE' THEN CONVERT(VARCHAR(30),'No Explorado')
		WHEN EV.EstNariz = 'AN' THEN CONVERT(VARCHAR(30),'Anormal')
		ELSE CONVERT(VARCHAR(30),EV.EstNariz)
		END AS EstNariz
	,EV.ObsNariz AS ObsNariz
	,CASE
		WHEN EV.EstBocaFaringe = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstBocaFaringe = 'NM' THEN CONVERT(VARCHAR(30),'Normal')
		WHEN EV.EstBocaFaringe = 'NE' THEN CONVERT(VARCHAR(30),'No Explorado')
		WHEN EV.EstBocaFaringe = 'AN' THEN CONVERT(VARCHAR(30),'Anormal')
		ELSE CONVERT(VARCHAR(30),EV.EstBocaFaringe)
		END AS EstBocaFaringe
	,EV.ObsBocaFaringe AS ObsBocaFaringe
	,CASE
		WHEN EV.EstCuello = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstCuello = 'NM' THEN CONVERT(VARCHAR(30),'Normal')
		WHEN EV.EstCuello = 'NE' THEN CONVERT(VARCHAR(30),'No Explorado')
		WHEN EV.EstCuello = 'AN' THEN CONVERT(VARCHAR(30),'Anormal')
		ELSE CONVERT(VARCHAR(30),EV.EstCuello)
		END AS EstCuello
	,EV.ObsCuello AS ObsCuello
	,CASE
		WHEN EV.EstTorax = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstTorax = 'NM' THEN CONVERT(VARCHAR(30),'Normal')
		WHEN EV.EstTorax = 'NE' THEN CONVERT(VARCHAR(30),'No Explorado')
		WHEN EV.EstTorax = 'AN' THEN CONVERT(VARCHAR(30),'Anormal')
		ELSE CONVERT(VARCHAR(30),EV.EstTorax)
		END AS EstTorax
	,EV.ObsTorax AS ObsTorax
	,CASE
		WHEN EV.EstAbdomen = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstAbdomen = 'NM' THEN CONVERT(VARCHAR(30),'Normal')
		WHEN EV.EstAbdomen = 'NE' THEN CONVERT(VARCHAR(30),'No Explorado')
		WHEN EV.EstAbdomen = 'AN' THEN CONVERT(VARCHAR(30),'Anormal')
		ELSE CONVERT(VARCHAR(30),EV.EstAbdomen)
		END AS EstAbdomen
	,EV.ObsAbdomen AS ObsAbdomen
	,CASE
		WHEN EV.EstGenitales = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstGenitales = 'NM' THEN CONVERT(VARCHAR(30),'Normal')
		WHEN EV.EstGenitales = 'NE' THEN CONVERT(VARCHAR(30),'No Explorado')
		WHEN EV.EstGenitales = 'AN' THEN CONVERT(VARCHAR(30),'Anormal')
		ELSE CONVERT(VARCHAR(30),EV.EstGenitales)
		END AS EstGenitales
	,EV.ObsGenitales AS ObsGenitales
	,CASE
		WHEN EV.EstExtremidadesSuperiores = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstExtremidadesSuperiores = 'NM' THEN CONVERT(VARCHAR(30),'Normal')
		WHEN EV.EstExtremidadesSuperiores = 'NE' THEN CONVERT(VARCHAR(30),'No Explorado')
		WHEN EV.EstExtremidadesSuperiores = 'AN' THEN CONVERT(VARCHAR(30),'Anormal')
		ELSE CONVERT(VARCHAR(30),EV.EstExtremidadesSuperiores)
		END AS EstExtremidadesSuperiores
	,EV.ObsExtremidadesSuperiores AS ObsExtremidadesSuperiores
	,CASE
		WHEN EV.EstExtremidadesInferiores = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstExtremidadesInferiores = 'NM' THEN CONVERT(VARCHAR(30),'Normal')
		WHEN EV.EstExtremidadesInferiores = 'NE' THEN CONVERT(VARCHAR(30),'No Explorado')
		WHEN EV.EstExtremidadesInferiores = 'AN' THEN CONVERT(VARCHAR(30),'Anormal')
		ELSE CONVERT(VARCHAR(30),EV.EstExtremidadesInferiores)
		END AS EstExtremidadesInferiores
	,EV.ObsExtremidadesInferiores AS ObsExtremidadesInferiores
	,CASE
		WHEN EV.EstColumnaVertebral = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstColumnaVertebral = 'NM' THEN CONVERT(VARCHAR(30),'Normal')
		WHEN EV.EstColumnaVertebral = 'NE' THEN CONVERT(VARCHAR(30),'No Explorado')
		WHEN EV.EstColumnaVertebral = 'AN' THEN CONVERT(VARCHAR(30),'Anormal')
		ELSE CONVERT(VARCHAR(30),EV.EstColumnaVertebral)
		END AS EstColumnaVertebral
	,EV.ObsColumnaVertebral AS ObsColumnaVertebral
	,CASE
		WHEN EV.EstNeurologico = 'NR' THEN CONVERT(VARCHAR(30),'No Referenciado')
		WHEN EV.EstNeurologico = 'NM' THEN CONVERT(VARCHAR(30),'Normal')
		WHEN EV.EstNeurologico = 'NE' THEN CONVERT(VARCHAR(30),'No Explorado')
		WHEN EV.EstNeurologico = 'AN' THEN CONVERT(VARCHAR(30),'Anormal')
		ELSE CONVERT(VARCHAR(30),EV.EstNeurologico)
		END AS EstNeurologico
	,EV.ObsNeurologico AS ObsNeurologico
	,DG.CodigoCIE10 AS CodigoCIE10
	,CIE.Descripcion AS DescripcionCIE10
	,EV.Tratamiento AS Tratamiento
	,EV.Recomendaciones AS Recomendaciones
	,EV.SignosAlarma AS SignosAlarma
	,EV.SaleHacia AS SaleHacia
	,EV.SolicitudControl AS SolicitudControl
	,EV.NombreAcompananteTraslado AS NombreAcompananteTraslado
	,EV.TelefonoAcompananteTraslado AS TelefonoAcompananteTraslado
	,EV.ServicioSolicitaReferencia AS ServicioSolicitaReferencia
	,EV.ImpresionDiagnostica AS ImpresionDiagnostica
	,EV.TratamientoRealizado AS TratamientoRealizado
	,EV.MotivoRemision AS MotivoRemision
	,EV.ExamenFisicoReferencia AS ExamenFisicoReferencia
FROM 
	EVOLUCION  AS EV
	INNER JOIN DIAGNOSTICO AS DG ON
	EV.Id = DG.IdEvolucion
	INNER JOIN CIE10 AS CIE ON
	DG.CodigoCIE10 = CIE.Codigo
WHERE 
	EV.TipoIdentificacion = @idP_TipoDocumentoPersona
	AND EV.NumeroIdentificacion = @ndP_NumeroDocumentoPersona

END