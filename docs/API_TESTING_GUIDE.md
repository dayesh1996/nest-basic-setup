# API Testing Guide - Dygus Backend

## Overview
This guide covers how to test your Dygus Plumbing E-Commerce API, including manual testing, automated testing, and understanding the healthcheck system.

## 🏥 Health Check System

### What is healthcheck.js?
The `healthcheck.js` file is a **Docker health check script** that monitors if your application is running properly.

**Purpose:**
- Verifies the API is responding to requests
- Ensures the container is healthy
- Automatically restarts containers if they become unhealthy

**How it works:**
```javascript
// healthcheck.js
const http = require('http');

const options = {
  host: 'localhost',
  port: process.env.PORT || 3000,
  path: '/health',           // Calls the /health endpoint
  timeout: 2000,            // 2 second timeout
};

// Makes HTTP request to /health endpoint
// Returns exit code 0 (healthy) or 1 (unhealthy)
```

**Health Check Flow:**
1. Docker runs `node healthcheck.js` every 30 seconds
2. Script makes HTTP request to `http://localhost:3000/health`
3. If response is 200 OK → Container is healthy
4. If response fails/timeout → Container is unhealthy

## 🧪 Manual API Testing

### 1. Test Basic Endpoints

#### Test Welcome Message
```bash
# Test root endpoint
curl http://localhost:3000

# Expected Response:
# "Welcome to Dygus Plumbing E-Commerce API – powering plumbing item sales!"
```

#### Test Health Check
```bash
# Test health endpoint
curl http://localhost:3000/health

# Expected Response:
# {"status":"ok","timestamp":"2025-08-25T04:10:00.000Z"}
```

#### Test Users API
```bash
# Get all users
curl http://localhost:3000/users

# Get specific user by ID
curl http://localhost:3000/users/1
```

### 2. Test with Different Tools

#### Using Postman
1. **Import Collection:**
   ```
   GET http://localhost:3000
   GET http://localhost:3000/health
   GET http://localhost:3000/users
   GET http://localhost:3000/users/:id
   ```

2. **Test Headers:**
   ```
   Content-Type: application/json
   Accept: application/json
   ```

#### Using Browser
- Open: `http://localhost:3000`
- Open: `http://localhost:3000/health`
- Open: `http://localhost:3000/users`

#### Using PowerShell
```powershell
# Test with Invoke-RestMethod
Invoke-RestMethod -Uri "http://localhost:3000" -Method Get
Invoke-RestMethod -Uri "http://localhost:3000/health" -Method Get
Invoke-RestMethod -Uri "http://localhost:3000/users" -Method Get
```

### 3. Test API Documentation
```bash
# Access Swagger UI
http://localhost:3000/api-docs
```

## 🤖 Automated Testing

### 1. Unit Tests
```bash
# Run unit tests
npm run test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:cov
```

### 2. E2E Tests
```bash
# Run end-to-end tests
npm run test:e2e

# Run e2e tests in watch mode
npm run test:e2e:watch
```

### 3. Manual E2E Testing Script
Create a test script to verify all endpoints:

```bash
# test-api.sh
#!/bin/bash

echo "🧪 Testing Dygus API Endpoints..."

# Test root endpoint
echo "1. Testing root endpoint..."
curl -s http://localhost:3000
echo -e "\n"

# Test health endpoint
echo "2. Testing health endpoint..."
curl -s http://localhost:3000/health
echo -e "\n"

# Test users endpoint
echo "3. Testing users endpoint..."
curl -s http://localhost:3000/users
echo -e "\n"

echo "✅ API Testing Complete!"
```

## 📊 API Response Examples

### 1. Welcome Endpoint (`GET /`)
```json
{
  "message": "Welcome to Dygus Plumbing E-Commerce API – powering plumbing item sales!"
}
```

### 2. Health Endpoint (`GET /health`)
```json
{
  "status": "ok",
  "timestamp": "2025-08-25T04:10:00.000Z"
}
```

### 3. Users Endpoint (`GET /users`)
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com"
    }
  ],
  "message": "Users retrieved successfully"
}
```

### 4. User by ID (`GET /users/:id`)
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com"
  },
  "message": "User found"
}
```

## 🔍 Debugging API Issues

### 1. Check Container Status
```bash
# Check if containers are running
docker ps

# Check container logs
docker logs dygus-app

# Check health status
docker inspect dygus-app | grep Health -A 10
```

### 2. Test Health Check Manually
```bash
# Test health check script manually
docker exec dygus-app node healthcheck.js

# Expected output: "Health check status: 200"
```

### 3. Check Network Connectivity
```bash
# Test if port is accessible
netstat -ano | findstr :3000

# Test with telnet (if available)
telnet localhost 3000
```

### 4. Check Database Connection
```bash
# Test database connection
docker exec dygus-postgres pg_isready -U dygus_user -d dygus_db
```

## 🚀 Performance Testing

### 1. Load Testing with Apache Bench
```bash
# Install Apache Bench (if not available)
# Windows: Download from Apache website
# Linux: sudo apt-get install apache2-utils

# Test with 100 requests, 10 concurrent
ab -n 100 -c 10 http://localhost:3000/

# Test health endpoint
ab -n 100 -c 10 http://localhost:3000/health
```

### 2. Response Time Testing
```bash
# Test response time
curl -w "@curl-format.txt" -o /dev/null -s http://localhost:3000/health
```

Create `curl-format.txt`:
```
     time_namelookup:  %{time_namelookup}\n
        time_connect:  %{time_connect}\n
     time_appconnect:  %{time_appconnect}\n
    time_pretransfer:  %{time_pretransfer}\n
       time_redirect:  %{time_redirect}\n
  time_starttransfer:  %{time_starttransfer}\n
                     ----------\n
          time_total:  %{time_total}\n
```

## 📝 Testing Checklist

### Pre-Testing Setup
- [ ] Docker containers are running
- [ ] Database is connected
- [ ] API is accessible on port 3000
- [ ] Health check endpoint is working

### Basic Functionality Tests
- [ ] Root endpoint returns welcome message
- [ ] Health endpoint returns status "ok"
- [ ] Users endpoint returns user list
- [ ] User by ID endpoint returns specific user
- [ ] API documentation is accessible

### Error Handling Tests
- [ ] Invalid user ID returns appropriate error
- [ ] Non-existent endpoints return 404
- [ ] Database connection errors are handled

### Performance Tests
- [ ] Response time is under 1 second
- [ ] Health check completes within 2 seconds
- [ ] API handles concurrent requests

## 🛠️ Quick Test Commands

### One-liner Tests
```bash
# Quick health check
curl -s http://localhost:3000/health | jq .

# Quick API test
curl -s http://localhost:3000/users | jq .

# Test with timeout
curl --max-time 5 http://localhost:3000/health
```

### Docker-based Testing
```bash
# Test from within container
docker exec dygus-app curl http://localhost:3000/health

# Run tests in container
docker exec dygus-app npm run test

# Check container health
docker inspect dygus-app --format='{{.State.Health.Status}}'
```

## 📈 Monitoring and Alerts

### 1. Health Check Monitoring
```bash
# Monitor health check status
watch -n 5 'docker inspect dygus-app --format="{{.State.Health.Status}}"'

# Check health check logs
docker inspect dygus-app --format='{{range .State.Health.Log}}{{.Output}}{{end}}'
```

### 2. API Monitoring
```bash
# Monitor API response time
while true; do
  curl -w "%{time_total}s\n" -o /dev/null -s http://localhost:3000/health
  sleep 5
done
```

---

## 🎯 Summary

### Health Check System
- **Purpose**: Monitor container health automatically
- **Frequency**: Every 30 seconds
- **Endpoint**: `/health`
- **Success**: HTTP 200 response
- **Failure**: Container marked as unhealthy

### Testing Strategy
1. **Manual Testing**: Use curl, Postman, or browser
2. **Automated Testing**: Use npm test commands
3. **Health Monitoring**: Use Docker health checks
4. **Performance Testing**: Use load testing tools

### Key Endpoints
- `GET /` - Welcome message
- `GET /health` - Health check
- `GET /users` - List all users
- `GET /users/:id` - Get specific user
- `GET /api-docs` - API documentation

---

**Document Version**: 1.0  
**Last Updated**: August 25, 2025  
**Testing Status**: ✅ Ready for testing
