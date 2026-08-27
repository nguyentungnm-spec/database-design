# Database Constraints

## 1. Overview

This document defines the integrity constraints for the e-commerce database.

Constraints are used to ensure that stored data remains valid, consistent, and reliable.

The main constraints used in this design are:

* Primary Key
* Foreign Key
* NOT NULL
* UNIQUE
* CHECK
* DEFAULT

---

## 2. Primary Key Constraints

Each entity requires a primary key to uniquely identify its records.

| Entity     | Primary Key             |
| ---------- | ----------------------- |
| Customer   | `customer_id`           |
| Category   | `category_id`           |
| Product    | `product_id`            |
| Order      | `order_id`              |
| Order Item | `order_id + product_id` |
| Payment    | `payment_id`            |
| Shipment   | `shipment_id`           |
| Review     | `review_id`             |

Example:

```sql
PRIMARY KEY (customer_id)
```

For `Order Item`:

```sql
PRIMARY KEY (order_id, product_id)
```

---

## 3. Foreign Key Constraints

Foreign Keys enforce referential integrity between related entities.

| Table      | Foreign Key   | References              |
| ---------- | ------------- | ----------------------- |
| Product    | `category_id` | Category(`category_id`) |
| Order      | `customer_id` | Customer(`customer_id`) |
| Order Item | `order_id`    | Order(`order_id`)       |
| Order Item | `product_id`  | Product(`product_id`)   |
| Payment    | `order_id`    | Order(`order_id`)       |
| Shipment   | `order_id`    | Order(`order_id`)       |
| Review     | `customer_id` | Customer(`customer_id`) |
| Review     | `product_id`  | Product(`product_id`)   |

Example:

```sql
FOREIGN KEY (customer_id)
REFERENCES customer(customer_id)
```

This prevents an order from referencing a customer that does not exist.

---

## 4. NOT NULL Constraints

`NOT NULL` is used for attributes that are required for the entity to function correctly.

Examples:

```text id="q8hlkj"
Customer
---------
first_name
last_name
email

Product
---------
product_name
price
category_id

Order
---------
customer_id
order_date
status
```

Example:

```sql
email VARCHAR(100) NOT NULL
```

The exact nullable/non-nullable attributes will be finalized during schema implementation.

---

## 5. UNIQUE Constraints

`UNIQUE` prevents duplicate values where business rules require uniqueness.

### Customer Email

Each customer should have a unique email address.

```sql
email VARCHAR(100) UNIQUE
```

### Shipment Tracking Number

A tracking number should identify one shipment.

```sql
tracking_number VARCHAR(100) UNIQUE
```

The constraint may allow `NULL` when a tracking number has not yet been assigned.

---

## 6. CHECK Constraints

`CHECK` constraints enforce business rules at the database level.

### Product Price

```sql
CHECK (price >= 0)
```

A product cannot have a negative price.

### Stock Quantity

```sql
CHECK (stock_quantity >= 0)
```

Stock cannot be negative.

### Order Item Quantity

```sql
CHECK (quantity > 0)
```

An order item must contain at least one product.

### Review Rating

```sql
CHECK (rating BETWEEN 1 AND 5)
```

The rating must be between 1 and 5.

### Payment Amount

```sql
CHECK (amount >= 0)
```

Payment amount cannot be negative.

---

## 7. DEFAULT Constraints

`DEFAULT` provides a value when one is not explicitly supplied.

### Timestamps

Example:

```sql
created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
```

This automatically records the creation time.

### Order Status

Example:

```sql
status VARCHAR(20) DEFAULT 'pending'
```

A new order starts with a `pending` status unless another valid status is explicitly provided.

---

## 8. Business Rules and Constraints

| Business Rule                                   | Constraint    |
| ----------------------------------------------- | ------------- |
| Customer email must be unique                   | `UNIQUE`      |
| Product price cannot be negative                | `CHECK`       |
| Stock cannot be negative                        | `CHECK`       |
| Order item quantity must be positive            | `CHECK`       |
| Review rating must be 1–5                       | `CHECK`       |
| Payment amount cannot be negative               | `CHECK`       |
| Order must reference an existing customer       | `FOREIGN KEY` |
| Product must reference an existing category     | `FOREIGN KEY` |
| Order Item must reference an existing order     | `FOREIGN KEY` |
| Order Item must reference an existing product   | `FOREIGN KEY` |
| Creation time should be generated automatically | `DEFAULT`     |

---

## 9. Referential Actions

Foreign Keys may define actions for updates or deletions.

For example:

```sql
FOREIGN KEY (customer_id)
REFERENCES customer(customer_id)
ON DELETE RESTRICT
```

The initial design should prevent deletion of a customer when related historical orders still exist.

For `Order Item`, cascading deletion may be considered:

```sql
FOREIGN KEY (order_id)
REFERENCES orders(order_id)
ON DELETE CASCADE
```

This means order items are removed when their parent order is deleted.

The final referential actions will be determined during PostgreSQL schema implementation.

---

## 10. Constraint Design Principles

The database should enforce important business rules as close to the data as possible.

The design prioritizes:

* Data validity
* Referential integrity
* Consistency
* Prevention of invalid values
* Prevention of unintended duplicates
* Clear business rules

Application-level validation may still be required, but critical data integrity rules should also be enforced by the database.

---

## 11. Constraint Summary

The database will use:

```text
PRIMARY KEY
    ↓
Unique record identification

FOREIGN KEY
    ↓
Referential integrity

NOT NULL
    ↓
Required attributes

UNIQUE
    ↓
Prevent duplicate values

CHECK
    ↓
Validate business rules

DEFAULT
    ↓
Provide automatic values
```

---

## 12. Next Step

The logical database design is now ready to be translated into PostgreSQL.

The next stage is:

```text
Database Requirements
        ↓
Entities & Attributes
        ↓
Keys
        ↓
Relationships
        ↓
ER Diagram
        ↓
Normalization
        ↓
Constraints
        ↓
PostgreSQL Schema
```

The next document will define the actual PostgreSQL tables and SQL statements in `schema.sql`.
