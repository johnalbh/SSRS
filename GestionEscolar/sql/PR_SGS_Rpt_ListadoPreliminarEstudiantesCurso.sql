/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_ListadoPreliminarEstudiantesCurso.sql
DESCRIPCIÓN:			Esta consulta sirve para traer todos los estudiantes asignados a un curso
						y su curso anterior.
						Esta compuesto dos secciones:
						Seccion 1: Muestra todos los estudiantes de un nivel seleccionado
						Agrupado por Curso
						Seccion 2: Muestra todos los estudiantes con estado "Pendiente" para el año
						academico anterior al seleccionado:
PARAMETROS:				PeriodoLectivo + Seccion + Nivel
RESULTADO:				Listado con las siguientes columnas: 
						Seccion 1: Nombre (Apellido + Nombre), Curso Actual, Curso Anterior
						Seccion 2: Nombre (Apellido + Nombre), Curso, Estado
CREACIÓN:				
REQUERIMIENTO:			
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2017-05-22
----------------------------------------------------------------------------
MODIFICACIÓN:			Mostrar en la sección de pendientes los estudiantes del 
						mismo nivel. Se agargea variable @NV2 y se pone la condición
						para que muestre los pendiente del mismo nivel y se agrega 
						un In where en el where del segundo caso.
FECHA MODIFICACIÓN:		08 de Junio de 2017
AUTOR:					John Alberto López Hernández
****************************************************************************/
CREATE PROCEDURE 

	 [dbo].[PR_SGS_Rpt_ListadoPreliminarEstudiantesCurso]
	  		
			 @AnioInicialP_PeriodoLectivo INT
			,@idP_Seccion VARCHAR(60)
			,@idP_Nivel VARCHAR(60) 
			,@P_Caso INT 

AS 
BEGIN
--------------------------------------------------------
/* Declaración Tabla Temporal */

DECLARE  @ConsultaEstudiantes TABLE (
			 Curso VARCHAR(60)
			,NombreEstudiante VARCHAR(1000)
			,PeriodoLectivo VARCHAR(100)
			,IdCurso INT
			,IdNivel INT
			,NombreNivel VARCHAR (100)
			,CursoAnterior VARCHAR (100)
			,EstadoEstudiante VARCHAR (100)
			,Matricula VARCHAR (100)
)
/** Consulta Para calcular el PeriodoLectivo Anterior */
DECLARE 

	@PLAN INT,
	@PLAC INT,
	@PL INT,
	@NV INT,
	@NV2 INT
/* COnsulta para información del PeriodoLectivo Anterior */
SELECT @PLAN = PL.Id
FROM PeriodoLectivo AS PL
WHERE AnioInicial = @AnioInicialP_PeriodoLectivo - 1

/* Consulta para información del PeriodoLecitvo Actual  */
SELECT @PLAC = PL.Id
FROM PeriodoLectivo AS PL
WHERE AnioInicial = @AnioInicialP_PeriodoLectivo
--------------------------------------------------------
SET @PL = IIF (@P_Caso  = 1, @PLAC, @PLAN)  
SET @NV = IIF (@P_Caso = 1, @idP_Nivel, @idP_Nivel -1)
SET @NV2 = IIF (@P_Caso = 1, @idP_Nivel, @idP_Nivel)
	
INSERT INTO @ConsultaEstudiantes
SELECT
	 CR.Nombre  AS Curso
	,PR.PrimerApellido +' '+ isNull(PR.SegundoApellido,'') + ' ' + PR.PrimerNombre + ' '+ isNull(PR.SegundoNombre,'') AS NombreEstudiante
	,PL.Descripcion AS PeriodoLectivo
	,CR.IdCurso
	,NV.IdNivel 
	,NV.Nombre
	,(SELECT CR.Nombre 
	  FROM estudiantecurso AS ESC 
			INNER JOIN Curso AS CR
			ON ESC.IdCurso = CR.IdCurso
			INNER JOIN PeriodoLectivo AS PL
			ON CR.AnioAcademico = PL.Id
			INNER JOIN Nivel AS NV
			ON CR.IdNivel = NV.IdNivel
			INNER JOIN Seccion AS SEC
			ON NV.IdSeccion = SEC.IdSeccion
		WHERE CR.AnioAcademico = @PLAN
		and ESC.TipoIdentificacionEstudiante = PR.TipoIdentificacion
		AND ESC.NumeroIdentificacionEstudiante = PR.NumeroIdentificacion

	) AS CursoAnterior
	, ESC.Estado AS Estado
	, CASE WHEN EST.Matricula = '1' THEN 'Si' ELSE  'No' END AS Matricula
FROM EstudianteCurso AS ESC

	/* Curso del Estudiante */

	INNER JOIN Curso AS CR
	ON ESC.IdCurso = CR.IdCurso
	INNER JOIN PeriodoLectivo AS PL
	ON CR.AnioAcademico = PL.Id
	INNER JOIN Nivel AS NV
	ON CR.IdNivel = NV.IdNivel
	INNER JOIN Seccion AS SEC
	ON NV.IdSeccion = SEC.IdSeccion
	INNER JOIN Estudiante AS EST
	ON ESC.TipoIdentificacionEstudiante = EST.TipoIdentificacion
	AND ESC.NumeroIdentificacionEstudiante  = EST.NumeroIdentificacion
	INNER JOIN Persona AS PR
	ON ESC.TipoIdentificacionEstudiante = PR.TipoIdentificacion
	AND ESC.NumeroIdentificacionEstudiante = PR.NumeroIdentificacion

WHERE 
	CR.AnioAcademico = @PL
	AND CR.IdNivel in (@NV , @NV2)
ORDER BY 
	PR.PrimerApellido ASC

IF @P_Caso = 1 
SELECT * FROM @ConsultaEstudiantes

ELSE 
	Select * from @ConsultaEstudiantes Where EstadoEstudiante = 'Pendiente' 
	Order By IdCurso ASC
SELECT @PL
END