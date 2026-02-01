-- RESET DATABASE: DROP ALL TABLES IF THEY EXIST
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS suppliers;
-- ==============================================
-- CREATE TABLES
-- Supplier  table: present the suppliers of the products
CREATE TABLE "suppliers" (
    "supplier_ID" INTEGER,
    "supplier_name" TEXT NOT NULL,
    "email" TEXT,
    "phone" TEXT,
    PRIMARY KEY (supplier_ID)
);

-- Product table: present the products' information
CREATE TABLE "products" (
    "product_ID" INTEGER,
    "product_name" TEXT NOT NULL,
    "weight_grams" NUMERIC NOT NULL,
    "buying_price_VND" INTEGER,
    "selling_price_VND" INTEGER,
    "min_quantity" INTEGER NOT NULL DEFAULT 10,
    "quantity_in_stock" INTEGER NOT NULL,
    "stocking_date" TEXT NOT NULL DEFAULT CURRENT_DATE,
    "manufacturing_date" TEXT NOT NULL DEFAULT CURRENT_DATE,
    "expiration_date" TEXT NOT NULL DEFAULT CURRENT_DATE
        CHECK (manufacturing_date < stocking_date AND stocking_date < expiration_date),
    "description" TEXT,
    "status" TEXT NOT NULL DEFAULT 'active'
        CHECK (status IN ('active','discontinued')),
    "supplier_ID" INTEGER NOT NULL,
    PRIMARY KEY (product_ID),
    FOREIGN KEY (supplier_ID) REFERENCES suppliers(supplier_ID)
);

-- Customer table: present customers' information
CREATE TABLE "customers" (
  "customer_ID" INTEGER,
  "customer_name" TEXT NOT NULL,
  "phone" TEXT,
  "address" TEXT,
  "email" TEXT,
  PRIMARY KEY ("customer_ID")
);

-- Order table: present orders from customers
CREATE TABLE "orders" (
  "order_number" INTEGER,
  "customer_ID" INTEGER NOT NULL,
  "order_date" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "phone" TEXT NOT NULL,
  "delivery_address" TEXT NOT NULL,
  "payment_method" TEXT NOT NULL CHECK (payment_method IN ('COD','Bank Transfer','MoMo', 'ZaloPay', 'VNPay')),
  "status" TEXT NOT NULL DEFAULT 'Pending',
  CHECK ("status" IN ('Pending','Shipped','Delivered','Cancelled','Completed')),
  PRIMARY KEY ("order_number"),
  FOREIGN KEY ("customer_ID") REFERENCES customers("customer_ID")
);

-- Order_Item table: present the items ordered, quantity ordered, unit price of items ordered from the orders
CREATE TABLE "order_items" (
  "order_item_id" INTEGER,
  "order_number" INTEGER NOT NULL,
  "product_ID" INTEGER NOT NULL,
  "quantity" INTEGER NOT NULL,
  "unit_price_VND" INTEGER NOT NULL,
  PRIMARY KEY ("order_item_id"),
  FOREIGN KEY ("order_number") REFERENCES orders("order_number"),
  FOREIGN KEY ("product_ID") REFERENCES products("product_ID")
);

-- Create indexes to speed up search
CREATE INDEX "search_order_status" ON orders(status);
CREATE INDEX "search_order_customer_ID" ON orders(customer_ID);
CREATE INDEX "search_products_status" ON products(status);
CREATE INDEX "search_products_name" ON products(product_name);
CREATE INDEX "search_orderitems_ordernumber" ON order_items(order_number);


-- IMPORT .CSV FILES INTO TABLES
.import --csv --skip 1 suppliers.csv suppliers
.import --csv --skip 1 products.csv products
.import --csv --skip 1 customers.csv customers
.import --csv --skip 1 orders.csv orders
.import --csv --skip 1 order_items.csv order_items


