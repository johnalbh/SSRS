/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_ListadoCitasEventos.sql
DESCRIPCIÓN:			Listado de los asistentes a un evento.
RESULTADO:				Listado con las siguientes columnas: 
						NombreEvento, FechaInicioGrupo, Lugar, HoraInicioCita
						,HoraFinCIta, NombreEstudiante, NombrePadre, NombreMadre 
CREACIÓN 
REQUERIMIENTO:			Reportes de Eventos
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2017-11-30
----------------------------------------------------------------------------
MODIFICACIÓN:			Se agrega la tabla temporal para poder generar
						varias agendas al tiempo. 
AUTOR:					John Alberto López Hernández
FECHA:				    2017-12-13
****************************************************************************/
ALTER PROCEDURE 
	 [dbo].[PR_SGS_Rpt_ListadoCitasEventos] 

	 /* Espacio Parametros */
		  @idP_Agenda VARCHAR (MAX)
AS
BEGIN

DECLARE @Agendas TABLE 
	(
		IdAgenda VARCHAR(max)
	)
INSERT INTO @Agendas
SELECT AGE.Valor AS Fecha
FROM F_SGS_Split(@idP_Agenda, ',') AS AGE


SELECT 

	 AG.Id AS IdEvento
	,AG.Nombre AS NombreEvento
	,CONVERT(VARCHAR(12),AG.FechaInicio ,103) AS FechaInicio
	,AG.Lugar AS Lugar
	,CONVERT (varchar(15),CAST(CT.Inicio AS TIME),100) AS HoraInicioCita
	,CONVERT (varchar(15),CAST(CT.Fin AS TIME),100) AS HoraFinCita
	,P.PrimerApellido + ' ' + ISNULL (P.SegundoApellido, '') + ' ' + P.PrimerNombre + ' ' + ISNULL (P.SegundoNombre, '') AS NombreEstudiante 
	,PA.PrimerApellido + ' ' + PA.PrimerNombre AS NombrePadre 
	,MA.PrimerApellido + ' ' + MA.PrimerNombre AS NombreMadre
 
FROM Agenda AS AG
INNER JOIN Cita AS CT ON
AG.Id = CT.IdAgenda

LEFT JOIN Estudiante AS EST ON
CT.TipoIdentificacion = EST.TipoIdentificacion
AND CT.NumeroIdentificacion = EST.NumeroIdentificacion

LEFT JOIN  Persona AS P ON
P.TipoIdentificacion = CT.Tipoidentificacion 
AND P.numeroIdentificacion = CT.NumeroIdentificacion

LEFT JOIN GrupoFamiliar AS GF ON
GF.NumeroIdentificacionMiembro = P.NumeroIdentificacion 
AND GF.TipoIdentificacionMiembro = P.tipoIdentificacion

LEFT JOIN Familia AS F ON
F.IdFamilia = GF.idfamilia

LEFT JOIN Persona AS MA ON 
MA.numeroidentificacion = F.NumeroDocumentoMadre 
AND MA.tipoIdentificacion = F.tipodocumentoMadre

LEFT JOIN Persona AS PA ON 
PA.numeroidentificacion = F.NumeroDocumentoPadre 
AND PA.tipoIdentificacion = F.TipoDocumentoPadre

INNER JOIN @Agendas AS AGT ON 
AG.Id = AGT.IdAgenda

ORDER BY CT.Inicio, AG.Nombre ASC

END


