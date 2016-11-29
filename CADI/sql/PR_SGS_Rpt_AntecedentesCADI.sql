USE [SGS]
GO
/****** Object:  StoredProcedure [dbo].[PR_SGS_Rpt_AntecedentesCADI]    Script Date: 22/11/2016 8:41:40 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:				dbo.PR_SGS_Rpt_AntecedentesCADI.sql
DESCRPCIÓN:			Creación Strored Procedures "Informe Antecedentes CADI"
AUTOR:				John Alberto López Hernández
REQUERIMIENTO:		SP40 - Transporte
EMPRESA:			Colegio San Jorge de Inglaterra
FECHA CREACIÓN:		11/11/2016
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
	 [dbo].[PR_SGS_Rpt_AntecedentesCADI] 
	 
		 @TipoIdentificacion VARCHAR(30) = 'NUIP'
		,@NumeroIdentificacion VARCHAR (30) = '1014881130'
AS
BEGIN


SELECT 

*
FROM NovedadMedica  AS NVM
INNER JOIN PersonaNovedadMedica AS PNM 
ON NVM.IdNovedadMedica = PNM.IdNovedadMedica

INNER JOIN Persona AS PR
ON PNM.TipoIdentificacionPersona = PR.TipoIdentificacion 
AND PNM.NumeroIdentificacionPersona = PR.NumeroIdentificacion

INNER JOIN EstudianteCurso AS ES 
ON PNM.TipoIdentificacionPersona = ES.TipoIdentificacionEstudiante
AND PNM.NumeroIdentificacionPersona = ES.NumeroIdentificacionEstudiante
AND ES.Estado <> 'Retirado'

INNER JOIN Curso as CR
ON ES.IdCurso = CR.IdCurso 

INNER JOIN Nivel as NV
ON CR.IdNivel = NV.IdNivel

INNER JOIN Seccion AS SE
ON NV.IdSeccion = SE.IdSeccion

INNER JOIN PeriodoLectivo AS PL
ON CR.AnioAcademico = PL.ID
AND PL.AnioActivo = '1'

INNER JOIN TipoNovedadMedica AS TNM 
ON NVM.IdTipoNovedad = TNM.IdTipoNovedadMedica

INNER JOIN TipoNovedadMedicaPestania AS TNMP
ON TNM.IdTipoNovedadMedica = TNMP.IdTipoNovedadMedica

INNER JOIN Usuario AS USR
ON NvM.UsuarioLog = USR.mail

LEFT JOIN CALENDARIO AS CAL 
ON NVM.FECHA1=CAL.FECHA

LEFT JOIN TipoHorario AS TH
	ON TH.IdTipoHorario = CASE 
					WHEN SE.IdSeccion = 1 THEN CAL.TipoHorarioPreescolar 
					WHEN SE.IdSeccion = 2 THEN CAL.TipoHorarioPrimaria
					WHEN SE.IdSeccion = 3 THEN CAL.TipoHorarioBachillerato
				END 
	AND  CONVERT(VARCHAR(50),TH.NumeroHora)= NVM.CampoTexto4

LEFT JOIN Horario AS HO
	ON TH.NumeroHora = HO.Hora 
	AND HO.IdCurso = CR.IdCurso 
	AND HO.Dia = cal.NumeroDia

LEFT JOIN Materia AS MAT
	ON HO.IdMateria = MAT.Id

INNER JOIN DOMINIO DOM 
	ON NVM.ValorDominio = DOM.Valor


WHERE 
	TNM.IdTipoNovedadMedica in(33,34,35,36)
	AND PNM.TipoIdentificacionPersona = @TipoIdentificacion
	AND PNM.NumeroIdentificacionPersona = @NumeroIdentificacion

ORDER BY TNM.IdTipoNovedadMedica asc
END

