--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--�������: ��� ������� ������ ���������� ����� �������� ����� ������, ����������� � ���������. �������: ����� � ����� ����������� ��������.

  select c.class, count(os.ship) from classes c
  left join (select o.ship, s.class from outcomes o
  left join ships s
  on o.ship = s.name
  where result = 'sunk') as os
  on c.class = os.class OR os.ship = c.class
  GROUP BY c.class
   ;
  
--task2
--�������: ��� ������� ������ ���������� ���, ����� ��� ������ �� ���� ������ ������� ����� ������. ���� ��� ������ �� ���� ��������� ������� ����������, ���������� ����������� ��� ������ �� ���� �������� ����� ������. �������: �����, ���.
 
select c.class, min(launched) as year
from classes c
left join ships s
on c.class  = s.class
group by c.class
order by year;

--task3
--�������: ��� �������, ������� ������ � ���� ����������� �������� � �� ����� 3 �������� � ���� ������, ������� ��� ������ � ����� ����������� ��������.

with t1 as (
  select ship as name, ship as class from outcomes
    union
  select name, class from ships
  )
  select os.class, sum(os.flag)  from classes c
  left join (select t1.name, t1.class, CASE WHEN o.result = 'sunk' THEN 1 ELSE 0 END AS flag 
  from t1 
  left join outcomes o
  on o.ship = t1.name
  ) as os
  on c.class = os.class
   GROUP BY os.class
  HAVING COUNT(os.name) >= 3 and sum(flag)>0;
  
  
--task4
--�������: ������� �������� ��������, ������� ���������� ����� ������ ����� ���� �������� ������ �� ������������� (������ ������� �� ������� Outcomes).
with t1 as (
  select name, class from ships 
    union
  select ship as name, ship as class from outcomes
  )
  select t1.name from t1
 join (select c.class, c.numguns from classes c, classes cl
 where c.displacement = cl.displacement) c1
 on t1.class = c1.class
and numguns >= all(select numguns from classes  where class in (SELECT t1.class 
                                            FROM t1)  );                                    
                                          
  
--task5
--������������ �����: ������� �������������� ���������, ������� ���������� �� � ���������� ������� RAM � � ����� ������� ����������� ����� ���� ��, ������� ���������� ����� RAM. �������: Maker

with us as (select model, speed 
      from pc
      where ram = (select min(ram) from pc))
select distinct maker from product
where type='Printer' 
and 
maker in (select maker
from  us
      join product pr
      on us.model = pr.model 
      where speed = (select max(speed) from us))
