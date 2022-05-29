--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- ������� 20: ������� ������� ������ hd PC ������� �� ��� ��������������, ������� ��������� � ��������. �������: maker, ������� ������ HD.
--
select avg(hd), maker 
from product join pc
on pc.model = product.model
where maker in (SELECT maker
FROM product
WHERE type='Printer') 
group by maker; 

-- ������� 1: ������� name, class �� ��������, ���������� ����� 1920
--
select name, class
from Ships
where launched > 1920 ; 

-- ������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942
--
select name, class
from Ships
where launched > 1920 and launched <= 1942 ;

-- ������� 3: ����� ���������� �������� � ������ ������. ������� ���������� � class
--
select count(class) as count, class
from Ships
group by class
order by count;

-- ������� 4: ��� ������� ��������, ������ ������ ������� �� ����� 16, ������� ����� � ������. (������� classes)
--
select class, country 
from Classes
where bore >=16 ;

-- ������� 5: ������� �������, ����������� � ��������� � �������� ��������� (������� Outcomes, North Atlantic). �����: ship.
--
select ship
from Outcomes
where result = 'sunk' and battle = 'North Atlantic';

-- ������� 6: ������� �������� (ship) ���������� ������������ �������
--
select ship
from outcomes
join battles
on outcomes.battle = battles.name
where date = (select max(date)
from outcomes
join battles
on outcomes.battle = battles.name) and result = 'sunk';

-- ������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������
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

-- ������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class
--
select ship, class
from classes
join ships
on classes.class = ships.class
join outcomes
on outcomes.ship = ships.name
where bore >=16 and result = 'sunk';
       

-- ������� 9: ������� ��� ������ ��������, ���������� ��� (������� classes, country = 'USA'). �����: class
--
select class
from Classes
where country = 'USA';

-- ������� 10: ������� ��� �������, ���������� ��� (������� classes & ships, country = 'USA'). �����: name, class
--
select name, classes.class
from classes
join ships
on classes.class = ships.class
where country = 'USA';