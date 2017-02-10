SELECT 


-- EPT.IdToma
--,TOM.Descripcion
EPT.TipoTalla
,CR.Nombre
--,NV.Nombre
--,SEC.Nombre
--,PL.Descripcion
,COUNT (*)


FROM EstudiantePesoTalla AS EPT

INNER JOIN EstudianteCurso AS EC 

ON EPT.TipoIdentificacion = EC.TipoIdentificacionEstudiante
AND EPT.NumeroIdentificacion = EC.NumeroIdentificacionEstudiante

INNER JOIN CURSO AS CR
ON EC.IdCurso = CR.IdCurso 

INNER JOIN NIVEL AS NV
ON CR.IdNivel = NV.IdNivel

INNER JOIN SECCION AS SEC
ON NV.IdSeccion = SEC.IdSeccion

INNER JOIN PeriodoLectivo AS PL 
ON CR.AnioAcademico = PL.Id
AND EPT.IdAnioAcademico = PL.Id

RIGHT JOIN VW_TallaGeneroDesviaciones AS DESV
ON EPT.TipoTalla = DESV.TallaComentario 

LEFT JOIN Dominio AS TOM  
ON TOM.Valor = EPT.IdToma 
AND TOM.Dominio = 'TomaPesoTalla'

GROUP BY  

	-- EPT.IdToma
	--,TOM.Descripcion
	   EPT.TipoTalla
	  ,CR.Nombre
	--,NV.Nombre
	--,SEC.Nombre
	--,PL.Descripcion


--ORDER BY 
--	 EPT.IdToma ASC
--	,EPT.TipoTalla ASC
--	,CR.IdCurso ASC


