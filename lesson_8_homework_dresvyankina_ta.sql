--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/
with s_top as
(
 select 
    d.name as dname,
    e.name as ename,
    Salary,
    DENSE_RANK() OVER(PARTITION BY d.ID Order By  e.Salary desc) as rank
 from Employee e join department d
 ON (e.DepartmentId = d.Id)
);

select dname as Department,
ename as Employee,
Salary from s_top
where rank <=3
order by dname;

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17
select member_name, 
status, 
SUM(amount*unit_price) as costs 
from Payments p
join FamilyMembers f
on f.member_id = p.family_member
where Year (date)='2005'
GROUP BY member_name, status;

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13
select name 
FROM passenger 
GROUP by name 
HAVING count(name) > 1;

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
SELECT COUNT(first_name) as count from student 
WHERE first_name LIKE 'Anna';

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35
SELECT  count(classroom) as count 
from Schedule 
where date = '2019.09.02';

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
SELECT COUNT(first_name) as count from student 
WHERE first_name LIKE 'Anna';

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32
SELECT ROUND(avg(YEAR(CURDATE()) - YEAR(birthday))) as age 
from FamilyMembers;

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27
select good_type_name, 
SUM(amount*unit_price) as costs 
from Payments p
join Goods g on p.good = g.good_id
join GoodTypes gt on type = good_type_id 
where Year (date)='2005'
GROUP BY good_type_name;

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37
SELECT min(TIMESTAMPDIFF(Year, BirthDay, CURRENT_DATE)) as year 
from student;

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44
SELECT MAX(TIMESTAMPDIFF(Year, BirthDay, CURRENT_DATE)) as max_year from 
student s join Student_in_class sc
on s.id = sc.student
join Class cl on sc.class = cl.id
where name LIKE '10%';

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20
SELECT status,
member_name,
sum(amount*unit_price) as costs
from GoodTypes gt join Goods g
on gt.good_type_id = g.type
join Payments p 
on g.good_id = p.good
join FamilyMembers fm 
on p.family_member = fm.member_id
where good_type_name = 'entertainment'
GROUP BY status,
member_name;

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

DELETE Company 
FROM  Company  JOIN Trip ON company= Company.id
WHERE Company.id IN (SELECT company FROM ( 
SELECT company, COUNT(ID) AS col FROM Trip
GROUP BY Company HAVING  col = (
SELECT  MIN(col1)  FROM ( 
SELECT COUNT(ID) AS col1 FROM Trip 
GROUP BY company) AS col_)) AS I);

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45
SELECT classroom 
FROM Schedule 
GROUP BY classroom 
HAVING count(classroom) =
(SELECT count(classroom) 
FROM Schedule 
GROUP BY classroom 
ORDER BY COUNT(classroom) DESC LIMIT 1);

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43
SELECT last_name from teacher t
JOIN Schedule s 
on t.id = s.teacher
JOIN subject sb 
on s.subject = sb.id
where sb.name = 'Physical Culture'
ORDER BY last_name;

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63
SELECT CONCAT(last_name, '.',
substring(first_name, 1, 1), '.', 
substring(middle_name, 1, 1), '.') as name FROM Student
ORDER BY last_name , first_name ;
