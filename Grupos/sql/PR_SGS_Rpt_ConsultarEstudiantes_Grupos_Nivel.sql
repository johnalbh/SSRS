/*********************************************************************************
NOMBRE:					dbo.PR_SGS_RPT_ConsultarEstudiantes.sql
DESCRIPCIÓN:			Procedimiento almacenado que permite consultar los estudiantes
						de acuerdo a parámetros de entrada por usuario y rol, para los reportes que lo requieran.
PARÁMETROS DE ENTRADA:	 @sP_AnioAcademico INT 
						,@sP_Codigo BIGINT = NULL
						,@sP_Nombre varchar(350)= NULL
						,@sP_Estado nvarchar(50) = NULL
						,@sP_Nivel INT = NULL
						,@sP_Curso INT = NULL
						,@sP_Casa nvarchar(50)= NULL
						,@sP_Usuario VARCHAR(200)
						,@sP_Rol INT
PARÁMETROS DE SALIDA:	No Aplica
EXCEPCIONES:			No Aplica
AUTOR:					Héctor Arias
REQUERIMIENTO:			Consulta filtrada de estudiantes
EMPRESA:				Colegio San Jorge de Inglaterra
FECHA CREACIÓN:			13-12-2018
----------------------------------------------------------------------------------
*********************************************************************************/

ALTER PROCEDURE [dbo].[PR_SGS_Rpt_ConsultarEstudiantes_RolNivel] 
(
	 @sP_Usuario VARCHAR(200) = NULL
	,@sP_TipoRol VARCHAR(12) = NULL
	,@Seccion VARCHAR(500) = NULL

) AS BEGIN
	/* Sacarlas Secciones Habilitadas */
	  DECLARE @Secciones TABLE(IdSeccion VARCHAR(MAX));
	  INSERT INTO @Secciones
      SELECT SEC.Valor
      FROM F_SGS_Split(@Seccion, ',') AS SEC;

	/****************************************************************************
	DECLARACIÓN DE VARIABLES GLOBALES
	****************************************************************************/
	DECLARE  @TipoIdentificacionUsuario VARCHAR(30)
			,@NumeroIdentificacionUsuario VARCHAR(50)
			,@TipoRolVIP VARCHAR(10) = 'VIP'
			,@TipoRolPadre VARCHAR(10) = 'PAD'
			,@TipoRolEstudiante VARCHAR(10) = 'EST'
			,@TipoRolDirector VARCHAR(10) = 'DIR'
			,@TipoRolCoordinador VARCHAR(10) = 'COO'
			,@TipoRolDocente VARCHAR(10) = 'DOC'
			,@TipoRolNinguno VARCHAR(10) = 'NAN'
			,@TipoRolUsuario VARCHAR(10)
			,@iP_AnioAcademico INT;
	/****************************************************************************
	--ASIGNACIÓN DE VALORES A LAS VARIABLES
	****************************************************************************/
	SELECT @iP_AnioAcademico = (SELECT PE.Id FROM dbo.PeriodoLectivo AS PE WHERE PE.AnioActivo = 1);

	SELECT
		 @TipoIdentificacionUsuario = P.TipoIdentificacion
		,@NumeroIdentificacionUsuario = P.NumeroIdentificacion
	FROM dbo.Usuario AS U WITH(NOLOCK)
	INNER JOIN dbo.Persona AS P WITH(NOLOCK)
		ON U.UserPrincipalName = P.Username
	WHERE U.userPrincipalName = @sP_Usuario;

	SELECT 
		@TipoRolUsuario = @sP_TipoRol

	IF (@TipoRolUsuario = @TipoRolVIP)
	BEGIN

	SELECT
				NV.IdNivel AS IdNivel,
				NV.Nombre AS NombreNivel
			
		FROM Nivel AS NV
		INNER JOIN Seccion AS SEC ON
		NV.IdSeccion = SEC.IdSeccion
		INNER JOIN @Secciones AS TSEC ON NV.IdSeccion = TSEC.IdSeccion

	END
	IF (@TipoRolUsuario = @TipoRolCoordinador)
	BEGIN
		
		SELECT 
				NV.IdNivel AS IdNivel,
				NV.Nombre AS NombreNivel
		FROM Nivel AS NV 
		INNER JOIN Seccion AS SEC ON 
			NV.IdSeccion = SEC.IdSeccion
		INNER JOIN EmpleadoSeccion AS ES ON
			ES.IdSeccion = SEC.IdSeccion
		AND ES.TipoIdentificacionEmpleado = @TipoIdentificacionUsuario
		AND ES.NumeroIdentificacionEmpleado = @NumeroIdentificacionUsuario
		
	END

	IF (@TipoRolUsuario = @TipoRolDirector)	
	BEGIN
		SELECT 
			NV.IdNivel AS IdNivel,
			NV.Nombre AS NombreNivel
		FROM Curso AS CR
		INNER JOIN Nivel AS NV ON
		CR.IdNivel = NV.IdNivel
		AND CR.AnioAcademico = @iP_AnioAcademico 
		AND TipoDocumentoDirector = @TipoIdentificacionUsuario 
		AND CR. NumeroDocumentoDirector = @NumeroIdentificacionUsuario 
		INNER JOIN Seccion AS SEC ON
		NV.IdSeccion = SEC.IdSeccion
	END

	IF (@TipoRolUsuario = @TipoRolPadre)
	BEGIN
		 
		SELECT 
				NV.IdNivel AS IdNivel,
				NV.Nombre AS NombreNivel

		  FROM GrupoFamiliar AS GF
		 INNER JOIN EstudianteCurso AS ESC ON
		ESC.TipoIdentificacionEstudiante = GF.TipoIdentificacionMiembro
		AND ESC.NumeroIdentificacionEstudiante = GF.NumeroIdentificacionMiembro
		INNER JOIN Curso AS CR ON
		ESC.IdCurso = CR.IdCurso 
		AND CR.AnioAcademico = @iP_AnioAcademico


		INNER JOIN Nivel AS NV ON
		CR.IdNivel = NV.IdNivel

		INNER JOIN Seccion AS SEC ON
		NV.IdSeccion = SEC.IdSeccion

		INNER JOIN @Secciones AS TSEC ON NV.IdSeccion = TSEC.IdSeccion
		 where IdFamilia = (SELECT 
			GF.IdFamilia
		FROM dbo.GrupoFamiliar AS GF WITH(NOLOCK)
			INNER JOIN dbo.Familia AS F WITH(NOLOCK)
			ON  GF.FamiliaPrincipal = 1 AND 
			GF.IdFamilia = F.IdFamilia
			AND GF.TipoIdentificacionMiembro = @TipoIdentificacionUsuario
		 AND  GF.NumeroIdentificacionMiembro = @NumeroIdentificacionUsuario)
		
	END
END 

