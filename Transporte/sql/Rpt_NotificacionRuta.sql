/********************************************************************
NOMBRE:				dbo.Rpt_NotificacionRuta.sql
DESCRPCIÓN:			CONSULTA QUE MUESTRA RUTA MAÑANA Y TARDE DE UN ESTUDIANTE.
AUTOR:				Maritza Zambrano
REQUERIMIENTO:		SP35 - Transporte
EMPRESA:			Colegio San Jorge de Inglaterra
FECHA CREACIÓN:		29-07-2016
PARÁMETROS ENTRADA:	No Aplica
EXCEPCIONES:		No Aplica
---------------------------------------------------------------------
MODIFICACIÓN:		Corrección Query, para mostrar datos de la jornada tarde.		
AUTOR:				John Alberto López Hernández
FECHA MODIFICACIÓN: 29-07-2016
********************************************************************/


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
		--INSERCIÓN DE REGISTROS DE PARA LA MAÑANA 
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
				,PER.PrimerApellido + '' + PER.SEGUNDOAPELLIDO + ' ' + PER.PRIMERNOMBRE + ' ' +PER.SEGUNDONOMBRE  AS NombrePasajero
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
		--INSERCIÓN DE REGISTROS PARA LA TARDE
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
			   ,TMP.RutaManana
			   ,PRMAN.DireccionParadero AS DireccionParaderoManana 
			   ,TMP.AuxMana
			   ,TMP.CelRutaMana
			   ,TMP.RutaTarde
			   ,TMP.AuxTarde
			   ,PRTAR.DireccionParadero AS DireccionParaderoTarde
			   ,TMP.CelRutaTarde

		 FROM @TempRutasPlantilla as TMP
				   LEFT JOIN PRERUTA AS PRMAN ON 
						TMP.idBusrutaManana  = PRMAN.IdPersonaRuta 
				   LEFT JOIN PRERUTA AS PRTAR ON 
						TMP.idBusrutaTarde = PRTAR.IdPersonaRuta
		ORDER BY RutaManana ASC
