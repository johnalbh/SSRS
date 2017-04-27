SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:				dbo.PR_SGS_DatosPersonalesEstudiante.sql
DESCRPCIÓN:			Creación Strored Procedures "Consulta Asistencia Refuerzos
AUTOR:				John Alberto López Hernández
REQUERIMIENTO:		Matrículas
EMPRESA:			Colegio San Jorge de Inglaterra
FECHA CREACIÓN:		23/03/2017
PARÁMETROS ENTRADA:	No Aplica
EXCEPCIONES:		No Aplica
------------------------------------------------------------------------------------------   
*******************************************************************************************/
ALTER PROCEDURE 
	 [dbo].[PR_SGS_DatosPersonalesEstudiante] 

	 /* Espacio Parametros */

		 @Periolectivo INT 
		,@Seccion VARCHAR (max)
		,@Nivel VARCHAR(max)
		,@Curso VARCHAR (max)
		,@Estudiantes VARCHAR (max)
AS
BEGIN
/* Tabla Temporal para filtrar por curso */

DECLARE @Cursos TABLE 
	(
		IdCursoSeleccionado varchar(60)

	)
INSERT INTO @Cursos
SELECT CR.Valor 
FROM F_SGS_Split(@Curso, ',') AS CR

/* Tabla Temporal para filtrar por Estudiante */

DECLARE @Estudiante TABLE 
	(
		IdEstudianteSeleccionado varchar(60)

	)
INSERT INTO @Estudiante
SELECT CR.Valor 
FROM F_SGS_Split(@Estudiantes, ',') AS CR


/* Consulta Principal*/

SELECT 
	 PR.PrimerApellido +' '+ isNull(PR.SegundoApellido,'') + ' ' + PR.PrimerNombre + ' '+ isNull(PR.SegundoNombre,'') AS NombreEstudiante
	,PR.TipoIdentificacion +' '+ PR.NumeroIdentificacion AS IdentificacionEstudiante
	,DC.TelefonoDireccion AS TeléfonoCasa
	,DC.Barrio AS Barrio
	,DC.Direccion AS Direccion
	,ED.CodigoEstudiante AS CodigoEstudiante
	,EC.Estado AS EstadoEstudiante
	,CR.Nombre AS Curso
	,NV.Nombre AS Nivel
	,SE.Nombre AS Seccion
	/** Información Padre de Familia */
	,PSP.PrimerApellido +' '+ isNull(PSP.SegundoApellido,'') + ' ' + PSP.PrimerNombre + ' '+ isNull(PSP.SegundoNombre,'') AS NombrePadre
	,PSP.TipoIdentificacion +' '+ PSP.NumeroIdentificacion AS IdentificacionPadre
	,PDP.Titulo AS ProfesionPadre
	,PDP.Empresa AS EmpresaPadre
	,PDP.TelefonoOficina AS TelefonoOficinaPadre
	,PSP.Celular AS CelularPadre
	,PSP.USERNAME AS CorreoPadre
	/** Información Madre de Familia */
	,PSM.PrimerApellido +' '+ isNull(PSM.SegundoApellido,'') + ' ' + PSM.PrimerNombre + ' '+ isNull(PSM.SegundoNombre,'') AS NombreMadre
	,PSM.TipoIdentificacion +' '+ PSM.NumeroIdentificacion AS IdentificacionMadre
	,PDM.Titulo AS ProfesionMadre
	,PDM.Empresa AS EmpresaMadre
	,PDM.TelefonoOficina AS TelefonoOficinaMadre
	,PSM.Celular AS CelularMadre
	,PSM.USERNAME AS CorreoMadre
	/** Información Acudiente */
	,PSA.PrimerApellido +' '+ isNull(PSA.SegundoApellido,'') + ' ' + PSA.PrimerNombre + ' '+ isNull(PSA.SegundoNombre,'') AS NombreAcudiente
	,PSA.TipoIdentificacion +' '+ PSA.NumeroIdentificacion AS IdentificacionAcudiente
	,PSA.Celular AS CelularAcudiente

FROM PERSONA AS PR WITH (NOLOCK) 
	/* Información Academica */

	JOIN ESTUDIANTE AS ED WITH (NOLOCK) ON
	ED.TIPOIDENTIFICACION =  PR.TIPOIDENTIFICACION 
	AND ED.NUMEROIDENTIFICACION = PR.NUMEROIDENTIFICACION

	JOIN ESTUDIANTECURSO AS EC WITH (NOLOCK) ON
	ED.TIPOIDENTIFICACION = EC.TIPOIDENTIFICACIONESTUDIANTE 
	AND ED.NUMEROIDENTIFICACION = EC.NUMEROIDENTIFICACIONESTUDIANTE

	JOIN CURSO AS CR WITH (NOLOCK) 
	ON EC.IdCURSO = CR.IdCurso

	JOIN NIVEL AS NV WITH (NOLOCK) 
	ON CR.IdNivel = NV.IdNivel

	JOIN SECCION AS SE WITH (NOLOCK) 
	ON NV.IdSeccion = SE.IdSeccion

	/* Datos Personal e Información Familiar */

	JOIN GRUPOFAMILIAR AS GF WITH (NOLOCK)
	ON 	GF.TIPOIDENTIFICACIONMIEMBRO = PR.TIPOIDENTIFICACION 
	AND GF.NUMEROIDENTIFICACIONMIEMBRO = PR.NUMEROIDENTIFICACION
	
	JOIN DIRECCION AS DC WITH (NOLOCK) 
	ON  DC.IDGRUPOFAMILIAR = GF.IDFAMILIA 
	AND DIRECCIONPRINCIPAL = 1
	
	JOIN FAMILIA AS FM WITH (NOLOCK) ON
	FM.IDFAMILIA = GF.IDFAMILIA 

	JOIN PERSONA AS PSA WITH (NOLOCK) ON
	PSA.TIPOIDENTIFICACION = ED.TIPOIDENTIFICACIONACUDIENTE 
	AND PSA.NUMEROIDENTIFICACION = ED.NUMEROIDENTIFICACIONACUDIENTE

	JOIN PERSONA AS PSP WITH (NOLOCK) ON
	PSP.TIPOIDENTIFICACION = FM.TIPODOCUMENTOPADRE 
	AND PSP.NUMEROIDENTIFICACION = FM.NUMERODOCUMENTOPADRE
	
	JOIN PADRE AS PDP WITH (NOLOCK) ON
	PDP.TIPOIDENTIFICACION = PSP.TIPOIDENTIFICACION 
	AND PDP.NUMEROIDENTIFICACION = PSP.NUMEROIDENTIFICACION 

	JOIN PERSONA AS PSM WITH (NOLOCK) ON
	PSM.TIPOIDENTIFICACION = FM.TIPODOCUMENTOMADRE 
	AND PSM.NUMEROIDENTIFICACION = FM.NUMERODOCUMENTOMADRE

	JOIN PADRE AS PDM WITH (NOLOCK) ON
	PDM.TIPOIDENTIFICACION = PSM.TIPOIDENTIFICACION 
	AND PDM.NUMEROIDENTIFICACION = PSM.NUMEROIDENTIFICACION 
	
	/* Información Curso */

	INNER JOIN dbo.Curso AS C WITH(NOLOCK) 
	ON  EC.IdCurso = C.IdCurso

	INNER JOIN @Cursos AS CURS
	ON C.IdCurso = CURS.IdCursoSeleccionado

	INNER JOIN @Estudiante AS ESTEM
	ON ED.NumeroIdentificacion = ESTEM.IdEstudianteSeleccionado

WHERE 
 	EC.Estado <> 'Retirado'

ORDER BY PR.PrimerApellido ASC

END



