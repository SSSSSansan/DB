CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(255),
    price DECIMAL(10, 2),
    quantity INT
);

INSERT INTO Books (book_id, title, author, price, quantity) VALUES
(1, 'Database 101', 'A. Smith', 40.00, 10),
(2, 'Learn SQL', 'B. Johnson', 35.00, 15),
(3, 'Advanced DB', 'C. Lee', 50.00, 5);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    book_id INT,
    customer_id INT,
    order_date DATE,
    quantity INT,
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255)
);

INSERT INTO Customers (customer_id, name, email) VALUES
(101, 'John Doe', 'johndoe@example.com'),
(102, 'Jane Doe', 'janedoe@example.com');
--1
BEGIN TRANSACTION;

INSERT INTO Orders (order_id, book_id, customer_id, order_date, quantity)
VALUES (1, 1, 101, CURRENT_DATE, 2);

UPDATE Books
SET quantity = quantity - 2
WHERE book_id = 1;

COMMIT;
--2
BEGIN;

DO $$
DECLARE
    available_quantity INT;
BEGIN
    SELECT quantity INTO available_quantity
    FROM Books
    WHERE book_id = 3;

    IF available_quantity >= 10 THEN
        INSERT INTO Orders (order_id, book_id, customer_id, order_date, quantity)
        VALUES (1, 3, 102, CURRENT_DATE, 10);

        UPDATE Books
        SET quantity = quantity - 10
        WHERE book_id = 3;

        RAISE NOTICE 'Order placed successfully.';
    ELSE
        RAISE NOTICE 'Insufficient stock. Transaction rolled back.';
        ROLLBACK;
        RETURN;
    END IF;
END $$;

COMMIT;
--3
--step1
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;
UPDATE Books SET price = 45.00 WHERE book_id = 1;
--step2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;
SELECT price FROM Books WHERE book_id = 1;
--c1
COMMIT;
--r2
SELECT price FROM Books WHERE book_id = 1;
--4
BEGIN;
UPDATE Customers SET email = 'newemail@example.com' WHERE customer_id = 101;
COMMIT;

SELECT customer_id, name, email FROM Customers WHERE customer_id = 101;
