docker run -d -p 5432:5432 --name pljava --restart always \
 --env 'DB_USER=pegabase' \
 --env 'DB_PASS=pega' \
 --env 'DB_NAME=pega' \
 --env 'REPLICATION_USER=repluser' --env 'REPLICATION_PASS=repluserpass' \
 --env 'PG_TRUST_LOCALNET=true' \
 --env 'PG_PASSWORD=welkom' \
       nlmacamp/pljava
