--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--������������ �����: ������� ������ ���� ��������� � ������������� � ��������� ���� �������� (pc, printer, laptop). �������: model, maker, type
with all_products as (
 select price, model
 from laptop l 
  union all
 select price, model
 from pc  
  union all
 select price, model
 from printer
)
select p.model, maker, type
from all_products
join product p 
on p.model = all_products.model;

--task14 (lesson3)
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� ������� PC - "1", � ��������� - "0"
with pc_avg as 
(select avg(price) from pc)
select *,
case 
	when price > (select price from pc_avg) then 1
	else 0
end flag
from printer;

--task15 (lesson3)
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL)

with t1 as (
  select ship as name, ship as class from outcomes
    union
  select name, class from ships
  )
select name from ships 
where class is null;

--task16 (lesson3)
--�������: ������� ��������, ������� ��������� � ����, �� ����������� �� � ����� �� ����� ������ �������� �� ����.
select name from battles where extract(year from date) not in (select launched from ships);
  
--task17 (lesson3)
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships.
select battle 
from outcomes o  
join ships s 
on o.ship = s.name
where class = 'Kongo';

--task1  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_300) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ > 300. �� view ��� �������: model, price, flag
create view all_products_flag_300 as  
with all_products as ( 
  select model, price  
  from pc 
    union all   
  select model, price  
  from laptop  
    union all 
  select model, price  
  from printer 
) 
select model, price,  
case when price > 300 
then 1 
else 0 
end flag 
from all_products;

select * from all_products_flag_300;

--task2  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_avg_price) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ c������ . �� view ��� �������: model, price, flag
create view all_products_flag_avg_price as  
with all_products as ( 
  select model, price  
  from pc 
    union all   
  select model, price  
  from laptop  
    union all 
  select model, price  
  from printer 
) 
select model, price,  
case when price > (select avg(price) from all_products) 
then 1 
else 0 
end flag 
from all_products;

select * from all_products_flag_avg_price;

--task3  (lesson4)
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model 
with all_printer as ( 
  select p.model, price, maker from printer p  
join product  
on p.model=product.model)  
select model from all_printer
where maker = 'A' and price > (select 
(select sum(price)
  from all_printer
  where maker = 'C' or maker = 'D')
/ 
(select count(price)
  from all_printer
  where maker = 'C'  or maker = 'D'));

--task4 (lesson4)
-- ������������ �����: ������� ��� ������ ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model
with all_printer as ( 
  select p.model, price, maker from printer p  
join product  
on p.model=product.model), all_product as (select model, price
  from pc 
    union all   
  select model, price  
  from laptop  
    union all 
  select model, price  
  from printer 
)  
select all_product.model from all_product 
join product  
on all_product.model=product.model
where maker = 'A' and price > (select 
(select sum(price)
  from all_printer
  where maker = 'C' or maker = 'D')
/ 
(select count(price)
  from all_printer
  where maker = 'C'  or maker = 'D'))
 group by all_product.model;
--task5 (lesson4)
-- ������������ �����: ����� ������� ���� ����� ���������� ��������� ������������� = 'A' (printer & laptop & pc)
with all_products as ( 
  select model, price  
  from pc 
    union all   
  select model, price  
  from laptop  
    union all 
  select model, price  
  from printer 
) 
select distinct all_products.model, avg(price)  
from all_products 
join product  
on all_products.model=product.model  
where maker = 'A'
group by all_products.model;

--task6 (lesson4)
-- ������������ �����: ������� view � ����������� ������� (�������� count_products_by_makers) �� ������� �������������. �� view: maker, count
create view count_products_by_makers as 
with all_products as ( 
  select model, price  
  from pc 
    union all   
  select model, price  
  from laptop  
    union all 
  select model, price  
  from printer 
) 
select count(all_products.model), maker  
from all_products 
join product  
on all_products.model=product.model  
group by maker;

select* from count_products_by_makers;

--task7 (lesson4)
-- �� ����������� view (count_products_by_makers) ������� ������ � colab (X: maker, y: count)

request = """ 
select maker, count 
from count_products_by_makers
order by maker
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.maker.to_list(), y=df['count'].to_list(), labels={'x':'maker', 'y':'avg price'})
fig.show()

--task8 (lesson4)
-- ������������ �����: ������� ����� ������� p7rinter (�������� printer_updated) � ������� �� ��� ��� �������� ������������� 'D'

create table printer_updated as
select * 
from printer
where model not in (select model from product where type = 'Printer' and maker = 'D');
select * from printer_updated;

--task9 (lesson4)
-- ������������ �����: ������� �� ���� ������� (printer_updated) view � �������������� �������� ������������� (�������� printer_updated_with_makers)
create view printer_updated_with_makers as
select p_u.*, maker 
from printer_updated p_u
join product p
on p_u.model = p.model; 
select * from printer_updated_with_makers;

--task10 (lesson4)
-- �������: ������� view c ����������� ����������� �������� � ������� ������� (�������� sunk_ships_by_classes). �� view: count, class (���� �������� ������ ���/IS NULL, �� �������� �� 0)

drop view sunk_ships_by_clases;

create view sunk_ships_by_clases as
select count(ship), class as clases
---CASE WHEN class IS NULL THEN 0 ELSE class  END as classs
---NVL(class, 0)
---coalesce(class, 0)
from outcomes o
left join ships s
on o.ship = s.name
where o.result = 'sunk'
group by o.ship, clases;
--��� ������ ������, �� ���� ������ ������...
select * from sunk_ships_by_clases;

--task11 (lesson4)
-- �������: �� ����������� view (sunk_ships_by_classes) ������� ������ � colab (X: class, Y: count)
request = """ 
select clases, count 
from sunk_ships_by_clases
order by clases
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.clases.to_list(), y=df['count'].to_list(), labels={'x':'clases', 'y':'count'})
fig.show()

--task12 (lesson4)
-- �������: ������� ����� ������� classes (�������� classes_with_flag) � �������� � ��� flag: ���� ���������� ������ ������ ��� ����� 9 - �� 1, ����� 0

create view classes_with_flag as 
select *,
case when numguns >= '9' then 1
	else 0
end count_fung
from classes;

select * from classes_with_flag;

--task13 (lesson4)
-- �������: ������� ������ � colab �� ������� classes � ����������� ������� �� ������� (X: country, Y: count)

request = """ 
select count(class), country from classes group by country
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.country.to_list(), y=df['count'].to_list(), labels={'x':'country', 'y':'count'})
fig.show() 

--task14 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ���������� � ����� "O" ��� "M".

with t1 as (
  select ship as name, ship as class from outcomes
    union
  select name, class from ships
  )
select count(name) from t1 where name like 'O%' or  name like 'M%';

--task15 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ������� �� ���� ����.

with t1 as (
  select ship as name, ship as class from outcomes
    union
  select name, class from ships
  )
select count(name) from t1 where name like '% %' and name not like '% % %';

--task16 (lesson4)
-- �������: ��������� ������ � ����������� ���������� �� ���� �������� � ����� ������� (X: year, Y: count)

request = """ 
select count(name), launched from ships group by launched
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.launched.to_list(), y=df['count'].to_list(), labels={'x':'year', 'y':'count'})
fig.show()
