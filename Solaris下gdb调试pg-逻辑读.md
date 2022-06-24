



1. 什么是逻辑读：

	逻辑读：缓冲池是内存中存放页的地方，当用户执行一条SQL，从内存中读取页而没有去磁盘上找的时候，称为逻辑读。
	物理读：在执行真正的查询操作前，将页从磁盘读入内存中，称为物理读。

  ![](./img/999560-20180720174455737-868415693.gif)
  
2. 调试流程

	查找当前 session （Session:在计算机中，尤其是在网络应用中，称为“会话控制”。） 对应的进程号：
		postgres@solaris:~$ psql testdb
		psql (14.1)
		Type "help" for help.

		testdb=# 
		testdb=# select pg_backend_pid();
		 pg_backend_pid 
		----------------
				   1234
		(1 row)

		testdb=# 

	或者ps简单查看一下（Sun系统这里看不太出来）：
	
		hap@solaris:~$ ps -ef | grep postgres
		postgres  1218  1215   0 14:22:29 ?           0:00 /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
		postgres  1203  1202   0 14:20:41 pts/2       0:00 bash
		postgres  1215     1   0 14:22:28 ?           0:00 /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
			root  1202  1197   0 14:20:38 pts/2       0:00 su postgres
		postgres  1217  1215   0 14:22:29 ?           0:00 /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
		postgres  1219  1215   0 14:22:29 ?           0:00 /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
		postgres  1220  1215   0 14:22:29 ?           0:00 /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
		postgres  1221  1215   0 14:22:29 ?           0:00 /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
		postgres  1222  1215   0 14:22:29 ?           0:00 /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
			root  1230  1225   0 14:22:49 pts/3       0:00 su postgres
		postgres  1231  1230   0 14:22:52 pts/3       0:00 bash
		postgres  1233  1231   0 14:23:00 pts/3       0:00 psql testdb
		postgres  1234  1215   0 14:23:00 ?           0:00 /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data
			 hap  1246  1124   0 14:27:04 pts/1       0:00 grep postgres
		hap@solaris:~$ 
