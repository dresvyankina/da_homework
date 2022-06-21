--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task3  (lesson6)
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model
select model 
from 
(select product.model, maker, price, type, 
rank() over (partition by type order by price desc) as price_max
from  
	(select code, model, price 
	from pc  
	union all 
	select code, model, price 
	from laptop l  
	union all 
	select code, model, price 
	from printer) all_products 
	join product  
	on all_products.model = product.model) as a
where price_max = 1; 

--task5  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу code (union all) и сделать флаг (flag) по цене > максимальной по принтеру. Также добавить нумерацию (через оконные функции) по каждой категории продукта в порядке возрастания цены (price_index). По этому price_index сделать индекс
create table all_products_with_index_task5 as 
 select product.model, maker, price, type, 
 case  
 when price > (select max(price) from printer) then 1 
 else 0 
 end flag,
 row_number() over (partition by type order by price ASC) as price_index
 from  
 (select code, model, price 
 from pc  
 union all 
 select code, model, price 
 from laptop l  
 union all 
 select code, model, price 
 from printer) all_products 
 join product  
 on all_products.model = product.model; 
 
create index price_index1 on all_products_with_index_task5 (price_index);

--task1  (lesson6, дополнительно)
-- SQL: Создайте таблицу с синтетическими данными (10000 строк, 3 колонки, все типы int) и заполните ее случайными данными от 0 до 1 000 000. Проведите EXPLAIN операции и сравните базовые операции.

create table ttt as
with tmp as (
    select
        random() as one_col,
        random() as two_col,
        random() as three_col
    from generate_series(1, 1000000))
   select
    one_col,
    two_col,
    three_col
from tmp;

select * from  ttt;

explain select * from  ttt;
Seq Scan on ttt  (cost=0.00..16370.00 rows=1000000 width=24)

explain analyse select * from  ttt;
Seq Scan on ttt  (cost=0.00..16370.00 rows=1000000 width=24) (actual time=0.012..66.053 rows=1000000 loops=1)
Planning time: 0.037 ms
Execution time: 97.267 ms

explain insert into ttt(one_col, two_col, three_col) values(1, 2, 3);
Insert on ttt  (cost=0.00..0.01 rows=1 width=24)

explain analyse insert into ttt(one_col, two_col, three_col) values(1, 2, 3);
Insert on ttt  (cost=0.00..0.01 rows=1 width=24)
Planning time: 0.031 ms
Execution time: 0.085 ms

explain delete from ttt where one_col = 1;
Delete on ttt  (cost=0.00..18870.00 rows=1 width=6)

explain analyse delete from ttt where one_col = 1;
Delete on ttt  (cost=0.00..18870.00 rows=1 width=6)
        Filter: (one_col = '1'::double precision)
        Rows Removed by Filter: 1000000
Planning time: 0.059 ms
Execution time: 58.430 ms

explain select * from  ttt order by one_col;
Sort  (cost=136537.84..139037.84 rows=1000000 width=24)

explain analyze select * from  ttt order by one_col;
Sort  (cost=136537.84..139037.84 rows=1000000 width=24) (actual time=419.461..544.642 rows=1000000 loops=1)
  Sort Key: one_col
  Sort Method: external merge  Disk: 33288kB
  ->  Seq Scan on ttt  (cost=0.00..16370.00 rows=1000000 width=24) (actual time=0.006..66.839 rows=1000000 loops=1)
Planning time: 0.042 ms
Execution time: 578.986 ms

explain select count(*) from  ttt;
Finalize Aggregate  (cost=12578.55..12578.56 rows=1 width=8)

explain analyze select count(*) from  ttt;
Finalize Aggregate  (cost=12578.55..12578.56 rows=1 width=8)
Planning time: 0.047 ms
Execution time: 51.404 ms


--task2 (lesson6, дополнительно)
-- GCP (Google Cloud Platform): Через GCP загрузите данные csv в базу PSQL по личным реквизитам (используя только bash и интерфейс bash) 

