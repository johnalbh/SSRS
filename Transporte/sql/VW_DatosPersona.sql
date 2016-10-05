CREATE VIEW vw_datospersona AS
select p.PrimerApellido+' '+ p.SegundoApellido+' '+ p.PrimerNombre+' '+ p.SegundoNombre AS Nombre
, c.nombre AS Curso
, c.idcurso
, c.anioAcademico
, n.nombre AS Nivel
, n.IdNivel
, p.celular
, p.Numeroidentificacion
, p.TipoIdentificacion
, d.Direccion
, d.TelefonoDireccion
, madre.celular AS CelularMadre
, padre.celular AS CelularPadre
from persona p
inner join grupofamiliar gf on gf.TipoIdentificacionMiembro = p.TipoIdentificacion and gf.NumeroIdentificacionMiembro = p.NumeroIdentificacion
inner join familia f on f.IdFamilia = gf.IdFamilia
inner join direccion d on f.IdFamilia = d.IdGrupoFamiliar and d.DireccionPrincipal=1
inner join persona madre on f.TipoDocumentoMadre = madre.TipoIdentificacion and f.NumeroDocumentoMadre = madre.NumeroIdentificacion
inner join persona padre on f.TipoDocumentoPadre = padre.TipoIdentificacion and f.NumeroDocumentoPadre = padre.NumeroIdentificacion
inner join EstudianteCurso ec on ec.TipoIdentificacionEstudiante = p.TipoIdentificacion and ec.NumeroIdentificacionEstudiante = p.NumeroIdentificacion and ec.Estado <> 'Retirado'
inner join curso c on c.IdCurso = ec.IdCurso 
inner join nivel n on n.IdNivel = c.IdNivel
inner join PeriodoLectivo pl on c.AnioAcademico = pl.id and pl.AnioActivo=1
where concat(p.TipoIdentificacion, p.NumeroIdentificacion) in (select concat(e.TipoIdentificacion, e.NumeroIdentificacion) from Estudiante e)
UNION
select p.PrimerApellido+' '+ p.SegundoApellido+' '+ p.PrimerNombre+' '+ p.SegundoNombre AS Nombre
, '' AS Curso
, NULL AS idCurso
, NULL AS AnioAcademico
, '' AS Nivel
, NULL AS IdNivel
, p.celular
, p.Numeroidentificacion
, p.TipoIdentificacion
, d.Direccion
, d.TelefonoDireccion
, '' AS CelularMadre
, '' AS CelularPadre
from persona p
inner join familia f on (p.TipoIdentificacion = f.TipoDocumentoPadre and p.NumeroIdentificacion= f.NumeroDocumentoPadre) or (p.TipoIdentificacion = f.TipoDocumentoMadre and p.NumeroIdentificacion= f.NumeroDocumentoMadre)
inner join direccion d on f.IdFamilia = d.IdGrupoFamiliar and d.DireccionPrincipal=1
where concat(p.TipoIdentificacion, p.NumeroIdentificacion) in (select concat(e.TipoIdentificacion, e.NumeroIdentificacion) from Empleado e)

