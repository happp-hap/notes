
[返回 - pg 查询在计划器所做的事 00182](./pg查询流程在计划器所做的事.md) 

# pg排序的代价估计


## 排序操作包含那些？

pg 排序操作有 `ORDER BY`、归并连接的预处理操作、其他函数等，其中最典型的就是 `ORDER BY` 关键字。本文使用带有 `ORDER BY` 关键字的例子，来说明排序操作的代价估计。


## 排序操作会使用什么排序算法？是内排序还是外排序？

如果能在内存中放下所有元组，排序操作会选择快速排序。
如果内存中放不下了，就会创建临时文件，使用文件归并排序算法。

所以，pg 使用内排序还是外排序，取决于内存中能不能放下所有待排序的元组。

## 本文研究的 SQL 语句

从表 `tbl` 中选取 `id, data` 列，要求 `data <= 240` ，并按 `id` 排序。

```
testdb=# SELECT id, data FROM tbl WHERE data <=240 ORDER BY id;

 id  | data 
-----+------
   1 |    1
   2 |    2
   3 |    3
   ...
 239 |  239
 240 |  240
(240 rows)
```

我们先用 `EXPLAIN` 直接出结果，然后再进行数学计算。

```
testdb=# EXPLAIN SELECT id, data FROM tbl WHERE data <=240 ORDER BY id;
                                   QUERY PLAN                                   
 
--------------------------------------------------------------------------------
-
 Sort  (cost=22.97..23.57 rows=240 width=8)
   Sort Key: id
   ->  Index Scan using tbl_data_idx on tbl  (cost=0.29..13.49 rows=240 width=8)
         Index Cond: (data <= 240)
(4 rows)
```
可以看到，排序操作的启动代价为 `22.97`，总代价为 `23.57`.

## 计算排序操作的启动代价、运行代价和总代价

### 启动代价

启动代价公式：

```
start_up_cost = C + comparision_cost * N_sort * log2(N_sort)
```

其中 C 是上一次扫描的总代价。换句话说，排序之前，先要索引扫描所需元组。

上一次扫描如下面的 `EXPLAIN`，是一个索引扫描，可以看到有 `Index` 字样。索引扫描的总代价是 `13.49`，所以次数 C = `13.485`(3 位小数由[前文](./pg索引扫描的代价估计.md)精确计算得到).


```
testdb=# EXPLAIN SELECT id, data FROM tbl WHERE data <=240;
                                QUERY PLAN                                 
---------------------------------------------------------------------------
 Index Scan using tbl_data_idx on tbl  (cost=0.29..13.49 rows=240 width=8)
   Index Cond: (data <= 240)
(2 rows)
```

我们继续计算启动代价：
```
start_up_cost = C + comparision_cost * N_sort * log2(N_sort)
              = 13.485 + ...
其中：
    N_sort           = 240
    comparision_cost = 2 * cpu_operator_cost 

所以：

    start_up_cost = C + comparision_cost * N_sort * log2(N_sort)
                  = 13.485 + (2*0.0025) * 240 * log2(240)
                  = 22.973
```

启动代价为 `22.973`.


### 运行代价

运行代价就是 cpu 在内存中读取排好序的元组的代价，也就是 cpu 顺序操作已排序元组：

```
run_cost = cpu_operator_cost * N_sort = 0.0025 * 240 = 0.6
```

运行代价为 `0.6`.

### 总代价

```
total_cost = start_up_cost + run_cost
           = 22.973 + 0.6 
           = 23.573
```

总代价为 `23.573`.

[返回 - pg 查询在计划器所做的事 00182](./pg查询流程在计划器所做的事.md) 
