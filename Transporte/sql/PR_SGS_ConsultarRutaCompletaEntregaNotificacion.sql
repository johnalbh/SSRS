USE [SGS];  
GO  
/********************************************************************
NOMBRE:				dbo.PR_SGS_ConsultarRutaCompletaEntregaNotificacion.sql
DESCRPCI�N:			Creaci�n Strored Procedures "Consulta Ruta Completa, Reporte
					Entrega de Notificaci�n"
AUTOR:				John Alberto L�pez Hern�ndez
REQUERIMIENTO:		SP36 - Transporte
EMPRESA:			Colegio San Jorge de Inglaterra
FECHA CREACI�N:		03-08-2016
PAR�METROS ENTRADA:	No Aplica
EXCEPCIONES:		No Aplica
---------------------------------------------------------------------
MODIFICACI�N:		
AUTOR:				
REQUERIMIENTO:		
EMPRESA:			
FECHA MODIFICACI�N:	
********************************************************************/

ALTER PROCEDURE 
	[dbo].[PR_SGS_ConsultarRutaCompletaEntregaNotificacion]
(
	@iP_RutaManana NVARCHAR = NULL
)    
AS   
BEGIN

	DECLARE @TempRutasPlantilla TABLE
		(
			 tmpTipoIdentificacion Varchar(10) NULL
			,tmpnumeroIdentificacion Varchar(20) 
			,NombrePasajero Varchar (100) NULL
			,CodigoEstudiante Varchar (100) NULL
			,RutaManana Varchar(10)
			,idBusrutamanana INT NULL
			,AuxMana Varchar (100) NULL
			,CelRutaMana Varchar (100) NULL
			,Rutatarde Varchar(100)
			,idBusrutaTarde INT NULL   
			,AuxTarde Varchar (100) NULL
			,CelRutaTarde Varchar (100) NULL
		); 
		/********************************************************************
		--INSERCI�N DE REGISTROS DE PARA LA MA�ANA 
		********************************************************************/
		INSERT INTO @TempRutasPlantilla 
			(
				 tmpTipoIdentificacion
				,tmpnumeroIdentificacion
				,NombrePasajero
				,CodigoEstudiante
				,rutamanana
				,idBusrutamanana
				,AuxMana
				,CelRutaMana
			)
		SELECT	 PR.TipoIdentificacionPasajero
				,PR.NumeroIdentificacionPasajero
				,PER.PrimerApellido + ' ' + PER.SEGUNDOAPELLIDO + ' ' + PER.PRIMERNOMBRE + ' ' +PER.SEGUNDONOMBRE  AS NombrePasajero
				,EST.CODIGOESTUDIANTE
				,BR.DominioNombreRuta
				,PR.IdPersonaRuta
				,PERAUX.PrimerApellido + '' + PERAUX.SEGUNDOAPELLIDO + ' ' + PERAUX.PRIMERNOMBRE + ' ' +PERAUX.SEGUNDONOMBRE  AS NombreAuxiliarManana
				,BUS.Celular

		FROM PersonaRuta AS PR
				JOIN BUSRUTA BR ON 
					PR.IdBusRuta = BR.IdBusRuta 
				JOIN PERSONA AS PER ON  
					PR.TipoIdentificacionPasajero   = PER.TipoIdentificacion and
					PR.NumeroIdentificacionPasajero = PER.Numeroidentificacion 
				JOIN PERSONA AS PERAUX ON
					BR.NumeroIdentificacionAsistente = PERAUX.NumeroIdentificacion and
					BR.TipoIdentificacionAsistente = PERAUX.TipoIdentificacion 					
				JOIN BUS AS BUS ON 
					BR.IdBus= BUS.IDBUS
				JOIN ESTUDIANTE AS EST ON 
					PER.TipoIdentificacion = EST.TIPOIDENTIFICACION and
					PER.Numeroidentificacion = EST.NUMEROIDENTIFICACION
		WHERE 			
				BR.FechaCalendario = '19000101' 
				AND BR.DominioJornada = '11'
		/********************************************************************
		--INSERCI�N DE REGISTROS PARA LA TARDE
		********************************************************************/
		DECLARE @TempRutastarde TABLE  
		(
			tmpTardeTipoIdentificacion Varchar(10) NULL
			,tmpTardenumeroIdentificacion Varchar(20) 
			,RutaTarde Varchar(100)
		    ,NombrePasajero Varchar (100)
			,idBusrutatarde INT NULL
			,AuxTarde Varchar (100) NULL
			,CelRutaTarde Varchar (100) NULL
		); 
		INSERT INTO @TempRutasTarde
			(
				 tmpTardeTipoIdentificacion
				,tmpTardenumeroIdentificacion
				,RutaTarde
				,idBusrutatarde
				,AuxTarde
				,CelRutaTarde
			)
		SELECT 
			 PR.TipoIdentificacionPasajero
			,PR.NumeroIdentificacionPasajero
			,BR.DominioNombreRuta
			,PR.IdPersonaRuta 
		    ,PERAUX.PrimerApellido + '' + PERAUX.SEGUNDOAPELLIDO + ' ' + PERAUX.PRIMERNOMBRE + ' ' +PERAUX.SEGUNDONOMBRE  AS NombreAuxiliarManana
			,BUS.Celular
		FROM 
			PersonaRuta AS PR
			   INNER JOIN BUSRUTA AS BR ON  
					PR.IDBUSRUTA = BR.IdBusRuta 
			   INNER JOIN PERSONA AS PERAUX ON
					BR.NumeroIdentificacionAsistente = PERAUX.NumeroIdentificacion and
					BR.TipoIdentificacionAsistente = PERAUX.TipoIdentificacion 	
			   INNER JOIN BUS AS BUS ON 
					BR.IdBus = BUS.IDBUS	
		WHERE 
				BR.FechaCalendario = '19000101' 
				AND BR.DominioJornada = '21'
		/********************************************************************
		--Update DE REGISTROS DE PARA la tarde
		********************************************************************/
		UPDATE @TempRutasPlantilla

		SET 
			 Rutatarde =  RT.RutaTarde
			,idBusrutaTarde = RT.IdBusrutatarde
			,AuxTarde = RT.AuxTarde
			,CelRutaTarde = RT.CelRutaTarde
		FROM @TempRutastarde AS RT

		WHERE tmpTipoIdentificacion = rt.tmpTardeTipoIdentificacion and tmpNumeroIdentificacion = rt.tmpTardenumeroIdentificacion

		/***********************************************************************
		--SELECT * FROM 
		*************************************************************************/
		SELECT 
				TMP.tmpTipoIdentificacion AS TipoIdentificacion
			   ,TMP.tmpnumeroIdentificacion AS NumeroIdentificacion
			   ,TMP.NombrePasajero AS NombrePasajero
			   ,TMP.CodigoEstudiante as CodigoEstudiante
			   ,PRMAN.Orden as OrdenManana
			   ,TMP.RutaManana
			   ,PRMAN.Hora AS HoraManana
			   ,PRMAN.DireccionParadero AS DireccionParaderoManana 
			   ,TMP.AuxMana
			   ,TMP.CelRutaMana
			   ,PRTAR.Orden as OrdenTarde
			   ,TMP.RutaTarde
			   ,TMP.AuxTarde
			   ,PRTAR.Hora AS HoraTarde
			   ,PRTAR.DireccionParadero AS DireccionParaderoTarde
			   ,TMP.CelRutaTarde

		 FROM @TempRutasPlantilla as TMP
				   LEFT JOIN PRERUTA AS PRMAN ON 
						TMP.idBusrutaManana  = PRMAN.IdPersonaRuta 
				   LEFT JOIN PRERUTA AS PRTAR ON 
						TMP.idBusrutaTarde = PRTAR.IdPersonaRuta
		WHERE TMP.RutaManana =  @iP_RutaManana OR @iP_RutaManana IS NULL
		ORDER BY RutaManana ASC, PRMAN.Orden ASC

END
	





