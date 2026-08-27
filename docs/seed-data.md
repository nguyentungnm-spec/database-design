# Seed Data — E-commerce Database

## 1. Overview

This document describes the sample dataset used to populate the e-commerce PostgreSQL database.

The seed data is designed for development, testing, and SQL practice.

---

## 2. Dataset

The initial dataset contains:

| Entity      | Records |
| ----------- | ------: |
| Customers   |       5 |
| Categories  |       4 |
| Products    |       7 |
| Orders      |       5 |
| Order Items |       8 |
| Payments    |       5 |
| Shipments   |       3 |
| Reviews     |       5 |

---

## 3. Purpose

The seed data provides enough variation to practice:

* SELECT
* WHERE
* ORDER BY
* GROUP BY
* HAVING
* JOIN
* Subqueries
* CTEs
* Aggregate functions
* Window functions
* INSERT
* UPDATE
* DELETE

---

## 4. Data Relationships

The sample data follows the database relationships:

```text
Customer
   │
   └──< Orders
           │
           ├──< Order Items >── Product >── Category
           │
           ├──< Payments
           │
           └──── Shipment

Customer ──< Reviews >── Product
```

---

## 5. Important Test Cases

The dataset intentionally includes:

### Multiple orders for one customer

Customer `1` has multiple orders.

This allows testing:

```sql
GROUP BY customer_id
```

and customer-level aggregation.

### Multiple products in one order

Order `1` contains more than one product.

This allows testing:

```sql
JOIN
```

between `orders`, `order_items`, and `products`.

### Different order statuses

The dataset includes:

```text
pending
confirmed
shipped
completed
```

This allows status filtering and aggregation.

### Different payment statuses

The dataset includes both:

```text
paid
pending
```

This allows payment-status queries.

### Different shipment states

The dataset includes:

```text
delivered
in_transit
```

This allows shipment-status analysis.

---

## 6. Seed Execution

The schema must be created before the seed data is inserted.

```text
schema.sql
    ↓
Create tables
    ↓
seed.sql
    ↓
Insert sample data
```

---

## 7. Next Step

After the seed data has been inserted successfully, the database is ready for constraint testing.

The next stage is:

```text
Seed Data
    ↓
Constraint Testing
    ↓
Database Design Validation
    ↓
SQL Practice
```
