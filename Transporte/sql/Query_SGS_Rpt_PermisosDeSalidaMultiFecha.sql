


		DECLARE 
		 @fP_Fechas DATETIME ='2019-01-23'
		,@idP_Seccion VARCHAR (max) = '1'
		,@idP_NombreEstudiante VARCHAR (max) = '1014882064'



/* Tabla Temporal para filtrar por curso */
DECLARE @Seccion TABLE 
	(
		IdSeccion VARCHAR (max)

	)
INSERT INTO @Seccion
SELECT SEC.Valor 
FROM F_SGS_Split(@idP_Seccion, ',') AS SEC

/* Tabla Temporal para filtrar por Nombre */
DECLARE @Nombre TABLE 
	(
		IdNombre VARCHAR (max)
	)
INSERT INTO @Nombre
SELECT NOM.Valor 
FROM F_SGS_Split(@idP_NombreEstudiante, ',') AS NOM



SELECT  
	STUFF(
			(SELECT
			', ' +  FORMAT(FCR.fechaseleccionada, 'dd/MM/yyyy')

		FROM FechaCambioTransporte  AS FCR
		WHERE FCR.IdSolicitudTransporte = ST.IdSolicitudTransporte
		FOR XML PATH ('')),
		1,2, '')as FechasSeleccionadas
	,C.nombre AS Curso
	,P.PrimerApellido + ' ' + isnull(P.SegundoApellido,'') + ' ' + 	P.PrimerNombre + ' ' + isnull(P.SegundoNombre,'') AS Nombre
	,CONVERT(varchar(15),CAST(ST.hora AS TIME),100) AS Hora
	,REPLACE(LOWER(RTRIM(SUBSTRING(ST.Observaciones,0, 200))),char(10),' ' ) AS Observaciones
	,UPPER(ST.NombreAutorizado) + ' ( ' + ST.identificacionAutorizado + ' )' AS Autorizado
	,FORMAT(ST.FechaSolicitud, 'dd/MM/yyyy') AS FechaSolicitud 
	,ST.telefono AS Teléfono
	,EST.Descripcion  + '' + isnull(MR.Descripcion,'') AS Estado
	,PADRE.PrimerNombre + ' ' + isnull(PADRE.SegundoNombre,'') +  ' ' + PADRE.PrimerApellido + ' ( ' + ST.UsuarioLog + ' ) ' AS Padre
	,R.Descripcion AS Ruta
	,ST.IdSolicitudTransporte AS IdSolicitudTransporte

FROM SolicitudTransporte AS ST

	INNER JOIN TipoSolicitudTransporte AS TST 
	ON ST.idtiposolicitudtransporte = TST.idtiposolicitudtransporte

	INNER JOIN FechaCambioTransporte AS FCT
	ON FCT.IdSolicitudTransporte = ST.idsolicitudtransporte 
	AND FCT.FechaSeleccionada = @fP_Fechas


	INNER JOIN Persona AS P 
	ON P.NumeroIdentificacion = ST.IdentificacionSolicitante 
	AND P.TipoIdentificacion = ST.TipoIdentSolicitante

	INNER JOIN EstudianteCurso AS EC 
	ON P.NumeroIdentificacion = EC.NumeroIdentificacionEstudiante 
	AND P.TipoIdentificacion = EC.TipoIdentificacionEstudiante
	
	INNER JOIN Curso AS C 
	ON C.IdCurso = EC.IdCurso 

	INNER JOIN Nivel AS NVL
	ON C.IdNivel = NVL.IdNivel

	INNER JOIN Seccion AS SECC
	ON NVL.IdSeccion = SECC.IdSeccion

	INNER JOIN PeriodoLectivo AS PL 
	ON PL.AnioActivo = 1 
	AND PL.Id = C.AnioAcademico

	INNER JOIN Persona AS PADRE 
	ON PADRE.Username = ST.usuariolog

	INNER JOIN Dominio AS EST 
	ON EST.Dominio = 'EstadoSolicitud' 
	AND ST.EstadoSolicitud = EST.Valor

	INNER JOIN PersonaRuta AS PR 
	ON PR.NumeroIdentificacionPasajero = P.NumeroIdentificacion 
	AND PR.TipoIdentificacionPasajero = P.TipoIdentificacion 
	AND PR.Estado = 'Activo' 

	INNER JOIN BusRuta AS BR 
	ON BR.IdBusRuta = PR.idbusruta 
	AND BR.DominioJornada = '21' 
	AND BR.FechaCalendario = '19000101'

	INNER JOIN Dominio AS R
	ON R.Dominio = 'Ruta' 
	AND R.Valor = BR.DominioNombreRuta

	INNER JOIN @Seccion AS TSEC
	ON SECC.IdSeccion = TSEC.IdSeccion

	INNER JOIN @Nombre AS TNOM
	ON  P.NumeroIdentificacion = TNOM.IdNombre

	LEFT JOIN Dominio AS MR 
	ON MR.Dominio = 'MotivoRechazo' 
	AND CAST (ST.MotivoRechazo AS Varchar) = MR.Valor


WHERE 
	TST.IdTipoSolicitudTransporte in (29, 30)
	