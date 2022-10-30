/* 1. Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd */
SELECT model, speed, dh
FROM pc
WHERE price < 500;

/* 2. Найдите производителей принтеров. Вывести: maker */
SELECT DISTINCT maker
FROM product
WHERE type = 'Printer';

/* 3. Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол. */
SELECT model, ram, screen
FROM laptop
WHERE price > 1000;

/* 4. Найдите все записи таблицы Printer для цветных принтеров. */
SELECT *
FROM printer
WHERE color = 'y';

/* 5. Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол. */
SELECT model, speed, hd
FROM pc 
WHERE (price < 600) AND cd IN ('12x', '24x');

/* 6. Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость. */
SELECT DISTINCT product.maker, laptop.speed
FROM product
JOIN laptop ON product.model = laptop.model
WHERE laptop.hd >= 10;

/* 7. Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква). */
SELECT pc.model, pc.price 
FROM pc
LEFT JOIN product ON product.model = pc.model
WHERE product.maker = 'B'
UNION
SELECT laptop.model, laptop.price 
FROM laptop
LEFT JOIN product ON product.model = laptop.model
WHERE product.maker = 'B'
UNION
SELECT printer.model, printer.price 
FROM printer
LEFT JOIN product ON product.model = printer.model
WHERE product.maker = 'B';

/* -- 8. Найдите производителя, выпускающего ПК, но не ПК-блокноты. */
SELECT product.maker
FROM product
JOIN pc ON product.model = pc.model
EXCEPT 
SELECT product.maker
FROM product
JOIN laptop ON product.model = laptop.model;

/* 9. Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker */
SELECT DISTINCT product.maker
FROM product
JOIN pc ON product.model = pc.model
WHERE pc.speed >= 450;

/* 10. Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price */
SELECT printer.model, printer.price
FROM printer
WHERE printer.price = (
    SELECT MAX(printer.price)
    FROM printer
);

/* 11. Найдите среднюю скорость ПК. */
SELECT AVG(speed)
FROM pc;

/* 12. Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол. */
SELECT AVG(speed) 
FROM laptop
WHERE price > 1000;

/* 13. Найдите среднюю скорость ПК, выпущенных производителем A. */
SELECT AVG(t1.speed)
FROM (
    SELECT pc.speed
    FROM pc
    JOIN product ON pc.model = product.model
    WHERE product.maker = 'A'
) AS t1;

/* 14. Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий. */