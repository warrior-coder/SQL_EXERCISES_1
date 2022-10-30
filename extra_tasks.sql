-- a) Find PC models having a speed of at least 3.00
SELECT model
FROM pc
WHERE speed > 3.0;

-- b) Find makers producing laptops with hd of at least 100GB.
SELECT product.maker
FROM product
JOIN laptop ON product.model = laptop.model;
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
((SELECT DISTINCT maker
FROM product, laptop
WHERE product.model = laptop.model)

EXCEPT ALL

(SELECT DISTINCT maker
FROM product, pc
WHERE product.model = pc.model));

-- f) Find those hd that occur in two or more PCs.
SELECT hd
FROM pc
GROUP BY hd
HAVING COUNT(hd) >= 2