# Primary Keys & Foreign Keys

## 1. Overview

This document defines the initial Primary Keys (PK) and Foreign Keys (FK) for the e-commerce database.

Primary Keys are used to uniquely identify records within each entity, while Foreign Keys establish references between related entities.

---

## 2. Primary Keys

| Entity     | Primary Key             | Purpose                                       |
| ---------- | ----------------------- | --------------------------------------------- |
| Customer   | `customer_id`           | Uniquely identifies a customer                |
| Category   | `category_id`           | Uniquely identifies a category                |
| Product    | `product_id`            | Uniquely identifies a product                 |
| Order      | `order_id`              | Uniquely identifies an order                  |
| Order Item | `order_id + product_id` | Uniquely identifies a product within an order |
| Payment    | `payment_id`            | Uniquely identifies a payment                 |
| Shipment   | `shipment_id`           | Uniquely identifies a shipment                |
| Review     | `review_id`             | Uniquely identifies a review                  |

---

## 3. Foreign Keys

| Entity     | Foreign Key   | References             |
| ---------- | ------------- | ---------------------- |
| Product    | `category_id` | `Category.category_id` |
| Order      | `customer_id` | `Customer.customer_id` |
| Order Item | `order_id`    | `Order.order_id`       |
| Order Item | `product_id`  | `Product.product_id`   |
| Payment    | `order_id`    | `Order.order_id`       |
| Shipment   | `order_id`    | `Order.order_id`       |
| Review     | `customer_id` | `Customer.customer_id` |
| Review     | `product_id`  | `Product.product_id`   |

---

## 4. Key Structure

The current key structure can be represented as:

```text
Customer
└── customer_id (PK)
        ↑
        │
        │ FK
Order
├── order_id (PK)
└── customer_id (FK)


Category
└── category_id (PK)
        ↑
        │
        │ FK
Product
├── product_id (PK)
└── category_id (FK)


Order
└── order_id (PK)
        ↑
        │
        │ FK
Order Item
├── order_id (PK, FK)
└── product_id (PK, FK)
        │
        ↑
        │
Product
└── product_id (PK)


Payment
├── payment_id (PK)
└── order_id (FK)


Shipment
├── shipment_id (PK)
└── order_id (FK)


Review
├── review_id (PK)
├── customer_id (FK)
└── product_id (FK)
```

---

## 5. Composite Primary Key

The `Order Item` entity currently uses a composite primary key:

```text
(order_id, product_id)
```

This means the combination of an order and a product must be unique.

For example:

```text
Order ID | Product ID | Quantity
---------|------------|---------
1001     | 501        | 2
1001     | 502        | 1
1002     | 501        | 3
```

The same product can appear in different orders, but the same product should not appear twice within the same order under this design.

---

## 6. Referential Integrity

Foreign Keys ensure that references between entities remain valid.

For example:

```text
Order.customer_id
        ↓
Customer.customer_id
```

An order cannot reference a customer that does not exist.

Similarly:

```text
OrderItem.product_id
        ↓
Product.product_id
```

An order item cannot reference a product that does not exist.

---

## 7. Design Notes

The current key design is an initial version.

Some relationships, especially `Payment`, `Shipment`, and `Order Item`, may be refined after analyzing cardinality and business requirements in later stages.

The final schema should enforce these relationships using PostgreSQL primary key and foreign key constraints.

---

## 8. Next Step

The next stage is to define **Relationships & Cardinality**.

The design will determine whether relationships are:

* One-to-One (1:1)
* One-to-Many (1:N)
* Many-to-Many (N:M)

These relationships will then be represented in the ER Diagram.
