-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database
-- Product & Inventory Tracking
-- 1. Show all products that are currently out of stock or below a minimum quantity.
SELECT * FROM products
WHERE quantity_in_stock <= min_quantity;

-- 2. List products that will expire within the next 30 days.
SELECT * FROM products
WHERE expiration_date > DATE ('now')
AND expiration_date <= DATE('now', '+30 days');

-- 3. Increase the stock quantity of a product after receiving a new shipment.
-- Adding a new product
INSERT INTO products (product_name, weight_grams, buying_price_VND, selling_price_VND, quantity_in_stock, stocking_date, manufacturing_date, expiration_date, supplier_ID)
VALUES ('Uji Ceremonial',
        30,
        180000,
        250000,
        25,
        '2025-09-25',
        '2025-03-20',
        '2026-03-20',
        1
);
-- Update the stock level of a current product
UPDATE products
SET quantity_in_stock = quantity_in_stock + 20
WHERE product_name = 'Uji Ceremonial';

-- 4. Add a new product with its supplier, prices, and expiration date.
INSERT INTO suppliers (supplier_name, email, phone)
VALUES ('Kyoto Tea House', 'contact@kyototeahouse.jp','+81-75-123-4567');

-- 5. Remove a discontinued product that is no longer sold.
DELETE FROM products
WHERE products.status = 'discontinued';


-- Orders & Sales Tracking
-- 6. Show all orders placed in the last 7 days, with customer names and delivery status.
SELECT customer_name, orders.status
FROM orders
JOIN customers ON customers.customer_ID = orders.customer_ID
WHERE order_date BETWEEN DATE ('now', '-7 day') AND DATE ('now');

-- 7. Find the total sales revenue from completed orders this month. (status = completed)
SELECT  order_items.order_number,
        orders.customer_ID,
        order_date,
        orders.status,
        SUM (order_items.unit_price_VND * order_items.quantity) AS "sale revenue this month"
FROM order_items
JOIN orders ON orders.order_number = order_items.order_number
WHERE orders.status = 'Completed'
AND strftime('%Y-%m', orders.order_date) = strftime('%Y-%m', 'now');


-- 8. Record a new order from a customer (with products and quantities).
INSERT INTO orders ("customer_ID","order_date","phone","delivery_address","payment_method")
VALUES (123,
        '2025-10-06',
        '0937422194',
        '10 3/2 street, district 10, Ho Chi Minh City',
        'MoMo'
        );

-- 9. Change the delivery status of an order (order number = 1) from “Pending” to “Shipped” (or “Delivered”).
UPDATE orders
SET orders.status = 'Shipped'
WHERE order_number = 1;
-- 10. Cancel and remove an order (order number = 5) that was created by mistake. (set to cancelled instead of hard delete)
UPDATE orders
SET orders.status = 'Cancelled'
WHERE order_number = 5;


-- Customers
-- 11. Show the top 5 customers who have spent the most overall.
SELECT customers.customer_ID,
        customer_name,
        SUM (order_items.quantity * order_items.unit_price_VND) AS total_spent
FROM customers
JOIN orders ON customers.customer_ID = orders.customer_ID
JOIN order_items ON orders.order_number = order_items.order_number
WHERE orders.status != 'Cancelled'
GROUP BY customers.customer_ID
HAVING total_spent > 0
ORDER BY total_spent DESC
LIMIT 5;

-- 12. Add a new customer with their contact details.
INSERT INTO customers ("customer_name","phone","address")
VALUES ('Suri','0977344233', '52 Ho Thi Ky Street, District 3, Ho Chi Minh City');

-- 13. Update a customer’s delivery address or phone number.
--NOTE: here we have not yet had a order from Suri so information updated in customers table instead of orders table
UPDATE customers
SET address = '50 Ho Thi Ky Street, District 3, Ho Chi Minh City'
WHERE customer_name = 'Suri'
AND phone = '0977344233'
;

-- Suppliers & Products
-- 14. Show all products supplied by a given supplier, along with stock levels.
SELECT products.product_ID, product_name, min_quantity, quantity_in_stock
FROM products
JOIN suppliers ON products.supplier_ID = suppliers.supplier_ID
WHERE supplier_name = 'Kyoto Tea House';
