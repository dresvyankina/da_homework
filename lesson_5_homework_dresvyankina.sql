--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- ������������ �����: ������� view (pages_all_products), � ������� ����� ������������ �������� ���� ��������� (�� ����� ���� ��������� �� ����� ��������). �����: ��� ������ �� laptop, ����� ��������, ������ ���� �������
drop view pages_all_products;

create view pages_all_products as
select
case when num % 2 != 0 then num%2 else num%2+2 end as cl_num,
case when num % 2 = 0 then num/2 else num/2 + 1 end as str_num
from 
(select *,  row_number () over() as num
from Laptop) z;

select * from pages_all_products;

sample:
1 1
2 1
1 2
2 2
1 3
2 3

--task2 (lesson5)
-- ������������ �����: ������� view (distribution_by_type), � ������ �������� ����� ���������� ����������� ���� ������� �� ���� ����������. �����: �������������, ���, ������� (%)
drop view distribution_by_type;

create view distribution_by_type as
select * 
from (
select maker, type,
---CUME_DIST() over (order by type) AS PctRank,
round(100.0 * count(type) OVER(partition by type)  /  count(*) over(),2) as procent
from ( 
   select product.model, maker, price, product.type 
   from product 
   join laptop 
   on product.model = laptop.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join pc 
    on product.model = pc.model 
   union all 
    select product.model, maker, price, product.type 
    from product 
    join printer 
    on product.model = printer.model 
    ) as foo 
 ) as foo1;

select * from distribution_by_type;


--task3 (lesson5)
-- ������������ �����: ������� �� ���� ����������� view ������ - �������� ���������. ������ https://plotly.com/python/histograms/

request = """ 
select * from distribution_by_type
""" 

df = pd.read_sql_query(request, conn)
fig = px.pie(df, names = 'type')
fig.show()

--task4 (lesson5)
-- �������: ������� ����� ������� ships (ships_two_words), �� �������� ������� ������ �������� �� ���� ����

select * from ships_two_words; --the table was made in the past dz

create table ships_two_words_copy as 
select * 
from ships_two_words; 

select * 
from ships_two_words_copy; 

--task5 (lesson5)
-- �������: ������� ������ ��������, � ������� class ����������� (IS NULL) � �������� ���������� � ����� "S"
with t1 as (
  select ship as name, ship as class from outcomes
    union
  select name, class from ships
  )
select name from t1 where name like 'S%' and  class IS NULL;

--task6 (lesson5)
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'C' � ��� ����� ������� (����� ������� �������). ������� model
select model 
from 
 ( 
 select *, 
 round(avg(price) over (partition by maker order by type),2) as rn,
 row_number() over (order by price desc) rg
 from 
  ( 
  select product.model, maker, price, product.type 
   from product 
    join printer 
    on product.model = printer.model 
    ) as foo 
 ) as foo1 
where rg <=3 or (maker = 'A' and (price - (select rn 
from 
 ( 
 select *, 
 round(avg(price) over (partition by maker order by type),2) as rn
 from 
  ( 
  select product.model, maker, price, product.type 
   from product 
    join printer 
    on product.model = printer.model 
    ) as foo 
 ) as foo1 
where maker = 'C') > 0));