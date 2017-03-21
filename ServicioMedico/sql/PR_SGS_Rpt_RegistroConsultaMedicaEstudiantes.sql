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
		,@idp_PeriodoLectivo VARCHAR (50)
		,@idP_Seccion INT 
		,@idP_Nivel VARCHAR (60) 
		,@idP_Curso VARCHAR (60)
AS
BEGIN
DECLARE @Cursos TABLE 
	(
		 IdCursoSeleccionado VARCHAR(60)
	)

-- Condición que permite evaluar Si selecciono un curso
IF @idP_Curso  <> 0

	INSERT INTO @Cursos 
	
	SELECT CR.Valor 
	FROM F_SGS_Split(@idP_Curso, ',') AS CR
-- Condición para que se inserten todos los cursos de un nivel.
ELSE IF @idP_Nivel <> 0

	INSERT INTO @Cursos 
	SELECT 
		idCurso AS Curso
	FROM 
		Curso 
	WHERE 
	AnioAcademico = @idp_PeriodoLectivo and idNivel = @idP_Nivel
-- Condición para que se inserten todos los cursos de una sección.
ELSE IF @idP_Seccion <> 0 
		
	INSERT INTO @Cursos SELECT 
	 idCurso AS Curso
	FROM Curso AS CR

	INNER JOIN Nivel AS NV ON
	CR.IdNivel = NV.IdNivel
	
	INNER JOIN SECCION AS SEC ON 
	NV.IdSeccion = SEC.IdSeccion
		
	WHERE CR.AnioAcademico = @idp_PeriodoLectivo and NV.IdSeccion = @idP_Seccion

-- Inserte todos los cursos de un periodo lectivo.
ELSE 

	INSERT INTO @Cursos 

	SELECT 
	  CR.idCurso AS Curso
	FROM Curso AS CR
	WHERE CR.AnioAcademico = @idp_PeriodoLectivo
-- Tabla temporal para almacenar los cursos 


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
		
	INNER JOIN @Cursos AS CURS
	ON CR.IdCurso = CURS.IdCursoSeleccionado
       
WHERE 
	EVL.FechaIngreso BETWEEN @FechaInicio AND @FechaFin              


ORDER BY 
	EVL.FECHAINGRESO ASC, CR.IdCurso ASC, PR.PrimerApellido ASC

END
GO