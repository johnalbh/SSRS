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
CREATE PROCEDURE 
	 [dbo].[PR_SGS_Rpt_FacturacionCADI] 
	 
		 @TipoIdentificacion VARCHAR(30)
		,@NumeroIdentificacion VARCHAR (30) 
		,@FechaInicio DATETIME
		,@FechaFin DATETIME
		,@Especialidad VARCHAR (30)
AS
BEGIN
DECLARE @Especialidades TABLE 
	(
		IdEspecialidad VARCHAR(60)
	)
INSERT INTO @Especialidades

SELECT ES.Valor AS Especialidad
FROM F_SGS_Split(@Especialidad, ',') AS ES


SELECT 

CONVERT (VARCHAR(10),NVM.Fecha1,110) AS FechaSesion
,PR.PrimerApellido + ' ' + isNull(PR.SegundoApellido,'') + ' ' + PR.PrimerNombre + ' ' + isNull(PR.SegundoNombre,'')  AS NombrePaciente
,[dbo].[F_SGS_CalcularEdadAniosMeses] (PR.FechaNacimiento) AS Edad
,NVM.NombreNovedad AS NombreNovedad
,TNM.Nombre	AS NombreTipoNovedad
,NVM.ValorDominio AS Especialidad
,NVM.Descripcion AS Descripcion
,CR.Nombre AS Curso
,MAT.Nombre AS Materia 

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
	TNMP.IdPestaniaDashboard =  9 AND TN
	AND PNM.TipoIdentificacionPersona = @TipoIdentificacion
	AND PNM.NumeroIdentificacionPersona = @NumeroIdentificacion
	AND NVM.Fecha1 BETWEEN @FechaInicio AND @FechaFin
	AND NVM.ValorDominio = @Especialidad

END
GO


SELECT * FROM NOVEDADMEDICA
SELECT * FROM TipoNovedadMedicaPestania
SELECT * FROM Dominio

EspecialidadCADI	Fono
EspecialidadCADI	Psico
EspecialidadCADI	TO

TarifaCADI	'Fono'
TarifaCADI	'Psico'
TarifaCADI	'To'

SELECT 