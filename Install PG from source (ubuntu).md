




# ubuntu 从源代码安装postgreSQL 14.1

## 安装gcc

sudo apt-get install gcc

## 安装基础库

（configure提示缺什么装什么）

readline lib:

    sudo apt install libreadline-dev

## configure && make && make install

configure:

    /home/hap/source/postgresql-14.1/configure --enable-debug --enable-cassert 

make(GNU make版本3.80或以上)，make install:

    make --version

    make -j8

    make check -j8

    echo $?

    sudo make install -j8

## 创建postgres用户
（你也可以使用自己的用户,这里我使用hap用户做示范）
### 用户需要拥有 /usr/local/pgsql/data 目录，需要自己创建并设置
    sudo mkdir /usr/local/pgsql/data/
    sudo chown hap:hap /usr/local/pgsql/data/

### 执行初始化程序，如果你看到如下提示，那么恭喜你，可以启动pg服务器了。
    （执行初始化程序的用户必须同时拥有服务器进程）

    Success. You can now start the database server using:

    pg_ctl -D /usr/local/pgsql/data/ -l logfile start

### 启动pg服务端

    pg_ctl -D /usr/local/pgsql/data/ -l pg.logfile start

    waiting for server to start.... done

    server started

## 监控服务器日志
    
    tail -f pg.logfile 
    2022-07-18 00:29:40.016 EDT [26241] LOG:  starting PostgreSQL 14.1 on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 11.2.0-19ubuntu1) 11.2.0, 64-bit
    2022-07-18 00:29:40.016 EDT [26241] LOG:  listening on IPv4 address "127.0.0.1", port 5432
    2022-07-18 00:29:40.021 EDT [26241] LOG:  listening on Unix socket "/tmp/.s.PGSQL.5432"
    2022-07-18 00:29:40.028 EDT [26242] LOG:  database system was shut down at 2022-07-18 00:21:32 EDT
    2022-07-18 00:29:40.033 EDT [26241] LOG:  database system is ready to accept connections


## 使用数据库

### 创建
    
    createdb testdb

### 连接

    psql testdb

### 使用

```testdb=# select * from company;
 id | name | age |                      address                       | salary 
----+------+-----+----------------------------------------------------+--------
  1 | Paul |  32 | California                                         |  20000
(1 row)
```

## 查看客户端日志

    cat .psql_history
    CREATE TABLE COMPANY(   ID INT PRIMARY KEY     NOT NULL,   NAME           TEXT    NOT NULL,   AGE            INT     NOT NULL,   ADDRESS        CHAR(50),   SALARY         REAL); INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY,JOIN_DATE) VALUES (1, 'Paul', 32, 'California', 20000.00,'2001-07-13'); INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1, 'Paul', 32, 'California', 20000.00); select * from company;
    select * from company;
    select 1 where 1=1;
    select 1+4 where 1=1;


## 查看pg进程

	ps -x  | grep postgres
	   3993 ?        Ss     0:00 /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
	   3995 ?        Ss     0:00 postgres: checkpointer 
	   3996 ?        Ss     0:00 postgres: background writer 
	   3997 ?        Ss     0:00 postgres: walwriter 
	   3998 ?        Ss     0:00 postgres: autovacuum launcher 
	   3999 ?        Ss     0:00 postgres: stats collector 
	   4000 ?        Ss     0:00 postgres: logical replication launcher 
	   4280 pts/0    S+     0:00 grep --color=auto postgres
	



