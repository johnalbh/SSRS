USE [SGS]
GO
/****** Object:  StoredProcedure [dbo].[PR_SGS_Rpt_PromocionEstudiantes]    Script Date: 23/05/2017 1:40:51 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_PromocionEstudiantes.sql
DESCRIPCIÓN:			Se solicita crear un reporte que muestre el total de estudiantes un curso con tu estado final luego de la promoción.
RESULTADO:				Listado con las siguientes columnas: 
						Numeración de Estudiante, Curso, Apellidos y Nombres, Código, Estado, Habilitado
						(* si el estudiante está inactivo, vacío si está activo).
						La consulta se entrega ordenada alfabéticamente por apellidos y nombres del estudiante y por nombre del grupo	
CREACIÓN 
REQUERIMIENTO:			
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2017-05-19
----------------------------------------------------------------------------
MODIFICACIÓN:			Se hace ajuste para presente los estado de Dominio por Valor.
						Se adiciona el estado retirado con Marca R
****************************************************************************/
ALTER PROCEDURE 
	 [dbo].[PR_SGS_Rpt_PromocionEstudiantes] 
	
	
		 @idP_Seccion VARCHAR (60)
		,@idP_Nivel VARCHAR(60)
		,@idP_Curso VARCHAR (60)
		,@idP_PeriodoLectivo INT 
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

SELECT
	 CR.Nombre  AS Curso
	,PR.PrimerApellido +' '+ isNull(PR.SegundoApellido,'') + ' ' + PR.PrimerNombre + ' '+ isNull(PR.SegundoNombre,'') AS NombreEstudiante
	,EST.CodigoEstudiante AS CodigoEstudiante
	,ESC.Estado AS EstadoEstudiante
	,CASE WHEN ESC.Estado = 'Aprobado'     THEN 'X' ELSE  '' END AS Aprobado
	,CASE WHEN ESC.Estado = 'Pendiente'    THEN 'X' ELSE  '' END AS Pendiente
	,CASE WHEN ESC.Estado = 'Graduado'     THEN 'X' ELSE  '' END AS Graduado
	,CASE WHEN ESC.Estado = 'ReprobadoSi' THEN 'X' ELSE  '' END AS ReprobadoSi
	,CASE WHEN ESC.Estado = 'ReprobadoNo' THEN 'X' ELSE  '' END AS ReprobadoNo
	,CASE WHEN ESC.Estado = 'Retirado'    THEN 'R' ELSE  '' END AS Retirado

/* Estado */
FROM EstudianteCurso AS ESC

	INNER JOIN Estudiante AS EST 
	ON ESC.TipoIdentificacionEstudiante = EST.TipoIdentificacion
	AND ESC.NumeroIdentificacionEstudiante = EST.NumeroIdentificacion

	INNER JOIN Curso AS CR
	ON ESC.IdCurso = CR.IdCurso

	INNER JOIN Nivel AS NV
	ON CR.IdNivel = NV.IdNivel

	INNER JOIN Seccion AS SEC
	ON NV.IdSeccion = SEC.IdSeccion
	
	INNER JOIN Persona AS PR
	ON ESC.TipoIdentificacionEstudiante = PR.TipoIdentificacion
	AND ESC.NumeroIdentificacionEstudiante = PR.NumeroIdentificacion

	INNER JOIN @Cursos AS CURS
	ON CR.IdCurso = CURS.IdCursoSeleccionado

WHERE 
	CR.AnioAcademico = @idP_PeriodoLectivo

ORDER BY 
	 CR.IdCurso ASC
	,PR.PrimerApellido

END 