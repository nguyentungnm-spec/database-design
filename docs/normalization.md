# Database Normalization — E-commerce System

## 1. Overview

Normalization is the process of organizing data into related tables to reduce unnecessary data duplication and prevent data anomalies.

This document analyzes the e-commerce database using the first three normal forms:

* First Normal Form (1NF)
* Second Normal Form (2NF)
* Third Normal Form (3NF)

The goal is to produce a relational design with clear dependencies and minimal unnecessary redundancy.

---

## 2. Why Normalization?

Without proper normalization, a database may suffer from:

* Duplicate data
* Update anomalies
* Insert anomalies
* Delete anomalies
* Inconsistent data

For example, storing customer information directly inside every order would duplicate the customer's name, email, and phone number across multiple orders.

Instead, customer information is stored in the `Customer` entity and referenced by `Order`.

```text
Customer
    │
    │ 1:N
    ↓
Order
```

---

# 3. First Normal Form (1NF)

## 3.1. Requirements

A relation satisfies 1NF when:

* Each column contains atomic values.
* There are no repeating groups.
* Each record can be uniquely identified.

---

## 3.2. Example of a Non-1NF Design

Consider the following order table:

```text
Order
---------------------------------------------------------------
order_id | customer_name | products              | quantities
---------------------------------------------------------------
1001     | Alice         | Laptop, Mouse         | 1, 2
1002     | Bob           | Keyboard              | 1
```

The `products` and `quantities` columns contain multiple values.

This violates the principle of atomic values.

---

## 3.3. Applying 1NF

The repeating product information is separated into individual order items:

```text
Order
------------------------------
order_id | customer_id
1001     | 1
1002     | 2


Order Item
-----------------------------------------
order_id | product_id | quantity
1001     | 501        | 1
1001     | 502        | 2
1002     | 503        | 1
```

Each attribute now contains a single value.

Therefore, the design satisfies 1NF.

---

# 4. Second Normal Form (2NF)

## 4.1. Requirements

A relation satisfies 2NF when:

1. It is already in 1NF.
2. Every non-key attribute depends on the whole primary key.

2NF is especially important when a table has a composite primary key.

---

## 4.2. Composite Key Example

The `Order Item` entity uses:

```text
(order_id, product_id)
```

as its composite primary key.

Example:

```text
Order Item
---------------------------------------------------
order_id | product_id | quantity | unit_price
---------------------------------------------------
1001     | 501        | 2        | 1200.00
1001     | 502        | 1        | 50.00
```

The attributes:

* `quantity`
* `unit_price`

describe the relationship between an order and a product.

They depend on the combination:

```text
(order_id, product_id)
```

rather than only one part of the composite key.

---

## 4.3. Partial Dependency

Consider an incorrectly designed table:

```text
Order Item
----------------------------------------------------------------
order_id | product_id | order_date | product_name | quantity
```

Here:

```text
order_id → order_date
product_id → product_name
```

`order_date` depends only on `order_id`.

`product_name` depends only on `product_id`.

These are partial dependencies because the attributes do not depend on the entire composite key.

---

## 4.4. Applying 2NF

Separate the information into the appropriate entities:

```text
Order
-------------------------
order_id
customer_id
order_date
status


Product
-------------------------
product_id
product_name
price
category_id


Order Item
-------------------------
order_id
product_id
quantity
unit_price
```

Now:

```text
Order Item
(order_id, product_id)
        ↓
quantity
unit_price
```

The non-key attributes depend on the complete composite key.

Therefore, the design satisfies 2NF.

---

# 5. Third Normal Form (3NF)

## 5.1. Requirements

A relation satisfies 3NF when:

1. It is already in 2NF.
2. Non-key attributes do not depend on other non-key attributes.

In other words, there should be no unnecessary transitive dependencies.

---

## 5.2. Transitive Dependency Example

Consider an incorrectly designed product table:

```text
Product
---------------------------------------------------------------
product_id | product_name | category_id | category_name
```

The dependency is:

```text
product_id → category_id
category_id → category_name
```

Therefore:

```text
product_id → category_name
```

through `category_id`.

`category_name` does not directly describe the product; it describes the category.

This creates a transitive dependency.

---

## 5.3. Applying 3NF

Separate category information into its own entity:

```text
Product
-------------------------
product_id
category_id
product_name
price


Category
-------------------------
category_id
category_name
description
```

The relationship becomes:

```text
Category 1 ───────< N Product
```

Now category information is stored only in the `Category` entity.

This removes the transitive dependency from `Product`.

---

# 6. Normalized E-commerce Model

After applying 1NF, 2NF, and 3NF, the core model becomes:

```text
Customer
    │
    │ 1:N
    ↓
Order
    │
    │ 1:N
    ↓
Order Item
    ↑
    │ N:1
    │
Product
    │
    │ N:1
    ↓
Category
```

Additional relationships:

```text
Customer 1 ───────< N Review >────── 1 Product

Order 1 ──────────< N Payment

Order 1 ─────────── 1 Shipment
```

---

# 7. Normalization Summary

| Entity     | Main Normalization Consideration                                 |
| ---------- | ---------------------------------------------------------------- |
| Customer   | Customer information is stored separately from orders            |
| Category   | Category information is separated from products                  |
| Product    | Product attributes depend on `product_id`                        |
| Order      | Order attributes depend on `order_id`                            |
| Order Item | Uses a composite key and stores relationship-specific attributes |
| Payment    | Payment information is separated from order information          |
| Shipment   | Shipping information is separated from order information         |
| Review     | Review information is separated from customer and product data   |

---

# 8. Anomalies Avoided

## Update Anomaly

Customer information does not need to be updated in every order record.

```text
Customer
    ↓
customer_id
    ↓
Orders
```

The customer information has a single source of truth.

---

## Insert Anomaly

A new product can be added without requiring an order.

```text
Product
    ↓
New product
```

The product does not need to exist inside an order before it can be stored.

---

## Delete Anomaly

Deleting an order does not automatically remove the product information.

```text
Order
   X

Product
   ✓
```

Product information remains available independently of historical orders.

---

# 9. Design Trade-offs

Normalization reduces redundancy and improves data integrity, but highly normalized databases may require more joins when retrieving information.

For this project, the initial design prioritizes:

* Data integrity
* Reduced redundancy
* Clear entity boundaries
* Referential integrity
* Maintainability

Performance optimization will be considered later during the **Query Optimization** stage using indexes and query execution plans.

---

# 10. Current Normalization Status

The current logical model is designed to satisfy the principles of:

```text
1NF
 ↓
2NF
 ↓
3NF
```

Further normalization beyond 3NF is not currently required for the initial e-commerce scope.

The model may be revised if new business requirements introduce additional dependencies or entities.

---

# 11. Next Step

After completing normalization, the next stage is to define the database constraints.

The design process continues:

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

The next stage will define:

* `PRIMARY KEY`
* `FOREIGN KEY`
* `NOT NULL`
* `UNIQUE`
* `CHECK`
* `DEFAULT`

before implementing the final PostgreSQL schema.
