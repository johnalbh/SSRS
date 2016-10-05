/*  TÍTULO: Query para consulta de total de registros a Eliminar 
	AUTOR:  Esteban Leguizamo


*/

DECLARE  @Calendario INT
		,@BusRuta INT
		,@PersonaRuta INT;
		

SELECT @Calendario = COUNT(C.Id)
FROM dbo.Calendario AS C WITH(NOLOCK)
WHERE C.TipoDia LIKE '%E-%';

SELECT @BusRuta = COUNT(BR.IdBusRuta)
FROM dbo.BusRuta AS BR WITH(NOLOCK)
WHERE BR.DominioJornada IN(11,21)
	AND BR.FechaCalendario = '1900-01-01';

SELECT @PersonaRuta = COUNT(PR.IdBusRuta)
FROM dbo.PersonaRuta AS PR WITH(NOLOCK)
INNER JOIN dbo.BusRuta AS BR WITH(NOLOCK)
	ON PR.IdBusRuta = BR.IdBusRuta
WHERE BR.FechaCalendario = '1900-01-01'
	AND BR.DominioJornada IN(11,21);
	SELECT 173* 2785, --481805
			173*96;
SELECT 
	 @Calendario AS Calendario
	,@BusRuta AS BusRuta
	,@PersonaRuta AS PersonaRuta
	,@Calendario * @BusRuta AS 'Calendario * BusRuta'
	,@Calendario * @PersonaRuta AS 'Calendario * PersonaRuta';

SELECT COUNT(BR.IdBusRuta)
FROM dbo.BusRuta AS BR WITH(NOLOCK)
where BR.FechaCalendario != '1900-01-01';


SELECT COUNT(PR.IdBusRuta)
FROM dbo.PersonaRuta AS PR WITH(NOLOCK)
INNER JOIN dbo.BusRuta AS BR WITH(NOLOCK)
	ON PR.IdBusRuta = BR.IdBusRuta
WHERE BR.FechaCalendario != '1900-01-01';