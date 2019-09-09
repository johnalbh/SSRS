USE [SGS]
GO
/****** Object:  StoredProcedure [dbo].[PR_SGS_Rpt_ResumenFamiliaNumerosas]    Script Date: 7/07/2017 7:48:32 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_ResumenFamiliaNumerosas].sql
DESCRIPCIÓN:			Consulta que muestr las familias con mas de 
						Dos estudiantes activos para un periodolectivo
PARAMETROS:				Seccion + Nivel
RESULTADO:				Listado con las siguientes columnas: 
						Seccion: Nivel: TotalEstudiantes
CREACIÓN:				
REQUERIMIENTO:			
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2017-07-06

----------------------------------------------------------------------
MODIFICACIÓN:			Se hace el cambio en los parametros de generaciòn 
						para que muestre las familias del año 2017

****************************************************************************/
CREATE PROCEDURE 

	 [dbo].[PR_SGS_Rpt_ResumenFamiliaNumerosas]

		@IdP_PeriodoLectivo INT	  		
AS 
BEGIN
SELECT 

	 GR.IdFamilia
	,PR.PrimerApellido +' ' + MD.PrimerApellido  AS NombreFamilia 
	,PR.TipoIdentificacion AS TipoIdentificacionPadre
	,PR.NumeroIdentificacion AS NumeroIdentificacionPadre
	,EST.PrimerApellido +' '+ isNull(EST.SegundoApellido,'') + ' ' + EST.PrimerNombre + ' '+ isNull(EST.SegundoNombre,'') AS NombreEstudiante
	,CR.Nombre AS Curso
	,SEC.Nombre AS Seccion

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

GROUP BY 
	 GR.IdFamilia
	,EST.PrimerApellido
	,EST.SegundoApellido
	,EST.PrimerNombre
	,EST.SegundoNombre
	,PR.TipoIdentificacion
	,PR.NumeroIdentificacion
	,PR.PrimerApellido
	,PR.SegundoApellido
	,PR.PrimerNombre
	,PR.SegundoNombre
	,CR.Nombre
	,MD.PrimerApellido
	,SEC.Nombre

ORDER BY PR.PrimerApellido asc

END 