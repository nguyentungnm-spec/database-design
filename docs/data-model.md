# Data Model — Entities & Attributes

## 1. Overview

This document defines the initial entities and attributes for the e-commerce database.

The purpose of this stage is to identify the information that must be stored for each business entity before defining keys, relationships, constraints, and the physical PostgreSQL schema.

---

## 2. Customer

Represents a customer who uses the e-commerce system.

| Attribute     | Description                                  |
| ------------- | -------------------------------------------- |
| `customer_id` | Unique identifier for the customer           |
| `first_name`  | Customer's first name                        |
| `last_name`   | Customer's last name                         |
| `email`       | Customer's email address                     |
| `phone`       | Customer's phone number                      |
| `created_at`  | Timestamp when the customer was created      |
| `updated_at`  | Timestamp when the customer was last updated |

---

## 3. Product

Represents a product available for sale.

| Attribute        | Description                                 |
| ---------------- | ------------------------------------------- |
| `product_id`     | Unique identifier for the product           |
| `category_id`    | Category associated with the product        |
| `product_name`   | Name of the product                         |
| `description`    | Description of the product                  |
| `price`          | Current selling price                       |
| `stock_quantity` | Current available quantity                  |
| `created_at`     | Timestamp when the product was created      |
| `updated_at`     | Timestamp when the product was last updated |

---

## 4. Category

Represents a category used to organize products.

| Attribute       | Description                             |
| --------------- | --------------------------------------- |
| `category_id`   | Unique identifier for the category      |
| `category_name` | Name of the category                    |
| `description`   | Description of the category             |
| `created_at`    | Timestamp when the category was created |

---

## 5. Order

Represents an order placed by a customer.

| Attribute      | Description                               |
| -------------- | ----------------------------------------- |
| `order_id`     | Unique identifier for the order           |
| `customer_id`  | Customer who placed the order             |
| `order_date`   | Date and time when the order was created  |
| `status`       | Current status of the order               |
| `total_amount` | Total amount of the order                 |
| `created_at`   | Timestamp when the order was created      |
| `updated_at`   | Timestamp when the order was last updated |

---

## 6. Order Item

Represents an individual product included in an order.

| Attribute    | Description                           |
| ------------ | ------------------------------------- |
| `order_id`   | Order containing the item             |
| `product_id` | Product included in the order         |
| `quantity`   | Quantity of the product purchased     |
| `unit_price` | Product price at the time of purchase |
| `subtotal`   | Total price for this order item       |

---

## 7. Payment

Represents a payment associated with an order.

| Attribute        | Description                                   |
| ---------------- | --------------------------------------------- |
| `payment_id`     | Unique identifier for the payment             |
| `order_id`       | Order associated with the payment             |
| `payment_method` | Method used to make the payment               |
| `amount`         | Amount paid                                   |
| `status`         | Current payment status                        |
| `paid_at`        | Timestamp when payment was completed          |
| `created_at`     | Timestamp when the payment record was created |

---

## 8. Shipment

Represents the shipping information for an order.

| Attribute          | Description                               |
| ------------------ | ----------------------------------------- |
| `shipment_id`      | Unique identifier for the shipment        |
| `order_id`         | Order associated with the shipment        |
| `shipping_address` | Address where the order will be delivered |
| `shipping_method`  | Shipping method used                      |
| `tracking_number`  | Shipment tracking number                  |
| `status`           | Current shipment status                   |
| `shipped_at`       | Timestamp when the shipment was sent      |
| `delivered_at`     | Timestamp when the shipment was delivered |

---

## 9. Review

Represents a customer review for a product.

| Attribute     | Description                                |
| ------------- | ------------------------------------------ |
| `review_id`   | Unique identifier for the review           |
| `customer_id` | Customer who wrote the review              |
| `product_id`  | Product being reviewed                     |
| `rating`      | Rating given to the product                |
| `comment`     | Optional review comment                    |
| `created_at`  | Timestamp when the review was created      |
| `updated_at`  | Timestamp when the review was last updated |

---

## 10. Initial Data Model

The entities identified in this stage are:

```text
Customer
Product
Category
Order
Order Item
Payment
Shipment
Review
```

At this stage, the attributes have been identified, but the final primary keys, foreign keys, constraints, data types, and relationship cardinalities have not yet been finalized.

These will be defined in the following database design stages.

---

## 11. Next Step

The next step is to identify the **Primary Keys and Foreign Keys** for each entity.

```text
Entities & Attributes
        ↓
Primary Keys
        ↓
Foreign Keys
        ↓
Relationships & Cardinality
```
