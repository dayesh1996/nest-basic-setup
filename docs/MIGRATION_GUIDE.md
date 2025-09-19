# MongoDB to PostgreSQL Migration Guide - Dygus Plumbing E-commerce

This guide will help you migrate your Dygus Backend project from MongoDB to PostgreSQL for the plumbing e-commerce platform.

## Prerequisites

1. **PostgreSQL Database**: You need a PostgreSQL database running locally or remotely
2. **Node.js and npm**: Ensure you have the latest LTS version
3. **Prisma CLI**: Should already be installed as a dev dependency

## Step-by-Step Migration Process

### 1. Install PostgreSQL Driver

```bash
npm install pg
```

### 2. Set Up Environment Variables

Create a `.env` file in your project root with the following configuration:

```env
# PostgreSQL Database URL
DATABASE_URL="postgresql://username:password@localhost:5432/dygus_db?schema=public"

# Application Configuration
PORT=3000
NODE_ENV=development

# JWT Configuration (if using authentication)
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRES_IN=7d
```

**Important**: Replace `username`, `password`, `localhost`, `5432`, and `dygus_db` with your actual PostgreSQL credentials.

### 3. Database Setup

#### Option A: Local PostgreSQL Setup

If you're setting up PostgreSQL locally:

1. **Install PostgreSQL** (if not already installed):
   - **Windows**: Download from https://www.postgresql.org/download/windows/
   - **macOS**: `brew install postgresql`
   - **Ubuntu**: `sudo apt-get install postgresql postgresql-contrib`

2. **Create Database**:
   ```bash
   # Connect to PostgreSQL
   psql -U postgres
   
   # Create database
   CREATE DATABASE dygus_db;
   
   # Exit
   \q
   ```

#### Option B: Cloud PostgreSQL (Recommended for Production)

Use services like:
- **Supabase** (Free tier available)
- **Neon** (Free tier available)
- **Railway**
- **Heroku Postgres**

### 4. Generate Prisma Client

```bash
npm run db:generate
```

### 5. Create and Apply Migrations

```bash
# Create initial migration
npm run db:migrate

# This will:
# 1. Create the migration files
# 2. Apply the migration to your database
# 3. Generate the Prisma client
```

### 6. Seed the Database (Optional)

```bash
npm run db:seed
```

This will populate your database with sample data including:
- Admin and support users
- NBFC company and users
- Customer with business details and address
- Product catalog (sectors, categories, sub-categories, brands, products, inventory)
- Sample cart items and coupons

### 7. Verify the Migration

```bash
# Start the development server
npm run start:dev

# Or open Prisma Studio to view your data
npm run db:studio
```

## Key Changes Made

### 1. Schema Changes
- **Provider**: Changed from `mongodb` to `postgresql`
- **ID Fields**: Removed `@map("_id")` as PostgreSQL uses standard column names
- **UUID Generation**: PostgreSQL will generate UUIDs automatically
- **E-commerce Structure**: Complete plumbing e-commerce schema with products, customers, orders, and NBFC integration

### 2. Database Features
- **Relationships**: PostgreSQL provides better support for foreign key constraints
- **Transactions**: Full ACID compliance for financial operations
- **Indexing**: Better performance for complex product catalog queries
- **JSON Support**: PostgreSQL has excellent JSON field support for flexible data

### 3. New Scripts Added
- `npm run db:generate` - Generate Prisma client
- `npm run db:migrate` - Create and apply migrations
- `npm run db:migrate:deploy` - Deploy migrations to production
- `npm run db:reset` - Reset database (WARNING: deletes all data)
- `npm run db:studio` - Open Prisma Studio
- `npm run db:seed` - Seed database with sample data

## E-commerce Platform Structure

### Core Modules
1. **User Management**
   - Admin users (super_admin, admin, account, dispatch, support)
   - NBFC users and companies
   - Customer management with OTP authentication

2. **Product Catalog**
   - Hierarchical structure: Sectors → Categories → Sub-categories → Brands → Products
   - Inventory management with variations (diameter, volume, length, grade)
   - HSN codes for GST compliance

3. **Customer Management**
   - Customer profiles with business details
   - Address management (billing/shipping)
   - Document management (GST, IT, Bank details)

4. **Financial Operations**
   - Line of credit applications and approvals
   - Payment processing (online, offline, credit)
   - Coupon and discount management
   - Credit reimbursement tracking

5. **Order Management**
   - Quotation system with GST calculations
   - Order processing and status tracking
   - Shipment and logistics management
   - E-way bill generation

## Troubleshooting

### Common Issues

1. **Connection Error**:
   ```
   Error: connect ECONNREFUSED 127.0.0.1:5432
   ```
   **Solution**: Ensure PostgreSQL is running and the connection URL is correct.

2. **Authentication Error**:
   ```
   Error: password authentication failed
   ```
   **Solution**: Check your username and password in the DATABASE_URL.

3. **Database Not Found**:
   ```
   Error: database "dygus_db" does not exist
   ```
   **Solution**: Create the database first using `CREATE DATABASE dygus_db;`

4. **Migration Conflicts**:
   ```
   Error: There are unapplied migrations
   ```
   **Solution**: Run `npm run db:migrate:deploy` to apply pending migrations.

### Reset Database (If Needed)

If you need to start fresh:

```bash
npm run db:reset
```

**Warning**: This will delete all data in your database.

## Production Deployment

### 1. Environment Variables
Ensure your production environment has the correct `DATABASE_URL` pointing to your production PostgreSQL instance.

### 2. Migrations
Before deploying:
```bash
npm run db:migrate:deploy
```

### 3. Prisma Client
Generate the production client:
```bash
npm run db:generate
```

## Benefits of PostgreSQL Migration

1. **Better Performance**: Optimized for complex e-commerce queries and large product catalogs
2. **ACID Compliance**: Full transaction support for financial operations
3. **Rich Data Types**: Better support for JSON, arrays, and custom types
4. **Advanced Features**: Full-text search, geospatial data, and more
5. **Ecosystem**: Large community and extensive tooling
6. **Scalability**: Better horizontal and vertical scaling options

## Next Steps

1. **Update Application Code**: Review your services to ensure they work with the new schema
2. **Test Thoroughly**: Run your test suite to ensure everything works correctly
3. **Performance Optimization**: Use PostgreSQL-specific features for better performance
4. **Backup Strategy**: Implement regular database backups
5. **Monitoring**: Set up database monitoring and alerting

## Support

If you encounter any issues during migration:
1. Check the Prisma documentation: https://www.prisma.io/docs
2. Review PostgreSQL documentation: https://www.postgresql.org/docs/
3. Check the migration logs in the `prisma/migrations` folder
