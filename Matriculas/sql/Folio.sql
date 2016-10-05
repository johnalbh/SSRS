/******************************************************************************************
	TÍTULO:			CONSULTA REPORTE MATRICULAS FOLIOS 
	AUTOR:			JOHN ALBERTO LÓPEZ HERNÁNDEZ
	FECHA:			18/05/2016
	CÓDIGO REPORTE: F-MAT-002-V2
------------------------------------------------------------------------------------------
	TÍTULO MODIFICACIÓN: Actualización Documentos de Identidad
	AUTOR: JOHN ALBERTO LÓPEZ
	FECHA DE MODIFICACIÓN: 25/05/2016	
	DESCRIPCIÓN: Se incluye en el SELECT los Número de Identificación de los padres y acudiente.
------------------------------------------------------------------------------------------   
******************************************************************************************/

SELECT 
	PR.PrimerApellido +' '+ PR.SegundoApellido + ' ' + PR.PrimerNombre + ' '+ Pr.SegundoNombre AS NombreEstudiante
	,PR.TipoIdentificacion +' '+ PR.NumeroIdentificacion AS IdentificacionEstudiante
	,DC.TelefonoDireccion AS TeléfonoCasa
	,DC.Barrio AS Barrio
	,DC.Direccion AS Direccion
	,PSP.PrimerApellido +' '+ PSP.SegundoApellido + ' ' + PSP.PrimerNombre + ' '+ PSP.SegundoNombre AS NombrePadre
	,PSP.TipoIdentificacion +' '+ PSP.NumeroIdentificacion AS IdentificacionPadre
	,PDP.Titulo AS ProfesionPadre
	,PDP.TelefonoOficina AS TelefonoOficinaPadre
	,PSP.Celular AS CelularPadre
	,PDP.Empresa AS EmpresaPadre
	,PSP.USERNAME AS CorreoPadre
	,PSM.PrimerApellido +' '+ PSM.SegundoApellido + ' ' + PSM.PrimerNombre + ' '+ PSM.SegundoNombre AS NombreMadre
	,PSM.TipoIdentificacion +' '+ PSM.NumeroIdentificacion AS IdentificacionMadre
	,PDM.Titulo AS ProfesionMadre
	,PDM.TelefonoOficina AS TelefonoOficinaMadre
	,PSM.Celular AS CelularMadre
	,PDM.Empresa AS EmpresaMadre
	,PSM.USERNAME AS CorreoMadre
	,PSA.PrimerApellido +' '+ PSA.SegundoApellido + ' ' + PSA.PrimerNombre + ' '+ PSA.SegundoNombre AS NombreAcudiente
	,PSA.TipoIdentificacion +' '+ PSA.NumeroIdentificacion AS IdentificacionAcudiente
	,PSA.Celular AS CelularAcudiente
FROM PERSONA AS PR WITH (NOLOCK)
	
	JOIN ESTUDIANTE AS ED WITH (NOLOCK) ON
	ED.TIPOIDENTIFICACION =  PR.TIPOIDENTIFICACION AND
	ED.NUMEROIDENTIFICACION = PR.NUMEROIDENTIFICACION
	
	JOIN GRUPOFAMILIAR AS GF WITH (NOLOCK) ON
	GF.TIPOIDENTIFICACIONMIEMBRO = PR.TIPOIDENTIFICACION AND
	GF.NUMEROIDENTIFICACIONMIEMBRO = PR.NUMEROIDENTIFICACION
	
	JOIN DIRECCION AS DC WITH (NOLOCK) ON
	DC.IDGRUPOFAMILIAR = GF.IDFAMILIA AND DIRECCIONPRINCIPAL = 1
	
	JOIN FAMILIA AS FM WITH (NOLOCK) ON
	FM.IDFAMILIA = GF.IDFAMILIA 

	JOIN PERSONA AS PSA WITH (NOLOCK) ON
	PSA.TIPOIDENTIFICACION = ED.TIPOIDENTIFICACIONACUDIENTE AND
	PSA.NUMEROIDENTIFICACION = ED.NUMEROIDENTIFICACIONACUDIENTE

	JOIN PERSONA AS PSP WITH (NOLOCK) ON
	PSP.TIPOIDENTIFICACION = FM.TIPODOCUMENTOPADRE AND
	PSP.NUMEROIDENTIFICACION = FM.NUMERODOCUMENTOPADRE
	
	JOIN PADRE AS PDP WITH (NOLOCK) ON
	PDP.TIPOIDENTIFICACION = PSP.TIPOIDENTIFICACION AND
	PDP.NUMEROIDENTIFICACION = PSP.NUMEROIDENTIFICACION 

	JOIN PERSONA AS PSM WITH (NOLOCK) ON
	PSM.TIPOIDENTIFICACION = FM.TIPODOCUMENTOMADRE AND
	PSM.NUMEROIDENTIFICACION = FM.NUMERODOCUMENTOMADRE

	JOIN PADRE AS PDM WITH (NOLOCK) ON
	PDM.TIPOIDENTIFICACION = PSP.TIPOIDENTIFICACION AND
	PDM.NUMEROIDENTIFICACION = PSP.NUMEROIDENTIFICACION 

