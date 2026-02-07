# Quick Setup Guide

This guide will help you get the Social Media Backend up and running quickly.

## Prerequisites

Before you begin, ensure you have:
- **Node.js** v16 or higher ([Download](https://nodejs.org/))
- **PostgreSQL** v12 or higher, OR **Docker** for containerized database
- **Git** for version control

## Setup Options

### Option 1: Automated Setup (Recommended)

Run the automated setup script:

```bash
chmod +x setup.sh
./setup.sh
```

This will:
- ✅ Check Node.js and npm installation
- ✅ Install all dependencies
- ✅ Create .env file from template
- ✅ Provide next steps

### Option 2: Manual Setup

#### Step 1: Install Dependencies
```bash
npm install
```

#### Step 2: Configure Environment
```bash
cp .env.example .env
```

Edit `.env` with your database credentials:
```env
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=social_media_db
NODE_ENV=development
```

#### Step 3: Set Up Database

**Using Docker (Recommended):**
```bash
docker-compose up -d
```

**Using Local PostgreSQL:**
```bash
# Login to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE social_media_db;

# Enable UUID extension
\c social_media_db
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
\q
```

#### Step 4: Run Migrations
```bash
npm run migration:run
```

#### Step 5: Start the Server
```bash
# Development mode with hot reload
npm run dev

# Production mode
npm run build
npm start
```

## Verification

### 1. Check Server Health
```bash
curl http://localhost:3000/health
```

Expected response:
```json
{
  "status": "OK",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

### 2. Run Test Suite
```bash
./test.sh
```

This opens an interactive menu to test all endpoints.

### 3. Create a Test User
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "fullName": "Test User",
    "bio": "This is a test account"
  }'
```

## Common Issues

### Issue: Database connection failed
**Solution:** 
- Verify PostgreSQL is running: `docker-compose ps` or check your local PostgreSQL service
- Check credentials in `.env` file
- Ensure database `social_media_db` exists

### Issue: Migration failed
**Solution:**
- Drop and recreate database
- Ensure UUID extension is installed: `CREATE EXTENSION IF NOT EXISTS "uuid-ossp";`

### Issue: Port 3000 already in use
**Solution:**
- Change PORT in `.env` file
- Or stop the process using port 3000: `lsof -ti:3000 | xargs kill -9`

### Issue: Test script fails
**Solution:**
- Ensure server is running: `npm run dev`
- Check server is accessible: `curl http://localhost:3000/health`
- Verify `jq` is installed (for JSON parsing in tests): `brew install jq` or `apt-get install jq`

## Database Management

### View Migrations
```bash
npm run typeorm migration:show
```

### Create New Migration
```bash
npm run migration:generate -- src/migrations/YourMigrationName
```

### Revert Last Migration
```bash
npm run migration:revert
```

### Reset Database
```bash
# Stop server
# Drop database
psql -U postgres -c "DROP DATABASE social_media_db;"
psql -U postgres -c "CREATE DATABASE social_media_db;"

# Or with Docker
docker-compose down -v
docker-compose up -d

# Run migrations again
npm run migration:run
```

## Development Workflow

1. **Start development server** with hot reload:
   ```bash
   npm run dev
   ```

2. **Make code changes** - server will automatically restart

3. **Test your changes**:
   ```bash
   ./test.sh
   ```

4. **Create migrations** for schema changes:
   ```bash
   npm run migration:generate -- src/migrations/YourChanges
   npm run migration:run
   ```

## Project Structure

```
social-media-backend/
├── src/
│   ├── entities/           # Database models
│   ├── controllers/        # Business logic
│   ├── routes/            # API routes
│   ├── validators/        # Input validation
│   ├── migrations/        # Database migrations
│   ├── data-source.ts     # TypeORM config
│   └── index.ts           # App entry point
├── test.sh                # Interactive test suite
├── setup.sh               # Automated setup
├── docker-compose.yml     # Docker configuration
└── README.md             # Full documentation
```

## Next Steps

After setup is complete:

1. ✅ Read the [API Documentation](README.md#-api-documentation) in README.md
2. ✅ Explore the [test script](test.sh) to understand API usage
3. ✅ Review the [database schema](README.md#-database-schema) 
4. ✅ Start building your features!

## Support

If you encounter any issues:
1. Check this guide's Common Issues section
2. Review the main [README.md](README.md)
3. Check server logs for error messages
4. Verify all prerequisites are installed

## Quick Reference

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run build` | Build for production |
| `npm start` | Start production server |
| `npm run migration:run` | Apply migrations |
| `npm run migration:revert` | Revert last migration |
| `./test.sh` | Run interactive tests |
| `docker-compose up -d` | Start PostgreSQL |
| `docker-compose down` | Stop PostgreSQL |

Happy coding! 🚀
