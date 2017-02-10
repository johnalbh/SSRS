/********************************************************************
NOMBRE:					dbo.vw_TallaGeneroDesviaciones.sql
DESCRIPCI�N:			Muestra el listado con la combinatoria de g�neros y desviaciones de talla.  
RESULTADO:				Contiene las siguientes columas:
						Genero: (F � M )
						TallaDesviaci�n: Identificaci�n de la desviaci�n de talla (T-2,T-1, etc)
						TallaComentario: Descripci�n en palabras de la desviaci�n
						RangoDesviaci�n:  Rango de cada valor de las desviaciones posibles para la talla
CREACI�N 
---------------------------------------------------------------------------
REQUERIMIENTO:			Reportes de Nutrici�n
AUTOR:					John Alberto L�pez Hern�ndez y Luisa Lamprea 
EMPRESA:				Saint George�s School  
FECHA DE CREACI�N:		2016-12-06
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


	  



