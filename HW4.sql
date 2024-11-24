
-- a) Назва схеми — “LibraryManagement”
CREATE SCHEMA LibraryManagement;
 -- b) Таблиця "authors":
-- author_id (INT, автоматично зростаючий PRIMARY KEY)
-- author_name (VARCHAR)
USE LibraryManagement;
CREATE TABLE authors (
 author_id INT AUTO_INCREMENT PRIMARY KEY,
 author_name VARCHAR (45)
 );
-- c) Таблиця "genres":
-- genre_id (INT, автоматично зростаючий PRIMARY KEY)
-- genre_name (VARCHAR)
CREATE TABLE genres (
 genre_id INT AUTO_INCREMENT PRIMARY KEY,
 genre_name VARCHAR (45)
 ); 
-- d) Таблиця "books":
-- book_id (INT, автоматично зростаючий PRIMARY KEY)
-- title (VARCHAR)
-- publication_year (YEAR)
-- author_id (INT, FOREIGN KEY зв'язок з "Authors")
-- genre_id (INT, FOREIGN KEY зв'язок з "Genres")
CREATE TABLE books (
 book_id INT AUTO_INCREMENT PRIMARY KEY,
 title VARCHAR (45),
 publication_year YEAR,
 author_id INT,
 FOREIGN KEY (author_id) REFERENCES authors(author_id),
 genre_id INT,
 FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
 );
 -- e) Таблиця "users":
-- user_id (INT, автоматично зростаючий PRIMARY KEY)
-- username (VARCHAR)
-- email (VARCHAR)
CREATE TABLE users (
 user_id INT AUTO_INCREMENT PRIMARY KEY,
 username VARCHAR (45),
 email VARCHAR (45)
 );
 -- f) Таблиця "borrowed_books":
-- borrow_id (INT, автоматично зростаючий PRIMARY KEY)
-- book_id (INT, FOREIGN KEY зв'язок з "Books")
-- user_id (INT, FOREIGN KEY зв'язок з "Users")
-- borrow_date (DATE)
-- return_date (DATE)
CREATE TABLE borrowed_books (
 borrow_id INT AUTO_INCREMENT PRIMARY KEY,
 book_id INT,
 FOREIGN KEY (book_id) REFERENCES books(book_id),
 user_id INT,
 FOREIGN KEY (user_id) REFERENCES users(user_id),
 borrow_dat DATE,
 return_date DATE
 );
-- 2. Заповніть таблиці простими видуманими тестовими даними. Достатньо одного-двох рядків у кожну таблицю.
INSERT INTO `librarymanagement`.`authors`
(`author_id`,
`author_name`)
VALUES
(3,'Ed'),
(4, 'Vlad');

INSERT INTO `librarymanagement`.`genres`
(`genre_id`,
`genre_name`)
VALUES
(1, 'Dony'),
(2, 'Myke');

INSERT INTO `librarymanagement`.`books`
(`book_id`,
`title`,
`publication_year`,
`author_id`,
`genre_id`)
VALUES
(1, 'Good book', 2021, 1, 1),
(2, 'Bed book', 2022, 2, 2);

INSERT INTO `librarymanagement`.`users`
(`user_id`,
`username`,
`email`)
VALUES
(1, 'Tom', 'egufr@gmail.com'),
(2, 'Jeck', '345@gmail.com');

INSERT INTO `librarymanagement`.`borrowed_books`
(`borrow_id`,
`book_id`,
`user_id`,
`borrow_dat`,
`return_date`)
VALUES
(1, 1, 1, '2024-11-11', '2024-11-12'),
(2, 2, 2, '2024-11-12', '2024-11-13');

-- 3. Перейдіть до бази даних, з якою працювали у темі 
-- Напишіть запит за допомогою операторів FROM та INNER JOIN, що об’єднує всі таблиці даних, 
-- які ми завантажили з файлів: order_details, orders, customers, products, categories,
-- employees, shippers, suppliers. Для цього ви маєте знайти спільні ключі.

USE mydb;

SELECT *
FROM orders
INNER JOIN order_details ON orders.id = order_details.order_id
INNER JOIN shippers ON orders.shipper_id = shippers.id
INNER JOIN employees ON orders.employee_id = employees.employee_id
INNER JOIN customers ON orders.customer_id = customers.id
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN suppliers ON products.supplier_id = suppliers.id
INNER JOIN categories ON products.category_id = categories.id;

-- 4. Виконайте запити, перелічені нижче.

-- Визначте, скільки рядків ви отримали (за допомогою оператора COUNT).
USE mydb;

SELECT COUNT(*) AS total_rows
FROM order_details
INNER JOIN orders ON order_details.order_id = orders.id
INNER JOIN customers ON orders.customer_id = customers.id
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN categories ON products.category_id = categories.id
INNER JOIN employees ON orders.employee_id = employees.employee_id
INNER JOIN shippers ON orders.shipper_id = shippers.id
INNER JOIN suppliers ON products.supplier_id = suppliers.id;

-- Змініть декілька операторів INNER на LEFT чи RIGHT. Визначте, що відбувається з кількістю рядків. 
USE mydb;

SELECT COUNT(*) AS total_rows2
FROM order_details
LEFT JOIN orders ON order_details.order_id = orders.id
RIGHT JOIN customers ON orders.customer_id = customers.id
INNER JOIN products ON order_details.product_id = products.id
LEFT JOIN categories ON products.category_id = categories.id
LEFT JOIN employees ON orders.employee_id = employees.employee_id
INNER JOIN shippers ON orders.shipper_id = shippers.id
INNER JOIN suppliers ON products.supplier_id = suppliers.id;
-- Чому? Напишіть відповідь у текстовому файлі.
-- Оберіть тільки ті рядки, де employee_id > 3 та ≤ 10.
SELECT COUNT(*) AS total_rows2
FROM order_details
LEFT JOIN orders ON order_details.order_id = orders.id
RIGHT JOIN customers ON orders.customer_id = customers.id
INNER JOIN products ON order_details.product_id = products.id
LEFT JOIN categories ON products.category_id = categories.id
LEFT JOIN employees ON orders.employee_id = employees.employee_id
INNER JOIN shippers ON orders.shipper_id = shippers.id
INNER JOIN suppliers ON products.supplier_id = suppliers.id
WHERE employees.employee_id > 3 AND employees.employee_id <= 10;
-- Згрупуйте за іменем категорії, порахуйте кількість рядків у групі,
-- середню кількість товару (кількість товару знаходиться в order_details.quantity)
USE mydb;

SELECT 
    categories.name AS category_name,
    COUNT(order_details.id) AS total_rows,
    AVG(order_details.quantity) AS avg_quantity
FROM order_details
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN categories ON products.category_id = categories.id
GROUP BY categories.name;

-- Відфільтруйте рядки, де середня кількість товару більша за 21.
USE mydb;

SELECT 
    categories.name AS category_name,
    COUNT(order_details.id) AS total_rows,
    AVG(order_details.quantity) AS avg_quantity
FROM order_details
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN categories ON products.category_id = categories.id
GROUP BY categories.name
HAVING AVG(order_details.quantity) > 21;

-- Відсортуйте рядки за спаданням кількості рядків.
USE mydb;

SELECT 
    categories.name AS category_name,
    COUNT(order_details.id) AS total_rows,
    AVG(order_details.quantity) AS avg_quantity
FROM order_details
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN categories ON products.category_id = categories.id
GROUP BY categories.name
ORDER BY total_rows DESC;

-- Виведіть на екран (оберіть) чотири рядки з пропущеним першим рядком.
USE mydb;

SELECT 
    categories.name AS category_name,
    COUNT(*) AS total_rows,
    AVG(order_details.quantity) AS avg_quantity
FROM order_details
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN categories ON products.category_id = categories.id
GROUP BY categories.name
HAVING avg_quantity > 21
ORDER BY total_rows DESC
LIMIT 4 OFFSET 1;



