-- ============================================================
-- E-commerce Database Seed Data
-- PostgreSQL
-- ============================================================

-- ============================================================
-- 1. Customers
-- ============================================================

INSERT INTO customers (
    first_name,
    last_name,
    email,
    phone
)
VALUES
    ('Alice', 'Johnson', 'alice@example.com', '0901000001'),
    ('Bob', 'Smith', 'bob@example.com', '0901000002'),
    ('Charlie', 'Brown', 'charlie@example.com', '0901000003'),
    ('Diana', 'Wilson', 'diana@example.com', '0901000004'),
    ('Ethan', 'Taylor', 'ethan@example.com', '0901000005');


-- ============================================================
-- 2. Categories
-- ============================================================

INSERT INTO categories (
    category_name,
    description
)
VALUES
    ('Laptops', 'Laptop computers'),
    ('Smartphones', 'Mobile smartphones'),
    ('Accessories', 'Computer and mobile accessories'),
    ('Monitors', 'Computer monitors');


-- ============================================================
-- 3. Products
-- ============================================================

INSERT INTO products (
    category_id,
    product_name,
    description,
    price,
    stock_quantity
)
VALUES
    (1, 'Laptop Pro 14', '14-inch professional laptop', 1499.99, 20),
    (1, 'Laptop Air 13', '13-inch lightweight laptop', 999.99, 30),
    (2, 'Phone X', 'Flagship smartphone', 899.99, 50),
    (2, 'Phone Mini', 'Compact smartphone', 599.99, 40),
    (3, 'Wireless Mouse', 'Wireless computer mouse', 29.99, 100),
    (3, 'Mechanical Keyboard', 'Mechanical keyboard', 89.99, 60),
    (4, 'Monitor 27', '27-inch 4K monitor', 399.99, 25);


-- ============================================================
-- 4. Orders
-- ============================================================

INSERT INTO orders (
    customer_id,
    order_date,
    status,
    total_amount
)
VALUES
    (1, '2026-01-10 10:00:00+00', 'completed', 1529.98),
    (2, '2026-01-12 14:30:00+00', 'completed', 929.98),
    (1, '2026-01-15 09:15:00+00', 'shipped', 999.99),
    (3, '2026-01-18 16:45:00+00', 'confirmed', 489.98),
    (4, '2026-01-20 11:20:00+00', 'pending', 599.99);


-- ============================================================
-- 5. Order Items
-- ============================================================

INSERT INTO order_items (
    order_id,
    product_id,
    quantity,
    unit_price,
    subtotal
)
VALUES
    -- Order 1
    (1, 1, 1, 1499.99, 1499.99),
    (1, 5, 1, 29.99, 29.99),

    -- Order 2
    (2, 3, 1, 899.99, 899.99),
    (2, 5, 1, 29.99, 29.99),

    -- Order 3
    (3, 2, 1, 999.99, 999.99),

    -- Order 4
    (4, 7, 1, 399.99, 399.99),
    (4, 6, 1, 89.99, 89.99),

    -- Order 5
    (5, 4, 1, 599.99, 599.99);


-- ============================================================
-- 6. Payments
-- ============================================================

INSERT INTO payments (
    order_id,
    payment_method,
    amount,
    status,
    paid_at
)
VALUES
    (1, 'credit_card', 1529.98, 'paid', '2026-01-10 10:05:00+00'),
    (2, 'credit_card', 929.98, 'paid', '2026-01-12 14:35:00+00'),
    (3, 'bank_transfer', 999.99, 'paid', '2026-01-15 09:20:00+00'),
    (4, 'credit_card', 489.98, 'paid', '2026-01-18 16:50:00+00'),
    (5, 'credit_card', 599.99, 'pending', NULL);


-- ============================================================
-- 7. Shipments
-- ============================================================

INSERT INTO shipments (
    order_id,
    shipping_address,
    shipping_method,
    tracking_number,
    status,
    shipped_at,
    delivered_at
)
VALUES
    (
        1,
        '123 Main Street',
        'standard',
        'TRK100001',
        'delivered',
        '2026-01-11 08:00:00+00',
        '2026-01-13 15:30:00+00'
    ),
    (
        2,
        '456 Oak Avenue',
        'express',
        'TRK100002',
        'delivered',
        '2026-01-13 09:00:00+00',
        '2026-01-14 12:00:00+00'
    ),
    (
        3,
        '123 Main Street',
        'standard',
        'TRK100003',
        'in_transit',
        '2026-01-16 10:00:00+00',
        NULL
    );


-- ============================================================
-- 8. Reviews
-- ============================================================

INSERT INTO reviews (
    customer_id,
    product_id,
    rating,
    comment
)
VALUES
    (1, 1, 5, 'Excellent laptop.'),
    (1, 5, 4, 'Good wireless mouse.'),
    (2, 3, 5, 'Great smartphone.'),
    (3, 7, 4, 'Very good monitor.'),
    (4, 4, 5, 'Compact and reliable phone.');
