

# ubuntu pg12 bao install

## docker install 

## docker

    docker ps
```
CONTAINER ID   IMAGE               COMMAND                  CREATED       STATUS       PORTS                NAMES
2e3cd477693d   ubuntu:20.04        "/bin/bash"              5 hours ago   Up 5 hours                        pg12-bao
e63bfc6be992   docker101tutorial   "/docker-entrypoint.…"   5 hours ago   Up 5 hours   0.0.0.0:80->80/tcp   docker-tutorial

```
    
    docker run -itd ubuntu:20.04 /bin/bash
    docker exec -it 2e3cd477693d /bin/bash
    
install what you need.

## install pg12 from source

## install imdb_pg11

imdb from: https://rmarcus.info/bao_docs/tutorial/1_pg_setup.html

    createuser imdb -d -s

    createdb imdb

    pg_restore -d imdb -U imdb --clean --if-exists -v ./imdb_pg11

test:
    psql -U imdb

```
$ psql -U imdb 
psql (12.3)
Type "help" for help.

imdb=# select count(*) from title;
  count  
---------
 2528312
(1 row)
```

## build & install Bao
link: https://rmarcus.info/bao_docs/tutorial/1_pg_setup.html

```
$ git clone https://github.com/learnedsystems/BaoForPostgreSQL
$ cd BaoForPostgreSQL
```

stop postgreSQL.

    sudo apt-get install postgresql-server-dev-12 postgresql-common
    cd pg_extension
    sudo make USE_PGXS=1 install

like this:

    echo "shared_preload_libraries = 'pg_bao'" >> /media/data/pg_data/data/postgresql.conf

the path of pg_bao.so can not be found, so :
    
    sudo cp /usr/lib/postgresql/12/lib/pg_bao.so /usr/local/pgsql/lib/

restart postgreSQL.

```
$ psql -U imdb 
psql (12.3)
Type "help" for help.

imdb=# SHOW enable_bao;
 enable_bao 
------------
 off
(1 row)
```



