SELECT 
	 DISTINCT GR.IdFamilia 

FROM GrupoFamiliar AS GR

INNER JOIN EstudianteCurso AS ESC
ON GR.TipoIdentificacionMiembro = ESC.TipoIdentificacionEstudiante
AND GR.NumeroIdentificacionMiembro = ESC.NumeroIdentificacionEstudiante

INNER JOIN Curso as CR
ON ESC.IdCurso = CR.IdCurso

INNER JOIN Nivel AS NV
ON CR.IdNivel = NV.IdNivel

INNER JOIN Seccion AS SEC
ON NV.IdSeccion = SEC.IdSeccion

INNER JOIN FAMILIA AS FM
ON GR.IdFamilia = FM.IdFamilia

INNER JOIN PERSONA AS PR
ON  FM.TipoDocumentoPadre = PR.TipoIdentificacion
AND FM.NumeroDocumentoPadre = PR.NumeroIdentificacion

INNER JOIN PERSONA AS MD
ON  FM.TipoDocumentoMadre = MD.TipoIdentificacion
AND FM.NumeroDocumentoMadre = MD.NumeroIdentificacion

INNER JOIN PERSONA AS EST
ON  ESC.TipoIdentificacionEstudiante = EST.TipoIdentificacion
AND ESC.NumeroIdentificacionEstudiante = EST.NumeroIdentificacion

WHERE CR.AnioAcademico = 12 AND GR.IdFamilia IN 

	(SELECT gr2.IdFamilia FROM GrupoFamiliar as gr2

		INNER JOIN EstudianteCurso AS ESC
		ON GR2.TipoIdentificacionMiembro = ESC.TipoIdentificacionEstudiante
		AND GR2.NumeroIdentificacionMiembro = ESC.NumeroIdentificacionEstudiante

		INNER JOIN Curso as CR
		ON ESC.IdCurso = CR.IdCurso

		INNER JOIN Nivel AS NV
		ON CR.IdNivel = NV.IdNivel

		INNER JOIN Seccion AS SEC
		ON NV.IdSeccion = SEC.IdSeccion
		
		INNER JOIN FAMILIA AS FM
		ON GR2.IdFamilia = FM.IdFamilia
		
		WHERE CR.AnioAcademico = 12  AND SEC.IdSeccion = 2)

and GR.IdFamilia IN 

	(SELECT gr2.IdFamilia FROM GrupoFamiliar as gr2

		INNER JOIN EstudianteCurso AS ESC
		ON GR2.TipoIdentificacionMiembro = ESC.TipoIdentificacionEstudiante
		AND GR2.NumeroIdentificacionMiembro = ESC.NumeroIdentificacionEstudiante

		INNER JOIN Curso as CR
		ON ESC.IdCurso = CR.IdCurso

		INNER JOIN Nivel AS NV
		ON CR.IdNivel = NV.IdNivel

		INNER JOIN Seccion AS SEC
		ON NV.IdSeccion = SEC.IdSeccion
		
		INNER JOIN FAMILIA AS FM
		ON GR2.IdFamilia = FM.IdFamilia
		
		WHERE CR.AnioAcademico = 12 AND SEC.IdSeccion = 3)

and GR.IdFamilia  IN 

	(SELECT gr2.IdFamilia FROM GrupoFamiliar as gr2

		INNER JOIN EstudianteCurso AS ESC
		ON GR2.TipoIdentificacionMiembro = ESC.TipoIdentificacionEstudiante
		AND GR2.NumeroIdentificacionMiembro = ESC.NumeroIdentificacionEstudiante

		INNER JOIN Curso as CR
		ON ESC.IdCurso = CR.IdCurso

		INNER JOIN Nivel AS NV
		ON CR.IdNivel = NV.IdNivel

		INNER JOIN Seccion AS SEC
		ON NV.IdSeccion = SEC.IdSeccion
		
		INNER JOIN FAMILIA AS FM
		ON GR2.IdFamilia = FM.IdFamilia
		
		WHERE CR.AnioAcademico = 12 AND SEC.IdSeccion = 1)

GROUP BY 
	 GR.IdFamilia
	,PR.TipoIdentificacion
	,PR.NumeroIdentificacion
	,PR.PrimerApellido
	,PR.SegundoApellido
	,PR.PrimerNombre
	,PR.SegundoNombre
	,CR.Nombre
	,MD.PrimerApellido
	,SEC.Nombre

ORDER BY GR.IdFamilia asc

