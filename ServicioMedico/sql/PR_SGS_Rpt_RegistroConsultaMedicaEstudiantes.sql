SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:				dbo.PR_SGS_Rpt_RegistroConsultaMedicaEstudiantes.sql
DESCRPCI�N:			Creaci�n Strored Procedures "Registro Consulta Medica Estudiantes"
					Se seleccionan unos parametros de entradas que son fecha inicio y fecha fin
					La consulta realizada busca el curso en que estaba el estudiante cuando se 
					creo el registro en la evoluci�n.
AUTOR:				John Alberto L�pez Hern�ndez
REQUERIMIENTO:		SP38 - Servicio M�dico
EMPRESA:			Colegio San Jorge de Inglaterra
FECHA CREACI�N:		12/10/2016
PAR�METROS ENTRADA:	@FechaInicio y @FechaFin
EXCEPCIONES:		No Aplica
---------------------------------------------------------------------
MODIFICACI�N:       Implementaci�n de Parametros por Secci�n, Nivel y Curso
AUTOR:				John Alberto L�pez Hern�ndez		
REQUERIMIENTO:		Servicio M�dico
FECHA MODIFICACI�N: 21 de Marzo de 2017
********************************************************************/
ALTER PROCEDURE 
	 [dbo].[PR_SGS_Rpt_RegistroConsultaMedicaEstudiantes] 
		 @pFechaInicio as DateTime
		,@pFechaFin as  DateTime
		,@idp_PeriodoLectivo VARCHAR (50)
		,@idP_Seccion VARCHAR (60) 
		,@idP_Nivel VARCHAR (60) 
		,@idP_Curso VARCHAR (max)
AS
BEGIN
DECLARE @Cursos TABLE 
	(
		 IdCursoSeleccionado VARCHAR(1000)
	)
INSERT INTO @Cursos
SELECT CR.Valor 
FROM F_SGS_Split(@idP_Curso, ',') AS CR

DECLARE 
        @FechaInicio AS Date = Convert( Date, @pFechaInicio)
       ,@FechaFin AS Date = Convert( Date, @pFechaFin)
SELECT 

	 PR.PrimerApellido + ' ' + isNull(PR.SegundoApellido,'') + ' ' + PR.PrimerNombre + ' ' + isNull(PR.SegundoNombre,'') AS NombreEstudiante
	,EVL.Edad AS Edad
	,EVL.ClasificacionTriage AS Triage
    ,EVL.HoraInicio AS HoraInicio
    ,EVL.HoraFin AS HoraFin
	,EVL.FechaIngreso	AS FechaIngreso
    ,PR.TipoIdentificacion + ' ' + PR.NumeroIdentificacion AS NumeroIdentificacion
	,CR.IdCurso AS IdCurso
    ,CR.Nombre	AS Curso
    ,EVL.Edad	AS Edad
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
		
	INNER JOIN @Cursos AS CURS
	ON CR.IdCurso = CURS.IdCursoSeleccionado
       
WHERE 
	EVL.FechaIngreso BETWEEN @FechaInicio AND @FechaFin              


ORDER BY 
	 EVL.FECHAINGRESO ASC
	,CR.IdCurso ASC
	,PR.PrimerApellido ASC
END
GO
