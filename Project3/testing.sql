with 
  Basic as (
    select V.login, V.realm, count(*) as #visit
    from Visit V
    group by V.login, V.realm
    order by V.login, V.realm
    ),
    
  Clean as (
      select B.login, B.realm, B.#visit
      from Basic B
      where
        B.#visit <> 0
        and B.#visit <> 1
      group by B.login, B.realm, B.#visit
    ),
    
    Days as (
		select B1.login, B1.realm, B1.#visit, cast(DAYS_BETWEEN(V1.day, V2.day) as decimal(5,2)) as days
        from Basic B1, Visit V1, Basic B2, Visit V2 
        where
			B1.login = V1.login
			and B1.realm = V1.realm
			and B2.login = V2.login
			and B2.realm = V2.realm
			and B1.login = B2.login
			and B1.realm = B2.realm
			and V1.day > V2.day
			and V2.day in (
							select min( V3.day) as smol
							from Visit V3
							where
								V3.login = V2.login
								and V3.realm = V2.realm	
								and V3.day = V2.day
								and V1.day > V2.day
							)
		order by B1.login, B1.realm
    ),
    
    Freq as (
		select D.login, D.realm, max(D.days) as frequency
		from Days D	
		group by D.login, D.realm
    )
    
    
    
select F.login, F.realm, C.#visit, cast((F.frequency / (C.#visit - 1)) as decimal(5,2))
from Freq F, Clean C
where
	F.login = C.login
	and F.realm = C.realm
order by F.login, F.realm;
