SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:				dbo.PR_SGS_Rpt_ListadoGeneralVehiculos.sql
DESCRPCI�N:			Creaci�n Strored Procedures "Consulta Listado General Veh�culos"
AUTOR:				John Alberto L�pez Hern�ndez
REQUERIMIENTO:		SP38 - Transporte
EMPRESA:			Colegio San Jorge de Inglaterra
FECHA CREACI�N:		11/10/2016
PAR�METROS ENTRADA:	No Aplica
EXCEPCIONES:		No Aplica
---------------------------------------------------------------------
MODIFICACI�N:
AUTOR:
REQUERIMIENTO:
EMPRESA:
FECHA MODIFICACI�N:
********************************************************************/
ALTER  PROCEDURE 
	 [dbo].[PR_SGS_Rpt_ListadoGeneralVehiculos] 
AS
BEGIN

SELECT * FROM (
	
	SELECT 
             BUS.Placa
			,DMR.Descripcion AS Marca
			,DLN.Descripcion AS L�nea
			,BR.DominioNombreRuta
			,Bus.ApellidoConductor + ' ' + Bus.NombreConductor  as NombreConductor
			,Bus.Celular 
			,Bus.Telefono
			,FORMAT(Bus.ResponsabilidadCivil,'dd/MM/yyyy') AS ReponsabilidadCivil
			,FORMAT(Bus.ResponsabilidadContractual,'dd/MM/yyyy') AS ReponsabilidadContraactual
			,FORMAT(Bus.RevisionTecnicoMecanica,'dd/MM/yyyy') AS RevisionTecnicoMecanica
			,FORMAT(Bus.TarjetaOperacion,'dd/MM/yyyy') AS TarjetaOperacion
			,FORMAT(Bus.Soat,'dd/MM/yyyy') AS Soat
			,DM. Descripcion AS Servicio

		FROM BUS AS BUS
			
			INNER JOIN BUSRUTA AS BR ON
			BUS.IDBUS = BR.IDBUS

			INNER JOIN DOMINIO AS DM ON
			BR.DominioJornada = DM.Valor and
			DM.Dominio = 'JornadaTransporte'

			LEFT JOIN DOMINIO AS DMR ON
			BUS.MARCA  =  DMR.VALOR
			AND DMR.DOMINIO = 'MarcaBus'

			LEFT JOIN DOMINIO AS DLN ON
			BUS.LINEA = DLN.VALOR 
			AND DLN.DOMINIO = 'L�neaBus'

		WHERE BR.FechaCalendario = '19000101'

) AS CONSULTAGENERAL
PIVOT (
	max (DominioNombreRuta)
	for  [Servicio] in ([Ma�ana], [Tarde], [Extracurricular adicional])
	)
 AS CONSULTAPIVOT


END
GO
