# PostgreSQL Schema — E-commerce Database

## 1. Overview

This file defines the initial PostgreSQL schema for the e-commerce database.

The schema implements the logical database design developed through:

```text
Business Requirements
        ↓
Entities & Attributes
        ↓
Primary Keys & Foreign Keys
        ↓
Relationships & Cardinality
        ↓
ER Diagram
        ↓
Normalization
        ↓
Constraints
        ↓
PostgreSQL Schema
```

---

## 2. Schema Design

The database contains the following tables:

```text
customers
categories
products
orders
order_items
payments
shipments
reviews
```

---

## 3. Create Tables

### 3.1. Customers

Stores customer information.

```sql
CREATE TABLE customers (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

---

### 3.2. Categories

Stores product categories.

```sql
CREATE TABLE categories (
    category_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

---

### 3.3. Products

Stores products available for sale.

```sql
CREATE TABLE products (
    product_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_id BIGINT NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    description TEXT,
    price NUMERIC(12,2) NOT NULL,
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_products_price
        CHECK (price >= 0),

    CONSTRAINT chk_products_stock
        CHECK (stock_quantity >= 0)
);
```

---

### 3.4. Orders

Stores orders placed by customers.

```sql
CREATE TABLE orders (
    order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    order_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    total_amount NUMERIC(12,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_orders_status
        CHECK (
            status IN (
                'pending',
                'confirmed',
                'shipped',
                'completed',
                'cancelled'
            )
        ),

    CONSTRAINT chk_orders_total_amount
        CHECK (total_amount >= 0)
);
```

---

### 3.5. Order Items

Stores products included in each order.

`order_items` uses a composite primary key:

```text
(order_id, product_id)
```

```sql
CREATE TABLE order_items (
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(12,2) NOT NULL,
    subtotal NUMERIC(12,2) NOT NULL,

    PRIMARY KEY (order_id, product_id),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_order_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_order_items_unit_price
        CHECK (unit_price >= 0),

    CONSTRAINT chk_order_items_subtotal
        CHECK (subtotal >= 0)
);
```

The `unit_price` is stored separately from `products.price` because the product price may change after an order has been placed.

---

### 3.6. Payments

Stores payment attempts and payment results.

```sql
CREATE TABLE payments (
    payment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    paid_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_payments_amount
        CHECK (amount >= 0),

    CONSTRAINT chk_payments_status
        CHECK (
            status IN (
                'pending',
                'paid',
                'failed',
                'refunded'
            )
        )
);
```

An order can have multiple payment records.

This allows the database to represent multiple payment attempts.

---

### 3.7. Shipments

Stores shipping and delivery information.

```sql
CREATE TABLE shipments (
    shipment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL UNIQUE,
    shipping_address TEXT NOT NULL,
    shipping_method VARCHAR(50) NOT NULL,
    tracking_number VARCHAR(100) UNIQUE,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    shipped_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ,

    CONSTRAINT fk_shipments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_shipments_status
        CHECK (
            status IN (
                'pending',
                'shipped',
                'in_transit',
                'delivered',
                'cancelled'
            )
        )
);
```

The `UNIQUE` constraint on `order_id` enforces the initial 1:1 relationship:

```text
Order 1 ───────── 1 Shipment
```

This can be changed later if the system supports split shipments.

---

### 3.8. Reviews

Stores customer reviews for products.

```sql
CREATE TABLE reviews (
    review_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    rating INTEGER NOT NULL,
    comment TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_reviews_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_reviews_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_reviews_rating
        CHECK (rating BETWEEN 1 AND 5),

    CONSTRAINT uq_reviews_customer_product
        UNIQUE (customer_id, product_id)
);
```

The composite `UNIQUE` constraint means a customer can review a product only once in the initial design.

---

# 4. Relationship Implementation

The implemented relationships are:

```text
customers
    │
    │ 1:N
    ↓
orders
    │
    ├── 1:N ──> order_items <── N:1 ── products
    │                                      │
    │                                      │ N:1
    │                                      ↓
    │                                  categories
    │
    ├── 1:N ──> payments
    │
    └── 1:1 ──> shipments


customers
    │
    │ 1:N
    ↓
reviews
    ↑
    │ N:1
products
```

---

# 5. Design Decisions

## 5.1. Identity Columns

The schema uses PostgreSQL identity columns:

```sql
GENERATED ALWAYS AS IDENTITY
```

instead of manually assigning numeric IDs.

This allows PostgreSQL to generate identifiers automatically.

---

## 5.2. Monetary Values

Monetary values use:

```sql
NUMERIC(12,2)
```

instead of floating-point types.

This avoids common precision problems associated with floating-point arithmetic when representing financial values.

---

## 5.3. Historical Order Price

`order_items` stores:

```text
unit_price
```

even though `products` already has:

```text
price
```

The reason is that product prices can change.

The order should preserve the price that was applied when the customer purchased the product.

---

## 5.4. Referential Integrity

Foreign Keys prevent invalid references.

For example:

```text
orders.customer_id
        ↓
customers.customer_id
```

An order cannot reference a customer that does not exist.

---

## 5.5. Shipment Cardinality

The initial design uses:

```sql
order_id BIGINT NOT NULL UNIQUE
```

to enforce:

```text
Order 1 ───── 1 Shipment
```

If the business later supports multiple shipments for one order, the `UNIQUE` constraint can be removed.

---

# 6. Complete Schema

The complete execution order is:

```text
1. customers
2. categories
3. products
4. orders
5. order_items
6. payments
7. shipments
8. reviews
```

The order is important because tables containing Foreign Keys depend on their referenced tables.

---

# 7. Validation Checklist

After executing the schema, the following should be verified:

```text
[ ] All tables are created successfully
[ ] Primary Keys work correctly
[ ] Foreign Keys prevent invalid references
[ ] UNIQUE constraints prevent duplicates
[ ] CHECK constraints reject invalid values
[ ] DEFAULT values are applied correctly
[ ] Order Item composite key works correctly
[ ] Shipment 1:1 relationship is enforced
[ ] Review uniqueness is enforced
```

---

# 8. Current Status

The initial PostgreSQL schema implements the logical database model defined in the previous design stages.

The schema is intentionally kept focused on the core e-commerce requirements.

Future versions may introduce:

* Product variants
* Inventory transactions
* Shopping carts
* Coupons
* Multiple addresses
* Split shipments
* Refund records
* Suppliers
* More detailed payment information

These features should be added only after their business requirements and relationships have been analyzed.

---

# 9. Next Stage

The Database Design phase is now complete at the initial level.

The next phase is:

```text
DATABASE DESIGN
       ↓
PostgreSQL Schema
       ↓
Seed Data
       ↓
SQL Practice / Advanced SQL
```

The next practical task is to create `database/seed.sql` and insert realistic sample data for testing the schema.
