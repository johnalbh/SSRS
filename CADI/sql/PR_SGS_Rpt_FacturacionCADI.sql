SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:				dbo.PR_SGS_Rpt_FacturacionCADI.sql
DESCRPCIÓN:			Creación Strored Procedures "Facturación CADI"
AUTOR:				John Alberto López Hernández
REQUERIMIENTO:		SP40 - Transporte
EMPRESA:			Colegio San Jorge de Inglaterra
FECHA CREACIÓN:		15/11/2016
PARÁMETROS ENTRADA:	No Aplica
EXCEPCIONES:		No Aplica
---------------------------------------------------------------------
MODIFICACIÓN:
AUTOR:
REQUERIMIENTO:
EMPRESA:
FECHA MODIFICACIÓN:
********************************************************************/
ALTER PROCEDURE 
	 [dbo].[PR_SGS_Rpt_FacturacionCADI] 
	 
         @FechaInicio DATETIME
		,@FechaFin DATETIME

AS
BEGIN

SELECT 


 PR.PrimerApellido + ' ' + isNull(PR.SegundoApellido,'') + ' ' + PR.PrimerNombre + ' ' + isNull(PR.SegundoNombre,'')  AS NombrePaciente
,CR.Nombre AS Curso
,EST.CodigoEstudiante AS Código
,COUNT (*) As Programdas
,SUM (IIF (NVM.Checkbox1 IS NULL, 1 , 1- NVM.Checkbox1)) AS Asistencias
,SUM (IIF (NVM.Checkbox6 IS NULL OR NVM.Checkbox6 = 0 , 1, 0 ))  As SesionesFacturar
,SUM (IIF (NVM.Checkbox6 IS NULL OR NVM.Checkbox6 = 0 , CONVERT (INT, DOM.Descripcion), 0)) AS ValorAFacturar


FROM NovedadMedica  AS NVM
INNER JOIN PersonaNovedadMedica AS PNM 
ON NVM.IdNovedadMedica = PNM.IdNovedadMedica

INNER JOIN Persona AS PR
ON PNM.TipoIdentificacionPersona = PR.TipoIdentificacion 
AND PNM.NumeroIdentificacionPersona = PR.NumeroIdentificacion 

INNER JOIN ESTUDIANTE AS EST
ON EST.TipoIdentificacion = PNM.TipoIdentificacionPersona
AND EST.NumeroIdentificacion = PNM.NumeroIdentificacionPersona

INNER JOIN EstudianteCurso AS ES 
ON PNM.TipoIdentificacionPersona = ES.TipoIdentificacionEstudiante
AND PNM.NumeroIdentificacionPersona = ES.NumeroIdentificacionEstudiante
AND ES.Estado <> 'Retirado'

INNER JOIN Curso as CR
ON ES.IdCurso = CR.IdCurso 

INNER JOIN PeriodoLectivo AS PL
ON CR.AnioAcademico = PL.ID
AND PL.AnioActivo = '1'

INNER JOIN TipoNovedadMedica AS TNM 
ON NVM.IdTipoNovedad = TNM.IdTipoNovedadMedica

INNER JOIN TipoNovedadMedicaPestania AS TNMP
ON TNM.IdTipoNovedadMedica = TNMP.IdTipoNovedadMedica

INNER JOIN DOMINIO DOM 
	ON NVM.ValorDominio = DOM.Valor
	AND DOM.Dominio = 'TarifaCADI'

WHERE 
	TNMP.IdPestaniaDashboard =  9 AND TNMP.IdTipoNovedadMedica in ('37','40') 
	AND NVM.Fecha1 BETWEEN @FechaInicio AND @FechaFin

GROUP BY 
	EST.CodigoEstudiante
   ,PR.PrimerApellido + ' ' + isNull(PR.SegundoApellido,'') + ' ' + PR.PrimerNombre + ' ' + isNull(PR.SegundoNombre,'')
   ,CR.Nombre

END
GO


