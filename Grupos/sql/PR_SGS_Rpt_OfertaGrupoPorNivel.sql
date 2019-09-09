/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_OfertaGrupoPorNivel.sql
DESCRIPCIÓN:			Consulta la oferta de grupos para el periodo lectivo Activo.
REQUERIMIENTO:			Reporte Grupos
AUTOR:					John López
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2019-08-30
****************************************************************************/

ALTER PROCEDURE [dbo].[PR_SGS_Rpt_OfertaGrupoPorNivel]			

   @IdNivel        VARCHAR(60), 
   @SalidaEscolar   BIT, 
   @Refuerzo        BIT, 
   @Extracurricular BIT,
   @Otros           BIT

AS
SET LANGUAGE Español
    BEGIN
		DECLARE @Niveles TABLE(Id_Nivel VARCHAR(MAX));
		INSERT INTO @Niveles
		SELECT NIV.Valor
		FROM F_SGS_Split(@IdNivel, ',') AS NIV
	SELECT 

		GR.Id AS IdGrupo,
		GR.Nombre AS NombreGrupo, 
		DOM.Descripcion AS Categoria,
		CONCAT(PR.PrimerApellido + ' ' + ISNULL(PR.SegundoApellido, '') + ' ' + PR.PrimerNombre + ' ' + ISNULL(PR.SegundoNombre, ''), +',' +	
		ISNULL(STUFF((SELECT  
				','+PR.PrimerApellido + ' ' + ISNULL(PR.SegundoApellido, '') + ' ' + PR.PrimerNombre + ' ' + ISNULL(PR.SegundoNombre, ''),
			    ','+PRA.PrimerApellido + ' ' + ISNULL(PRA.SegundoApellido, '') + ' ' + PRA.PrimerNombre + ' ' + ISNULL(PRA.SegundoNombre, '')

	 		 FROM GrupoEmpleado AS GEM INNER JOIN Persona AS PRA ON
			 	GEM.TipoIdentificacionEmpleado = PRA.TipoIdentificacion 
				AND GEM.NumeroIdentificacionEmpleado = PRA.NumeroIdentificacion
			  WHERE GEM.IdGrupo = GR.Id FOR XML PATH('')), 1,1, ''),'')  )  AS Responsable,

		NV.Nombre AS Nivel,
		NV.IdNivel AS IdNivel,
		 ISNULL((SELECT TOP 1
		 		'X'
 		 FROM SESION AS SES1 WHERE SES1.IdGrupo = GR.Id AND DATEPART(weekday, SES1.Fecha) = 1 ), '') AS Lunes,

		 ISNULL((SELECT TOP 1
		 		'X'
 		 FROM SESION AS SES2 WHERE SES2.IdGrupo = GR.Id AND DATEPART(weekday, SES2.Fecha) = 2 ), '') AS Martes,

		 ISNULL((SELECT TOP 1
		 		'X'
 		 FROM SESION AS SES3 WHERE SES3.IdGrupo = GR.Id AND DATEPART(weekday, SES3.Fecha) = 3 ), '') AS Miercoles,

		 ISNULL((SELECT TOP 1
		 		'X'
 		 FROM SESION AS SES4 WHERE SES4.IdGrupo = GR.Id AND DATEPART(weekday, SES4.Fecha) = 4 ), '') AS Jueves,

		 ISNULL((SELECT TOP 1
		 		'X'
 		 FROM SESION AS SES5 WHERE SES5.IdGrupo = GR.Id AND DATEPART(weekday, SES5.Fecha) = 5 ), '') AS Viernes,

		 ISNULL((SELECT TOP 1
		 		'X'
 		 FROM SESION AS SES5 WHERE SES5.IdGrupo = GR.Id AND DATEPART(weekday, SES5.Fecha) = 6 ), '') AS Sabados,

		 (SELECT COUNT(1) FROM dbo.GrupoEstudiante AS GRESTU WHERE GRESTU.EstudianteActivo = 'Activo' AND GRESTU.IdGrupo = GR.Id) AS CuposTomados


		 /* ***************************************
		 ------Si quieren implementar no muestre x si no una fecha dejo esta línea para que se orienten --
		 ISNULL(STUFF((SELECT TOP 10   
			','+ CONVERT(nvarchar, SES6.Fecha, 6)
 		 FROM SESION AS SES6 WHERE SES6.IdGrupo = GR.Id AND DATEPART(weekday, SES6.Fecha) = 7 FOR XML PATH('')), 1,1, ''),'') AS Sabados
		 
		 */



	FROM Grupo  AS GR 
	INNER JOIN TipoGrupo AS TG ON
	GR.IdTipoGrupo = TG.Id
	AND ((TG.Refuerzo = @Refuerzo AND @Refuerzo = 1) OR (TG.SalidaEscolar = @SalidaEscolar AND @SalidaEscolar = 1) OR (TG.Extracurricular = @Extracurricular AND @Extracurricular = 1) 
	                  OR IIF(TG.Refuerzo = 0
                              AND TG.SalidaEscolar = 0
                              AND TG.Extracurricular = 0, 1, 0) = @Otros
                       AND @Otros = 1)
	INNER JOIN Dominio AS DOM ON 
	TG.Categoria = DOM.Dominio 
	AND GR.Categoria = DOM.Valor
	INNER JOIN Persona AS PR ON
	GR.TipoIdentificacionEmpleado = PR.TipoIdentificacion 
	AND GR.NumeroIdentificacionEmpleado = PR.NumeroIdentificacion
	INNER JOIN GRUPONIVEL AS GRN ON
	GR.Id = GRN.IdGrupo

	INNER JOIN PeriodoLectivo AS PL ON
	PL.AnioActivo = 1 AND 
	(GR.FechaInicio >= PL.FechaInicioPeriodo  AND GR.FechaInicio <=PL.FechaFinPeriodo)
	INNER JOIN Nivel AS NV ON
	GRN.IdNivel  = NV.IdNivel
	INNER JOIN @Niveles AS TNVL ON
	TNVL.Id_Nivel = GRN.IdNivel

	ORDER BY NV.IdNivel ASC, GR.Nombre ASC 

END 


