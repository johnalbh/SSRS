SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:				dbo.PR_SGS_Rpt_ConsultaMedicaEmpleadosTriage.sql
DESCRPCI�N:			Creaci�n Strored Procedures "Registro Consulta Medica 
					Empleados Clasificaci�n por Triage" Se seleccionan unos 
					parametros de entradas que son fecha inicio y fecha fin
					que el rango a consultar y triage.
AUTOR:				John Alberto L�pez Hern�ndez
REQUERIMIENTO:		Servicio M�dico
EMPRESA:			Colegio San Jorge de Inglaterra
FECHA CREACI�N:		30/08/2017
PAR�METROS ENTRADA:	@FechaInicio y @FechaFin
EXCEPCIONES:		No Aplica
---------------------------------------------------------------------
MODIFICACI�N:
AUTOR:
REQUERIMIENTO:
EMPRESA:
FECHA MODIFICACI�N:
********************************************************************/
CREATE PROCEDURE 
	 [dbo].[PR_SGS_Rpt_ConsultaMedicaEmpleadosTriage] 

        @pFechaInicio as DateTime
       ,@pFechaFin as  DateTime
AS
BEGIN
	DECLARE  
        @FechaInicio as Date =  Convert( Date, @pFechaInicio)
       ,@FechaFin    as Date =  Convert( Date, @pFechaFin)
SELECT 

       PR.PrimerApellido + ' ' + isNull(PR.SegundoApellido,'') + ' ' + PR.PrimerNombre + ' ' + isNull(PR.SegundoNombre,'') AS NombreEmpleado
      ,EVL.ClasificacionTriage AS Triage
       
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