
SELECT * FROM TIPOGRUPO AS TG
INNER JOIN  GRUPO AS GR ON
	TG.Id = GR.IdTipoGrupo

INNER JOIN GrupoEstudiante as GE ON
	GR.Id = GE.IdGrupo

INNER JOIN GrupoEstudianteSesion as GES ON
	GR.Id = GES.IdGrupoEstudiante

LEFT JOIN Sesion as SES ON 
	GES.IdGrupoEstudiante = SES.IdGrupo AND
	GES.IdSesion = SES.Id

INNER JOIN PERSONA AS PR ON
	GE.TipoIdentificacionEstudiante = PR.TipoIdentificacion AND
	GE.NumeroIdentificacionEstudiante = PR.NumeroIdentificacion
	

INNER JOIN SolicitudTransporte as ST ON 
	GE.TipoIdentificacionEstudiante = ST.TipoIdentSolicitante AND
	GE.NumeroIdentificacionEstudiante = ST.IdentificacionSolicitante

INNER JOIN FECHACAMBIOTRANSPORTE AS FCT ON
	ST.IdsolicitudTransporte = FCT.IdSolicitudTransporte 

WHERE 

	TG.ID = 13 AND 
	SES.Fecha BETWEEN @FechaInicio AND @FechaFin AND
	FCT.FechaSeleccionada BETWEEN @FechaInicio AND @FechaFin AND




SELECT * FROM SOLICITUDTRANSPORTE

SELECT * FROM FECHACAMBIOTRANSPORTE