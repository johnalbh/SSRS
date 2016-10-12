DECLARE 
        @pFecha1 as DateTime =   '2016-05-28'
       ,@pFecha2 as  DateTime =  '2016-10-30'
          DECLARE 
        @Fecha1 as Date =   Convert( Date, @pFecha1)
       ,@Fecha2 as  Date =  Convert( Date, @pFecha2)

Declare @anio int = ( select id from periodolectivo
          where  fechainicioperiodo <= @fecha2 and  @fecha2 <= FechaFinPeriodo)

SELECT 

PR.PrimerApellido + ' ' + isNull(PR.SegundoApellido,'') + ' ' + PR.PrimerNombre + ' ' + isNull(PR.SegundoNombre,'') AS NombreEstudiante
,EVL.Edad AS Edad
,EVL.ClasificacionTriage
    ,EVL.HoraInicio
    ,EVL.HoraFin
,EVL.FechaIngreso
    ,PR.TipoIdentificacion
    ,PR.NumeroIdentificacion
    ,CR.Nombre
    ,EVL.Edad
, isnull (STUFF(
    (SELECT  ', ' + cie.Descripcion
            FROM DIAGNOSTICO AS DG
            INNER JOIN CIE10 AS CIE
        ON DG.CODIGOCIE10=CIE.CODIGO 
            WHERE EVL.Id = DG.IdEvolucion
            FOR XML PATH ('')) , 1, 1, ''),'')  AS Diagnostico
        ,EVL.SaleHacia                    
  
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
	EVL.FechaIngreso BETWEEN @Fecha1 AND @Fecha2              


ORDER BY 
	EVL.FECHAINGRESO ASC, PR.PrimerApellido ASC
