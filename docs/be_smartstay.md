# Smart Stay API Hoan Thanh

> Tong hop tu swagger.json. Moi endpoint duoi day la API da duoc implement o tang backend.

- Module: Smart Stay
- Port mac dinh: 5043
- Base URL: http://localhost:5043
- So module/controller: 15
- So endpoint da hoan thanh: 61

## Danh sach API da hoan thanh

### Announcement

| Method | Endpoint                                    | Xac thuc       |
| ------ | ------------------------------------------- | -------------- |
| POST   | /api/v1/announcements                       | JWT (Landlord) |
| GET    | /api/v1/announcements/property/{propertyId} | JWT (Landlord) |
| GET    | /api/v1/announcements/tenant                | JWT (Tenant)   |
| DELETE | /api/v1/announcements/{id}                  | JWT (Landlord) |

### Auth

| Method | Endpoint                   | Xac thuc |
| ------ | -------------------------- | -------- |
| POST   | /api/v1/auth/register      |          |
| POST   | /api/v1/auth/login         |          |
| POST   | /api/v1/auth/refresh-token |          |
| POST   | /api/v1/auth/revoke-token  | JWT      |
| GET    | /api/v1/auth/me            | JWT      |

### Contract

| Method | Endpoint                            | Xac thuc               |
| ------ | ----------------------------------- | ---------------------- |
| POST   | /api/v1/contracts                   | JWT (Landlord)         |
| GET    | /api/v1/contracts/room/{roomId}     | JWT (Landlord, Tenant) |
| GET    | /api/v1/contracts/tenant/{tenantId} | JWT (Tenant)           |
| GET    | /api/v1/contracts/{id}              | JWT                    |
| PUT    | /api/v1/contracts/{id}              | JWT (Landlord)         |
| DELETE | /api/v1/contracts/{id}              | JWT (Landlord)         |

### InventoryItem

| Method | Endpoint                                      | Xac thuc       |
| ------ | --------------------------------------------- | -------------- |
| POST   | /api/v1/inventory-items                       | JWT (Landlord) |
| GET    | /api/v1/inventory-items/contract/{contractId} | JWT            |
| PUT    | /api/v1/inventory-items/{id}/checkout         | JWT (Landlord) |
| DELETE | /api/v1/inventory-items/{id}                  | JWT (Landlord) |

### Invoice

| Method | Endpoint                               | Xac thuc       |
| ------ | -------------------------------------- | -------------- |
| POST   | /api/v1/invoices                       | JWT (Landlord) |
| GET    | /api/v1/invoices/contract/{contractId} | JWT            |
| GET    | /api/v1/invoices/{id}                  | JWT            |
| PUT    | /api/v1/invoices/{id}                  | JWT (Landlord) |
| DELETE | /api/v1/invoices/{id}                  | JWT (Landlord) |

### Listing

| Method | Endpoint                     | Xac thuc       |
| ------ | ---------------------------- | -------------- |
| POST   | /api/v1/listings             | JWT (Landlord) |
| GET    | /api/v1/listings             |                |
| PUT    | /api/v1/listings/{id}/toggle | JWT (Landlord) |
| DELETE | /api/v1/listings/{id}        | JWT (Landlord) |

### MeterReading

| Method | Endpoint                                     | Xac thuc       |
| ------ | -------------------------------------------- | -------------- |
| POST   | /api/v1/meter-readings                       | JWT (Landlord) |
| GET    | /api/v1/meter-readings/room/{roomId}         | JWT            |
| GET    | /api/v1/meter-readings/property/{propertyId} | JWT (Landlord) |
| DELETE | /api/v1/meter-readings/{id}                  | JWT (Landlord) |

### Property

| Method | Endpoint                | Xac thuc       |
| ------ | ----------------------- | -------------- |
| POST   | /api/v1/properties      | JWT (Landlord) |
| GET    | /api/v1/properties      | JWT (Landlord) |
| GET    | /api/v1/properties/{id} | JWT            |
| PUT    | /api/v1/properties/{id} | JWT (Landlord) |
| DELETE | /api/v1/properties/{id} | JWT (Landlord) |

### Room

| Method | Endpoint                            | Xac thuc       |
| ------ | ----------------------------------- | -------------- |
| POST   | /api/v1/rooms                       | JWT (Landlord) |
| GET    | /api/v1/rooms/property/{propertyId} | JWT            |
| GET    | /api/v1/rooms/{id}                  | JWT            |
| PUT    | /api/v1/rooms/{id}                  | JWT (Landlord) |
| DELETE | /api/v1/rooms/{id}                  | JWT (Landlord) |

### Roommate

| Method | Endpoint                                | Xac thuc               |
| ------ | --------------------------------------- | ---------------------- |
| POST   | /api/v1/roommates                       | JWT                    |
| GET    | /api/v1/roommates/contract/{contractId} | JWT                    |
| PUT    | /api/v1/roommates/{id}/approve          | JWT (Landlord)         |
| DELETE | /api/v1/roommates/{id}                  | JWT (Landlord, Tenant) |

### ServiceConfig

| Method | Endpoint                                      | Xac thuc       |
| ------ | --------------------------------------------- | -------------- |
| POST   | /api/v1/service-configs                       | JWT (Landlord) |
| GET    | /api/v1/service-configs/property/{propertyId} | JWT            |
| PUT    | /api/v1/service-configs/{id}                  | JWT (Landlord) |
| DELETE | /api/v1/service-configs/{id}                  | JWT (Landlord) |

### Statistics

| Method | Endpoint                           | Xac thuc       |
| ------ | ---------------------------------- | -------------- |
| GET    | /api/v1/statistics/finance-summary | JWT (Landlord) |

### Ticket

| Method | Endpoint                    | Xac thuc       |
| ------ | --------------------------- | -------------- |
| POST   | /api/v1/tickets             | JWT (Tenant)   |
| GET    | /api/v1/tickets/tenant      | JWT (Tenant)   |
| GET    | /api/v1/tickets/landlord    | JWT (Landlord) |
| PUT    | /api/v1/tickets/{id}/status | JWT (Landlord) |

### Vehicle

| Method | Endpoint              | Xac thuc |
| ------ | --------------------- | -------- |
| POST   | /api/v1/vehicles      | JWT      |
| GET    | /api/v1/vehicles      | JWT      |
| DELETE | /api/v1/vehicles/{id} | JWT      |

### VisitorLog

| Method | Endpoint                      | Xac thuc       |
| ------ | ----------------------------- | -------------- |
| POST   | /api/v1/visitor-logs          | JWT (Tenant)   |
| GET    | /api/v1/visitor-logs/tenant   | JWT (Tenant)   |
| GET    | /api/v1/visitor-logs/landlord | JWT (Landlord) |
