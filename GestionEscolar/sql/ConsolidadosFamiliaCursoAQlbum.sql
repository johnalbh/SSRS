DECLARE

		@IdP_PeriodoLectivo INT	 = 12	

SELECT 

	 GR.IdFamilia
	,PR.PrimerApellido +' ' + MD.PrimerApellido  AS NombreFamilia 
	,PR.TipoIdentificacion AS TipoIdentificacionPadre
	,PR.NumeroIdentificacion AS NumeroIdentificacionPadre
	,EST.PrimerApellido +' '+ isNull(EST.SegundoApellido,'') + ' ' + EST.PrimerNombre + ' '+ isNull(EST.SegundoNombre,'') AS NombreEstudiante
	,CR.Nombre AS Curso
	,SEC.Nombre AS Seccion
	,CR.IdCurso
	,NV.IdNivel

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

WHERE CR.AnioAcademico = @IdP_PeriodoLectivo



ORDER BY GR.IdFamilia ASC , CR.IdCurso DESC


