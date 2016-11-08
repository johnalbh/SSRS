SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:				dbo.PR_SGS_Rpt_ConsultaAusenciasRefuerzos.sql
DESCRPCIÓN:			Creación Strored Procedures "Consulta Asistencia Refuerzos
AUTOR:				John Alberto López Hernández
REQUERIMIENTO:		SP39 - Gestión Escolar
EMPRESA:			Colegio San Jorge de Inglaterra
FECHA CREACIÓN:		20/10/2016
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
	 [dbo].[PR_SGS_Rpt_ConsultaAusenciasRefuerzos] 

	  @FechaInicio datetime
	 ,@FechaFin datetime
	 ,@TipoGrupo VARCHAR(500) = 13
	 ,@Seccion VARCHAR (100)
AS
BEGIN

SELECT 
	 CONVERT (VARCHAR(10),SES.Fecha,110) AS FechaSesion
	,GR.Nombre AS NombreGrupo
	,PR.PrimerApellido + ' ' + isNull(PR.SegundoApellido,'') + ' ' + PR.PrimerNombre + ' ' + isNull(PR.SegundoNombre,'')  AS NombreEstudiante
	,IIF (GES.Asistencia = 'True' , 'Si','No')  as Asistentcia
	,SE.Nombre AS Seccion
	,CR.Nombre AS Curso
	,isnull(STUFF(
         (SELECT '-' + ST.Observaciones
			FROM SolicitudTransporte AS ST 
			INNER JOIN FECHACAMBIOTRANSPORTE AS FCT ON
			ST.IdsolicitudTransporte = FCT.IdSolicitudTransporte 
			WHERE 
			    ST.TipoIdentSolicitante  = GE.TipoIdentificacionEstudiante
			AND ST.IdentificacionSolicitante = GE.NumeroIdentificacionEstudiante
			AND FCT.FechaSeleccionada = SES.Fecha
			AND ST.IdTipoSolicitudTransporte != TG.IdTipoSolicitudTransporte 
          FOR XML PATH (''))
          , 1, 1, ''),'')  AS SolicitudesTransporte
	,IIF (SES.SesionRealizada = 1, 'Si', 'No') as SesionRealizada
	,GES.Observacion AS Observaciones
	

FROM 

TIPOGRUPO AS TG

INNER JOIN  GRUPO AS GR 
ON TG.Id = GR.IdTipoGrupo

INNER  JOIN Sesion AS SES 
ON GR.Id = SES.IdGrupo 

INNER JOIN GrupoEstudianteSesion AS GES
ON GES.IdSesion = SES.Id
AND (GES.Asistencia IS NULL OR GES.Asistencia <> 1)

INNER JOIN GrupoEstudiante AS GE 
ON GES.IdGrupoEstudiante = GE.Id

INNER JOIN EstudianteCurso AS ES 
ON GE.TipoIdentificacionEstudiante = ES.TipoIdentificacionEstudiante
AND GE.NumeroIdentificacionEstudiante = ES.NumeroIdentificacionEstudiante
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

INNER JOIN PERSONA AS PR
ON  ES.TipoIdentificacionEstudiante = PR.TipoIdentificacion
AND ES.NumeroIdentificacionEstudiante = PR.NumeroIdentificacion

WHERE 

TG.ID = @TipoGrupo 
AND SES.Fecha BETWEEN @FechaInicio AND @FechaFin 
AND SE.IdSeccion = @Seccion

 ORDER BY
 SES.Fecha ASC 
,GR.Nombre ASC
,CR.IdCurso ASC

END 
GO

