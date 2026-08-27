# Entity-Relationship Diagram

## 1. Overview

This ER Diagram represents the logical data model of the e-commerce database.

It combines the entities, attributes, primary keys, foreign keys, and relationships defined during the previous database design stages.

The diagram serves as a visual reference for the database structure before moving to normalization and physical PostgreSQL implementation.

---

## 2. Entities

The current data model contains eight main entities:

* Customer
* Category
* Product
* Order
* Order Item
* Payment
* Shipment
* Review

---

## 3. Entity Relationships

```text
Customer
    │
    │ 1:N
    ↓
Order
    │
    ├────────── 1:N ──────────> Order Item <────────── N:1 ────────── Product
    │                                                                    │
    │                                                                    │ N:1
    │                                                                    ↓
    │                                                                 Category
    │
    ├────────── 1:N ──────────> Payment
    │
    └────────── 1:1 ──────────> Shipment


Customer
    │
    │ 1:N
    ↓
Review
    ↑
    │ N:1
Product
```

---

## 4. Core Relationship Model

### Customer → Order

```text
Customer 1 ───────< N Order
```

A customer can place multiple orders, while each order belongs to one customer.

### Category → Product

```text
Category 1 ───────< N Product
```

A category can contain multiple products.

### Order → Order Item

```text
Order 1 ───────< N Order Item
```

An order contains multiple order items.

### Product → Order Item

```text
Product 1 ───────< N Order Item
```

A product can appear in multiple order items.

### Customer → Review

```text
Customer 1 ───────< N Review
```

A customer can create multiple reviews.

### Product → Review

```text
Product 1 ───────< N Review
```

A product can receive multiple reviews.

### Order → Payment

```text
Order 1 ───────< N Payment
```

An order may have multiple payment records.

### Order → Shipment

```text
Order 1 ─────── 1 Shipment
```

The initial design assumes one shipment per order.

---

## 5. Many-to-Many Relationship

At the business level, `Order` and `Product` have a many-to-many relationship:

```text
Order N ───────── M Product
```

This relationship is resolved using the `Order Item` associative entity:

```text
Order
  │
  │ 1:N
  ↓
Order Item
  ↑
  │ N:1
Product
```

Therefore, `Order Item` is an important part of the relational design.

---

## 6. Key Information

The ERD should identify primary and foreign keys.

Example:

```text
Customer
---------
PK customer_id


Order
---------
PK order_id
FK customer_id


Product
---------
PK product_id
FK category_id


Order Item
---------
PK order_id + product_id
FK order_id
FK product_id
```

Other entities follow the same PK/FK structure defined in `docs/keys.md`.

---

## 7. ERD File

The visual ER Diagram is stored at:

```text
docs/er-diagram.png
```

The image should provide a clear visual representation of:

* Entities
* Important attributes
* Primary Keys
* Foreign Keys
* Relationship lines
* Cardinality

---

## 8. Design Status

The current ERD represents the initial logical model.

The model may be refined after normalization analysis and additional business requirements are introduced.

The ERD should therefore be treated as a living design artifact rather than a final implementation.

---

## 9. Next Step

The next stage is **Normalization**.

The design will be evaluated against:

```text
1NF
 ↓
2NF
 ↓
3NF
```

The goal is to reduce unnecessary data duplication and prevent insertion, update, and deletion anomalies before implementing the final PostgreSQL schema.
