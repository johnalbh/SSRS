/********************************************************************
NOMBRE:					dbo.vw_TallaGeneroDesviaciones.sql
DESCRIPCIÓN:			Muestra el listado con la combinatoria de géneros y desviaciones de talla.  
RESULTADO:				Contiene las siguientes columas:
						Genero: (F ó M )
						TallaDesviación: Identificación de la desviación de talla (T-2,T-1, etc)
						TallaComentario: Descripción en palabras de la desviación
						RangoDesviación:  Rango de cada valor de las desviaciones posibles para la talla
CREACIÓN 
---------------------------------------------------------------------------
REQUERIMIENTO:			Reportes de Nutrición
AUTOR:					John Alberto López Hernández y Luisa Lamprea 
EMPRESA:				Saint George´s School  
FECHA DE CREACIÓN:		2016-12-06
----------------------------------------------------------------------------
****************************************************************************/

CREATE VIEW 

	VW_TallaGeneroDesviaciones

AS

SELECT 

	 GENERO.VALOR AS Genero 
	,TCOM.VALOR	  AS TallaComentario 
	,TCOM.Descripcion AS ComentarioDescripcion
	,TDES.Descripcion  AS RangoDesviacion


FROM DOMINIO AS GENERO

INNER JOIN DOMINIO AS TCOM
ON TCOM.Dominio = 'TallaComentario'

INNER JOIN DOMINIO AS TDES
ON TDES.Dominio = 'TallaDesviacion'
AND TCOM.Valor = TDES.Valor

WHERE GENERO.DOMINIO = 'Genero'


	  



