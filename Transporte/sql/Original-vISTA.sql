SELECT p.PrimerApellido + ISNULL(' ' + p.SegundoApellido, '') + ' ' + p.PrimerNombre + ISNULL(' ' + p.SegundoNombre, '') AS Nombre, 
       c.nombre AS Curso, 
       c.idcurso, 
       c.anioAcademico, 
       n.nombre AS Nivel, 
       n.IdNivel, 
       p.celular, 
       p.Numeroidentificacion, 
       p.TipoIdentificacion, 
       madre.celular AS CelularMadre, 
       padre.celular AS CelularPadre
FROM persona p
     INNER JOIN grupofamiliar gf WITH(NOLOCK) ON gf.TipoIdentificacionMiembro = p.TipoIdentificacion
                                                 AND gf.NumeroIdentificacionMiembro = p.NumeroIdentificacion
     INNER JOIN familia f WITH(NOLOCK) ON f.IdFamilia = gf.IdFamilia
                                          AND gf.familiaprincipal = 1
     INNER JOIN persona madre WITH(NOLOCK) ON f.TipoDocumentoMadre = madre.TipoIdentificacion
                                              AND f.NumeroDocumentoMadre = madre.NumeroIdentificacion
     INNER JOIN persona padre WITH(NOLOCK) ON f.TipoDocumentoPadre = padre.TipoIdentificacion
                                              AND f.NumeroDocumentoPadre = padre.NumeroIdentificacion
     INNER JOIN EstudianteCurso ec WITH(NOLOCK) ON ec.TipoIdentificacionEstudiante = p.TipoIdentificacion
                                                   AND ec.NumeroIdentificacionEstudiante = p.NumeroIdentificacion
                                                   AND ec.Estado <> 'Retirado'
     INNER JOIN PeriodoLectivo pl WITH(NOLOCK) ON pl.AnioActivo = 1
	 INNER JOIN curso c ON c.IdCurso = ec.IdCurso
                           AND c.AnioAcademico = pl.Id
     INNER JOIN nivel n ON n.IdNivel = c.IdNivel
UNION
SELECT(ISNULL(p.PrimerApellido, '') + ' ' + ISNULL(p.SegundoApellido, '')) + ' ' + ISNULL(p.PrimerNombre, '') + ' ' +ISNULL(p.SegundoNombre, '') + ' ' AS Nombre, 
      '' AS Curso, 
      NULL AS idCurso, 
      NULL AS AnioAcademico, 
      '' AS Nivel, 
      NULL AS IdNivel, 
      p.celular, 
      p.Numeroidentificacion, 
      p.TipoIdentificacion, 
      '' AS CelularMadre, 
      '' AS CelularPadre
FROM persona p
     INNER JOIN familia f WITH(NOLOCK) ON(p.TipoIdentificacion = f.TipoDocumentoPadre
                                          AND p.NumeroIdentificacion = f.NumeroDocumentoPadre)
                                         OR (p.TipoIdentificacion = f.TipoDocumentoMadre
                                             AND p.NumeroIdentificacion = f.NumeroDocumentoMadre)
     INNER JOIN grupofamiliar gf WITH(NOLOCK) ON gf.IdFamilia = f.IdFamilia
                                                 AND gf.familiaprincipal = 1
                                                 AND gf.numeroidentificacionmiembro = p.NumeroIdentificacion
                                                 AND p.TipoIdentificacion = gf.TipoIdentificacionMiembro
WHERE concat(p.TipoIdentificacion, p.NumeroIdentificacion) IN
(
    SELECT concat(e.TipoIdentificacion, e.NumeroIdentificacion)
    FROM Empleado e
);

