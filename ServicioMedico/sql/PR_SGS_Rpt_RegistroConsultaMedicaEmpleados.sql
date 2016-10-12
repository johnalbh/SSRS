SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:				dbo.PR_SGS_Rpt_RegistroConsultaMedicaEmpleados.sql
DESCRPCIÓN:			Creación Strored Procedures "Registro Consulta Medica Estudiantes"
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
CREATE PROCEDURE 
	 [dbo].[PR_SGS_Rpt_RegistroConsultaMedicaEmpleados] 

        @pFechaInicio as DateTime
       ,@pFechaFin as  DateTime
AS
BEGIN
	DECLARE  
        @FechaInicio as Date =  Convert( Date, @pFechaInicio)
       ,@FechaFin    as Date =  Convert( Date, @pFechaFin)
SELECT 

       PR.PrimerApellido + ' ' + isNull(PR.SegundoApellido,'') + ' ' + PR.PrimerNombre + ' ' + PR.SegundoNombre AS NombreEmpleado
       ,EVL.Edad AS Edad
       ,EVL.ClasificacionTriage AS Triage
             , isnull (STUFF(
         (SELECT  ', ' + cie.Descripcion
                    FROM DIAGNOSTICO AS DG
                    INNER JOIN CIE10 AS CIE
              ON DG.CODIGOCIE10=CIE.CODIGO 
                    WHERE EVL.Id = DG.IdEvolucion
                    FOR XML PATH ('')) , 1, 1, ''),'')  AS Diagnostico
       ,CRG.Cargo AS Cargo
       ,EVL.FechaIngreso
       
       FROM EMPLEADO AS EMP

       INNER JOIN EVOLUCION AS EVL
       ON EMP.TIPOIDENTIFICACION = EVL.TIPOIDENTIFICACION 
       AND EMP.NUMEROIDENTIFICACION = EVL.NUMEROIDENTIFICACION 

       INNER JOIN PERSONA AS PR
       ON  EMP.TIPOIDENTIFICACION = PR.TIPOIDENTIFICACION 
       AND EMP.NUMEROIDENTIFICACION = PR.NUMEROIDENTIFICACION 

       INNER JOIN CARGO AS CRG
       ON EMP.Cargo = CRG.IdCargo
       
       WHERE EVL.FechaIngreso BETWEEN @FechaInicio AND @FechaFin

       ORDER BY 
       EVL.FechaIngreso ASC, EVL.ClasificacionTriage ASC, PR.PrimerApellido ASC

END
GO


