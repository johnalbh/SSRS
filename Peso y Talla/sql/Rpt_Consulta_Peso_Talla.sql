USE [SGS]
GO
/****** Object:  StoredProcedure [dbo].[PR_SGS_Rpt_PerfilTalla]   . ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************************************        
NOMBRE DEL PROGRAMA:	[dbo].[PR_SGS_Rpt_SesionesGrupoEstudiantesSemana]        
DESCRIPCIÓN:			Devuelve un listado de todas los registros de peso y talla que tiene un estudiante en un periodo lectivo.
PARÁMETROS DE ENTRADA: 	
PARÁMETROS DE SALIDA:   No aplica.  
RESULTADO:						
CÓDIGOS DE ERROR:		No existen códigos de excepción Personalizados.  


************************************************************************/
ALTER PROCEDURE  [dbo].[PR_SGS_Rpt_GraficasPerfilTalla] 

	 @idp_PeriodoLectivo VARCHAR (50)
	,@idP_Toma INT
	,@idP_Seccion INT
	,@idP_Nivel INT
	,@idP_Curso INT

AS
BEGIN

DECLARE @Cursos TABLE 
	(
		IdCursoSeleccionado varchar(60)
	)
DECLARE @Temporal TABLE 
(
	 Genero  VARCHAR(40)
	,TipoTalla VARCHAR (20)
)

IF @idP_Curso  <> 0
	INSERT INTO @Cursos SELECT @idP_Curso 

ELSE IF @idP_Nivel <> 0
	INSERT INTO @Cursos SELECT 
	 idCurso as CursouiQ
	FROM Curso WHERE AnioAcademico = @idp_PeriodoLectivo and idNivel = @idP_Nivel

ELSE IF @idP_Seccion <> 0 
		
	INSERT INTO @Cursos SELECT 
	 idCurso as Curso
	FROM Curso AS CR

	INNER JOIN Nivel AS NV ON
	CR.IdNivel = NV.IdNivel
	
	INNER JOIN SECCION AS SEC ON 
	NV.IdSeccion = SEC.IdSeccion
		
	WHERE CR.AnioAcademico = @idp_PeriodoLectivo and NV.IdSeccion = @idP_Seccion

ELSE 
	INSERT INTO @Cursos SELECT 
	 idCurso as Curso
	FROM Curso AS CR

	WHERE CR.AnioAcademico = @idp_PeriodoLectivo

INSERT INTO @Temporal

SELECT  
	 PR.GENERO As Genero
	,ESPT.TipoTalla AS TipoTalla
FROM ESTUDIANTEPESOTALLA AS ESPT

	INNER JOIN PeriodoLectivo AS PL
	ON ESPT.IdAnioAcademico = PL.Id

	INNER JOIN CURSO AS CR
	ON ESPT.IdAnioAcademico = CR.AnioAcademico

	INNER JOIN ESTUDIANTECURSO AS ESC
	ON ESPT.TipoIdentificacion = ESC.TipoIdentificacionEstudiante 
	AND ESPT. NumeroIdentificacion = ESC.NumeroIdentificacionEstudiante
	AND ESC.IdCurso = CR.IdCurso

	INNER JOIN PERSONA AS PR 
	ON ESPT.TipoIdentificacion = PR.TipoIdentificacion
	AND ESPT.NumeroIdentificacion = PR.NumeroIdentificacion

	INNER JOIN DOMINIO AS D 
	ON D.DOMINIO = 'TallaDesviacion' 
	AND D.VALOR = ESPT.TIPOTALLA

	INNER JOIN DOMINIO AS DCOM
	ON DCOM.DOMINIO = 'TallaComentario'
	AND DCOM.VALOR = ESPT.TIPOTALLA

	INNER JOIN @Cursos AS CURS
	ON CR.IdCurso = CURS.IdCursoSeleccionado

WHERE 
    PL.Id = @idp_PeriodoLectivo
	AND ESPT.IdToma = (@idP_Toma) OR @idP_Toma IS NULL

SELECT 
	 VTL.Genero
	,VTL.DescripcionGenero AS Generos
	,VTL.TallaComentario
	,VTL.ComentarioDescripcion
	,VTL.RangoDesviacion
	,VTL.Criterio
	,(Select Count (*) FROM @Temporal as Tmp where Tmp.Genero = VTL.Genero and Tmp.TipoTalla = VTL.TallaComentario) AS Cantidad

FROM VW_TallaGeneroDesviaciones AS VTL

GROUP BY 
	 VTL.Genero
	,VTL.DescripcionGenero
	,VTL.TallaComentario
	,VTL.ComentarioDescripcion
	,VTL.RangoDesviacion
	,VTL.Criterio

ORDER BY 
	 VTL.GENERO ASC
	,VTL.Criterio ASC
	,VTL.TallaComentario ASC 
	,VTL.ComentarioDescripcion ASC 
	,VTL.RangoDesviacion ASC

END


