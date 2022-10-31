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
WHERE product.type IN ('PC')
EXCEPT
SELECT product.maker 
FROM product 
WHERE product.type IN ('Laptop');

-- 8.
SELECT DISTINCT product.maker
FROM product
WHERE product.type = 'PC' AND product.maker NOT IN (
	SELECT product.maker
	FROM product
	WHERE product.type = 'Laptop'
);

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
SELECT DISTINCT t1.hd 
FROM pc AS t1
WHERE EXISTS (
    SELECT * 
    FROM pc 
    WHERE pc.hd = t1.hd AND pc.code != t1.code
);

-- 15.
SELECT DISTINCT pc1.hd 
FROM pc AS pc1, pc AS pc2 
WHERE pc1.hd = pc2.hd AND pc1.code != pc2.code;

