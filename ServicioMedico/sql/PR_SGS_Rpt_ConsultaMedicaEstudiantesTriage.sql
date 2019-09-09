SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:				dbo.PR_SGS_Rpt_ConsultaMedicaEstudiantesTriage.sql
DESCRPCIÓN:			Creación Strored Procedures "Registro Consulta Medica Estudiantes Clasificao
					por Triage"
					Se seleccionan unos parametros de entradas que son fecha inicio y fecha fin
					que el rango a consultar y triage.
AUTOR:				John Alberto López Hernández
REQUERIMIENTO:		Servicio Médico - Calidad 
EMPRESA:			Colegio San Jorge de Inglaterra
FECHA CREACIÓN:		28/06/2017
PARÁMETROS ENTRADA:	@FechaInicio, @FechaFin, @P_Triage
EXCEPCIONES:		No Aplica
---------------------------------------------------------------------

********************************************************************/
CREATE PROCEDURE 
	 [dbo].[PR_SGS_Rpt_ConsultaMedicaEstudiantesTriage] 
		 @pFechaInicio as DateTime
		,@pFechaFin as  DateTime
		,@P_Triage VARCHAR (1000)
AS
BEGIN
DECLARE @clasificacionTriage TABLE 
	(
		 triageSeleccionado VARCHAR(1000)
	)
INSERT INTO @clasificacionTriage
SELECT TR.Valor 
FROM F_SGS_Split(@P_Triage, ',') AS TR

DECLARE 
        @FechaInicio AS Date = Convert( Date, @pFechaInicio)
       ,@FechaFin AS Date = Convert( Date, @pFechaFin)
SELECT 

	 PR.PrimerApellido + ' ' + isNull(PR.SegundoApellido,'') + ' ' + PR.PrimerNombre + ' ' + isNull(PR.SegundoNombre,'') AS NombreEstudiante
	,CR.IdCurso AS IdCurso
    ,CR.Nombre	AS Curso            
	,EVL.ClasificacionTriage AS Triage
	  
FROM ESTUDIANTE AS EST

	INNER JOIN EVOLUCION AS EVL
	ON EST.TIPOIDENTIFICACION = EVL.TIPOIDENTIFICACION 
	AND EST.NUMEROIDENTIFICACION = EVL.NUMEROIDENTIFICACION 

	INNER JOIN PERSONA AS PR
	ON  EST.TIPOIDENTIFICACION = PR.TIPOIDENTIFICACION 
	AND EST.NUMEROIDENTIFICACION = PR.NUMEROIDENTIFICACION 

	INNER JOIN ESTUDIANTECURSO AS ESC 
	ON EST.TIPOIDENTIFICACION = ESC.TIPOIDENTIFICACIONESTUDIANTE
	AND EST.NUMEROIDENTIFICACION = ESC.NUMEROIDENTIFICACIONESTUDIANTE

	INNER JOIN CURSO AS CR
	ON ESC.IdCurso = CR.IdCurso

	INNER JOIN NIVEL AS NVL
	ON CR.IdNivel = NVL.IdNivel

	INNER JOIN SECCION AS SCC
	ON NVL.IdSeccion = SCC.IdSeccion

	INNER JOIN PERIODOLECTIVO AS PL
	ON PL.FechaInicioPeriodo <= EVL.FechaIngreso AND EVL.FechaIngreso <= PL.FechaFinPeriodo  and
	CR.AnioAcademico = PL.Id
		
	INNER JOIN @clasificacionTriage AS TRI
	ON EVL.ClasificacionTriage = TRI.triageSeleccionado
       
WHERE 
	EVL.FechaIngreso BETWEEN @FechaInicio AND @FechaFin        

ORDER BY 
	 EVL.ClasificacionTriage ASC
	,CR.IdCurso ASC
	,PR.PrimerApellido ASC
END
GO