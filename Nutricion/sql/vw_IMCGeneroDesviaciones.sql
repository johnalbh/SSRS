CREATE VIEW  vw_IMCGeneroDesviaciones
AS
SELECT        GENERO.Valor AS Genero, ICOM.Valor AS IMCComentario, ICOM.Descripcion AS ComentarioDescripcion, IDES.Descripcion AS RangoDesviacion, IDES.Criterio, GENERO.Descripcion AS DescripcionGenero
FROM            dbo.Dominio AS GENERO INNER JOIN
                         dbo.Dominio AS ICOM ON ICOM.Dominio = 'IMCComentario' INNER JOIN
                         dbo.Dominio AS IDES ON IDES.Dominio = 'IMCDesviacion' AND ICOM.Valor = IDES.Valor
WHERE        (GENERO.Dominio = 'Genero')