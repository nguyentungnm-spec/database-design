-- ============================================================
-- Constraint Tests
-- E-commerce Database
-- PostgreSQL
-- ============================================================


-- ============================================================
-- 1. NOT NULL TEST
-- ============================================================

-- Expected result:
-- ERROR: null value in column "email" violates not-null constraint

INSERT INTO customers (
    first_name,
    last_name,
    email
)
VALUES (
    'Test',
    'User',
    NULL
);


-- ============================================================
-- 2. UNIQUE TEST
-- ============================================================

-- Expected result:
-- ERROR: duplicate key value violates unique constraint

INSERT INTO customers (
    first_name,
    last_name,
    email
)
VALUES (
    'Duplicate',
    'User',
    'alice@example.com'
);


-- ============================================================
-- 3. FOREIGN KEY TEST
-- ============================================================

-- Expected result:
-- ERROR: insert or update on table violates foreign key constraint

INSERT INTO orders (
    customer_id,
    status,
    total_amount
)
VALUES (
    999999,
    'pending',
    100.00
);


-- ============================================================
-- 4. CHECK: PRODUCT PRICE
-- ============================================================

-- Expected result:
-- ERROR: violates check constraint

INSERT INTO products (
    category_id,
    product_name,
    price,
    stock_quantity
)
VALUES (
    1,
    'Invalid Product',
    -100.00,
    10
);


-- ============================================================
-- 5. CHECK: PRODUCT STOCK
-- ============================================================

-- Expected result:
-- ERROR: violates check constraint

INSERT INTO products (
    category_id,
    product_name,
    price,
    stock_quantity
)
VALUES (
    1,
    'Invalid Stock Product',
    100.00,
    -5
);


-- ============================================================
-- 6. CHECK: ORDER ITEM QUANTITY
-- ============================================================

-- Expected result:
-- ERROR: violates check constraint

INSERT INTO order_items (
    order_id,
    product_id,
    quantity,
    unit_price,
    subtotal
)
VALUES (
    1,
    1,
    0,
    100.00,
    0.00
);


-- ============================================================
-- 7. CHECK: REVIEW RATING
-- ============================================================

-- Expected result:
-- ERROR: violates check constraint

INSERT INTO reviews (
    customer_id,
    product_id,
    rating,
    comment
)
VALUES (
    5,
    1,
    6,
    'Invalid rating'
);


-- ============================================================
-- 8. CHECK: PAYMENT AMOUNT
-- ============================================================

-- Expected result:
-- ERROR: violates check constraint

INSERT INTO payments (
    order_id,
    payment_method,
    amount,
    status
)
VALUES (
    1,
    'credit_card',
    -50.00,
    'paid'
);


-- ============================================================
-- 9. PRIMARY KEY TEST
-- ============================================================

-- Expected result:
-- ERROR: duplicate key value violates primary key constraint

INSERT INTO categories (
    category_id,
    category_name
)
VALUES (
    1,
    'Duplicate Category'
);


-- ============================================================
-- 10. DEFAULT VALUE TEST
-- ============================================================

-- This statement should succeed.

INSERT INTO customers (
    first_name,
    last_name,
    email
)
VALUES (
    'Default',
    'Test',
    'default-test@example.com'
);

-- Verify generated values.

SELECT
    customer_id,
    first_name,
    last_name,
    email,
    created_at
FROM customers
WHERE email = 'default-test@example.com';
