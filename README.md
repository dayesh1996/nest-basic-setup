# Dygus Backend - Plumbing E-commerce Platform

## Docker Setup (Recommended)

The easiest way to run Dygus is using Docker. This will set up PostgreSQL, Redis, and your application automatically.

### Quick Start with Docker

1. **Clone and navigate to the project**:
   ```bash
   cd dygus-backend
   ```

2. **Start all services**:
   ```bash
   npm run docker:compose:up
   ```

3. **Run database migrations**:
   ```bash
   docker-compose exec app npm run db:migrate
   ```

4. **Seed the database** (optional):
   ```bash
   docker-compose exec app npm run db:seed
   ```

5. **Access your application**:
   - **API**: http://localhost:3000
   - **Prisma Studio**: http://localhost:5555
   - **PostgreSQL**: localhost:5432
   - **Redis**: localhost:6379

### Docker Commands

```bash
# Start services
npm run docker:compose:up

# Stop services
npm run docker:compose:down

# View logs
npm run docker:compose:logs

# Restart services
npm run docker:compose:restart

# Build containers
npm run docker:compose:build

# Production deployment
npm run docker:compose:prod

# Clean up Docker resources
npm run docker:clean
```

### Docker Services

- **PostgreSQL**: Database with persistent storage
- **Redis**: Caching layer
- **App**: NestJS application
- **Prisma Studio**: Database management UI (optional)

## PostgreSQL Migration Setup

This project has been migrated from MongoDB to PostgreSQL. Follow these steps to set up your PostgreSQL database for the Dygus plumbing e-commerce platform:

### 1. Install PostgreSQL Driver
```bash
npm install pg
```

### 2. Environment Configuration
Create a `.env` file in the root directory with the following configuration:

```env
# Database Configuration
DATABASE_URL="postgresql://username:password@localhost:5432/dygus_db?schema=public"

# Application Configuration
PORT=3000
NODE_ENV=development

# JWT Configuration (if using authentication)
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRES_IN=7d
```

### 3. Database Setup
```bash
# Generate Prisma client
npx prisma generate

# Create and apply database migrations
npx prisma migrate dev --name init

# (Optional) Seed the database
npx prisma db seed
```

### 4. Database Management
```bash
# Open Prisma Studio to manage your data
npx prisma studio

# Reset database (WARNING: This will delete all data)
npx prisma migrate reset
```

## Project Overview

Dygus is a comprehensive plumbing e-commerce platform that includes:

### Core Features
- **Product Management**: Sectors, Categories, Sub-categories, Brands, Products, and Inventory
- **Customer Management**: Customer profiles, business details, addresses, and documents
- **NBFC Integration**: Line of credit applications and approvals
- **Order Management**: Quotations, payments, orders, and shipping
- **GST & Tax Management**: HSN codes, tax calculations, and e-way bills
- **User Management**: Multi-role user system (admin, support, account, dispatch)

### Database Structure
- **Users & Authentication**: Admin users, NBFC users, customers with OTP login
- **Product Catalog**: Hierarchical product structure with images and variations
- **Financial**: Line of credit, payments, coupons, and reimbursement tracking
- **Logistics**: Shipment modes, transport details, and e-way bill management

## Project setup

```bash
$ npm install
```

## Compile and run the project
## First, generate the Prisma client
```bash
npx prisma generate
```

```bash
# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

## API Documentation (Swagger) will be available 
```bash
## This way it’s **short, step-by-step, and very understandable for any user**.  
## Do you also want me to make it in a **copy-paste friendly quick start section** (just commands + Swagger link), without explanations?

# Local:
$ http://localhost:3000/api-docs

#Production: 
https://dygus.api/api-docs

```
## Run tests

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```

## Deployment

When you're ready to deploy your NestJS application to production, there are some key steps you can take to ensure it runs as efficiently as possible. Check out the [deployment documentation](https://docs.nestjs.com/deployment) for more information.

If you are looking for a cloud-based platform to deploy your NestJS application, check out [Mau](https://mau.nestjs.com), our official platform for deploying NestJS applications on AWS. Mau makes deployment straightforward and fast, requiring just a few simple steps:

```bash
$ npm install -g @nestjs/mau
$ mau deploy
```

With Mau, you can deploy your application in just a few clicks, allowing you to focus on building features rather than managing infrastructure.

## Resources

Check out a few resources that may come in handy when working with NestJS:

- Visit the [NestJS Documentation](https://docs.nestjs.com) to learn more about the framework.
- For questions and support, please visit our [Discord channel](https://discord.gg/G7Qnnhy).
- To dive deeper and get more hands-on experience, check out our official video [courses](https://courses.nestjs.com/).
- Deploy your application to AWS with the help of [NestJS Mau](https://mau.nestjs.com) in just a few clicks.
- Visualize your application graph and interact with the NestJS application in real-time using [NestJS Devtools](https://devtools.nestjs.com).
- Need help with your project (part-time to full-time)? Check out our official [enterprise support](https://enterprise.nestjs.com).
- To stay in the loop and get updates, follow us on [X](https://x.com/nestframework) and [LinkedIn](https://linkedin.com/company/nestjs).
- Looking for a job, or have a job to offer? Check out our official [Jobs board](https://jobs.nestjs.com).

## Support

Nest is an MIT-licensed open source project. It can grow thanks to the sponsors and support by the amazing backers. If you'd like to join them, please [read more here](https://docs.nestjs.com/support).

## Stay in touch

- Author - [Kamil Myśliwiec](https://twitter.com/kammysliwiec)
- Website - [https://nestjs.com](https://nestjs.com/)
- Twitter - [@nestframework](https://twitter.com/nestframework)

## License

Nest is [MIT licensed](https://github.com/nestjs/nest/blob/master/LICENSE).



🎉 Success! Your School Management System Database is Ready!
✅ What was accomplished:
Fixed Prisma Schema Issues:
✅ Added @map("_id") to all 29 model ID fields for MongoDB compatibility
✅ Replaced Decimal types with Float for MongoDB support
✅ Added missing relation fields to complete bidirectional relationships
Fixed Connection Issues:
✅ Recreated the .env file with proper MongoDB connection string
✅ Added database name /school_management to the connection URL
✅ Completed connection parameters (retryWrites=true&w=majority)
Successfully Deployed to MongoDB:
✅ Created 29 collections in your MongoDB database
✅ Applied unique index on User email field
✅ Generated Prisma Client for your application
📊 Your Database Now Includes:
User Management: Users, Students, Parents, Teachers
Academic Structure: Classes, Sections, Subjects, Enrollments
Scheduling: TimetableSlots, TeacherAssignments
Assessment: Exams, ExamResults, Attendance
Financial: FeeStructures, FeeItems, Invoices, Payments
Library: LibraryBooks, BookCopies, BookIssues
Transport: Routes, Vehicles, Stops, Assignments
Hostel: Hostels, Rooms, RoomAllocations
System: Notifications, AuditLogs
Your school management system database is now fully operational and ready for development! 🚀

📖 Developer Docs
- [Coding Conventions & Best Practices](./dev-guidelines.md)

# 📖 Developer Docs

- [Controller](./docs/controller.md)  
- [Service](./docs/service.md)  
- [Repository](./docs/repository.md)  
...

