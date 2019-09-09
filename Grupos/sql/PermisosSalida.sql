/* Consultar el los estudiantes de un curso */
DECLARE 
	
	 @PeriodoLectivo INT = 12
	,@Curso varchar(20) = 'Primero B'
	,@Nivel Varchar(20) = 'Primero'
	,@FechaDia DateTime = DATEADD( hour, -5, GetDate());
DECLARE @Consulta TABLE
	(
		 Id BIGINT IDENTITY
		,NombreEstudiante VARCHAR(403)
		,Curso VARCHAR(50)
		,Codigo VARCHAR(MAX)
	)
INSERT INTO @Consulta
SELECT 
	 PR.PrimerApellido + ' ' + ISNULL(PR.SegundoApellido, '') + ' ' + PR.PrimerNombre + ISNULL(PR.SegundoNombre, '') AS NombreEstudiante
	,CR.Nombre AS Curso
	,ES.CodigoEstudiante AS CodigoEstudiante

FROM EstudianteCurso AS ESC

INNER JOIN Curso AS CR 
ON ESC.IdCurso = CR.IdCurso

INNER JOIN Nivel AS NV
ON CR.IdNivel = NV.IdNivel

INNER JOIN Seccion AS SEC
ON NV.IdSeccion = SEC.IdSeccion

INNER JOIN Estudiante AS  ES
ON ESC.TipoIdentificacionEstudiante = ES.TipoIdentificacion
AND ESC.NumeroIdentificacionEstudiante = ES.NumeroIdentificacion

INNER JOIN Persona AS PR ON 
ESC.TipoIdentificacionEstudiante = PR.TipoIdentificacion
AND ESC.NumeroIdentificacionEstudiante = PR.NumeroIdentificacion


WHERE 
	CR.AnioAcademico = @PeriodoLectivo 
	AND CR.Nombre = 'Primero B'

select * from @Consulta