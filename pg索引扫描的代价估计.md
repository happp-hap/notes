
[返回 - pg 查询在计划器所做的事 00182](./pg查询流程在计划器所做的事.md) 

# pg索引扫描的代价估计



## 什么是索引？

索引是关系型数据库对列进行与排序的数据结构。有了索引，数据库就不必扫描整个表，就能直接定位到符合条件的记录，大幅加快了查询速度。

## 索引有什么用？

加快查询速度。但不是所有的扫描中，索引都是最快的。索引列的值越不相同，索引效率就越高。如果目标是扫描并打印整个表，那么用索引也没什么意义。

## 什么是索引扫描？

索引扫描是指数据库管理器在访问基本表之前访问索引，并通过扫描该索引中指定范围内的行，来缩小合格行的集合。

## 索引扫描有什么用？

大部分时候更快。访问索引就像看书查目录一样，可以方便找到目标。

## 索引扫描怎么估计代价？

### 索引扫描的源码函数是什么？

`cost_index()`
```
path->path.total_cost = startup_cost + run_cost;
// 在cost_index() 函数最后一行
```

### 本文研究的 SQL

```

testdb=# select id, data from tbl where data <= 240;

testdb=# select relpages, reltuples from pg_class where relname = 'tbl_data_idx';
 relpages | reltuples 
----------+-----------
       30 |     10000
(1 row)
```
其中，`N_index_page = 30, N_index_tuple = 10000`.

```
testdb=# select relpages, reltuples from pg_class where relname = 'tbl';
 relpages | reltuples 
----------+-----------
       45 |     10000
(1 row)

```
我们先前所建立的表，有 45 个页和 10000 个元组。其中，`N_page = 45, N_tuple = 10000`.

### 索引扫描的启动代价

对于顺序扫描，cpu 可以直接开始读取元组，没有启动代价。
上面我们说到，索引扫描在开始获取第一个元组之前，需要读取目标表的索引页，所以，索引扫描有启动代价。

```
start_up_cost = {...} * cpu_operator_cost
              = { ceil(log2(N_index_tuple)) + (H_index+1)*50 } * cpu_operator_cost
```

其中：

```
N_index_tuple     = 10000
H_index           = 1
cpu_operator_cost = 0.0025
```

所以 `strat_up_cost = {ceil(log2(10000))+2*50}*0.0025 = 0.285`

### 索引扫描的运行代价

```
run_cost = cpu_run_cost + io_run_cost
         = (index_cpu_cost + table_cpu_cost)
         + (index_io_cost + table_io_cost)

         = index_cost   + table_cost
         = (index_cpu_cost + index_io_cost)
         + (table_cpu_cost + table_io_cost)

index_cpu_cost = Selectivity * N_index_tuple * (cpu_index_tuple_cost + qual_op_cost)


table_cpu_cost = Selectivity * N_tuple * cpu_tuple_cost


index_io_cost = ceil(Selectivity*N_index_page) * random_page_cost

table_io_cost = max_io_cost+indexCorerelation^2
              ×（min_io_cost-max_io_cost）

```
其中：
```
cpu_index_tuple_cost = 0.005
random_page_cost     = 4.0
(postgresql.conf中配置)
```
```
qual_op_cost         = 0.0025 (索引求值的代价)
Selectivity: 选择率，0~1 的浮点数，代表查询指定的 where 子句在索引中搜索范围的比例。
需要读取表元组的数量：Selectivity*N_tuple 
需要读取索引元组的数量：Selectivity*N_index_page 

```

[计算过程 - 选择率和 cost 计算](./选择率.md)


经过一系列繁琐的计算，可以得到`run_cost = 13.2`.


### 索引扫描的总代价

`total_cost = 0.285 + 13.2 = 13.485`

```
testdb=# EXPLAIN SELECT id,data FROM tbl WHERE data <= 240;
                                QUERY PLAN                                 
---------------------------------------------------------------------------
 Index Scan using tbl_data_idx on tbl  (cost=0.29..13.49 rows=240 width=8)
   Index Cond: (data <= 240)
(2 rows)

```

[返回 - pg 查询在计划器所做的事 00182](./pg查询流程在计划器所做的事.md) 


