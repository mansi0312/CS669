CREATE TABLE Pizza (
pizza_id DECIMAL(12) PRIMARY KEY,
name VARCHAR(32) NOT NULL,
date_available DATE NOT NULL,
price DECIMAL(4,2) NOT NULL
);
CREATE TABLE Topping (
topping_id DECIMAL(12) PRIMARY KEY,
topping_name VARCHAR(64) NOT NULL,
pizza_id DECIMAL(12) FOREIGN KEY REFERENCES Pizza(pizza_id)
);

INSERT INTO Pizza (pizza_id, name, date_available, price)
VALUES (1, 'Plain', '12-OCT-2020', $5.07);
INSERT INTO Pizza (pizza_id, name, date_available, price)
VALUES (2, 'Cheese Burst', '10-OCT-2020', $15.07);
INSERT INTO Pizza (pizza_id, name, date_available, price)
VALUES (3, 'Veggie Blast', '17-OCT-2020', $10.07);
INSERT INTO Pizza (pizza_id, name, date_available, price)
VALUES (4, 'Paneer Delight', '20-OCT-2020', $25.07);
INSERT INTO Topping(topping_id, topping_name)
VALUES (101, 'Extra Tomatoes');
INSERT INTO Topping(topping_id, topping_name, pizza_id)
VALUES (201, 'Extra Cheese',2);
INSERT INTO Topping(topping_id, topping_name, pizza_id)
VALUES (202, 'Extra Onions', 2);
INSERT INTO Topping(topping_id, topping_name, pizza_id)
VALUES (301, 'Extra Capsicum', 3);
INSERT INTO Topping(topping_id, topping_name, pizza_id)
VALUES (302, 'Extra Spicy', 3);
INSERT INTO Topping(topping_id, topping_name, pizza_id)
VALUES (401, 'Extra Corn',4);
INSERT INTO Topping(topping_id, topping_name, pizza_id)
VALUES (402, 'Extra Paneer', 4);

SELECT * 
FROM Pizza;
SELECT *
FROM Topping;

INSERT INTO Topping(topping_id, topping_name, pizza_id)
VALUES (1, 'Pepparoni', 100);

SELECT name, topping_name
FROM Topping
JOIN Pizza ON Topping.pizza_id = Pizza.pizza_id;

SELECT name, date_available, topping_name
FROM Topping
RIGHT JOIN Pizza ON Topping.pizza_id = Pizza.pizza_id
ORDER BY date_available;
SELECT name, date_available, topping_name
FROM Pizza
LEFT JOIN Topping ON Topping.pizza_id = Pizza.pizza_id
ORDER BY date_available;


SELECT topping_name, name
FROM Topping
LEFT JOIN Pizza ON Topping.pizza_id = Pizza.pizza_id
ORDER BY topping_name DESC;
SELECT topping_name, name
FROM Pizza
RIGHT JOIN Topping ON Topping.pizza_id = Pizza.pizza_id
ORDER BY topping_name DESC;

SELECT name, topping_name
FROM Pizza
FULL JOIN Topping ON Topping.pizza_id = Pizza.pizza_id
ORDER BY name, topping_name;

