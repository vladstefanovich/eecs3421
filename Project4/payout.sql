--#SET TERMINATOR @

create or replace trigger PayOut
after update of succeeded on Quest
referencing
    old as A
    new as Z
for each row mode db2sql
when (
    A.succeeded IS NULL
    and Z.succeeded IS NOT NULL
)
begin atomic
    update (select T.loot#, T.realm, T.day, T.theme, T.login,
               (select  count(*)
                from Actor A
                where A.realm = T.realm
                  and A.day   = T.day
                  and A.theme = T.theme
               ) as #players
        from Loot T
       ) as L
    set L.login = ( select login
                from Actor A
                where A.realm = L.realm
                  and A.day   = L.day
                  and A.theme = L.theme
                order by rand() * L.#players
                limit 1
               )
    where L.realm = Z.realm
      and L.day   = Z.day
      and L.theme = Z.theme
      and L.login is null -- sanity checks
      and L.#players > 0;
end@
