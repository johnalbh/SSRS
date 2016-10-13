USE [SGS]
GO
/****** Object:  StoredProcedure [dbo].[PR_SGS_Rpt_CifrasAdmisiones]    Script Date: 13/10/2016 9:09:09 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:				dbo.PR_SGS_Rpt_CifrasAdmisiones.sql
DESCRPCIÓN:			Calcula los indicadores básicos del avance de admisiones comparando el año actual con el anterior
AUTOR:				Luisa Lamprea LLamprea
REQUERIMIENTO:		Admisiones
EMPRESA:		    Colegio San Jorge de Inglaterra
FECHA CREACIÓN:		14-09-2016
PARÁMETROS ENTRADA:	@dP_Indicador: Indicador que se consulta. Puede tener los valores Preinsrito, Inscrito
EXCEPCIONES:		No Aplica
********************************************************************/
ALTER PROCEDURE 
	[dbo].[PR_SGS_Rpt_CifrasAdmisiones]    
	@sP_Indicador Varchar (20)
AS
BEGIN
/**************************************************************************
-- Inicialización de los dos últimos años y sus fechas de inicio de proceso
***********************'***************************************************/
DECLARE @Anio_Actual INT = (select id from PeriodoLectivo WHERE AnioAdmision = 1); -- Periodo Actual de Admisiones
DECLARE @Inicio_Actual Date = (	select DATEADD (DAY, -1, CONVERT (DATE,MIN(preinscripcion))) 
								from Admision
								WHERE periodolectivo_id = @Anio_Actual); -- Fecha de primera Inscripción -1
Declare @Anio_Ant INT =		(select id  -- Periodo anterior
							from PeriodoLectivo 
							WHERE AnioInicial = (select anioInicial from periodoLectivo WHERE Anioadmision = 1) - 1);
Declare @Inicio_Ant Date = ( select DATEADD (DAY, -1, CONVERT (DATE,MIN(preinscripcion))) 
							from Admision WHERE periodolectivo_id = @Anio_Ant);


DECLARE @TempCifrasHistAdmisiones TABLE
(
	Dia INT not null
	, ValorN1 INT  DEFAULT (null)
	, ValorN INT DEFAULT(null)

); 

/********************************************************************
--Se insertan los días pertinentes para el reporte
***********************'*********************************************/
IF @sP_Indicador IN ('Preinscrito', 'Inscrito')
BEGIN 
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (1);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (2);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (3);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (4);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (5);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (6);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (7);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (8);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (9);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (10);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (11);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (12);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (13);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (14);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (15);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (16);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (17);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (18);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (19);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (20);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (21);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (22);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (23);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (24);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (25);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (26);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (27);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (28);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (29);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (30);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (31);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (32);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (33);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (34);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (35);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (40);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (41);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (42);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (43);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (34);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (45);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (50);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (55);
		INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (60);
END
ELSE 
		IF @sP_Indicador = 'Aprobado'

			BEGIN 
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (20);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (21);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (22);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (23);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (24);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (25);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (26);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (27);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (28);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (29);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (30);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (31);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (32);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (33);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (34);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (35);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (40);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (41);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (42);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (43);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (34);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (45);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (50);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (55);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (60);
				END
			ELSE 
				BEGIN
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (30);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (31);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (32);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (33);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (34);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (35);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (40);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (41);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (42);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (43);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (34);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (45);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (50);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (55);
					INSERT INTO @TempCifrasHistAdmisiones ( Dia) VALUES (60);

				END
/**************************************************************************
-- Se actualizan los valores del año anterior para cada uno de los días
-- con el acumulado de aspirantes que pasaron por el estado @sP_Indicador
**************************************************************************/
UPDATE @TempCifrasHistAdmisiones 
SET ValorN1 = (SELECT COUNT(*) 
				FROM Admision AS D 
	INNER JOIN EstadoAdmision EA ON EA.codigo = D.Codigo and EA.Estado = @sP_Indicador
	WHERE D.periodolectivo_id = @Anio_ANT and DATEDIFF (DAY, @Inicio_Ant, CONVERT (DATE, EA.Fecha)) <= Dia);

/**************************************************************************
-- Se actualizan los valores del año actual para cada uno de los días que 
-- van corridos en el proceso, con el acumulado de aspirantes que pasaron 
-- por el estado @sP_Indicador
**************************************************************************/
UPDATE @TempCifrasHistAdmisiones 
Set  ValorN = (SELECT COUNT(*) 
FROM Admision D
	INNER JOIN EstadoAdmision EA ON EA.Codigo = D.Codigo and EA.Estado = @sP_Indicador
	WHERE D.PeriodoLectivo_id = @Anio_Actual and DATEDIFF (DAY, @Inicio_Actual, CONVERT(DATE, EA.Fecha)) <= Dia)
WHERE Dia < GETDATE() - @Inicio_Actual 

/**************************************************************************
-- la tabla Se envía al reporte 
**************************************************************************/
SELECT @sP_Indicador + 's' , Dia, ValorN1, ValorN
, (SELECT Descripcion from PeriodoLectivo WHERE Id = @Anio_Ant) as NombreN1
, (SELECT Descripcion from PeriodoLectivo WHERE Id = @Anio_Actual) as NombreN
FROM @TempCifrasHistAdmisiones 
ORDER BY Dia
END

