
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

### 顺序扫描怎么估计代价？

### 索引扫描怎么估计代价？

### 排序怎么估计代价？






[返回 - pg查询流程梳理](./pg查询流程梳理.md)

