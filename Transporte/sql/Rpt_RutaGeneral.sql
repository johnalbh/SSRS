/********************************************************************
NOMBRE:				dbo.Rpt_RutaGeneral.sql
DESCRPCIÓN:			Consulta reporte Ruta General
AUTOR:				Maritza Zambrano
REQUERIMIENTO:		SP35 - Transporte
EMPRESA:			Colegio San Jorge de Inglaterra
FECHA CREACIÓN:		29-07-2016
PARÁMETROS ENTRADA:	No Aplica
EXCEPCIONES:		No Aplica
---------------------------------------------------------------------
MODIFICACIÓN:
AUTOR:
REQUERIMIENTO:
EMPRESA:
FECHA MODIFICACIÓN:
********************************************************************/

SELECT  
     p.Nombre 
   , p.Curso
   , p.Direccion
   , p.TelefonoDireccion
   , p.CelularMadre
   , p.CelularPadre
   , pre.direccionparadero AS Paradero
   , pre.Orden AS NumeroParadero
   , pre.Hora AS Hora
   , asis.PrimerApellido + ' ' + asis.SegundoApellido + ' ' + asis.PrimerNombre + ' ' + asis.SegundoNombre AS NombreAuxiliar
   , st.Descripcion
FROM

   personaruta as pr inner join busruta as br
   on pr.idbusruta= br.IdBusRuta
   inner join vw_datospersona as  p on 
	pr.NumeroIdentificacionPasajero =   p.NumeroIdentificacion and 
	pr.TipoIdentificacionPasajero = p.TipoIdentificacion
   left join PreRuta pre on pre.idpersonaruta = pr.IdPersonaRuta 
   left join persona asis on asis.TipoIdentificacion = br.TipoIdentificacionAsistente and 
	asis.NumeroIdentificacion = br.NumeroIdentificacionAsistente
   left join vw_ServiciosTransporte st on 
	st.CodigoServicio = br.DominioJornada
WHERE 
   br.DominioNombreRuta =@Ruta AND
   br.DominioJornada=@Jornada  AND
   FechaCalendario = '19000101'

ORDER BY 
	pre.Orden