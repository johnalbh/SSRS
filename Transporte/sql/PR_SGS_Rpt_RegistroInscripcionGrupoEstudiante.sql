SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_RegistroInscripcionGrupoEstudiante.sql
DESCRIPCIÓN:			Muestra los Grupos a los que esta inscrito un estudiante.
						Reportes de Estudiantes Inscritos a Grupos por Día   
						Devuelve un listado de todos los grupos en los que está inscrito un estudiante en una fecha dada.
PARÁMETROS DE ENTRADA:  @dP_Fecha: Fecha de la consulta 
PARÁMETROS DE SALIDA:   No aplica.  
RESULTADO:				Listado con las siguientes columnas: 
						Seccion, Nivel, Curso, Apellidos, Nombres, Grupo, FechaInicio, FechaFin, Profesor,Inactivo 
						(* si el estudiante está inactivo, vacío si está activo).
						La consulta se entrega ordenada alfabéticamente por apellidos y nombres del estudiante y por nombre del grupo	
CREACIÓN 
REQUERIMIENTO:			Reportes de Transporte
AUTOR:					LLamprea
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2016-08-27
----------------------------------------------------------------------------
****************************************************************************/
ALTER PROCEDURE [dbo].[PR_SGS_Rpt_RegistroInscripcionGrupoEstudiante]

	  
		 @dp_Fecha DATE		
		,@Seccion INT
		,@Nivel VARCHAR(60)
		,@Curso VARCHAR (60)

AS
BEGIN
DECLARE @Cursos TABLE
	(
		IdCursoSeleccionado varchar(60)
	)
INSERT INTO @Cursos
SELECT CR.Valor
FROM F_SGS_Split(@Curso, ',') AS CR

SELECT
	  P.PrimerApellido + ' ' + isnull (P.SegundoApellido, '') AS Apellidos
	, P.PrimerNombre + ' ' + isnull (P.SegundoNombre, '') AS Nombres
	, S.Nombre AS Seccion
	, N.Nombre AS Nivel
	, C.Nombre AS Curso
	, G.Nombre AS Grupo
	, CONVERT(varchar(15),CAST(G.FechaInicio AS DATE),100)  AS FechaInicio
	, CONVERT(varchar(15),CAST(G.FechaFin AS DATE),100)  AS FechaFin
	, PROF.PrimerApellido + ' ' + isnull (PROF.PrimerNombre, '') + ' ' + isnull (PROF.SegundoNombre, '') AS Profesor
	, IIF (GE.EstudianteActivo = 1, '','*') AS Inactivo
/********************************************************************
Consulta de todos los Estudiantes del año lectivo actual con su información de ubicación
********************************************************************/
FROM 
	Estudiante AS E
INNER JOIN Persona P ON 
	E.NumeroIdentificacion = P.NumeroIdentificacion
INNER JOIN EstudianteCurso AS EC 
	ON EC.NumeroIdentificacionEstudiante = E.NumeroIdentificacion
INNER JOIN Curso AS C ON 
	EC.idCurso = C.idCurso
INNER JOIN PeriodoLectivo AS PL ON 
	PL.Id = C.AnioAcademico 
	AND PL.AnioActivo = 1 
	AND C.AnioAcademico = PL.id
INNER JOIN Nivel AS N ON 
	N.IdNivel = C.IdNivel
INNER JOIN Seccion AS S ON 
	S.IdSeccion = N.IdSeccion
    
/********************************************************************
Consulta de los grupos en los que está el estudiante
********************************************************************/
INNER JOIN GrupoEstudiante AS GE ON 
	GE.NumeroIdentificacionEstudiante = E.NumeroIdentificacion
/********************************************************************
Filtro de los grupos que están vigentes en @dP_Fecha
********************************************************************/
INNER JOIN Grupo G ON 
	G.ID = GE.IdGrupo 
	AND G.FechaInicio <= @dP_Fecha 
	AND G.FechaFin >= @dP_Fecha 
/********************************************************************
Consulta del nombre del profesor responsable del grupo
********************************************************************/
INNER JOIN Persona PROF ON 
	PROF.NumeroIdentificacion = G.NumeroIdentificacionEmpleado


INNER JOIN @Cursos AS CURS
	ON C.IdCurso = CURS.IdCursoSeleccionado


ORDER BY 
	  P.PrimerApellido
	, P.SegundoApellido
	, P.PrimerNombre
	, P.SegundoNombre
	, G.Nombre

END
GO
