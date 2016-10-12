DECLARE 
        @pFecha1 as DateTime =   '2016-06-20'
       ,@pFecha2 as  DateTime =  '2016-10-30'
DECLARE  
        @FechaInicio as Date =  Convert( Date, @pFecha1)
       ,@FechaFin    as Date =  Convert( Date, @pFecha2)


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
       EVL.FechaIngreso ASC, PR.PrimerApellido ASC

