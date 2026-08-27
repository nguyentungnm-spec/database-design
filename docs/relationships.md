# Relationships & Cardinality

## 1. Overview

This document defines the relationships and cardinality between entities in the e-commerce database.

Cardinality describes how many records of one entity can be associated with records of another entity.

The main relationship types considered in this design are:

* One-to-One (1:1)
* One-to-Many (1:N)
* Many-to-Many (N:M)

---

## 2. Customer → Order

### Relationship

```text
Customer 1 ───────< N Order
```

### Business Rule

* One customer can place multiple orders.
* Each order belongs to exactly one customer.

### Cardinality

**One-to-Many (1:N)**

```text
Customer
customer_id (PK)
      │
      │ 1:N
      ↓
Order
customer_id (FK)
```

---

## 3. Category → Product

### Relationship

```text
Category 1 ───────< N Product
```

### Business Rule

* One category can contain multiple products.
* Each product belongs to one category in the initial design.

### Cardinality

**One-to-Many (1:N)**

---

## 4. Order → Order Item

### Relationship

```text
Order 1 ───────< N Order Item
```

### Business Rule

* One order contains one or more order items.
* Each order item belongs to exactly one order.

### Cardinality

**One-to-Many (1:N)**

---

## 5. Product → Order Item

### Relationship

```text
Product 1 ───────< N Order Item
```

### Business Rule

* One product can appear in many order items.
* Each order item references one product.

### Cardinality

**One-to-Many (1:N)**

---

## 6. Order ↔ Product

At the business level, orders and products have a Many-to-Many relationship.

```text
Order N ─────────── M Product
```

A single order can contain multiple products, while a product can appear in multiple orders.

This relationship is resolved through the `Order Item` entity.

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

Therefore:

```text
Order 1 ───────< N Order Item N >────── 1 Product
```

`Order Item` acts as the associative entity between `Order` and `Product`.

---

## 7. Customer → Review

### Relationship

```text
Customer 1 ───────< N Review
```

### Business Rule

* One customer can write multiple reviews.
* Each review is written by one customer.

### Cardinality

**One-to-Many (1:N)**

---

## 8. Product → Review

### Relationship

```text
Product 1 ───────< N Review
```

### Business Rule

* One product can receive multiple reviews.
* Each review belongs to one product.

### Cardinality

**One-to-Many (1:N)**

---

## 9. Order → Payment

### Relationship

Initial design:

```text
Order 1 ───────< N Payment
```

### Business Rule

* An order can have multiple payment records.
* Each payment belongs to one order.

This design allows the system to represent scenarios such as failed payment attempts followed by a successful payment.

### Cardinality

**One-to-Many (1:N)**

> This cardinality may be simplified to 1:1 in a future version if the business rules require exactly one payment per order.

---

## 10. Order → Shipment

### Relationship

Initial design:

```text
Order 1 ─────── 1 Shipment
```

### Business Rule

* Each order has one shipment in the initial system.
* Each shipment belongs to one order.

### Cardinality

**One-to-One (1:1)**

> This relationship may change to 1:N if the system later supports split shipments.

---

## 11. Relationship Summary

| Entity A | Entity B   | Cardinality | Reason                                        |
| -------- | ---------- | ----------- | --------------------------------------------- |
| Customer | Order      | 1:N         | A customer can place many orders              |
| Category | Product    | 1:N         | A category can contain many products          |
| Order    | Order Item | 1:N         | An order contains multiple items              |
| Product  | Order Item | 1:N         | A product can appear in many orders           |
| Order    | Product    | N:M         | Resolved through Order Item                   |
| Customer | Review     | 1:N         | A customer can write multiple reviews         |
| Product  | Review     | 1:N         | A product can receive multiple reviews        |
| Order    | Payment    | 1:N         | An order may have multiple payment records    |
| Order    | Shipment   | 1:1         | Initial design assumes one shipment per order |

---

## 12. Overall Relationship Model

```text
                         Category
                            │
                            │ 1:N
                            ↓
                         Product
                            │
                  ┌─────────┴─────────┐
                  │                   │
                 1:N                 1:N
                  ↓                   ↓
             Order Item            Review
                  ↑                   ↑
                 N:1                 N:1
                  │                   │
                  │                   │
Order ────────────┘                Customer
  ↑                                  │
  │                                  │ 1:N
  │                                  ↓
  │                                Review
  │
  │ 1:N
  ↓
Payment

Customer
   │
   │ 1:N
   ↓
Order
   │
   │ 1:1
   ↓
Shipment
```

---

## 13. Design Notes

The cardinalities defined in this document represent the initial business model.

Some relationships may be refined as additional business requirements are introduced, especially:

* Payment processing
* Split shipments
* Product categories
* Customer reviews
* Order item structure

The final cardinalities will be reflected in the ER Diagram and PostgreSQL schema.

---

## 14. Next Step

The next stage is to create the **Entity-Relationship Diagram (ERD)**.

The ERD will visually combine:

```text
Entities
   +
Attributes
   +
Primary Keys
   +
Foreign Keys
   +
Relationships
   +
Cardinality
```

into a single database model.
