SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_HistoriaClinica.sql
DESCRIPCIÓN:			SP para la construcción del reporte de Historia Clínica 
						del modulo de Servicio Médico
PARAMETRO ENTRADA:		@idP_TipoDocumentoPersona = Tipo Documetno de Persona
						@ndP_NumeroDocumentoPersona = Número Documento de Persona
ESULTADO:				
CREACIÓN 
REQUERIMIENTO:			Reporte de Servicio Médico
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2017-03-13
----------------------------------------------------------------------------
****************************************************************************/
ALTER PROCEDURE dbo.PR_SGS_Rpt_HistoriaClinica

	 @idP_TipoDocumentoPersona varchar(30) 
	,@ndP_NumeroDocumentoPersona varchar(50)

AS BEGIN 

  SET NOCOUNT ON
  DECLARE @EsEstudiante AS bit;		
  DECLARE @AnioAcademicoActual AS int;
  DECLARE @Seccion AS int;
  DECLARE @TipoHorario AS int;
  DECLARE @Dia AS INT;

  SELECT
    @AnioAcademicoActual = Id
  FROM 
	PeriodoLectivo
  WHERE 
	AnioActivo = 1

/* Revisar que el numero de documento este en en la tabla estudiantes */ 

 SELECT
    @EsEstudiante = COUNT(NumeroIdentificacion)
  FROM 
	dbo.Estudiante
  WHERE 
	TipoIdentificacion = @idP_TipoDocumentoPersona
	AND NumeroIdentificacion = @ndP_NumeroDocumentoPersona

  IF @EsEstudiante = 1
/* Cuando la persona que se busca es un Estudiante */
	SELECT	

       DOC.Descripcion AS TipoDocumento
      ,PR.NumeroIdentificacion
      ,LEFT(CONVERT(varchar, PR.FechaNacimiento, 120), 10) AS FechaNac
      ,dbo.F_SGS_CalcularEdadAniosMeses(PR.FechaNacimiento) AS Edad
	  ,ISNULL(PR.PrimerApellido, ' ') AS PrimerApellido
	  ,ISNULL(PR.SegundoApellido, ' ') AS SegundoApellido
      ,ISNULL(PR.PrimerNombre, ' ') + ' ' + ISNULL(PR.SegundoNombre, ' ')  AS NombreCompleto
      ,NAC.Descripcion AS LugarNacimiento
	  ,CUR.IdCurso
      ,CUR.Nombre AS NombreCurso
      ,EST.Casa
      ,PR.Celular
      ,PR.Genero
      ,PR.UserName AS Email   
      ,EST.CodigoEstudiante
      ,ESTC.Estado
	  ,IM.InstitucionCasoEmergencia
	  ,IM.MedicaTratante
	  ,IM.TelefonoMedicoTratante
	  ,DOM.Descripcion AS EPS
	  ,DOMP.Descripcion AS MedicinaPrepagada
	  ,PR.UrlFoto
	  ,'Estudiante' AS TipoPaciente 

    FROM Persona AS PR

		INNER JOIN Estudiante AS EST ON 
			EST.TipoIdentificacion = PR.TipoIdentificacion
			AND EST.NumeroIdentificacion = PR.NumeroIdentificacion
		INNER JOIN EstudianteCurso AS ESTC ON 
			EST.TipoIdentificacion = ESTC.TipoIdentificacionEstudiante
			AND EST.NumeroIdentificacion = ESTC.NumeroIdentificacionEstudiante
		INNER JOIN CURSO AS CUR ON 
			CUR.IdCurso = ESTC.IdCurso
		INNER JOIN Ciudad AS CIU ON 
			PR.LugarExpedicion = CIU.Id
		INNER JOIN Nacionalidad AS NAC ON 
			PR.PaisNacimiento = NAC.Codigo
		INNER JOIN INFORMACIONMEDICA AS IM ON
			PR.TipoIdentificacion = IM.TipoIdentificacion
			AND PR.NumeroIdentificacion = IM.NumeroIdentificacion
		INNER JOIN Dominio AS DOC ON
			DOC.Dominio = 'TipoDocumento'
			AND DOC.Valor = PR.TipoIdentificacion
		INNER JOIN Dominio AS DOM ON
			DOM.Dominio = 'EPS'
			AND DOM.Valor = IM.IdEPS
		LEFT JOIN Dominio AS DOMP ON
			DOM.Dominio = 'MedicinaPrepagada' 		
			AND DOM.Valor = IM.IdMedicinaPrepagada

    WHERE 
		EST.TipoIdentificacion = @idP_TipoDocumentoPersona
		AND EST.NumeroIdentificacion = @ndP_NumeroDocumentoPersona
		AND CUR.AnioAcademico = @AnioAcademicoActual

  ELSE
  
  /*Cuando la persona que se busca es Empleado */
    SELECT

       PR.TipoIdentificacion
      ,PR.NumeroIdentificacion
      ,LEFT(CONVERT(varchar, PR.FechaNacimiento, 120), 10) AS FechaNac
	  ,dbo.F_SGS_CalcularEdadAniosMeses(PR.FechaNacimiento) AS Edad
	  ,ISNULL(PR.PrimerApellido, ' ') AS PrimerApellido
	  ,ISNULL(PR.SegundoApellido, ' ') AS SegundoApellido
      ,ISNULL(PR.PrimerNombre, ' ') + ' ' + ISNULL(PR.SegundoNombre, ' ')  AS NombreCompleto
      ,NAC.Descripcion AS LugarNacimiento
      ,PR.Celular
      ,PR.Genero
      ,PR.UserName AS Email
	  ,IM.InstitucionCasoEmergencia
	  ,IM.MedicaTratante
	  ,IM.TelefonoMedicoTratante
	  ,DOM.Descripcion AS EPS
	  ,DOMP.Descripcion AS MedicinaPrepagada
      ,PR.UrlFoto
	  ,'Empleado' AS TipoPaciente	
    FROM Persona AS PR
		INNER JOIN Ciudad AS CIU
		  ON PR.LugarExpedicion = CIU.Id
		INNER JOIN Nacionalidad AS NAC
		  ON PR.PaisNacimiento = NAC.Codigo
		INNER JOIN Dominio AS DOC ON
			DOC.Dominio = 'TipoDocumento'
			AND DOC.Valor = PR.TipoIdentificacion
		LEFT JOIN INFORMACIONMEDICA AS IM ON
			PR.TipoIdentificacion = IM.TipoIdentificacion
			AND PR.NumeroIdentificacion = IM.NumeroIdentificacion
		LEFT JOIN Dominio AS DOM ON
			DOM.Dominio = 'EPS'
			AND DOM.Valor = IM.IdEPS
		LEFT JOIN Dominio AS DOMP ON
			DOM.Dominio = 'MedicinaPrepagada' 		
			AND DOM.Valor = IM.IdMedicinaPrepagada
    WHERE 
		PR.TipoIdentificacion = 'cc'
		AND PR.NumeroIdentificacion = '1022347504'

END 

