# 30_Day_SQL_Query_Challenge-Solving_SQL_Problems_for_Interview
## Solving 30 SQL problems

Acknowledgement: Questions for this projects are taken from multiple souces by youtube channel techTFQ.

30 Day SQL Query Challenge is covering 30 SQL Queries of varying complexity. This project aims to provide 30 SQL Queries that can be asked during SQL Interviews.

## DAY 1

### Question 1 : Remove Redundant Pairs

Problem Statement:
- For pairs of brands in the same year (e.g. apple/samsung/2020 and samsung/apple/2020) 
      - if custom1 = custom3 and custom2 = custom4 : then keep only one from pair
- For pairs of brands in the same year 
      - if custom1 != custom3 OR custom2 != custom4 : then keep both from pairs
- For brands that do not have pairs in the same year : keep those rows as well
  
  ![Query1](https://github.com/towhidrazu/30_Day_SQL_Query_Challenge-Solving_SQL_Problems_for_Interview/blob/main/Query1.png)

### Solution of question no. 1: CTE inside CTE

```
WITH temp AS(
	WITH CTE AS(
		SELECT *, 
			CASE 
				WHEN brand1 < brand2 THEN CONCAT(brand1, brand2, year)
				ELSE CONCAT (brand2, brand1, year)
			END AS pair_id
		FROM brands)
	SELECT *, ROW_NUMBER() OVER(PARTITION BY pair_id) AS rn
	FROM CTE)
SELECT brand1, brand2, year, custom1, custom2, custom3, custom4
FROM temp
WHERE rn = 1 OR (custom1 <> custom3 AND custom2 <> custom4)
```

### Solution of question no. 1: 2 independent CTEs

```
WITH CTE AS(SELECT *,
		CASE 
			WHEN brand1 > brand2 THEN CONCAT(brand2,brand1,year)
			ELSE CONCAT (brand1, brand2, year)
		END AS pair_id
            FROM brands),
     CTE2 AS(SELECT *, ROW_NUMBER() OVER(PARTITION BY pair_id) AS rn
			 FROM CTE)
SELECT brand1, brand2, year, custom1, custom2, custom3, custom4
FROM CTE2
WHERE rn = 1 OR (custom1 <> custom3 AND custom2 <> custom4)
```

## DAY 2

### Question 2: Find the unique numbers of drivers and matching drivers

Problem Statement:
 
  ![Query1](https://github.com/towhidrazu/30_Day_SQL_Query_Challenge-Solving_SQL_Problems_for_Interview/blob/main/Query2.png)

### Solution of question no. 2: Full Join

```
select d1.driver1, d2.driver2
from drivers d1
full join drivers d2
on d1.driver1 = d2.driver2
```

## DAY 3

### Question 3: Find the names contain special character or numbers

Problem Statement:
 
  ![Query1](https://github.com/towhidrazu/30_Day_SQL_Query_Challenge-Solving_SQL_Problems_for_Interview/blob/main/Query3.png)

### Solution of question no. 3: SIMILAR TO

```
select *
from all_names
where names SIMILAR TO '%[0-9]%' OR names SIMILAR TO '%[^a-zA-Z\s]%'
```



## DAY 4

### Question 4: Identify the students who always outscored themselves each semester.

Problem Statement:
 
  ![Query1](https://github.com/towhidrazu/30_Day_SQL_Query_Challenge-Solving_SQL_Problems_for_Interview/blob/main/Query4.png)

### 1st Solution of question no. 4: Subquery, Lead window function

```
select student_name
from
(select *, lead(percentage,1,percentage) over (partition by id order by semester) next_per, percentage - lead(percentage,1,percentage) over (partition by id order by semester) diff
from student_marks)
group by student_name
having max(diff) = 0
```

### 2nd Solution of question no. 4: CTE, Lead window function

```
with CTE as
(
select *, lead(percentage,1,percentage) over (partition by id order by semester) next_per, percentage - lead(percentage,1,percentage) over (partition by id order by semester) diff
from student_marks
)
select student_name
from CTE
group by student_name
having max(diff) = 0
```

## DAY 5

### Question 5: Find the names contain special character or numbers

Problem Statement: Identify the students who attended atleast 3 semesters.
 
  ![Query1](https://github.com/towhidrazu/30_Day_SQL_Query_Challenge-Solving_SQL_Problems_for_Interview/blob/main/Query5.png)

### Solution of question no. 5: GROUP BY, COUNT

```
select student_name
from student_semesters
group by student_name
having count(1)>2
```

## DAY 6

### Question 6: Delete duplicate user entries. Only the first entry made by each user must be kept.

Problem Statement:
 
  ![Query1](https://github.com/towhidrazu/30_Day_SQL_Query_Challenge-Solving_SQL_Problems_for_Interview/blob/main/Query6.png)

### 1st Solution of question no.6: Subquery, row_number window function

```
select id, user_name, email
from(
select *, row_number() over(partition by user_name order by id)
from user_entries
	)
where row_number = 1
order by id
```

### 2nd Solution of question no.6: Subquery, group by

```
delete from user_entries
where id not in(
		select min(id)
		from user_entries
		group by user_name
		)
select * from user_entries
```

## DAY 7

### Question 7: Identify the countries present in multiple continents.

Problem Statement:
 
  ![Query1](https://github.com/towhidrazu/30_Day_SQL_Query_Challenge-Solving_SQL_Problems_for_Interview/blob/main/Query7.png)

### 1st Solution of question no.7: distinct, Subquery, group by, having

```
select country 
from (select distinct * from countries) c
group by country 
having count(1) > 1
```

### 2nd Solution of question no.7: CTE, CTID, group by, having

```
with CTE as(
		select *
		from countries
		where ctid in (
				select min(ctid)
				from countries
				group by country, continent
				)
	)
select country
from CTE
group by country
having count(country)>1
```


