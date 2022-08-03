--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко
request = """ 
create table t3ct as
with tmp as (
    select 
        (random()*1000000)::int as one_col,
        (random()*1000000)::int as two_col,
        (random()*1000000)::int as three_col
    from generate_series(1, 10000))
   select
    one_col,
    two_col,
    three_col
from tmp;

select * from  t3ct
""" 
df = pd.read_sql_query(request, conn_psql)
df.to_sql('t3ct', conn)

import matplotlib.pyplot as plt
df.plot.bar()
plt.show()

--более наглядно:
df.hist(figsize = (16,10), xlabelsize = 8, ylabelsize = 8)
plt.show()

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

Select email from (
    Select email, count (*) as c from person group BY email) 
    where c >=2;
   
--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

select n.name as Employee
from employee n
join employee m on n.managerId = m.id
where n.salary > m.salary;

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/

Select score, DENSE_RANK() OVER(ORDER BY score DESC) 
as 
Rank from Scores;

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

Select firstName, lastName, city, state 
from person p
left Join Address a 
on p.personId = a.personId;
