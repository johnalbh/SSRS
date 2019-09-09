SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************************************        
NOMBRE DEL PROGRAMA:	[dbo].[PR_SGS_Rpt_SesionesGrupoEstudiantesSemana]        
DESCRIPCIÓN:			Devuelve un listado de todas las sesiones que tiene un estudiante una semana dada.
						Retorna curso, Apellidos y nombres del estudiante, y los nombres de los grupos en columnas para cada uno de los días de la semana (Lu a Sa)
PARÁMETROS DE ENTRADA: 	@dP_Fecha: Fecha. Corresponde a un día cualquiera de la semana que se consulta. La semana va de domingo a Sábado
PARÁMETROS DE SALIDA:   No aplica.  
RESULTADO:				Listado con las siguientes columnas: 
						Curso, Apellidos, Nombres,Lunes,Martes,Miercoles,Jueves,Viernes,Sabado
						La consulta se entrega ordenada por curso y luego alfabéticamente por apellidos y nombres del estudiante			
CÓDIGOS DE ERROR:		No existen códigos de excepción Personalizados.  
-------------------------------------------------------------------------  
MODIFICACIÓN:
REQUERIMIENTO:			Reportes de Transporte
AUTOR:					LLamprea
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2016-08-27
-------------------------------------------------------------------------
REQUERIMIENTO:			Inserción de parametros Sección, Nivel, Curso opcionales. 
MODIFICACIÓN:			Se hace la inserción de parametros Sección, Nivel, Curso opcionales
						añadiendo, parametros multivalues con selección de todos los elementos 
						por default.
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2016-11-30
-------------------------------------------------------------------------
************************************************************************/
CREATE PROCEDURE  [dbo].[PR_SGS_Rpt_SesionesGrupoEstudiantesSemana] 

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

/********************************************************************
Busca el lunes de la semana seleccionada. La semana comienza en Domingo
********************************************************************/
DECLARE @d_Lunes DATE = DATEADD (d , 2 - DATEpart(weekday, @dP_Fecha)  , @dP_Fecha );

/********************************************************************
Consulta todos los estudiantes del año activo con su curso
********************************************************************/
SELECT 
	  C.Nombre AS Curso
	, P.PrimerApellido + ' ' + isnull (P.SegundoApellido, '') AS Apellidos
	, P.PrimerNombre + ' ' + isnull (P.SegundoNombre, '') AS Nombres
/********************************************************************
Concatena todos los grupos con sesión el lunes
********************************************************************/
, isnull (STUFF(
         (SELECT DISTINCT ', ' + nombre
       	  FROM Grupo AS G2 WITH(NOLOCK)
			INNER JOIN Sesion AS S2 WITH(NOLOCK) ON 
					G2.ID = S2.IdGrupo 
				AND S2.Fecha = @d_Lunes 
			INNER JOIN dbo.GrupoEstudiante AS GE WITH(NOLOCK) ON 
				GE.IdGrupo = G2.Id 
          WHERE 
				GE.numeroidentificacionestudiante = E.NumeroIdentificacion 
			AND GE.TipoIdentificacionEstudiante = E.TipoIdentificacion
          FOR XML PATH (''))
          , 1, 1, ''),'')  AS Lunes
/********************************************************************
Concatena todos los grupos con sesión el martes
********************************************************************/
, isnull (STUFF(
         (SELECT DISTINCT ', ' + nombre
       	  FROM Grupo AS G2 WITH(NOLOCK)
			INNER JOIN Sesion AS S2 WITH(NOLOCK) ON 
				G2.ID = S2.IdGrupo 
			AND S2.Fecha = DATEADD (d , 1 , @d_Lunes ) 
		INNER JOIN dbo.GrupoEstudiante AS GE WITH(NOLOCK) ON 
				GE.IdGrupo = G2.Id 
          WHERE 
				GE.numeroidentificacionestudiante = E.NumeroIdentificacion 
			AND GE.TipoIdentificacionEstudiante = E.TipoIdentificacion
          FOR XML PATH (''))
          , 1, 1, ''),'')  AS Martes
/********************************************************************
Concatena todos los grupos con sesión el miercoles
********************************************************************/
, isnull (STUFF(
         (SELECT DISTINCT ', ' + nombre
       	  FROM Grupo AS G2 WITH(NOLOCK)
			INNER JOIN Sesion AS S2 WITH(NOLOCK) ON 
				G2.ID = S2.IdGrupo 
			AND S2.Fecha = DATEADD (d , 2 , @d_Lunes ) 
			INNER JOIN dbo.GrupoEstudiante AS GE WITH(NOLOCK) ON 
				GE.IdGrupo = G2.Id 
          WHERE 
				GE.numeroidentificacionestudiante = E.NumeroIdentificacion 
			AND GE.TipoIdentificacionEstudiante = E.TipoIdentificacion
          FOR XML PATH (''))
          , 1, 1, ''),'')  AS Miercoles
/********************************************************************
Concatena todos los grupos con sesión el jueves
********************************************************************/
, isnull (STUFF(
         (SELECT DISTINCT ', ' + nombre
       	  FROM Grupo AS G2 WITH(NOLOCK)
			INNER JOIN Sesion AS S2 WITH(NOLOCK) ON 
					G2.ID = S2.IdGrupo 
				AND S2.Fecha = DATEADD (d , 3 , @d_Lunes ) 
			INNER JOIN dbo.GrupoEstudiante AS GE WITH(NOLOCK) ON 
				GE.IdGrupo = G2.Id 
          WHERE 
				GE.numeroidentificacionestudiante = E.NumeroIdentificacion 
			AND GE.TipoIdentificacionEstudiante = E.TipoIdentificacion
          FOR XML PATH (''))
          , 1, 1, ''),'')  AS Jueves
/********************************************************************
Concatena todos los grupos con sesión el viernes
********************************************************************/
, isnull (STUFF(
         (SELECT DISTINCT ', ' + nombre
       	  FROM Grupo AS G2 WITH(NOLOCK)
			INNER JOIN Sesion AS S2 WITH(NOLOCK) ON 
					G2.ID = S2.IdGrupo 
				AND S2.Fecha = DATEADD (d , 4 , @d_Lunes ) 
			INNER JOIN dbo.GrupoEstudiante AS GE WITH(NOLOCK) ON 
				GE.IdGrupo = G2.Id 
          WHERE 
				GE.numeroidentificacionestudiante = E.NumeroIdentificacion 
			AND GE.TipoIdentificacionEstudiante = E.TipoIdentificacion
          FOR XML PATH (''))
          , 1, 1, ''),'')  AS Viernes
/********************************************************************
Concatena todos los grupos con sesión el sabado
********************************************************************/
, isnull (STUFF(
         (SELECT DISTINCT ', ' + nombre
       	  FROM Grupo AS G2 WITH(NOLOCK)
			INNER JOIN Sesion AS S2 WITH(NOLOCK) ON 
					G2.ID = S2.IdGrupo 
				AND S2.Fecha = DATEADD (d , 5 , @d_Lunes ) 
			INNER JOIN dbo.GrupoEstudiante AS GE WITH(NOLOCK) ON 
				GE.IdGrupo = G2.Id 
          WHERE 
				GE.numeroidentificacionestudiante = E.NumeroIdentificacion 
			AND GE.TipoIdentificacionEstudiante = E.TipoIdentificacion
          FOR XML PATH (''))
          , 1, 1, ''),'')  AS Sabado
FROM 

Estudiante AS E
	INNER JOIN dbo.Persona AS P WITH(NOLOCK) 
		ON 	E.TipoIdentificacion = P.TipoIdentificacion
		AND E.NumeroIdentificacion = P.NumeroIdentificacion 
		AND E.TipoIdentificacion = P.TipoIdentificacion
	INNER JOIN dbo.EstudianteCurso AS EC WITH(NOLOCK) 
		ON 	E.TipoIdentificacion = EC.TipoIdentificacionEstudiante
		AND E.NumeroIdentificacion = EC.NumeroIdentificacionEstudiante
	INNER JOIN dbo.Curso AS C WITH(NOLOCK) 
		ON  EC.IdCurso = C.IdCurso
	INNER JOIN @Cursos AS CURS
		ON C.IdCurso = CURS.IdCursoSeleccionado

GROUP BY  
	  C.idCurso
	, C.Nombre
	, C.Nombre
	, P.PrimerApellido + ' ' + isnull (P.SegundoApellido, '')
	, P.PrimerNombre + ' ' + isnull (P.SegundoNombre, '')
	, E.NumeroIdentificacion
	, E.TipoIdentificacion
ORDER BY 
	  C.idCurso
	, P.PrimerApellido + ' ' + isnull (P.SegundoApellido, '')
	, P.PrimerNombre + ' ' + isnull (P.SegundoNombre, '')

END
GO

