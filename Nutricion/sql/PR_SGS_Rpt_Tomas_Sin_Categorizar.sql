/********************************************************************
NOMBRE:					dbo.PR_SGS_Rpt_PR_SGS_Rpt_Tomas_Sin_Categorizar.sql
DESCRIPCIÓN:			Muestra los estudiantes con tomas sin categorizar.
RESULTADO:				Listado con las siguientes columnas: 
						Nombres, Apellidos, Curso, Peso, Talla, IMC, Usuario, fechaNacimiento, Observaciones 
						(* si el estudiante está inactivo, vacío si está activo).
						La consulta se entrega ordenada alfabéticamente por apellidos y nombres del estudiante y por nombre del grupo	
CREACIÓN 
REQUERIMIENTO:			Reportes de Transporte
AUTOR:					John Alberto López Hernández
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2016-06-22
----------------------------------------------------------------------------
****************************************************************************/
ALTER PROCEDURE [dbo].[PR_SGS_Rpt_Tomas_Sin_Categorizar] 

		 @idP_Toma INT
		,@idP_Anio INT
AS
BEGIN

SELECT 
           ISNULL(p.PrimerNombre, '') + ' ' + ISNULL(p.SegundoNombre, '') AS Nombres
         , ISNULL(p.PrimerApellido, '') + ' ' + ISNULL(p.SegundoApellido, '') AS Apellidos
         , C.Nombre AS Curso
         , ISNULL(CAST(ept.Peso AS varchar(4)),'') AS Peso
         , ISNULL(CAST(ept.talla AS varchar(4)),'') AS Talla
		 , ISNULL(CAST(ept.imc AS varchar(4)),'') AS IMC
         , ISNULL(ept.UsuarioLog,'') AS Usuario
         , p.fechaNacimiento AS FechaNacimiento
		 , IIF(EC.estado = 'Retirado', EC.Estado , 
				IIF(ept.tipoimc = 'Sin categorizar', ept.tipoIMC,
					IIF(ept.Peso IS NULL AND ept.talla IS NULL, 'Sin Toma Registrada', 
						IIF(ept.Peso IS NULL AND ept.talla IS NOT NULL, 'Toma Incompleta', 'Toma Incompleta'
							)))) AS Observaciones

FROM 
	   Persona AS P
       INNER JOIN EstudianteCurso AS EC  
       ON EC.NumeroIdentificacionEstudiante = P.NumeroIdentificacion
       INNER JOIN Curso AS C 
	   ON EC.idcurso = C.idCurso 
	   AND C.ANIOACADEMICO = @idP_Anio
       INNER JOIN Nivel AS N 
       ON N.IdNivel = C.IdNivel
       LEFT JOIN EstudiantePesoTalla EPT ON EPT.NumeroIdentificacion = EC.NumeroIdentificacionEstudiante 
	   AND EPT.TipoIdentificacion = EC.TipoIdentificacionEstudiante AND EPT.IdToma = @idP_Toma AND EPT.IdAnioAcademico = @idP_Anio

       WHERE 
	
		(EPT.TipoIMC IS NULL ) OR (EPT.TipoIMC = 'Sin categorizar')

       ORDER BY 
	   C.IdCurso, P.PrimerApellido


END

