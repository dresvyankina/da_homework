--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- Задание 20: Найдите средний размер hd PC каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.
--
select avg(hd), maker 
from product join pc
on pc.model = product.model
where maker in (SELECT maker
FROM product
WHERE type='Printer') 
group by maker; 

-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
--
select name, class
from Ships
where launched > 1920 ; 

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
--
select name, class
from Ships
where launched > 1920 and launched <= 1942 ;

-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
--
select count(class) as count, class
from Ships
group by class
order by count;

-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
--
select class, country 
from Classes
where bore >=16 ;

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
--
select ship
from Outcomes
where result = 'sunk' and battle = 'North Atlantic';

-- Задание 6: Вывести название (ship) последнего потопленного корабля
--
select ship
from outcomes
join battles
on outcomes.battle = battles.name
where date = (select max(date)
from outcomes
join battles
on outcomes.battle = battles.name) and result = 'sunk';

-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
--
select ship, class
from outcomes
join ships
on outcomes.ship = ships.name
where ship in (select ship
from outcomes
join battles
on outcomes.battle = battles.name
where date = (select max(date)
from outcomes
join battles
on outcomes.battle = battles.name) and result = 'sunk');

-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
--
select ship, class
from classes
join ships
on classes.class = ships.class
join outcomes
on outcomes.ship = ships.name
where bore >=16 and result = 'sunk';
       

-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
--
select class
from Classes
where country = 'USA';

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class
--
select name, classes.class
from classes
join ships
on classes.class = ships.class
where country = 'USA';