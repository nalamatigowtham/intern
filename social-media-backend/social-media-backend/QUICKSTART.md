# Quick Reference Card

## 🚀 Getting Started (3 Steps)

```bash
# 1. Extract and setup
tar -xzf social-media-backend.tar.gz
cd social-media-backend
./setup.sh

# 2. Start database (choose one)
docker-compose up -d              # Using Docker
# OR setup PostgreSQL manually

# 3. Run migrations and start
npm run migration:run
npm run dev
```

## 📋 Essential Commands

| Task | Command |
|------|---------|
| Install dependencies | `npm install` |
| Start development | `npm run dev` |
| Build for production | `npm run build` |
| Start production | `npm start` |
| Run migrations | `npm run migration:run` |
| Revert migration | `npm run migration:revert` |
| Run tests | `./test.sh` |
| Start database | `docker-compose up -d` |
| Stop database | `docker-compose down` |

## 🔌 API Endpoints Quick Reference

### Users
```bash
GET    /api/users                    # List all users
GET    /api/users/:id                # Get user by ID
POST   /api/users                    # Create user
PUT    /api/users/:id                # Update user
DELETE /api/users/:id                # Delete user
GET    /api/users/:id/followers      # Get followers
GET    /api/users/:id/activity       # Get activity
```

### Posts
```bash
GET    /api/posts                    # List all posts
GET    /api/posts/:id                # Get post by ID
POST   /api/posts                    # Create post (with hashtags)
PUT    /api/posts/:id                # Update post
DELETE /api/posts/:id                # Delete post
```

### Special Endpoints
```bash
GET    /api/feed?userId=xxx          # Personalized feed
GET    /api/posts/hashtag/:tag       # Posts by hashtag
```

### Likes
```bash
GET    /api/likes                    # List all likes
POST   /api/likes                    # Like a post
DELETE /api/likes/:id                # Unlike a post
```

### Follows
```bash
GET    /api/follows                  # List all follows
POST   /api/follows                  # Follow a user
DELETE /api/follows/:id              # Unfollow a user
```

## 📝 Sample API Calls

### Create User
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "username": "johndoe",
    "email": "john@example.com",
    "fullName": "John Doe",
    "bio": "Developer"
  }'
```

### Create Post with Hashtags
```bash
curl -X POST http://localhost:3000/api/posts \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Hello world! #coding #nodejs",
    "authorId": "USER_ID_HERE",
    "hashtags": ["coding", "nodejs"]
  }'
```

### Follow User
```bash
curl -X POST http://localhost:3000/api/follows \
  -H "Content-Type: application/json" \
  -d '{
    "followerId": "USER1_ID",
    "followingId": "USER2_ID"
  }'
```

### Like Post
```bash
curl -X POST http://localhost:3000/api/likes \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "USER_ID",
    "postId": "POST_ID"
  }'
```

### Get Feed
```bash
curl "http://localhost:3000/api/feed?userId=USER_ID&limit=10&offset=0"
```

### Get Posts by Hashtag
```bash
curl "http://localhost:3000/api/posts/hashtag/coding?limit=10"
```

## 📊 Pagination

All list endpoints support:
```
?limit=10&offset=0
```

- `limit`: Number of items per page (default: 10, max: 100)
- `offset`: Number of items to skip (default: 0)

## 🔍 Testing

Interactive test menu:
```bash
./test.sh
```

Options:
1. Test individual entities (Users, Posts, etc.)
2. Test special endpoints
3. Run full automated test suite

## 📁 Project Structure

```
social-media-backend/
├── src/
│   ├── entities/          # TypeORM models
│   ├── controllers/       # API logic
│   ├── routes/           # Route definitions
│   ├── validators/       # Joi schemas
│   ├── migrations/       # Database migrations
│   └── index.ts          # Entry point
├── test.sh               # Interactive tests
├── setup.sh              # Auto setup
└── README.md            # Full docs
```

## 🗄️ Database Schema

```
users
  ├── id (uuid, PK)
  ├── username (unique)
  ├── email (unique)
  └── ...

posts
  ├── id (uuid, PK)
  ├── content
  ├── authorId (FK -> users)
  └── ...

likes
  ├── id (uuid, PK)
  ├── userId (FK -> users)
  ├── postId (FK -> posts)
  └── UNIQUE(userId, postId)

follows
  ├── id (uuid, PK)
  ├── followerId (FK -> users)
  ├── followingId (FK -> users)
  └── UNIQUE(followerId, followingId)

hashtags
  ├── id (uuid, PK)
  └── name (unique)

activities
  ├── id (uuid, PK)
  ├── userId (FK -> users)
  ├── activityType
  └── metadata (jsonb)
```

## ⚙️ Environment Variables

Create `.env` file:
```env
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=social_media_db
NODE_ENV=development
```

## 🐛 Common Issues

**Database connection error**
- Check PostgreSQL is running
- Verify credentials in `.env`

**Migration failed**
- Run: `CREATE EXTENSION IF NOT EXISTS "uuid-ossp";`
- Recreate database if needed

**Port 3000 in use**
- Change PORT in `.env`
- Or: `lsof -ti:3000 | xargs kill -9`

**Test script fails**
- Install jq: `brew install jq` or `apt-get install jq`
- Ensure server is running

## 📚 Documentation

- **README.md** - Complete API documentation
- **SETUP.md** - Detailed setup guide
- **ARCHITECTURE.md** - Technical decisions and design

## ✅ Checklist for Submission

- [ ] Extract archive
- [ ] Run `./setup.sh`
- [ ] Start PostgreSQL
- [ ] Run migrations
- [ ] Start server
- [ ] Test with `./test.sh`
- [ ] Record Loom video
- [ ] Push to GitHub
- [ ] Submit form

## 🎯 Key Features Implemented

✅ Complete CRUD for all entities
✅ Personalized feed endpoint
✅ Hashtag search endpoint
✅ User followers endpoint
✅ User activity endpoint
✅ Comprehensive test suite
✅ Migration-based schema
✅ Efficient indexing
✅ Input validation
✅ Pagination support
✅ Activity tracking
✅ Interactive testing

---

**Need Help?** Check README.md for detailed documentation.
