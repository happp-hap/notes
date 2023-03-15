
# ubuntu pg12-bao install

## ref

   bao doc:   https://rmarcus.info/bao_docs/tutorial/1_pg_setup.html
   

## ubuntu

   ubuntu20.04

   sudo apt update
   sudo apt upgrade
   
## pg12
```
   sudo apt install make gcc curl wget emacs postgresql-server-dev-12

   sudo apt install postgresql-12 # postgresql-common in this

   sudo usermod -aG sudo postgres
   su - postgres

   
   sudo pg_ctlcluster 12 main start
   sudo pg_ctlcluster 12 main stop
   sudo pg_ctlcluster 12 main restart

   or

   sudo /etc/init.d/postgresql stop
   sudo /etc/init.d/postgresql start

   createdb testdb
   psql testdb

   createuser imdb -d -s
   createdb imdb
```

## PG的启动和停止
```
sudo service postgresql status 用于检查数据库的状态。
ps -ef | grep postgresql 用于显示postgresql进程状态。
sudo service postgresql start 用于开始运行数据库。
sudo service postgresql stop 用于停止运行数据库。
sudo service postgresql restart 用于重启运行数据库。
```

### change passwd

    sudo -u postgres psql
    ALTER USER postgres WITH PASSWORD 'postgres'; 
    ALTER USER imdb WITH PASSWORD 'imdb';
    exit

### psql: error: FATAL:  Peer authentication failed for user "imdb"

    sudo emacs /etc/postgresql/12/main/pg_hba.conf

```
# "local" is for Unix domain socket connections only                                                                            
local   all             all					md5

```
```
如果您在本地主机上连接到PostgreSQL，则可以尝试将身份验证方法更改为“trust”或“md5”。要更改pg_hba.conf文件中的身份验证方法，请使用以下命令：

javascript
Copy code
sudo nano /etc/postgresql/<version>/main/pg_hba.conf
在文件中找到包含“local”和“peer”（或“md5”）的行，并将其更改为：

sql
Copy code
local   all             all                                     trust
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust
保存文件并重新启动PostgreSQL服务器：

Copy code
sudo service postgresql restart
这将允许在不需要密码的情况下连接到PostgreSQL服务器。
```
restart pg

### login imdb without passwd

    emacs .bashrc

    export PGPASSWORD=imdb

    source .bashrc

## imdb database

    sudo cp /home/hap/Downloads/imdb_pg11 ~/
    pg_restore -d imdb -U imdb --clean --if-exists -v ./imdb_pg11
    ...
    psql -U imdb
    select count(*) from title;

data okay

## bao 
   sudo apt install aptitude
   sudo aptitude install postgresql-server-dev-12
   !!! do not accept first schema, then downgrade libc6
   
   sudo make USE_PGXS=1 install
```
/bin/mkdir -p '/usr/lib/postgresql/12/lib'
/bin/mkdir -p '/usr/share/postgresql/12/extension'
/bin/mkdir -p '/usr/share/postgresql/12/extension'
/usr/bin/install -c -m 755  pg_bao.so '/usr/lib/postgresql/12/lib/pg_bao.so'
/usr/bin/install -c -m 644 .//pg_bao.control '/usr/share/postgresql/12/extension/'
/usr/bin/install -c -m 644 .//pg_bao--0.0.1.sql  '/usr/share/postgresql/12/extension/'
/bin/mkdir -p '/usr/lib/postgresql/12/lib/bitcode/pg_bao'
/bin/mkdir -p '/usr/lib/postgresql/12/lib/bitcode'/pg_bao/
/usr/bin/install -c -m 644 main.bc '/usr/lib/postgresql/12/lib/bitcode'/pg_bao/./
cd '/usr/lib/postgresql/12/lib/bitcode' && /usr/lib/llvm-10/bin/llvm-lto -thinlto -thinlto-action=thinlink -o pg_bao.index.bc pg_bao/main.bc
```

    echo "shared_preload_libraries = 'pg_bao'" >> /etc/postgresql/12/main/postgresql.conf	
    sudo pg_ctlcluster 12 main restart

    psql -U imdb
    SHOW enable_bao;


## bao_server
```
   sudo apt install python3 python3-pip

   pip install psycopg2
   pip3 install scikit-learn numpy joblib
   pip3 install torch==1.5.0+cpu -f https://download.pytorch.org/whl/torch_stable.html

   python3 main.py 1>>bao_server.log 2>&1 &
   ps -ef | grep "python3 main.py"
   tail -f bao_server.log

   su - postgres
   psql -U imdb
   SET enable_bao TO on;
   EXPLAIN SELECT count(*) FROM title;
   SELECT count(*) FROM title;
```
## test & show tests
   
   python3 run_queries.py sample_queries/*.sql | tee ~/bao_run.txt
   
   run_queries.py 
   USE_BAO = False

   python3 run_queries.py sample_queries/*.sql | tee ~/pg_run.txt

   pip install matplotlib pandas

   run analyze_bao.ipynb

   
