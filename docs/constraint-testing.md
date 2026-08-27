# Constraint Testing

## 1. Overview

This document describes the tests used to verify the integrity constraints implemented in the PostgreSQL database.

The tests intentionally attempt to insert invalid data and verify that PostgreSQL rejects the operations.

---

## 2. Testing Strategy

The following constraints are tested:

```text
PRIMARY KEY
FOREIGN KEY
NOT NULL
UNIQUE
CHECK
DEFAULT
```

Expected behavior:

```text
Valid data
    ↓
INSERT succeeds

Invalid data
    ↓
INSERT fails
```

---

## 3. Test Cases

| Test                       | Constraint    | Expected Result                          |
| -------------------------- | ------------- | ---------------------------------------- |
| Null customer email        | `NOT NULL`    | Reject                                   |
| Duplicate customer email   | `UNIQUE`      | Reject                                   |
| Invalid customer ID        | `FOREIGN KEY` | Reject                                   |
| Negative product price     | `CHECK`       | Reject                                   |
| Negative stock             | `CHECK`       | Reject                                   |
| Zero order quantity        | `CHECK`       | Reject                                   |
| Invalid review rating      | `CHECK`       | Reject                                   |
| Negative payment amount    | `CHECK`       | Reject                                   |
| Duplicate category ID      | `PRIMARY KEY` | Reject                                   |
| Missing creation timestamp | `DEFAULT`     | Insert succeeds with generated timestamp |

---

## 4. NOT NULL Test

Attempt to insert a customer without an email:

```sql
INSERT INTO customers (
    first_name,
    last_name,
    email
)
VALUES (
    'Test',
    'User',
    NULL
);
```

Expected result:

```text
INSERT fails
```

Reason:

```text
email is defined as NOT NULL
```

---

## 5. UNIQUE Test

Attempt to insert an existing email:

```text
alice@example.com
```

Expected result:

```text
INSERT fails
```

Reason:

```text
email must be unique
```

---

## 6. Foreign Key Test

Attempt to create an order for a customer that does not exist.

```text
customer_id = 999999
```

Expected result:

```text
INSERT fails
```

Reason:

```text
customer_id must reference an existing customer
```

---

## 7. CHECK Constraint Tests

### Product Price

```text
price = -100
```

Expected:

```text
INSERT fails
```

### Product Stock

```text
stock_quantity = -5
```

Expected:

```text
INSERT fails
```

### Order Item Quantity

```text
quantity = 0
```

Expected:

```text
INSERT fails
```

### Review Rating

```text
rating = 6
```

Expected:

```text
INSERT fails
```

### Payment Amount

```text
amount = -50
```

Expected:

```text
INSERT fails
```

---

## 8. Primary Key Test

Attempt to insert a category using an existing `category_id`.

Expected:

```text
INSERT fails
```

Reason:

```text
category_id must be unique
```

---

## 9. DEFAULT Test

Insert a customer without explicitly providing `created_at`.

Expected:

```text
INSERT succeeds
```

PostgreSQL automatically generates:

```text
created_at = CURRENT_TIMESTAMP
```

---

## 10. Test Result

The expected behavior is:

```text
NOT NULL       → Invalid NULL rejected
UNIQUE         → Duplicate value rejected
FOREIGN KEY    → Invalid reference rejected
CHECK          → Invalid value rejected
PRIMARY KEY    → Duplicate key rejected
DEFAULT        → Missing value automatically generated
```

These tests demonstrate that the database itself enforces important data integrity rules.

---

## 11. Conclusion

The constraint tests confirm that the initial PostgreSQL schema protects the database against common invalid data scenarios.

Application-level validation should still be implemented, but critical integrity rules are also enforced at the database layer.

---

## 12. Next Step

The initial database design and validation are now complete.

The next phase is SQL practice using the seeded e-commerce dataset.

```text
Database Design
       ↓
Schema
       ↓
Seed Data
       ↓
Constraint Testing
       ↓
SQL Fundamentals
       ↓
Advanced SQL
```
