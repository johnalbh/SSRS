----------------------------- Antecedentes Prenatales---------------

SELECT 
	 CONVERT (varchar(10),NVM.Fecha1,103) AS FechaCapturaPerinatales
	,NVM.CampoTexto2 AS NumTotalEmbarazosMadrea
	,NVM.CampoTexto3 AS EdadMadreparto 
	,NVM.CampoTexto4 AS DuracionEmbarazo
	,NVM.CampoTexto5 AS TipoParto
	,CASE WHEN NVM.Checkbox6   = 'True' THEN 'Si' ELSE 'No' END AS ProblemasDurantegestacion
	,NVM.CampoTexto6 AS CualPDG
	,CASE WHEN NVM.Checkbox7   = 'True' THEN 'Si' ELSE 'No' END AS ProblemasDuranteParto
	,NVM.CampoTexto7 AS CualPDP
FROM NovedadMedica AS NVM
	INNER JOIN PersonaNovedadMedica AS PNM WITH(NOLOCK)
	ON NVM.IdNovedadMedica = PNM.IdNovedadMedica
WHERE 
	NVM.IdTipoNovedad = 33
	AND PNM.TipoIdentificacionPersona = @TipoIdentificacion
	AND PNM.NumeroIdentificacionPersona = @NumeroIdentificacion
ORDER BY 
	NVM.Fecha1 DESC

----------------------------- Antecedentes Desarrollo Psicomotor---------

SELECT 
	 CONVERT (varchar(10),NVMP.Fecha1,103) AS FechaCapturaDesarrollo
	,NVMP.CampoTexto2 AS SostuvolaCabeza
	,NVMP.CampoTexto3 AS Sesento 
	,NVMP.CampoTexto4 AS Gateo
	,NVMP.CampoTexto5 AS Camino
	,NVMP.CampoTexto6 AS ControlEsfinteresDiurno
	,NVMP.CampoTexto7 AS ControlEsfinteresNocturno
FROM NovedadMedica  AS NVMP
	INNER JOIN PersonaNovedadMedica AS PNM WITH(NOLOCK)
	ON NVMP.IdNovedadMedica = PNM.IdNovedadMedica
WHERE 
	NVMP.IdTipoNovedad = 34
	AND PNM.TipoIdentificacionPersona = @TipoIdentificacion
	AND PNM.NumeroIdentificacionPersona = @NumeroIdentificacion
ORDER BY 
	NVMP.Fecha1 DESC
--------------------------------- Desarrollo Lenguaje---------------------

SELECT 
     NVM.NombreNovedad AS NombreNovedad
	,NVM.Descripcion AS DescripcionDesarrolloLenguaje
	,CONVERT (varchar(10),NVM.Fecha1,103) AS FechaCapturaLenguaje
	,NVM.CampoTexto2 AS Inicioelbalbuceo
	,NVM.CampoTexto3 AS Dijoprimeraspalabras 
	,NVM.CampoMemo3 AS Observaciones

FROM NovedadMedica  AS NVM
	INNER JOIN PersonaNovedadMedica AS PNM WITH(NOLOCK)
	ON NVM.IdNovedadMedica = PNM.IdNovedadMedica
WHERE 
	NVM.IdTipoNovedad = 35
	AND PNM.TipoIdentificacionPersona = @TipoIdentificacion
	AND PNM.NumeroIdentificacionPersona = @NumeroIdentificacion
ORDER BY 
	NVM.Fecha1 DESC
---------------------------------Proceso Terapeutico Anterior------------------

SELECT 
	 NVM.NombreNovedad AS NombreNovedad 
	,NVM.ValorDominio AS Categoría	
	,NVM.Descripcion AS DescripcionProcesoTerapeuticoAnterior
	,CONVERT (varchar(10),NVM.Fecha1,103) AS FechaCapturaProcesoTerapeutico

FROM NovedadMedica  AS NVM
	INNER JOIN PersonaNovedadMedica AS PNM WITH(NOLOCK)
	ON NVM.IdNovedadMedica = PNM.IdNovedadMedica
WHERE 
	NVM.IdTipoNovedad = 36
	AND PNM.TipoIdentificacionPersona = @TipoIdentificacion
	AND PNM.NumeroIdentificacionPersona = @NumeroIdentificacion
ORDER BY 
	NVM.Fecha1 DESC
-------------------------------- Antecendentes Patologicos--------------------------

SELECT 
	 NVM.NombreNovedad AS NombreNovedad 
	,NVM.Descripcion AS DescripcionAntecedentesPatologicos
	,CONVERT (varchar(10),NVM.Fecha1,103) AS FechaAntecedentesPatologicos
	,CASE WHEN NVM.Checkbox2  = 'True' THEN 'Si' ELSE 'No' END AS ASMA
	,CASE WHEN NVM.Checkbox3  = 'True' THEN 'Si' ELSE 'No' END AS Diabetes
	,CASE WHEN NVM.Checkbox4  = 'True' THEN 'Si' ELSE 'No' END AS Epilepsia
	,CASE WHEN NVM.Checkbox5  = 'True' THEN 'Si' ELSE 'No' END AS Faringoamigdalitis
	,CASE WHEN NVM.Checkbox6  = 'True' THEN 'Si' ELSE 'No' END AS HepatitisA
	,CASE WHEN NVM.Checkbox7  = 'True' THEN 'Si' ELSE 'No' END AS Hipoglicemia
	,CASE WHEN NVM.Checkbox8  = 'True' THEN 'Si' ELSE 'No' END AS Infecciónurinaria
	,CASE WHEN NVM.Checkbox9  = 'True' THEN 'Si' ELSE 'No' END AS Meningitis
	,CASE WHEN NVM.Checkbox10 = 'True' THEN 'Si' ELSE 'No' END AS Migraña
	,CASE WHEN NVM.Checkbox11 = 'True' THEN 'Si' ELSE 'No' END AS OtitisMedia
	,CASE WHEN NVM.Checkbox12 = 'True' THEN 'Si' ELSE 'No' END AS Paperas
	,CASE WHEN NVM.Checkbox13 = 'True' THEN 'Si' ELSE 'No' END AS Rinitis
	,NVM.CampoMemo3  AS OtrasCuáles
FROM NovedadMedica  AS NVM
	INNER JOIN PersonaNovedadMedica AS PNM WITH(NOLOCK)
	ON NVM.IdNovedadMedica = PNM.IdNovedadMedica
WHERE 
   NVM.IdTipoNovedad = 1
   AND  PNM.TipoIdentificacionPersona = @TipoIdentificacion
   AND PNM.NumeroIdentificacionPersona = @NumeroIdentificacion
ORDER BY 
	NVM.Fecha1 DESC
----------------------------------Antecedentes Quirurgicos ----------------------------
SELECT 
	 NVM.NombreNovedad AS NombreNovedad 
	,NVM.ValorDominio AS Categoria
	,NVM.Descripcion AS DescripcionAntecedentesQuirurgicos
	,CONVERT (varchar(10),NVM.Fecha1,103) AS FechaAntecedentesQuirurgicos
	,NVM.CampoTexto2 AS Cuál
	,CONVERT (varchar(10),NVM.Fecha2,103)  AS Fecha
FROM NovedadMedica  AS NVM
	INNER JOIN PersonaNovedadMedica AS PNM WITH(NOLOCK)
	ON NVM.IdNovedadMedica = PNM.IdNovedadMedica
WHERE 
	NVM.IdTipoNovedad = 5
	AND  PNM.TipoIdentificacionPersona = @TipoIdentificacion
	AND PNM.NumeroIdentificacionPersona = @NumeroIdentificacion
ORDER BY 
	NVM.Fecha1 DESC
---------------------------------------------------------------------------------------