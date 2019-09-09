/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_ConsolidadoEstudiantesNivel.sql
DESCRIPCIÓN:			Este SP muestra el total de estudiantes por nivel que
						Se encuentren en estado Activo o Asignado y con flat
						de matriculas con valor 1. Se agrupa por Nivel 
PARAMETROS:				Seccion + Nivel
RESULTADO:				Listado con las siguientes columnas: 
						Seccion: Nivel: TotalEstudiantes
CREACIÓN:				
REQUERIMIENTO:			
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2017-07-05

****************************************************************************/
CREATE PROCEDURE 

	 [dbo].[PR_SGS_Rpt_ConsolidadoEstudiantesNivel]
	  		
AS 
BEGIN
/* Tabla Temporal para filtrar por curso */

SELECT
	 CR.Nombre
	,COUNT(1) AS TotalRegistros
	,NV.IdNivel
	,NV.Nombre AS NombreNivel
	,SEC.IdSeccion
	,SEC.Nombre AS NombreSeccion
	,PL.Descripcion AS PeriodoLectivo

FROM EstudianteCurso AS ESC

	/* Curso del Estudiante */

	INNER JOIN Curso AS CR
	ON ESC.IdCurso = CR.IdCurso

	INNER JOIN PeriodoLectivo AS PL
	ON CR.AnioAcademico = PL.Id
	AND PL.AnioActivo = 1

	INNER JOIN Nivel AS NV
	ON CR.IdNivel = NV.IdNivel

	INNER JOIN Seccion AS SEC
	ON NV.IdSeccion = SEC.IdSeccion

	INNER JOIN Estudiante AS EST
	ON ESC.TipoIdentificacionEstudiante = EST.TipoIdentificacion
	AND ESC.NumeroIdentificacionEstudiante  = EST.NumeroIdentificacion

	INNER JOIN Persona AS PR
	ON ESC.TipoIdentificacionEstudiante = PR.TipoIdentificacion
	AND ESC.NumeroIdentificacionEstudiante = PR.NumeroIdentificacion

	LEFT JOIN Persona AS DIR
	ON CR.TipoDocumentoDirector = DIR.TipoIdentificacion
	AND CR.NumeroDocumentoDirector = DIR.NumeroIdentificacion

WHERE 
	ESC.Estado in ('Asignado', 'Activo')
	AND EST.Matricula = 1

GROUP BY	
	 CR.Nombre
	 ,NV.IdNivel
	 ,NV.Nombre
	 ,SEC.IdSeccion
	 ,SEC.Nombre
	 ,PL.Descripcion
END