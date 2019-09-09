ALTER PROCEDURE [dbo].[PR_SGS_Rpt_ConsultarEstudiantes_RolNivelSinSeccion]  
	(

	 @sP_Usuario VARCHAR(200)  = NULL
	,@sP_TipoRol VARCHAR(12) = NULL
	
	)
	/****************************************************************************
	DECLARACIÓN DE VARIABLES GLOBALES
	****************************************************************************/
AS BEGIN
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
				NV.IdNivel,
				NV.Nombre AS NombreNivel 
		FROM Nivel AS NV

	ORDER BY NV.IdNivel ASC;
			

	END
	IF (@TipoRolUsuario = @TipoRolCoordinador)
	BEGIN
	
		SELECT 
				NV.IdNivel,
				NV.Nombre AS NombreNivel
		FROM EmpleadoSeccion AS ES
		INNER JOIN Seccion AS SEC ON
		ES.IdSeccion = SEC.IdSeccion 
		AND ES.TipoIdentificacionEmpleado = @TipoIdentificacionUsuario
		AND ES.NumeroIdentificacionEmpleado = @NumeroIdentificacionUsuario
		INNER JOIN NIVEL AS NV ON
		NV.IdSeccion = SEC.IdSeccion
		
	END

	IF (@TipoRolUsuario = @TipoRolDirector)	
	BEGIN
		SELECT 
				 NV.IdNivel 
				,NV.Nombre  AS NombreNivel
		FROM Curso AS CR
		INNER JOIN Nivel AS NV ON
		CR.IdNivel = NV.IdNivel
		AND CR.AnioAcademico = @iP_AnioAcademico 
		AND TipoDocumentoDirector = @TipoIdentificacionUsuario 
		AND CR. NumeroDocumentoDirector = @NumeroIdentificacionUsuario 
		INNER JOIN Seccion AS SEC ON
		NV.IdSeccion = SEC.IdSeccion
	END
END 
