update Quest as Q
set Q.succeeded = '23:59:59'
where Q.succeeded IS NULL;
