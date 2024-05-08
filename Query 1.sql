DROP TABLE IF EXISTS brands;

CREATE TABLE brands 
(
    brand1      VARCHAR(20),
    brand2      VARCHAR(20),
    year        INT,
    custom1     INT,
    custom2     INT,
    custom3     INT,
    custom4     INT
);

INSERT INTO brands VALUES ('apple', 'samsung', 2020, 1, 2, 1, 2);
INSERT INTO brands VALUES ('samsung', 'apple', 2020, 1, 2, 1, 2);
INSERT INTO brands VALUES ('apple', 'samsung', 2021, 1, 2, 5, 3);
INSERT INTO brands VALUES ('samsung', 'apple', 2021, 5, 3, 1, 2);
INSERT INTO brands VALUES ('google', NULL, 2020, 5, 9, NULL, NULL);
INSERT INTO brands VALUES ('oneplus', 'nothing', 2020, 5, 9, 6, 3);


SELECT * FROM brands


/* Problem Statement:
- For pairs of brands in the same year (e.g. apple/samsung/2020 and samsung/apple/2020) 
    - if custom1 = custom3 and custom2 = custom4 : then keep only one pair

- For pairs of brands in the same year 
    - if custom1 != custom3 OR custom2 != custom4 : then keep both pairs

- For brands that do not have pairs in the same year : keep those rows as well
*/

--- Solution 1 : CTE inside CTE
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


--- Solution 2 : 2 independent CTEs

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