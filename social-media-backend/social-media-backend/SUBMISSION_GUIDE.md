# 🎯 ASSIGNMENT SUBMISSION INSTRUCTIONS

## What's Included

This archive contains a **complete, production-ready** social media backend with:

✅ **All Required Features**
- User management (CRUD)
- Post creation with hashtags
- Like/Unlike posts
- Follow/Unfollow users
- Personalized feed
- Hashtag search
- User followers list
- Activity history tracking

✅ **Technical Requirements Met**
- TypeORM entities (proper structure)
- Database migrations (NO synchronize: true)
- Joi validation for all entities
- Efficient indexing strategy
- Comprehensive test suite
- Full API documentation

✅ **Bonus Features**
- Interactive test script with menu
- Docker support for easy setup
- Automated setup script
- Architecture documentation
- Activity tracking system

## 📦 Quick Start (5 Minutes)

### Step 1: Extract
```bash
tar -xzf social-media-backend.tar.gz
cd social-media-backend
```

### Step 2: Setup
```bash
./setup.sh
```

### Step 3: Database
```bash
# Option A: Docker (Recommended)
docker-compose up -d

# Option B: Local PostgreSQL
# Make sure PostgreSQL is running and create database
```

### Step 4: Migrate & Run
```bash
npm run migration:run
npm run dev
```

### Step 5: Test
```bash
# In another terminal
./test.sh
```

## 📹 Loom Video Checklist

Here's what to cover in your video:

1. **Introduction (30 seconds)**
   - Your name and background
   - Why you're interested in backend engineering
   - What you enjoy about it

2. **Code Walkthrough (2-3 minutes)**
   - Project structure overview
   - Show entities in `src/entities/`
   - Show migrations in `src/migrations/`
   - Explain one controller (e.g., PostController)
   - Point out validation schemas

3. **CLI Demo (3-4 minutes)**
   - Start the server: `npm run dev`
   - Run test script: `./test.sh`
   - Navigate through menu:
     - Create users
     - Create posts with hashtags
     - Create follows
     - Test feed endpoint
     - Test hashtag search
   - Show successful responses

4. **Technical Decisions (2-3 minutes)**
   - Why TypeORM and migrations
   - Indexing strategy explanation
   - How feed endpoint works
   - Activity tracking feature
   - Testing approach

## 🔑 Key Technical Decisions

### 1. **Database Design**
- **UUIDs** for scalability and security
- **Composite indexes** for feed queries (authorId, createdAt)
- **Unique constraints** to prevent duplicates
- **CASCADE deletes** for data integrity

### 2. **Feed Algorithm**
```typescript
// Efficient feed implementation:
1. Get user's following list (indexed)
2. Query posts WHERE authorId IN (following list)
3. Sort by createdAt DESC (indexed)
4. Paginate with limit/offset
```

### 3. **Hashtag System**
- Case-insensitive storage
- Many-to-many relationship
- Automatic hashtag creation on post
- Efficient search with ILIKE

### 4. **Activity Tracking**
- Automatic logging of key actions
- JSONB metadata for flexibility
- Filterable by type and date
- Supports analytics use cases

### 5. **Testing Strategy**
- Interactive CLI menu
- Color-coded output
- Tests all CRUD operations
- Tests all special endpoints
- No external dependencies needed

## 📊 API Endpoints Summary

**Core CRUD (for all entities):**
- GET /api/{entity} - List all
- GET /api/{entity}/:id - Get one
- POST /api/{entity} - Create
- PUT /api/{entity}/:id - Update (where applicable)
- DELETE /api/{entity}/:id - Delete

**Special Endpoints:**
```
GET /api/feed?userId={id}&limit={n}&offset={m}
→ Personalized content stream from followed users

GET /api/posts/hashtag/:tag?limit={n}&offset={m}
→ Posts containing specific hashtag

GET /api/users/:id/followers?limit={n}&offset={m}
→ List of user's followers with follow dates

GET /api/users/:id/activity?limit={n}&offset={m}&activityType={type}
→ User activity history with filtering
```

## 🏗️ Architecture Highlights

### Layered Structure
```
HTTP Layer (Routes)
    ↓
Business Logic (Controllers)
    ↓
Data Access (TypeORM Repositories)
    ↓
Database (PostgreSQL)
```

### Key Design Patterns
- **Repository Pattern** via TypeORM
- **Validation Layer** with Joi
- **Error Handling** middleware
- **Pagination** standard across all lists
- **RESTful** conventions

## 📁 Files Overview

```
social-media-backend/
├── src/
│   ├── entities/              # 6 entities (User, Post, Like, Follow, Hashtag, Activity)
│   ├── migrations/            # 6 migration files (no synchronize!)
│   ├── controllers/           # 6 controllers with business logic
│   ├── validators/            # Joi schemas for all entities
│   ├── routes/               # Centralized route definitions
│   ├── data-source.ts        # TypeORM configuration
│   └── index.ts              # Express app setup
├── test.sh                    # Interactive test suite ⭐
├── setup.sh                   # Automated setup
├── docker-compose.yml         # PostgreSQL container
├── package.json              # Dependencies and scripts
├── tsconfig.json             # TypeScript config
├── README.md                 # Complete documentation
├── SETUP.md                  # Setup guide
├── QUICKSTART.md             # Quick reference
└── ARCHITECTURE.md           # Technical decisions
```

## ✅ Verification Checklist

Before submitting, verify:

- [ ] Server starts successfully (`npm run dev`)
- [ ] All migrations run (`npm run migration:run`)
- [ ] Test script works (`./test.sh`)
- [ ] Can create users via API
- [ ] Can create posts with hashtags
- [ ] Feed endpoint returns correct data
- [ ] Hashtag search works
- [ ] All CRUD operations work
- [ ] Repository is public on GitHub
- [ ] Loom video recorded

## 🎬 Recording Your Loom Video

### Setup Before Recording
1. Start the server in one terminal
2. Have test.sh ready in another terminal
3. Have your code editor open
4. Close unnecessary applications
5. Test your microphone

### Recording Tips
- **Keep it 8-10 minutes total**
- Speak clearly and at moderate pace
- Show enthusiasm for backend engineering
- Be specific about technical decisions
- Demonstrate features, don't just describe them

### Video Structure Template

```
[0:00-0:30] Introduction
"Hi, I'm [Name]. I'm a [background] passionate about backend 
engineering because [specific reasons]..."

[0:30-3:00] Code Walkthrough
"Let me show you the project structure..."
- Navigate through files
- Explain key code sections
- Point out interesting implementations

[3:00-6:00] CLI Demo
"Now let's see it in action..."
- Start server
- Run test.sh
- Create entities
- Test special endpoints

[6:00-9:00] Technical Decisions
"Let me explain some key decisions I made..."
- Database design
- Indexing strategy
- Feed implementation
- Testing approach

[9:00-10:00] Closing
"Thank you for reviewing my submission. I'm excited about
the opportunity to contribute to your team!"
```

## 📤 Submission Steps

1. **Push to GitHub**
   ```bash
   cd social-media-backend
   git init
   git add .
   git commit -m "Complete social media backend implementation"
   git remote add origin YOUR_REPO_URL
   git push -u origin main
   ```

2. **Make Repository Public**
   - Go to repository settings
   - Change visibility to public

3. **Record Loom Video**
   - Use template above
   - Keep it 8-10 minutes
   - Upload to Loom

4. **Submit Form**
   - GitHub repository link
   - Loom video link

## 🎯 What Makes This Submission Stand Out

1. **Complete Implementation** - All requirements met and tested
2. **Production Quality** - Proper error handling, validation, indexing
3. **Excellent Documentation** - 4 comprehensive docs included
4. **Easy to Evaluate** - Interactive test script, clear structure
5. **Best Practices** - Migrations, TypeScript, proper architecture
6. **Bonus Features** - Activity tracking, Docker support, automation

## 💡 Tips for Your Video

**DO:**
- ✅ Show genuine enthusiasm for backend engineering
- ✅ Explain your thought process
- ✅ Demonstrate working features
- ✅ Mention specific technologies and why you used them
- ✅ Show the test script running successfully

**DON'T:**
- ❌ Just read the code
- ❌ Spend too long on any one section
- ❌ Forget to show features working
- ❌ Skip explaining technical decisions
- ❌ Apologize or be overly humble

## 🚀 Ready to Submit?

You have a **complete, working, well-documented** social media backend that:
- Meets all assignment requirements
- Follows best practices
- Is easy to set up and test
- Demonstrates strong backend engineering skills

**Good luck with your submission!** 🎉

---

Questions? Check the README.md for detailed documentation.
