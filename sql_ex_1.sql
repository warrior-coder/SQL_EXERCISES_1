-- 1. Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
-- Result set: model, speed, hd.
SELECT model, speed, dh
FROM pc
WHERE price < 500;

-- 2. List all printer makers.
-- Result set: maker.
SELECT DISTINCT maker
FROM product
WHERE type = 'Printer';

-- 3. Find the model number, RAM and screen size of the laptops with prices over $1000.
SELECT model, ram, screen
FROM laptop
WHERE price > 1000;

-- 4. Find all records from the Printer table containing data about color printers.
SELECT *
FROM printer
WHERE color = 'y';

-- 5. Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive.
SELECT model, speed, hd
FROM pc 
WHERE (price < 600) AND cd IN ('12x', '24x');

-- 6. For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops.
-- Result set: maker, speed.
SELECT DISTINCT product.maker, laptop.speed
FROM product
JOIN laptop ON product.model = laptop.model
WHERE laptop.hd >= 10;

-- 7. Get the models and prices for all commercially available products (of any type) produced by maker B.
SELECT pc.model, pc.price
FROM pc
LEFT JOIN product ON pc.model = product.model
WHERE product.maker = 'B'
UNION
SELECT laptop.model, laptop.price
FROM laptop
LEFT JOIN product ON laptop.model = product.model
WHERE product.maker = 'B'
UNION
SELECT printer.model, printer.price
FROM printer
LEFT JOIN product ON printer.model = product.model
WHERE product.maker = 'B';

-- 7.
SELECT pc.model, pc.price
FROM pc
WHERE pc.model IN (
    SELECT product.model
    FROM product
    WHERE product.maker = 'B'
)
UNION 
SELECT laptop.model, laptop.price
FROM laptop
WHERE laptop.model IN (
    SELECT product.model
    FROM product
    WHERE product.maker = 'B'
)
UNION 
SELECT printer.model, printer.price
FROM printer
WHERE printer.model IN (
    SELECT product.model
    FROM product
    WHERE product.maker = 'B'
);

-- 8. Find the makers producing PCs but not laptops.
SELECT product.maker 
FROM product
WHERE product.type = 'PC'
EXCEPT
SELECT product.maker 
FROM product 
WHERE product.type = 'Laptop';

-- 8.
SELECT DISTINCT p.maker
FROM product AS p
WHERE p.type = 'PC' AND p.maker NOT IN (
	SELECT product.maker
	FROM product
	WHERE product.type = 'Laptop'
);

-- 8.
SELECT DISTINCT p.maker
FROM product AS p
WHERE p.type = 'PC' AND NOT EXISTS (
    SELECT product.maker 
    FROM product
    WHERE product.type = 'Laptop' AND product.maker = p.maker
);

-- 8.
SELECT DISTINCT p.maker 
FROM product AS p 
WHERE (
    SELECT COUNT(1) 
    FROM product 
    WHERE product.type = 'PC' AND product.maker = p.maker
) > 0 AND (
    SELECT COUNT(1) 
    FROM product
    WHERE product.type = 'Laptop' AND product.maker = p.maker
) = 0;

-- 9. Find the makers of PCs with a processor speed of 450 MHz or more.
-- Result set: maker.
SELECT DISTINCT product.maker
FROM product
JOIN pc ON product.model = pc.model
WHERE pc.speed >= 450;

-- 10. Find the printer models having the highest price.
-- Result set: model, price.
SELECT printer.model, printer.price
FROM printer
WHERE printer.price = (
    SELECT MAX(printer.price)
    FROM printer
);

-- 10.
SELECT printer.model, printer.price
FROM printer, (
    SELECT MAX(price) AS max_price  
    FROM printer
) AS t1 
WHERE price = t1.max_price;

-- 11. Find out the average speed of PCs.
SELECT AVG(speed)
FROM pc;

-- 12. Find out the average speed of the laptops priced over $1000.
SELECT AVG(speed) 
FROM laptop
WHERE price > 1000;

-- 13. Find out the average speed of the PCs produced by maker A.
SELECT AVG(t1.speed)
FROM (
    SELECT pc.speed
    FROM pc
    JOIN product ON pc.model = product.model
    WHERE product.maker = 'A'
) AS t1;

-- 15. Get hard drive capacities that are identical for two or more PCs.
-- Result set: hd.
SELECT hd
FROM pc
GROUP BY hd
HAVING COUNT(hd) >= 2;

-- 15.
SELECT DISTINCT p.hd 
FROM pc AS p
WHERE EXISTS (
    SELECT * 
    FROM pc 
    WHERE pc.hd = p.hd AND pc.code != p.code
);

-- 15.
SELECT DISTINCT pc1.hd 
FROM pc AS pc1, pc AS pc2 
WHERE pc1.hd = pc2.hd AND pc1.code != pc2.code;

-- 16. Get pairs of PC models with identical speeds and the same RAM capacity.
-- Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i).
-- Result set: model with the bigger number, model with the smaller number, speed, and RAM.
SELECT DISTINCT pc1.model, pc2.model, pc1.speed, pc1.ram
FROM pc AS pc1, pc AS pc2
WHERE pc1.model > pc2.model AND pc1.speed = pc2.speed AND pc1.ram = pc2.ram;

-- 17. Get the laptop models that have a speed smaller than the speed of any PC.
-- Result set: type, model, speed.
SELECT DISTINCT 'Laptop', laptop.model, laptop.speed
FROM laptop, pc
WHERE laptop.speed < ALL(
    SELECT pc.speed FROM pc
);

-- 18. Find the makers of the cheapest color printers.
-- Result set: maker, price.
SELECT DISTINCT product.maker, color_printer.price
FROM (
    SELECT *
    FROM printer
    WHERE printer.color = 'y'
) AS color_printer
JOIN product ON color_printer.model = product.model
WHERE color_printer.price = (
    SELECT MIN(price)
    FROM printer
    WHERE color = 'y'
);

-- 19. For each maker having models in the Laptop table, find out the average screen size of the laptops he produces.
-- Result set: maker, average screen size.
SELECT product.maker, AVG(laptop.screen)
FROM laptop
JOIN product ON laptop.model = product.model
GROUP BY product.maker;

-- 20. Find the makers producing at least three distinct models of PCs.
-- Result set: maker, number of PC models.
    SELECT product.maker, COUNT(product.model)
    FROM product
    WHERE product.type = 'pc'
    GROUP BY product.maker
    HAVING COUNT(product.model) >= 3;

-- 21. Find out the maximum PC price for each maker having models in the PC table.
-- Result set: maker, maximum price.
SELECT product.maker, MAX(pc.price)
FROM product
JOIN pc ON product.model = pc.model
GROUP BY product.maker;

-- 22. For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds.
-- Result set: speed, average price.
SELECT pc.speed, AVG(pc.price)
FROM pc
WHERE pc.speed > 600
GROUP BY pc.speed;

-- 23. Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher.
-- Result set: maker
SELECT product.maker
FROM product
JOIN pc ON product.model = pc.model
WHERE pc.speed >= 750
INTERSECT
SELECT product.maker
FROM product
JOIN laptop ON product.model = laptop.model
WHERE laptop.speed >= 750;

-- 24. List the models of any type having the highest price of all products present in the database.
SELECT t1.model
FROM (
    SELECT model, price FROM pc
    UNION
    SELECT model, price FROM laptop
    UNION
    SELECT model, price FROM printer
) AS t1
WHERE t1.price = (
    SELECT MAX(t2.price)
    FROM (
        SELECT model, price FROM pc
        UNION
        SELECT model, price FROM laptop
        UNION
        SELECT model, price FROM printer
    ) AS t2
);

-- 24.
WITH t1 AS (
    SELECT model, price FROM pc
    UNION
    SELECT model, price FROM laptop
    UNION
    SELECT model, price FROM printer
)
SELECT t1.model
FROM t1
WHERE t1.price = (
    SELECT MAX(t1.price) FROM t1
);

-- 25. Find the printer makers also producing PCs with the lowest RAM capacity and the highest processor speed of all PCs having the lowest RAM capacity.
-- Result set: maker.
SELECT DISTINCT product.maker FROM product
JOIN pc ON product.model = pc.model
WHERE pc.ram = (
    SELECT MIN(ram) FROM pc
) AND pc.speed = (
    SELECT MAX(speed) FROM pc
    WHERE ram = (
        SELECT MIN(ram) FROM pc
    )
) AND product.maker IN (
    SELECT maker FROM product
    WHERE type = 'printer'
);

-- 26. Find out the average price of PCs and laptops produced by maker A.
-- Result set: one overall average price for all items.
-- Hint: UNION excludes duplicate rows.
SELECT AVG(t1.price)
FROM (
    SELECT laptop.price
    FROM laptop
    JOIN product ON laptop.model = product.model
    WHERE product.maker = 'A'
    UNION ALL
    SELECT pc.price
    FROM pc
    JOIN product ON pc.model = product.model
    WHERE product.maker = 'A'
) AS t1;

-- 26.
SELECT AVG(t1.price)
FROM (
    SELECT laptop.price, product.maker 
    FROM laptop
    JOIN product ON laptop.model = product.model
    UNION ALL
    SELECT pc.price, product.maker
    FROM pc
    JOIN product ON pc.model = product.model
) AS t1
WHERE t1.maker = 'A';

-- 27. Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.
-- Result set: maker, average HDD capacity.
SELECT product.maker, AVG(pc.hd)
FROM product
JOIN pc ON product.model = pc.model
WHERE product.maker IN (
    SELECT maker
    FROM product
    WHERE type = 'printer'
)
GROUP BY product.maker;

-- 28. Using Product table, find out the number of makers who produce only one model.
SELECT COUNT(*)
FROM (
    SELECT product.maker, COUNT(product.model) AS model_count
    FROM product
    GROUP BY product.maker
    HAVING COUNT(product.model) = 1
) AS t1;

-- 35. Find models in the Product table consisting either of digits only or Latin letters (A-Z, case insensitive) only.
-- Result set: model, type.
SELECT model, type
FROM product
WHERE model NOT LIKE '%[^0-9]%' OR model NOT LIKE '%[^a-z]%';

-- 35.
SELECT model, type
FROM product
WHERE model LIKE REPLICATE('[0-9]', LEN(model)) OR model LIKE REPLICATE('[a-z]', LEN(model));