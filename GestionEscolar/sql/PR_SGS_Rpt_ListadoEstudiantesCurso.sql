/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_ListadoEstudiantesCurso.sql
DESCRIPCIÓN:			Esta consulta sirve para traer todos los estudiantes 
						de un curso que se encuentren estado Activo o Asignado 
						y que se encuentren con Matricula igual 1
PARAMETROS:				PeriodoLectivo + Seccion + Nivel
RESULTADO:				Listado con las siguientes columnas: 
						Seccion 1: Nombre (Apellido + Nombre), Observaciones, Estado
CREACIÓN:				
REQUERIMIENTO:			
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2017-05-22
----------------------------------------------------------------------------
MODIFICACIÓN:			Mostrar en la sección de pendientes los estudiantes del 
						mismo nivel. Se agargea variable @NV2 y se pone la condición
						para que muestre los pendiente del mismo nivel y se agrega 
						un In where en el where del segundo caso.
FECHA MODIFICACIÓN:		08 de Junio de 2017
AUTOR:					John Alberto López Hernández
----------------------------------------------------------------------------
MODIFICACIÓN:			Se separa el reporte Listado Estudiantes en dos y se genera un 
						reporte llamado ListadoPreliminarEstudiantesCurso,
						a este reporte de eliminar el calculo del registro del 
						años anterior del estudiantes.
FECHA MODIFICACIÓN:		04 de Julio de 2017
AUTOR:					John Alberto López Hernández
----------------------------------------------------------------------------
MODIFICACIÓN:			Se agrega order by por Apellidos y Nombres
FECHA MODIFICACIÓN:		30 de Agosto de 2017
AUTOR:					John Alberto López Hernández
****************************************************************************/
ALTER  PROCEDURE 

	 [dbo].[PR_SGS_Rpt_ListadoEstudiantesCurso]
	  		
			 @idP_Seccion VARCHAR(60)
			,@idP_Nivel VARCHAR(60) 
			,@idP_Curso VARCHAR (60)
AS 
BEGIN
/* Tabla Temporal para filtrar por curso */
DECLARE @Cursos TABLE 
	(
		IdCursoSeleccionado varchar(60)

	)
INSERT INTO @Cursos
SELECT CR.Valor 
FROM F_SGS_Split(@idP_Curso, ',') AS CR
/* Consulta Principal */
SELECT
	 CR.Nombre  AS NombreCurso
	,PR.PrimerApellido +' '+ isNull(PR.SegundoApellido,'') + ' ' + PR.PrimerNombre + ' '+ isNull(PR.SegundoNombre,'') AS NombreEstudiante
	,PL.Descripcion AS PeriodoLectivo
	,CR.IdCurso AS Id_Curso
	,NV.IdNivel AS Id_Nivel
	,NV.Nombre AS NombreNivel
	,ESC.Estado AS Estado
	,DIR.PrimerNombre + ' '+ isNull(DIR.SegundoNombre,'') + ' ' + DIR.PrimerApellido +' '+ isNull(DIR.SegundoApellido,'') AS DirectorGrupo
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

	/* Join con tabla Temporal Cursos*/
	INNER JOIN @Cursos AS CURS
	ON CR.IdCurso = CURS.IdCursoSeleccionado

WHERE 
	ESC.Estado in ('Asignado', 'Activo')
	AND EST.Matricula = 1

ORDER BY 
	 PR.PrimerApellido ASC 
	,PR.SegundoApellido ASC
	,PR.PrimerNombre ASC
	,PR.SegundoNombre ASC

END 