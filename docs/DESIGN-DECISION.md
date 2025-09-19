## 📖 Developer Documentation – Design Decisions


1: [Separate `User` and `Customer` Tables](#seperateUserAndCustomerTable)


```bash
# seperateUserAndCustomerTable

# Status
Accepted ✅

## Context
In our e-commerce plumbing platform, we have two types of people in the system:
- **Users**: Internal staff (super_admin, admin, account, support, dispatch) — around 10 members.
- **Customers**: Buyers who register and place orders — potentially thousands.

## Decision
We will **maintain two separate tables** in the database:
- `User` → for internal staff with roles and permissions.
- `Customer` → for buyers with profile, shipping address, and order history.

## Rationale
- Different purposes: Staff manage the system, customers buy products.
- Different attributes: Staff need role/permissions, customers need cart, orders, addresses.
- Different lifecycle: Staff accounts are limited & manually created, customer accounts scale automatically.
- Security: Internal users use the admin portal, customers use the storefront.

## Consequences
- Clean separation of concerns.
- Simpler security/auth flows.
- Scales better as customer base grows.
- Slightly more code (two models, two auth flows) but maintainable.

```+