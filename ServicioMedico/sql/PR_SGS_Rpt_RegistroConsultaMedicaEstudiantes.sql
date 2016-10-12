SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:				dbo.PR_SGS_Rpt_RegistroConsultaMedicaEstudiantes.sql
DESCRPCIÓN:			Creación Strored Procedures "Registro Consulta Medica Estudiantes"
					Se seleccionan unos parametros de entradas que son fecha inicio y fecha fin
					La consulta realizada busca el curso en que estaba el estudiante cuando se 
					creo el registro en la evolución.
AUTOR:				John Alberto López Hernández
REQUERIMIENTO:		SP38 - Servicio Médico
EMPRESA:			Colegio San Jorge de Inglaterra
FECHA CREACIÓN:		12/10/2016
PARÁMETROS ENTRADA:	@FechaInicio y @FechaFin
EXCEPCIONES:		No Aplica
---------------------------------------------------------------------
MODIFICACIÓN:
AUTOR:
REQUERIMIENTO:
EMPRESA:
FECHA MODIFICACIÓN:
********************************************************************/
ALTER PROCEDURE 
	 [dbo].[PR_SGS_Rpt_RegistroConsultaMedicaEstudiantes] 

        @pFechaInicio as DateTime
       ,@pFechaFin as  DateTime
AS
BEGIN
DECLARE 
        @FechaInicio as Date =   Convert( Date, @pFechaInicio)
       ,@FechaFin as  Date =  Convert( Date, @pFechaFin)

SELECT 

	 PR.PrimerApellido + ' ' + isNull(PR.SegundoApellido,'') + ' ' + PR.PrimerNombre + ' ' + isNull(PR.SegundoNombre,'') AS NombreEstudiante
	,EVL.Edad AS Edad
	,EVL.ClasificacionTriage AS Triage
    ,EVL.HoraInicio AS HoraInicio
    ,EVL.HoraFin AS HoraFin
	,EVL.FechaIngreso	AS FechaIngreso
    ,PR.TipoIdentificacion	AS TipoIdentificacion
    ,PR.NumeroIdentificacion AS NumeroIdentificaicon
    ,CR.Nombre	AS Curso
    ,EVL.Edad	AS EDAD
	, isnull (STUFF(
    (SELECT  ', ' + cie.Descripcion
            FROM DIAGNOSTICO AS DG
            INNER JOIN CIE10 AS CIE
        ON DG.CODIGOCIE10=CIE.CODIGO 
            WHERE EVL.Id = DG.IdEvolucion
            FOR XML PATH ('')) , 1, 1, ''),'')  AS Diagnostico
     ,EVL.SaleHacia   as SaleHacia                 
  
FROM ESTUDIANTE AS EST

	INNER JOIN EVOLUCION AS EVL
	ON EST.TIPOIDENTIFICACION = EVL.TIPOIDENTIFICACION 
	AND EST.NUMEROIDENTIFICACION = EVL.NUMEROIDENTIFICACION 

	INNER JOIN PERSONA AS PR
	ON  EST.TIPOIDENTIFICACION = PR.TIPOIDENTIFICACION 
	AND EST.NUMEROIDENTIFICACION = PR.NUMEROIDENTIFICACION 

	INNER JOIN ESTUDIANTECURSO AS ESC 
	ON EST.TIPOIDENTIFICACION = ESC.TIPOIDENTIFICACIONESTUDIANTE
	AND EST.NUMEROIDENTIFICACION = ESC.NUMEROIDENTIFICACIONESTUDIANTE

	INNER JOIN CURSO AS CR
	ON ESC.IdCurso = CR.IdCurso

	INNER JOIN NIVEL AS NVL
	ON CR.IdNivel = NVL.IdNivel

	INNER JOIN SECCION AS SCC
	ON NVL.IdSeccion = SCC.IdSeccion

	INNER JOIN PERIODOLECTIVO AS PL
	ON PL.FechaInicioPeriodo <= EVL.FechaIngreso AND EVL.FechaIngreso <= PL.FechaFinPeriodo  and
	CR.AnioAcademico = PL.Id
       
WHERE 
	EVL.FechaIngreso BETWEEN @FechaInicio AND @FechaFin              


ORDER BY 
	EVL.FECHAINGRESO ASC, PR.PrimerApellido ASC

END
GO


