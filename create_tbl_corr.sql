
-- 建表语句
drop table tbl_corr;
create table tbl_corr (
  col text, 
  col_asc integer, 
  col_desc integer, 
  col_rand integer, 
  data text
);

CREATE INDEX tbl_corr_asc_idx ON tbl_corr (col_asc);
CREATE INDEX tbl_corr_desc_idx ON tbl_corr (col_desc);
CREATE INDEX tbl_corr_rand_idx ON tbl_corr (col_rand);

INSERT INTO tbl_corr (col, col_asc, col_desc, col_rand) values  ('Tuple_1' , 1 , 12, 3);
INSERT INTO tbl_corr (col, col_asc, col_desc, col_rand) values  ('Tuple_2' , 2 , 11, 8);
INSERT INTO tbl_corr (col, col_asc, col_desc, col_rand) values  ('Tuple_3' , 3 , 10, 5);
INSERT INTO tbl_corr (col, col_asc, col_desc, col_rand) values  ('Tuple_4' , 4 , 9 , 9);
INSERT INTO tbl_corr (col, col_asc, col_desc, col_rand) values  ('Tuple_5' , 5 , 8 , 7);
INSERT INTO tbl_corr (col, col_asc, col_desc, col_rand) values  ('Tuple_6' , 6 , 7 , 2);
INSERT INTO tbl_corr (col, col_asc, col_desc, col_rand) values  ('Tuple_7' , 7 , 6 , 10);
INSERT INTO tbl_corr (col, col_asc, col_desc, col_rand) values  ('Tuple_8' , 8 , 5 , 11);
INSERT INTO tbl_corr (col, col_asc, col_desc, col_rand) values  ('Tuple_9' , 9 , 4 , 4);
INSERT INTO tbl_corr (col, col_asc, col_desc, col_rand) values  ('Tuple_10', 10, 3 , 1);
INSERT INTO tbl_corr (col, col_asc, col_desc, col_rand) values  ('Tuple_11', 11, 2 , 12);
INSERT INTO tbl_corr (col, col_asc, col_desc, col_rand) values  ('Tuple_12', 12, 1 , 6);

-- 查询语句

ANALYZE; -- 产生分析数据

\d tbl_corr;

select * from tbl_corr;

select tablename, attname, correlation From pg_stats WHERE tablename = 'tbl_corr';

select tablename, attname, correlation From pg_stats WHERE tablename = 'tbl';



