DECLARE 

	 @sP_Usuario VARCHAR(200) = 'carolina.florez@sgs.edu.co'
	,@sP_TipoRol VARCHAR(12) = 'COO'



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

		/* Sacarlas Secciones Habilitadas */

		SELECT
			SEC.IdSeccion,
			SEC.Nombre
			
		FROM Seccion AS SEC
		/** */
		SELECT * FROM Seccion

		SELECT DISTINCT
			CR.IdCurso,
			CR.Nombre
		FROM Curso AS CR
		INNER JOIN Nivel AS NV ON
		CR.IdNivel = NV.IdNivel

		INNER JOIN Seccion AS SEC ON
		NV.IdSeccion = SEC.IdSeccion

		WHERE CR.AnioAcademico = @iP_AnioAcademico /*((LTRIM(RTRIM(T.Apellido + ' ' + ISNULL(LTRIM(RTRIM(T.Nombre1)),'')))) 
		LIKE '%' + @PNombreEstudiante + '%' COLLATE Modern_Spanish_CI_AI OR @PNombreEstudiante IS NULL)*/
	END
	IF (@TipoRolUsuario = @TipoRolCoordinador)
	BEGIN
	
		SELECT 
				ES.IdSeccion AS Seccion,
				SEC.Nombre,
				CR.IdCurso AS Curso ,
				CR.Nombre
		FROM EmpleadoSeccion AS ES
		INNER JOIN Seccion AS SEC 
		ON ES.IdSeccion = SEC.IdSeccion
		INNER JOIN Nivel AS NV ON
		ES.IdSeccion = NV.IdSeccion 
		INNER JOIN Curso AS CR ON
		NV.IdNivel = CR.IdNivel
		AND CR.AnioAcademico = @iP_AnioAcademico
			
		WHERE ES.TipoIdentificacionEmpleado = @TipoIdentificacionUsuario
			AND ES.NumeroIdentificacionEmpleado = @NumeroIdentificacionUsuario

		
	END

	IF (@TipoRolUsuario = @TipoRolDirector)	
	BEGIN
		SELECT 
			CR.IdCurso,
			CR.Nombre
		FROM Curso AS CR
		INNER JOIN Nivel AS NV ON
		CR.IdNivel = NV.IdNivel

		INNER JOIN Seccion AS SEC ON
		NV.IdSeccion = SEC.IdSeccion
		WHERE CR.AnioAcademico = @iP_AnioAcademico AND TipoDocumentoDirector = @TipoIdentificacionUsuario AND CR. NumeroDocumentoDirector = @NumeroIdentificacionUsuario 
		
		/*T.TipoDocumentoDirectorGrupo = @TipoIdentificacionUsuario
			AND T.NumeroDocumentoDirectorGrupo = @NumeroIdentificacionUsuario
			AND	((LTRIM(RTRIM(T.Apellido + ' ' + ISNULL(LTRIM(RTRIM(T.Nombre1)),'')))) 
		LIKE '%' + @PNombreEstudiante + '%' COLLATE Modern_Spanish_CI_AI OR @PNombreEstudiante IS NULL)
		AND T.IdCurso = @Curso*/
	END

	IF (@TipoRolUsuario = @TipoRolPadre)
	BEGIN
		 
		 SELECT 
			CR.IdCurso,
			CR.Nombre,
			SEC.IdSeccion, 
			SEC.Nombre

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
		 where IdFamilia = (SELECT 
			GF.IdFamilia
		FROM dbo.GrupoFamiliar AS GF WITH(NOLOCK)
			INNER JOIN dbo.Familia AS F WITH(NOLOCK)
			ON  GF.FamiliaPrincipal = 1 AND 
			GF.IdFamilia = F.IdFamilia
			AND GF.TipoIdentificacionMiembro = @TipoIdentificacionUsuario
		 AND  GF.NumeroIdentificacionMiembro = @NumeroIdentificacionUsuario)
		
	END