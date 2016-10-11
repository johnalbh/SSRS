SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
NOMBRE:				dbo.PR_SGS_Rpt_ListadoGeneralVehiculos.sql
DESCRPCIÓN:			Creación Strored Procedures "Consulta Listado General Vehículos"
AUTOR:				John Alberto López Hernández
REQUERIMIENTO:		SP38 - Transporte
EMPRESA:			Colegio San Jorge de Inglaterra
FECHA CREACIÓN:		11/10/2016
PARÁMETROS ENTRADA:	No Aplica
EXCEPCIONES:		No Aplica
---------------------------------------------------------------------
MODIFICACIÓN:
AUTOR:
REQUERIMIENTO:
EMPRESA:
FECHA MODIFICACIÓN:
********************************************************************/
ALTER  PROCEDURE 
	 [dbo].[PR_SGS_Rpt_ListadoGeneralVehiculos] 
AS
BEGIN

SELECT * FROM (
	
	SELECT 
             BUS.Placa
			,DMR.Descripcion AS Marca
			,DLN.Descripcion AS Línea
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
			AND DLN.DOMINIO = 'LíneaBus'

		WHERE BR.FechaCalendario = '19000101'

) AS CONSULTAGENERAL
PIVOT (
	max (DominioNombreRuta)
	for  [Servicio] in ([Mañana], [Tarde], [Extracurricular adicional])
	)
 AS CONSULTAPIVOT


END
GO
