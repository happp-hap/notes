


# Solaris从源码安装postgreSQL & 安装后基本配置和管理

1. 安装gcc编译工具
	
	
	安装gc，否则configure会报错。
		configure: error: no acceptable C compiler found in $PATH

		sudo pkg search gcc

		sudo pkg install gcc

		gcc

		gcc version 11.2.0 (GCC)

2. 保持编译目录的独立，在一个源码树之外的目录中运行configure ，然后在那里构建。这个过程也被称为一个VPATH编译：

		mkdir build_dir

		cd build_dir

		/export/home/hap/source/postgresql-14.1/configure --enable-debug --enable-cassert --enable-dtrace DTRACEFLAGS='-64'
	
		在 Solaris 上，要在一个64位二进制中包括 DTrace，你必须指定DTRACEFLAGS="-64"。


		--enable-debug
		
		把所有程序和库以带有调试符号的方式编译。这意味着你可以通过一个调试器运行程序来分析问题。 这样做显著增大了最后安装的可执行文件的大小，并且在非 GCC 的编译器上，这么做通常还要关闭编译器优化， 这些都导致速度的下降。但是，如果有这些符号的话，就可以非常有效地帮助定位可能发生问题的位置。目前，我们只是在你使用 GCC 的情况下才建议在生产安装中使用这个选项。但是如果你正在进行开发工作，或者正在使用 beta 版本，那么你就应该总是打开它。

		--enable-cassert
		
		打开在服务器中的assertion检查， 它会检查许多“不可能发生”的条件。它对于代码开发的用途而言是无价之宝， 不过这些测试可能会显著地降低服务器的速度。并且，打开这个测试不会提高你的系统的稳定性！ 这些断言检查并不是按照严重性分类的，因此一些相对无害的小故障也可能导致服务器重启 — 只要它触发了一次断言失败。 目前，我们不推荐在生产环境中使用这个选项，但是如果你在做开发或者在使用 beta 版本的时候应该打开它。


		默认时所有文件都将安装到/usr/local/pgsql。
	configure和make的过程中出了很多问题，PATH环境变量问题，还有可能之前的错误make没有清理干净，导致后面一直出问题。全都删除直接./configure是可以的，后来就没再出问题了。



	检查你的make，要求GNU make版本3.80或以上；其他的make程序或更老的GNU make版本将不会工作（GNU make有时以名字gmake安装）。要测试GNU make可以输入：
		make --version
		
		gmake 

	进行回归测试：
		gmake check


	安装需要适当权限。通常，您需要以 root 身份执行此步骤。 或者，您可以提前创建目标目录并安排授予适当的权限：
		sudo gmake install

3. 安装完成后，创建postgres用户用来管理数据库。

		useradd postgres
		su postgres 或 sudo -u postgres bash

	将/usr/local/pgsql/bin写入PATH:
	
		PATH=/usr/local/pgsql/bin:$PATH
		export PATH
		MANPATH=/usr/local/pgsql/share/man:$MANPATH
		export MANPATH

	postgres 用户密码提示 1和0

		mkdir /usr/local/pgsql/data/

4. 初始化数据库，设置data目录

		postgres@solaris:/usr/local/pgsql/bin$ /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data/
		The files belonging to this database system will be owned by user "postgres".
		This user must also own the server process.

		The database cluster will be initialized with locale "en_US.UTF-8".
		The default database encoding has accordingly been set to "UTF8".
		The default text search configuration will be set to "english".

		Data page checksums are disabled.

		fixing permissions on existing directory /usr/local/pgsql/data ... ok
		creating subdirectories ... ok
		selecting dynamic shared memory implementation ... posix
		selecting default max_connections ... 100
		selecting default shared_buffers ... 128MB
		selecting default time zone ... Asia/Shanghai
		creating configuration files ... ok
		running bootstrap script ... ok
		performing post-bootstrap initialization ... ok
		syncing data to disk ... ok

		initdb: warning: enabling "trust" authentication for local connections
		You can change this by editing pg_hba.conf or using the option -A, or
		--auth-local and --auth-host, the next time you run initdb.

		Success. You can now start the database server using:

			/usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data/ -l logfile start

		postgres@solaris:/usr/local/pgsql/bin$ echo $?
		0

5. 启动pg_ctl

		postgres@solaris:/usr/local/pgsql/data$ /usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l /usr/local/pgsql/data/log/logfile start
		waiting for server to start.... done
		server started



6. 监控日志

		postgres@solaris:/usr/local/pgsql/data/log$ cat logfile 
		2022-06-20 14:10:41.789 CST [1215] LOG:  starting PostgreSQL 14.1 on x86_64-pc-solaris2.11, compiled by gcc (GCC) 11.2.0, 64-bit
		2022-06-20 14:10:41.790 CST [1215] LOG:  listening on IPv6 address "::1", port 5432
		2022-06-20 14:10:41.790 CST [1215] LOG:  listening on IPv4 address "127.0.0.1", port 5432
		2022-06-20 14:10:41.792 CST [1215] LOG:  listening on Unix socket "/tmp/.s.PGSQL.5432"
		2022-06-20 14:10:41.798 CST [1216] LOG:  database system was shut down at 2022-06-20 14:03:42 CST
		2022-06-20 14:10:41.811 CST [1215] LOG:  database system is ready to accept connections


		postgres@solaris:~$ cat /usr/local/pgsql/data/log/logfile
		2022-06-20 14:10:41.789 CST [1215] LOG:  starting PostgreSQL 14.1 on x86_64-pc-solaris2.11, compiled by gcc (GCC) 11.2.0, 64-bit
		2022-06-20 14:10:41.790 CST [1215] LOG:  listening on IPv6 address "::1", port 5432
		2022-06-20 14:10:41.790 CST [1215] LOG:  listening on IPv4 address "127.0.0.1", port 5432
		2022-06-20 14:10:41.792 CST [1215] LOG:  listening on Unix socket "/tmp/.s.PGSQL.5432"
		2022-06-20 14:10:41.798 CST [1216] LOG:  database system was shut down at 2022-06-20 14:03:42 CST
		2022-06-20 14:10:41.811 CST [1215] LOG:  database system is ready to accept connections
		2022-06-20 14:20:28.524 CST [1291] ERROR:  syntax error at or near "1" at character 19
		2022-06-20 14:20:28.524 CST [1291] STATEMENT:  select 1+1
				select 1+1;
		2022-06-20 14:20:32.531 CST [1291] ERROR:  syntax error at or near "1" at character 19
		2022-06-20 14:20:32.531 CST [1291] STATEMENT:  select 1+1
				select 1+1;
		2022-06-20 14:23:47.199 CST [1291] ERROR:  column "join_date" of relation "company" does not exist at character 49
		2022-06-20 14:23:47.199 CST [1291] STATEMENT:  INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY,JOIN_DATE) VALUES (1, 'Paul', 32, 'California', 20000.00,'2001-07-13');
		postgres@solaris:~$ 

7. 创建和删除数据库

		postgres@solaris:/usr/local/pgsql/data/log$ createdb testdb
		postgres@solaris:/usr/local/pgsql/data/log$ psql testdb
		psql (14.1)
		Type "help" for help.

		testdb=# 

		如果用不了createdb等指令，就source一下/etc/profile

8. 查看客户端指令记录文件

		cat /export/home/postgres/.psql_history 
		\l
		\c postgres 
		\l
		\d
		CREATE TABLE COMPANY(   ID INT PRIMARY KEY     NOT NULL,   NAME           TEXT    NOT NULL,   AGE            INT     NOT NULL,   ADDRESS        CHAR(50),   SALARY         REAL);
		INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY,JOIN_DATE) VALUES (1, 'Paul', 32, 'California', 20000.00,'2001-07-13');
		INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1, 'Paul', 32, 'California', 20000.00);
		select * from company;
		qexit
		\q


9. 查看运行的postgres进程

		ps us
		ps: illegal option -- s
		usage: ps [ -aceglnrSuUvwx ] [ -t term ] [ --scale[=item1,item2,...] ] [ num ]
		postgres@solaris:~$ ps ux
		USER       PID %CPU %MEM   SZ  RSS TT       S    START  TIME COMMAND
		postgres  1314  0.1  0.1 10908 4176 pts/1    O 14:27:38  0:00 ps ux
		postgres  1267  0.0  0.1 13312 5976 pts/1    R 14:17:15  0:00 bash
		postgres  1217  0.0  0.1 165808 6428 ?        S 14:10:41  0:00 /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
		postgres  1218  0.0  0.1 165800 3416 ?        S 14:10:41  0:00 /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
		postgres  1219  0.0  0.1 165804 6168 ?        S 14:10:41  0:00 /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
		postgres  1220  0.0  0.1 166324 5328 ?        S 14:10:41  0:00 /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
		postgres  1221  0.0  0.1 20724 2108 ?        S 14:10:41  0:00 /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
		postgres  1222  0.0  0.1 166196 2868 ?        S 14:10:41  0:00 /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data






(在读第 17 章 从源代码安装)







