--a) Which are the supermarkets names that start with ‘P’ and end with ‘E’?

SELECT name 
FROM supermarket
WHERE name LIKE 'P%E';


--b) How many units of the product ‘Golden Whistle’ were replenished in 2018?

SELECT SUM(r.number_units) as sum
FROM replenishment r
WHERE r.ean = (
	SELECT p.ean
	FROM product p
	WHERE p.designation = 'Golden Whistle') AND
r.instant BETWEEN '2018-01-01' AND '2018-12-31';


--c) Which primary suppliers (name and TIN) have supplied products of simple categories

SELECT DISTINCT ps.tin_supplier, ps.name_supplier
FROM primary_supplier ps
	JOIN product p
	  ON ps.tin_supplier = p.tin_supplier
	JOIN organized_into oi
	  ON p.ean = oi.ean
	WHERE oi.name IN (
		SELECT name
		FROM simple_category
);


--d)  Which products (ean) have less than 3 secondary suppliers

SELECT p.ean, p.designation, COUNT(*) AS 'Number of Suppliers'
FROM product p JOIN supplies_secondary s
	ON p.tin_supplier = s.tin_supplier
GROUP BY p.ean, p.designation
HAVING COUNT(*) < 3


--e) What is the name of the supplier that supplied more categories? (Note that there can be more than one)

SELECT ps.name_supplier, COUNT(DISTINCT oi.name) AS number_of_categories_supplied
FROM primary_supplier ps
	FULL OUTER JOIN product p
	  ON ps.tin_supplier = p.tin_supplier
	FULL OUTER JOIN supplies_secondary ss
	  ON p.ean = ss.ean
	FULL OUTER JOIN organized_into oi
	  ON p.ean = oi.ean
GROUP BY ps.name_supplier
HAVING COUNT(DISTINCT oi.name) >= ALL (
	SELECT COUNT(DISTINCT oi.name)
	FROM primary_supplier ps
		FULL OUTER JOIN product p
		  ON ps.tin_supplier = p.tin_supplier
		FULL OUTER JOIN supplies_secondary ss
		  ON p.ean = ss.ean
		FULL OUTER JOIN organized_into oi
		  ON p.ean = oi.ean
	GROUP BY ps.name_supplier
);


--f) Which supplier (name and TIN) has supplied the more simple categories?

SELECT tin_supplier, name_supplier
FROM supplier
WHERE tin_supplier IN (
	SELECT s.tin_supplier
	FROM supplier s
	WHERE tin_supplier IN (
		SELECT p.tin_supplier
		FROM product p
			JOIN organized_into oi
			  ON p.ean = oi.ean
			JOIN category c 
			  ON oi.name = c.name
			JOIN simple_category sc 
			  ON c.name=sc.name
		GROUP BY p.tin_supplier
		HAVING COUNT(*)	>= ALL (
			SELECT COUNT(s.tin_supplier)
			FROM supplier s
				JOIN product p
				  ON s.tin_supplier = p.tin_supplier
				JOIN organized_into oi
				  ON p.ean = oi.ean
				JOIN category c 
				  ON oi.name = c.name
				JOIN simple_category sc 
				  ON c.name=sc.name
			GROUP BY s.tin_supplier
			HAVING s.tin_supplier IN (
				SELECT tin_supplier 
				FROM supplier
			) 
		)
	)
);


--g) Which product (ean) have never been replenished?

SELECT ean, designation
FROM product
WHERE ean NOT IN (
	SELECT ean 
	FROM replenishment
); 


--h) Which products (ean and designation) have been replenished in more than 10 units after '10/10/2018' in the category ‘Vegetais’?

SELECT DISTINCT p.ean, p.designation
FROM product p JOIN organized_into oi
	ON p.ean = oi.ean
JOIN replenishment r
	ON p.ean = r.ean
WHERE oi.name LIKE 'Vegetais' AND
	r.number_units > 10 AND
	r.instant > '2018-10-10';


--i) What is the total number of sub-categories (DIRECT DESCENDANTS of the category 'Refeicoes congeladas')

SELECT COUNT(*) AS number_of_subcategories
FROM made_up 
GROUP BY name_super 
HAVING name_super LIKE 'Refeicoes congeladas';