SELECT        GENERO.Valor AS Genero, GENERO.Descripcion AS DescripcionGenero, TCOM.Valor AS TallaComentario, TCOM.Descripcion AS ComentarioDescripcion, TDES.Descripcion AS RangoDesviacion, 
                         TCOM.Criterio
FROM            dbo.Dominio AS GENERO INNER JOIN
                         dbo.Dominio AS TCOM ON TCOM.Dominio = 'TallaComentario' INNER JOIN
                         dbo.Dominio AS TDES ON TDES.Dominio = 'TallaDesviacion' AND TCOM.Valor = TDES.Valor
WHERE        (GENERO.Dominio = 'Genero')