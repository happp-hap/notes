
[返回 - pg查询流程梳理](./pg查询流程梳理.md)

# pg查询流程在计划器所做的事

## 计划优化的依据

前面我们说到，pg的计划器是 完全 基于 代价估计 的。通过使用专用的函数进行代价估计，计划器能够通过估计代价来优化查询。


所以首先，要清楚常用的代价估计。


## 代价估计是什么

代价估计就是 计划器 给各种操作一个估算的代价数值，它是一个数，没有量纲，也就是说没有单位。单看这一个数字并不能说明什么，但是我们可以通过比较不同操作的代价数值，来相对估计不同的操作，需要什么样的开销。


对于所有被执行器执行的操作，计划器都有相应的代价函数，这些函数被存储在 costsize.c 中。

## 单表查询的代价估计

### 代价估计包含那些部分？作为用户怎样进行代价估计？

代价估计包含：启动代价、运行代价、总代价。

    启动代价是：在读取到第一条元组前花费的代价。

    运行代价是：获取全部所需元组的代价。

    启动代价 + 运行代价 = 总代价
    总代价  - 启动代价 = 运行代价

用户可以通过两种方式得到运行 SQL 所需的代价估计：
1. 使用 EXPLAIN :

先使用一些 SQL，产生使用环境：

```
testdb=# CREATE TABLE tbl (id int PRIMARY KEY, data int);
CREATE TABLE
testdb=# CREATE INDEX tbl_data_idx ON tbl (data);
CREATE INDEX
testdb=# INSERT INTO tbl SELECT generate_series(1,10000),generate_series(1,10000);
INSERT 0 10000
testdb=# ANALYZE;
ANALYZE
testdb=# \d tbl
                Table "public.tbl"
 Column |  Type   | Collation | Nullable | Default 
--------+---------+-----------+----------+---------
 id     | integer |           | not null | 
 data   | integer |           |          | 
Indexes:
    "tbl_pkey" PRIMARY KEY, btree (id)
    "tbl_data_idx" btree (data)

```

EXPLAIN 初体验：

```
testdb=# EXPLAIN SELECT * FROM TBL;
                       QUERY PLAN                        
---------------------------------------------------------
 Seq Scan on tbl  (cost=0.00..145.00 rows=10000 width=8)
(1 row)

```

2. 手工计算（学习用）

通过后面提到的计算公式来估计代价。

### 顺序扫描怎么估计代价？

我们估计顺序扫描的代价，首先估计顺序扫描的 启动代价，然后是运行代价，最后把它们相加。
顺序扫描通过 `cost_seqscan()` 函数来估计代价。它在 `Costsize.c` 文件中。
我们阅读 pg 源码中的 `cost_seqscan()` 函数，可以知道：

```
path->total_cost = startup_cost + cpu_run_cost + disk_run_cost;
// 写在 cost_seqscan() 函数的最后一行
```

顺序扫描的启动代价为 0 。也就是说，cpu可以直接开始读取顺序扫描的目标元组。

顺序扫描的运行代价，根据我们从代码中读到的公式，有：

```
run_cost = cpu_run_cost + disk_run_cost;
```
又有：
```
run_cost = cpu_run_cost + disk_run_cost;
         = (cpu_tuple_cost + cpu_operator_cost) * N_tuple
         + seq_page_cost * N_page
```
其中：
```
double		seq_page_cost     = 1;
double		cpu_tuple_cost    = 0.01;
double		cpu_operator_cost = 0.0025;
```
拿我们的例子来看：

```
testdb=# select relpages, reltuples from pg_class where relname = 'tbl';
 relpages | reltuples 
----------+-----------
       45 |     10000
(1 row)

```
我们先前所建立的表，有 45 个页和 10000 个元组。

带入其中，得到 `run_cost = (0.01+0.0025)*10000 + 1.0*45 = 170`，得到顺序扫描 tbl 表的代价为 170. 这个数字并没有什么决定性的意义，代价估计没有量纲，所以只有相对意义。

通过 EXPLAIN，得到顺序扫描的代价为 170.
```
testdb=# EXPLAIN SELECT * FROM tbl where id < 8000;
                       QUERY PLAN                       
--------------------------------------------------------
 Seq Scan on tbl  (cost=0.00..170.00 rows=7999 width=8)
   Filter: (id < 8000)
(2 rows)

-- 使用过滤器 id<8000 来确保数据库产生顺序扫描的行为。

```

比如说，我们恰巧又有一个 tbl2 表，有10000行：

```
testdb=# CREATE TABLE tbl2 (id int PRIMARY KEY, data int);
CREATE TABLE
testdb=# CREATE INDEX tbl2_data_idx ON tbl2 (data);
CREATE INDEX
testdb=# INSERT INTO tbl2 SELECT generate_series(1,100000),generate_series(1,100000);
INSERT 0 100000
testdb=# ANALYZE;
ANALYZE
testdb=# \d tbl
                Table "public.tbl"
 Column |  Type   | Collation | Nullable | Default 
--------+---------+-----------+----------+---------
 id     | integer |           | not null | 
 data   | integer |           |          | 
Indexes:
    "tbl_pkey" PRIMARY KEY, btree (id)
    "tbl_data_idx" btree (data)

testdb=# select relpages, reltuples from pg_class where relname = 'tbl2';
 relpages | reltuples 
----------+-----------
      443 |    100000
(1 row)


```

我们先用公式估计一下代价：

`run_cost = (0.01+0.0025)*100000 + 1.0*443 = 1693`

再用 EXPLAIN 估计代价：

```
testdb=# EXPLAIN SELECT * FROM tbl2 where id < 80000;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on tbl2  (cost=0.00..1693.00 rows=80169 width=8)
   Filter: (id < 80000)
(2 rows)


```
这个时候，我们就知道，对于 tbl2，全表扫描的代价是 tbl 的十倍左右。


others：

```

testdb=# EXPLAIN SELECT * FROM tbl;
                       QUERY PLAN                        
---------------------------------------------------------
 Seq Scan on tbl  (cost=0.00..145.00 rows=10000 width=8)
(1 row)

testdb=# EXPLAIN SELECT * FROM tbl where id < 8000;
                       QUERY PLAN                       
--------------------------------------------------------
 Seq Scan on tbl  (cost=0.00..170.00 rows=7999 width=8)
   Filter: (id < 8000)
(2 rows)

-- 没有 where 子句的话，会快一些



testdb=# EXPLAIN SELECT * FROM tbl2 where id < 1;
                              QUERY PLAN                              
----------------------------------------------------------------------
 Index Scan using tbl2_pkey on tbl2  (cost=0.29..4.31 rows=1 width=8)
   Index Cond: (id < 1)
(2 rows)


testdb=# EXPLAIN SELECT * FROM tbl2 where id < 8000;
                                QUERY PLAN                                 
---------------------------------------------------------------------------
 Index Scan using tbl2_pkey on tbl2  (cost=0.29..271.56 rows=8015 width=8)
   Index Cond: (id < 8000)
(2 rows)

testdb=# EXPLAIN SELECT * FROM tbl2 where id < 80000;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on tbl2  (cost=0.00..1693.00 rows=80169 width=8)
   Filter: (id < 80000)
(2 rows)

testdb=# EXPLAIN SELECT * FROM tbl2 where id < 90000;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on tbl2  (cost=0.00..1693.00 rows=89946 width=8)
   Filter: (id < 90000)
(2 rows)

testdb=# EXPLAIN SELECT * FROM tbl2 where id < 50616;
                                 QUERY PLAN                                  
-----------------------------------------------------------------------------
 Index Scan using tbl2_pkey on tbl2  (cost=0.29..1675.93 rows=50722 width=8)
   Index Cond: (id < 50616)
(2 rows)


testdb=# EXPLAIN SELECT * FROM tbl2 where id < 50617;
                                 QUERY PLAN                                  
-----------------------------------------------------------------------------
 Index Scan using tbl2_pkey on tbl2  (cost=0.29..1675.95 rows=50723 width=8)
   Index Cond: (id < 50617)
(2 rows)


testdb=# EXPLAIN SELECT * FROM tbl2 where id < 50618;
                                 QUERY PLAN                                  
-----------------------------------------------------------------------------
 Index Scan using tbl2_pkey on tbl2  (cost=0.29..1675.96 rows=50724 width=8)
   Index Cond: (id < 50618)
(2 rows)

testdb=# EXPLAIN SELECT * FROM tbl2 where id < 50619;
                        QUERY PLAN                         
-----------------------------------------------------------
 Seq Scan on tbl2  (cost=0.00..1693.00 rows=50725 width=8)
   Filter: (id < 50619)
(2 rows)

-- 10000 行的表， where 子句 id < 50618 走索引，再大就直接走全表扫描，因为代价已经达到全表扫描的程度。

```



### 索引扫描怎么估计代价？

对于顺序扫描，cpu 可以直接开始读取元组，没有启动代价。
索引扫描在开始获取第一个元组之前，需要读取目标表的索引页，所以，索引扫描有启动代价。

### 排序怎么估计代价？






[返回 - pg查询流程梳理](./pg查询流程梳理.md)

