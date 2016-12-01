SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:					PR_SGS_Rpt_GrupoProfesorconEstudianteRegistradoSesion.sql
DESCRIPCIÓN:			Muestra la lista de estudiantes inscritos a una sesión de un grupo
						determinado. 
PARÁMETROS DE ENTRADA:  @dP_Fecha: Fecha de la consulta 
						@TipoIdentificacion: Tipo Identificacion Docente
						@NumeroIdentificacion: Número Identificacion Docente
PARÁMETROS DE SALIDA:   No aplica.  
------------------------------------------------------------------------
CREACIÓN 
REQUERIMIENTO:			Módulo Gestión Escolar
AUTOR:					John López
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2016-12-01
----------------------------------------------------------------------------
****************************************************************************/
ALTER PROCEDURE 
	 [dbo].[PR_SGS_Rpt_GrupoProfesorconEstudianteRegistradoSesion] 

	 @FechaSesion DATE 
	,@TipoIdentificacion VARCHAR (50)
	,@NumeroIdentificacion VARCHAR (50) 

AS
BEGIN

SELECT 
 GR.Nombre AS NombreGrupo
,EST.PrimerApellido + ' ' + isNull(EST.SegundoApellido,'') + ' ' + EST.PrimerNombre + ' ' + isNull(EST.SegundoNombre,'')  AS NombreEstudiante
,DTP.Curso

FROM GRUPO AS GR

INNER JOIN SESION AS SES 
ON GR.Id = SES.IdGrupo

INNER JOIN GRUPOESTUDIANTESESION AS GES
ON SES.Id = GES.IdSesion

INNER JOIN GrupoEstudiante AS GE
ON GES.IdGrupoEstudiante = GE.Id

INNER JOIN PERSONA AS PRO
ON GR.TipoIdentificacionEmpleado = PRO.TipoIdentificacion
AND GR.NumeroIdentificacionEmpleado = PRO.NumeroIdentificacion

INNER JOIN PERSONA AS EST
ON GE.TipoIdentificacionEstudiante = EST.TipoIdentificacion
AND GE.NumeroIdentificacionEstudiante = EST.NumeroIdentificacion

INNER JOIN VW_DATOSPERSONA AS DTP
ON GE.TipoIdentificacionEstudiante = DTP.TipoIdentificacion
AND GE.NumeroIdentificacionEstudiante = DTP.NumeroIdentificacion

WHERE 

GR.TipoIdentificacionEmpleado = @TipoIdentificacion
AND NumeroIdentificacionEmpleado = @NumeroIdentificacion 
AND SES.FECHA = @FechaSesion
AND GE.EstudianteActivo = 1

ORDER BY

	 NombreEstudiante ASC

END
GO
