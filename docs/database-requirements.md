# Database Requirements

## 1. Overview

This document defines the initial business requirements for an e-commerce database system.

The purpose of the system is to manage customers, products, orders, payments, shipments, and product reviews.

This document will serve as the foundation for the database design process, including entity identification, relationship modeling, ERD design, normalization, and PostgreSQL schema implementation.

---

## 2. Business Objectives

The system should allow the business to:

* Manage customer information.
* Manage products and product categories.
* Record customer orders.
* Track products included in each order.
* Manage payment information and payment status.
* Manage shipment information and delivery status.
* Allow customers to submit product reviews.
* Maintain data consistency and integrity between related entities.

---

## 3. Core Entities

The initial system contains the following entities:

| Entity     | Description                                |
| ---------- | ------------------------------------------ |
| Customer   | Stores information about customers.        |
| Product    | Stores products available for sale.        |
| Category   | Organizes products into categories.        |
| Order      | Represents an order placed by a customer.  |
| Order Item | Represents a product included in an order. |
| Payment    | Stores payment information for orders.     |
| Shipment   | Stores shipping and delivery information.  |
| Review     | Stores customer reviews for products.      |

---

## 4. Business Rules

### 4.1 Customer

* A customer can place multiple orders.
* Each order belongs to one customer.
* A customer can write multiple product reviews.
* Customer email addresses must be unique.

### 4.2 Product

* Each product belongs to a category.
* A product can appear in multiple order items.
* A product can receive multiple reviews.
* Product price must not be negative.

### 4.3 Category

* A category can contain multiple products.
* Each product belongs to a category.
* Categories may be extended to support hierarchical structures in the future.

### 4.4 Order

* An order belongs to one customer.
* A customer can have multiple orders.
* An order contains one or more order items.
* An order has a lifecycle/status such as `pending`, `confirmed`, `shipped`, `completed`, or `cancelled`.

### 4.5 Order Item

* Each order item belongs to one order.
* Each order item references one product.
* An order item stores the quantity purchased.
* An order item stores the product price at the time of purchase.
* Quantity must be greater than zero.

### 4.6 Payment

* A payment is associated with an order.
* Payment information includes the payment method and payment status.
* Payment status may include `pending`, `paid`, `failed`, or `refunded`.

### 4.7 Shipment

* A shipment is associated with an order.
* Shipment information includes shipping status and delivery information.
* Shipment status may include `pending`, `shipped`, `in_transit`, `delivered`, or `cancelled`.

### 4.8 Review

* A review is written by a customer for a product.
* A product can have multiple reviews.
* A review contains a rating and optional comment.
* The rating must be within the defined rating range.
* The system may restrict a customer to one review per product.

---

## 5. Initial Relationships

The initial relationships between entities are:

```text
Customer
   │
   ├── 1:N ── Order
   │
   └── 1:N ── Review
                    │
                    N:1
                    │
                  Product
                    │
                    N:1
                    │
                 Category


Order
   │
   ├── 1:N ── Order Item ── N:1 ── Product
   │
   ├── 1:N ── Payment
   │
   └── 1:1 ── Shipment
```

> Note: The exact cardinality of Payment and Shipment will be finalized during the detailed database design phase because it depends on the business requirements.

---

## 6. Initial Scope

The first version of the database will focus on:

1. Customer management
2. Product and category management
3. Order management
4. Order item management
5. Payment tracking
6. Shipment tracking
7. Product reviews

The following features are outside the initial scope and may be added later:

* Product variants
* Shopping carts
* Coupons and discounts
* Inventory management
* Multiple shipping addresses
* Multiple payment attempts
* Product suppliers
* Refund processing
* Customer authentication and authorization

---

## 7. Design Considerations

The database design should prioritize:

* Data integrity
* Consistency
* Appropriate normalization
* Clear relationships between entities
* Appropriate PostgreSQL data types
* Primary and foreign key constraints
* Business rule enforcement
* Future extensibility

---

## 8. Next Step

The next step is to transform these business requirements into a detailed data model.

The database design process will continue with:

```text
Business Requirements
        ↓
Entity Identification
        ↓
Attributes
        ↓
Primary Keys
        ↓
Foreign Keys
        ↓
Relationships & Cardinality
        ↓
ER Diagram
        ↓
Normalization
        ↓
PostgreSQL Schema
```

This document represents the initial version of the requirements and will be updated as the database design evolves.
