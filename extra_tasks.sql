-- a) Find PC models having a speed of at least 3.00
SELECT model
FROM pc
WHERE speed > 3.0;

-- b) Find makers producing laptops with hd of at least 100GB.
SELECT product.maker
FROM product
JOIN laptop ON product.model = laptop.model
WHERE laptop.hd > 100.0;

-- c) Find the model numbers and price of all products made by maker B.
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

-- c)
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

-- d) Find the model numbers of all color laser printers.
SELECT model
FROM printer
WHERE color = 'y' AND type = 'Laser';

-- e) Find those makers producing laptops but not PCs.
SELECT product.maker 
FROM product
WHERE product.type = 'PC'
EXCEPT
SELECT product.maker 
FROM product 
WHERE product.type = 'Laptop';

-- e) 2
SELECT DISTINCT p.maker
FROM product AS p
WHERE p.type = 'Laptop' AND p.maker NOT IN (
	SELECT product.maker
	FROM product
	WHERE product.type = 'PC'
);

-- e) 3
SELECT DISTINCT p.maker
FROM product AS p
WHERE p.type = 'Laptop' AND NOT EXISTS (
    SELECT product.maker 
    FROM product
    WHERE product.type = 'PC' AND product.maker = p.maker
);

-- e) 4
SELECT DISTINCT p.maker 
FROM product AS p 
WHERE (
    SELECT COUNT(1) 
    FROM product 
    WHERE product.type = 'Laptop' AND product.maker = p.maker
) > 0 AND (
    SELECT COUNT(1) 
    FROM product
    WHERE product.type = 'PC' AND product.maker = p.maker
) = 0;

-- f) Find those hd sizes that occur in two or more PCs.
SELECT hd
FROM pc
GROUP BY hd
HAVING COUNT(hd) >= 2;

-- f) 2
SELECT DISTINCT p.hd 
FROM pc AS p
WHERE EXISTS (
    SELECT * 
    FROM pc 
    WHERE pc.hd = p.hd AND pc.code != p.code
);

-- f) 3
SELECT DISTINCT pc1.hd 
FROM pc AS pc1, pc AS pc2 
WHERE pc1.hd = pc2.hd AND pc1.code != pc2.code;

