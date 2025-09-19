# Docker Setup Guide - Dygus Plumbing E-commerce

This guide will help you set up and run the Dygus application using Docker containers.

## Prerequisites

1. **Docker**: Install Docker Desktop or Docker Engine
   - [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/Mac)
   - [Docker Engine](https://docs.docker.com/engine/install/) (Linux)

2. **Docker Compose**: Usually included with Docker Desktop

## Quick Start

### 1. Start All Services

```bash
# Start PostgreSQL, Redis, and the application
npm run docker:compose:up
```

### 2. Run Database Migrations

```bash
# Apply database schema
docker-compose exec app npm run db:migrate
```

### 3. Seed Database (Optional)

```bash
# Populate with sample data
docker-compose exec app npm run db:seed
```

### 4. Access Your Application

- **API**: http://localhost:3000
- **Prisma Studio**: http://localhost:5555
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379

## Docker Services Overview

### PostgreSQL Database
- **Image**: postgres:15-alpine
- **Port**: 5432
- **Database**: dygus_db
- **User**: dygus_user
- **Password**: dygus_password
- **Persistent Storage**: Yes

### Redis Cache
- **Image**: redis:7-alpine
- **Port**: 6379
- **Persistent Storage**: Yes

### NestJS Application
- **Port**: 3000
- **Environment**: Development
- **Hot Reload**: Enabled
- **Health Check**: Available

### Prisma Studio (Optional)
- **Port**: 5555
- **Purpose**: Database management UI

## Docker Commands

### Development Commands

```bash
# Start all services
npm run docker:compose:up

# Start services in background
docker-compose up -d

# Stop all services
npm run docker:compose:down

# View logs
npm run docker:compose:logs

# View logs for specific service
docker-compose logs -f app
docker-compose logs -f postgres

# Restart services
npm run docker:compose:restart

# Rebuild containers
npm run docker:compose:build

# Access container shell
docker-compose exec app sh
docker-compose exec postgres psql -U dygus_user -d dygus_db
```

### Database Commands

```bash
# Run migrations
docker-compose exec app npm run db:migrate

# Seed database
docker-compose exec app npm run db:seed

# Reset database
docker-compose exec app npm run db:reset

# Open Prisma Studio
docker-compose exec app npm run db:studio
```

### Production Commands

```bash
# Start production services
npm run docker:compose:prod

# Stop production services
npm run docker:compose:prod:down

# Build production image
docker build -t dygus-app:prod .
```

### Maintenance Commands

```bash
# Clean up Docker resources
npm run docker:clean

# Remove all containers and volumes
docker-compose down -v

# Remove all images
docker system prune -a

# View resource usage
docker stats
```

## Environment Variables

### Development (.env)

```env
# Database
DATABASE_URL=postgresql://dygus_user:dygus_password@postgres:5432/dygus_db?schema=public

# Application
NODE_ENV=development
PORT=3000

# JWT
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRES_IN=7d

# Redis
REDIS_URL=redis://redis:6379
```

### Production (.env.prod)

```env
# Database
POSTGRES_DB=dygus_db
POSTGRES_USER=dygus_user
POSTGRES_PASSWORD=your-secure-password

# Application
NODE_ENV=production
JWT_SECRET=your-production-jwt-secret
JWT_EXPIRES_IN=7d
```

## Docker Compose Files

### docker-compose.yml (Development)
- PostgreSQL with persistent storage
- Redis cache
- NestJS app with hot reload
- Prisma Studio for database management

### docker-compose.prod.yml (Production)
- PostgreSQL with health checks
- Redis with persistence
- NestJS app optimized for production
- Nginx reverse proxy (optional)

## Troubleshooting

### Common Issues

1. **Port Already in Use**
   ```bash
   # Check what's using the port
   lsof -i :3000
   
   # Stop conflicting services
   docker-compose down
   ```

2. **Database Connection Issues**
   ```bash
   # Check if PostgreSQL is running
   docker-compose ps
   
   # Check PostgreSQL logs
   docker-compose logs postgres
   
   # Restart PostgreSQL
   docker-compose restart postgres
   ```

3. **Permission Issues**
   ```bash
   # Fix file permissions
   sudo chown -R $USER:$USER .
   
   # Rebuild containers
   docker-compose build --no-cache
   ```

4. **Out of Disk Space**
   ```bash
   # Clean up Docker
   docker system prune -a
   docker volume prune
   ```

### Health Checks

```bash
# Check application health
curl http://localhost:3000/health

# Check database connection
docker-compose exec postgres pg_isready -U dygus_user

# Check Redis connection
docker-compose exec redis redis-cli ping
```

### Logs and Debugging

```bash
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs app
docker-compose logs postgres
docker-compose logs redis

# Follow logs in real-time
docker-compose logs -f

# View container details
docker-compose ps
docker inspect dygus-app
```

## Production Deployment

### 1. Set Environment Variables

Create `.env.prod` with production values:
```env
POSTGRES_PASSWORD=your-secure-password
JWT_SECRET=your-production-jwt-secret
NODE_ENV=production
```

### 2. Deploy

```bash
# Start production services
npm run docker:compose:prod

# Run migrations
docker-compose -f docker-compose.prod.yml exec app npm run db:migrate:deploy

# Seed database (if needed)
docker-compose -f docker-compose.prod.yml exec app npm run db:seed
```

### 3. SSL/HTTPS Setup

1. Add SSL certificates to `docker/nginx/ssl/`
2. Update `docker/nginx/nginx.conf` for HTTPS
3. Restart nginx container

### 4. Monitoring

```bash
# View resource usage
docker stats

# Monitor logs
docker-compose -f docker-compose.prod.yml logs -f

# Check health
curl https://your-domain.com/health
```

## Backup and Restore

### Database Backup

```bash
# Create backup
docker-compose exec postgres pg_dump -U dygus_user dygus_db > backup.sql

# Restore backup
docker-compose exec -T postgres psql -U dygus_user dygus_db < backup.sql
```

### Volume Backup

```bash
# Backup PostgreSQL data
docker run --rm -v dygus_postgres_data:/data -v $(pwd):/backup alpine tar czf /backup/postgres_backup.tar.gz -C /data .

# Restore PostgreSQL data
docker run --rm -v dygus_postgres_data:/data -v $(pwd):/backup alpine tar xzf /backup/postgres_backup.tar.gz -C /data
```

## Security Considerations

1. **Change Default Passwords**: Update PostgreSQL and Redis passwords
2. **Use Environment Variables**: Never hardcode secrets
3. **Network Security**: Use Docker networks for service communication
4. **Regular Updates**: Keep Docker images updated
5. **Backup Strategy**: Implement regular backups
6. **Monitoring**: Set up logging and monitoring

## Performance Optimization

1. **Resource Limits**: Set memory and CPU limits
2. **Caching**: Use Redis for caching
3. **Database Optimization**: Configure PostgreSQL for performance
4. **Load Balancing**: Use Nginx for load balancing
5. **Monitoring**: Monitor resource usage

## Support

For Docker-related issues:
1. Check Docker documentation: https://docs.docker.com/
2. Review Docker Compose documentation: https://docs.docker.com/compose/
3. Check container logs for error messages
4. Verify environment variables and configuration
