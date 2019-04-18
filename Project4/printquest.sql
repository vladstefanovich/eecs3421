select Q.realm, Q.theme, L.login, Q.day, Q.succeeded, L.loot#
from Loot L, Quest Q
where L.theme = 'Airport Chaos'
      and L.realm = Q.realm
      and L.theme = Q.theme
      and L.day = Q.day
order by L.realm, L.theme, L.day, L.loot#;
