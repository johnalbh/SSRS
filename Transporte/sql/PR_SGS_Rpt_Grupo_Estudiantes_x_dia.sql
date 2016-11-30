SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************************************        
NOMBRE DEL PROGRAMA:	[dbo].[PR_SGS_Rpt_Grupo_Estudiantes_x_dia]        
DESCRIPCI�N:			Devuelve un listado de todas las sesiones que tiene un estudiante una semana dada.
						Retorna curso, Apellidos y nombres del estudiante, y los nombres de los grupos en columnas para cada uno de los d�as de la semana (Lu a Sa)
PAR�METROS DE ENTRADA: 	@dP_Fecha: Fecha. Corresponde a un d�a cualquiera de la semana que se consulta. La semana va de domingo a S�bado
PAR�METROS DE SALIDA:   No aplica.  
RESULTADO:				Listado con las siguientes columnas: 
						Curso, Apellidos, Nombres,Lunes,Martes,Miercoles,Jueves,Viernes,Sabado
						La consulta se entrega ordenada por curso y luego alfab�ticamente por apellidos y nombres del estudiante			
C�DIGOS DE ERROR:		No existen c�digos de excepci�n Personalizados.  
-------------------------------------------------------------------------  
MODIFICACI�N:
REQUERIMIENTO:			Reportes de Transporte
AUTOR:					LLamprea
EMPRESA:				Saint George�s School  
FECHA DE CREACI�N:		2016-08-27
-------------------------------------------------------------------------
MODIFICACI�N:			Inserci�n de parametro de Secci�n.
REQUERIMIENTO:			Inserci�n de parametro por secci�n para que sea m�s f�cil la organizaci�n.
AUTOR:					John Alberto L�pez Hern�ndez
EMPRESA:				Saint George�s School  
FECHA DE CREACI�N:		2016-11-30
-------------------------------------------------------------------------


************************************************************************/
ALTER PROCEDURE  [dbo].[PR_SGS_Rpt_Grupo_Estudiantes_x_dia] 

		 @dp_Fecha DATE		
		,@Seccion INT
		,@Nivel VARCHAR(60)
AS
BEGIN
DECLARE @Niveles TABLE 
	(
		IdNiveles varchar(60)
	)
INSERT INTO @Niveles

SELECT NIV.Valor AS Nivel
FROM F_SGS_Split(@Nivel, ',') AS NIV

/********************************************************************
Busca el lunes de la semana seleccionada. La semana comienza en Domingo
********************************************************************/
DECLARE @d_Lunes DATE = DATEADD (d , 2 - DATEpart(weekday, @dP_Fecha)  , @dP_Fecha );

/********************************************************************
Consulta todos los estudiantes del a�o activo con su curso
********************************************************************/
SELECT 
	  C.Nombre AS Curso
	, P.PrimerApellido + ' ' + isnull (P.SegundoApellido, '') AS Apellidos
	, P.PrimerNombre + ' ' + isnull (P.SegundoNombre, '') AS Nombres
/********************************************************************
Concatena todos los grupos con sesi�n el lunes
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
Concatena todos los grupos con sesi�n el martes
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
Concatena todos los grupos con sesi�n el miercoles
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
Concatena todos los grupos con sesi�n el jueves
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
Concatena todos los grupos con sesi�n el viernes
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
Concatena todos los grupos con sesi�n el sabado
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
	Estudiante E
INNER JOIN dbo.Persona AS P WITH(NOLOCK) ON 
		E.TipoIdentificacion = P.TipoIdentificacion
	AND E.NumeroIdentificacion = P.NumeroIdentificacion 
	AND E.TipoIdentificacion = P.TipoIdentificacion
INNER JOIN dbo.EstudianteCurso AS EC WITH(NOLOCK) ON 
		E.TipoIdentificacion = EC.TipoIdentificacionEstudiante
	AND E.NumeroIdentificacion = EC.NumeroIdentificacionEstudiante
INNER JOIN dbo.Curso AS C WITH(NOLOCK) ON 
	EC.IdCurso = C.IdCurso

INNER JOIN NIVEL AS NV WITH(NOLOCK)
ON C.IdNivel = NV.IdNivel 

INNER JOIN SECCION AS SEC WITH(NOLOCK)
ON NV.IdSeccion = sec.IdSeccion

INNER JOIN dbo.PeriodoLectivo AS PL WITH(NOLOCK) ON 
	C.AnioAcademico = PL.Id AND PL.AnioActivo = 1

INNER JOIN @Niveles AS NIVE
	ON NV.IdNivel = NIVE.IdNiveles

WHERE 
	
	SEC.IdSeccion = @Seccion

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
