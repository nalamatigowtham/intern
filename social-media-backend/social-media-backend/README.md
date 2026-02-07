# Social Media Platform Backend

A full-featured backend API for a social media platform built with TypeScript, Express, TypeORM, and PostgreSQL.

## 🌟 Features

### Core Functionality
- ✅ User management (CRUD operations)
- ✅ Post creation with text content
- ✅ Follow/Unfollow users
- ✅ Like posts
- ✅ Hashtag tagging system
- ✅ User activity tracking

### Special Endpoints
- 🌊 **Personalized Feed** - Get posts from followed users
- 🔍 **Hashtag Search** - Find posts by hashtag
- 👥 **Follower Lists** - View user followers with pagination
- 📜 **Activity History** - Track user activities with filtering

## 🛠️ Tech Stack

- **Runtime**: Node.js
- **Language**: TypeScript
- **Framework**: Express.js
- **ORM**: TypeORM
- **Database**: PostgreSQL
- **Validation**: Joi
- **Testing**: Custom shell script with curl

## 📋 Prerequisites

- Node.js (v16 or higher)
- PostgreSQL (v12 or higher)
- npm or yarn

## 🚀 Installation

1. **Clone the repository**
```bash
git clone <your-repo-url>
cd social-media-backend
```

2. **Install dependencies**
```bash
npm install
```

3. **Set up environment variables**
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

4. **Create the database**
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

5. **Run migrations**
```bash
npm run migration:run
```

6. **Start the server**
```bash
# Development mode with hot reload
npm run dev

# Production mode
npm run build
npm start
```

The server will start on `http://localhost:3000`

## 📚 API Documentation

### Base URL
```
http://localhost:3000/api
```

### Entities

#### Users
- `GET /users` - Get all users (paginated)
- `GET /users/:id` - Get user by ID
- `POST /users` - Create new user
- `PUT /users/:id` - Update user
- `DELETE /users/:id` - Delete user
- `GET /users/:id/followers` - Get user's followers (paginated)
- `GET /users/:id/activity` - Get user's activity history (paginated, filterable)

#### Posts
- `GET /posts` - Get all posts (paginated)
- `GET /posts/:id` - Get post by ID
- `POST /posts` - Create new post
- `PUT /posts/:id` - Update post
- `DELETE /posts/:id` - Delete post

#### Likes
- `GET /likes` - Get all likes (paginated)
- `GET /likes/:id` - Get like by ID
- `POST /likes` - Create like
- `DELETE /likes/:id` - Delete like

#### Follows
- `GET /follows` - Get all follows (paginated)
- `GET /follows/:id` - Get follow by ID
- `POST /follows` - Create follow
- `DELETE /follows/:id` - Delete follow (unfollow)

#### Hashtags
- `GET /hashtags` - Get all hashtags (paginated)
- `GET /hashtags/:id` - Get hashtag by ID
- `POST /hashtags` - Create hashtag
- `PUT /hashtags/:id` - Update hashtag
- `DELETE /hashtags/:id` - Delete hashtag

#### Activities
- `GET /activities` - Get all activities (paginated)
- `GET /activities/:id` - Get activity by ID
- `POST /activities` - Create activity
- `DELETE /activities/:id` - Delete activity

### Special Endpoints

#### 1. Feed (Personalized Content Stream)
```
GET /api/feed?userId={userId}&limit={limit}&offset={offset}
```
Returns posts from users that the specified user follows, sorted by creation date (newest first).

**Query Parameters:**
- `userId` (required) - ID of the user requesting the feed
- `limit` (optional, default: 10) - Number of posts per page
- `offset` (optional, default: 0) - Number of posts to skip

**Response:**
```json
{
  "posts": [
    {
      "id": "uuid",
      "content": "Post content",
      "createdAt": "2024-01-01T00:00:00.000Z",
      "author": {
        "id": "uuid",
        "username": "johndoe",
        "fullName": "John Doe"
      },
      "hashtags": [
        { "id": "uuid", "name": "coding" }
      ],
      "likeCount": 5
    }
  ],
  "total": 50,
  "limit": 10,
  "offset": 0
}
```

#### 2. Posts by Hashtag
```
GET /api/posts/hashtag/:tag?limit={limit}&offset={offset}
```
Returns all posts containing the specified hashtag (case-insensitive).

**Parameters:**
- `tag` (path parameter) - Hashtag name (with or without #)
- `limit` (optional, default: 10)
- `offset` (optional, default: 0)

**Response:**
```json
{
  "posts": [...],
  "total": 25,
  "limit": 10,
  "offset": 0,
  "hashtag": "coding"
}
```

#### 3. User Followers
```
GET /api/users/:id/followers?limit={limit}&offset={offset}
```
Returns a list of users who follow the specified user.

**Response:**
```json
{
  "followers": [
    {
      "id": "uuid",
      "username": "janedoe",
      "fullName": "Jane Doe",
      "followedAt": "2024-01-01T00:00:00.000Z"
    }
  ],
  "total": 100,
  "limit": 10,
  "offset": 0
}
```

#### 4. User Activity History
```
GET /api/users/:id/activity?limit={limit}&offset={offset}&activityType={type}&startDate={date}&endDate={date}
```
Returns chronological list of user activities.

**Query Parameters:**
- `limit` (optional, default: 10)
- `offset` (optional, default: 0)
- `activityType` (optional) - Filter by: POST_CREATED, POST_LIKED, USER_FOLLOWED, USER_UNFOLLOWED
- `startDate` (optional) - ISO date string
- `endDate` (optional) - ISO date string

## 🧪 Testing

Run the interactive test suite:

```bash
./test.sh
```

The test script provides:
- Interactive menu system
- CRUD tests for all entities
- Tests for all special endpoints
- Full automated test suite option
- Color-coded output for easy reading

### Test Structure

The test script is organized with:
1. **Main Menu** - Select entity or run full suite
2. **Entity Submenus** - CRUD operations for each entity
3. **Special Endpoints Menu** - Test feed, hashtag search, etc.
4. **Full Test Suite** - Automated testing of all functionality

## 📊 Database Schema

### Indexing Strategy

The database uses strategic indexing for optimal query performance:

**Composite Indexes:**
- `users(username)` - User lookup
- `users(email)` - Authentication
- `posts(authorId, createdAt)` - Feed queries
- `likes(userId, postId)` - Unique constraint + like checks
- `follows(followerId, followingId)` - Unique constraint + follow checks
- `activities(userId, createdAt)` - Activity history

**Single Column Indexes:**
- `posts(createdAt)` - Sorting posts
- `hashtags(name)` - Hashtag lookup

### Relationships

```
User
  ├── has many Posts
  ├── has many Likes
  ├── has many Followers (through Follow)
  ├── has many Following (through Follow)
  └── has many Activities

Post
  ├── belongs to User (author)
  ├── has many Likes
  └── has many Hashtags (many-to-many)

Like
  ├── belongs to User
  └── belongs to Post

Follow
  ├── belongs to User (follower)
  └── belongs to User (following)

Hashtag
  └── has many Posts (many-to-many)

Activity
  └── belongs to User
```

## 🔄 Migrations

### Creating New Migrations
```bash
npm run migration:generate -- src/migrations/MigrationName
```

### Running Migrations
```bash
npm run migration:run
```

### Reverting Migrations
```bash
npm run migration:revert
```

## 🏗️ Project Structure

```
social-media-backend/
├── src/
│   ├── entities/           # TypeORM entities
│   │   ├── User.ts
│   │   ├── Post.ts
│   │   ├── Like.ts
│   │   ├── Follow.ts
│   │   ├── Hashtag.ts
│   │   └── Activity.ts
│   ├── migrations/         # Database migrations
│   ├── controllers/        # Request handlers
│   │   ├── UserController.ts
│   │   ├── PostController.ts
│   │   ├── LikeController.ts
│   │   ├── FollowController.ts
│   │   ├── HashtagController.ts
│   │   └── ActivityController.ts
│   ├── routes/            # API routes
│   │   └── index.ts
│   ├── validators/        # Joi validation schemas
│   │   └── index.ts
│   ├── data-source.ts     # TypeORM configuration
│   └── index.ts           # Application entry point
├── test.sh                # Interactive test script
├── package.json
├── tsconfig.json
└── README.md
```

## 🔒 Validation

All endpoints use Joi validation to ensure data integrity:

- **User**: Username (3-50 chars), valid email, full name
- **Post**: Content (1-5000 chars), valid author ID
- **Like**: Valid user and post IDs, no duplicates
- **Follow**: Valid user IDs, no self-follows, no duplicates
- **Hashtag**: Name (1-100 chars), unique
- **Activity**: Valid activity type and user ID

## 📈 Performance Optimizations

1. **Efficient Indexing**: Composite and single-column indexes on frequently queried columns
2. **Pagination**: All list endpoints support limit/offset pagination
3. **Query Optimization**: Relations loaded only when needed
4. **Database Constraints**: Unique constraints at database level
5. **Cascade Deletes**: Automatic cleanup of related records

## 🔧 Development Guidelines

### Code Quality
- TypeScript strict mode enabled
- Consistent error handling
- Comprehensive validation
- Clean separation of concerns

### Best Practices
- ✅ Use migrations instead of synchronize
- ✅ Implement proper indexes
- ✅ Validate all input data
- ✅ Handle errors gracefully
- ✅ Use transactions where appropriate
- ✅ Follow RESTful conventions

## 🐛 Error Handling

The API returns consistent error responses:

```json
{
  "error": "Error message description"
}
```

**Status Codes:**
- `200` - Success
- `201` - Created
- `204` - No Content
- `400` - Bad Request (validation error)
- `404` - Not Found
- `409` - Conflict (duplicate)
- `500` - Internal Server Error

## 📝 Example Requests

### Create User
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "username": "johndoe",
    "email": "john@example.com",
    "fullName": "John Doe",
    "bio": "Software developer"
  }'
```

### Create Post with Hashtags
```bash
curl -X POST http://localhost:3000/api/posts \
  -H "Content-Type: application/json" \
  -d '{
    "content": "Just deployed my new app! #coding #webdev",
    "authorId": "user-uuid-here",
    "hashtags": ["coding", "webdev"]
  }'
```

### Follow User
```bash
curl -X POST http://localhost:3000/api/follows \
  -H "Content-Type: application/json" \
  -d '{
    "followerId": "user1-uuid",
    "followingId": "user2-uuid"
  }'
```

### Get Feed
```bash
curl "http://localhost:3000/api/feed?userId=user-uuid&limit=10&offset=0"
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests
5. Submit a pull request

## 📄 License

MIT License

## 👨‍💻 Author

Your Name - Backend Engineering Intern Candidate

## 🙏 Acknowledgments

Built as part of the Backend Engineering Intern assignment for demonstrating:
- RESTful API design
- Database modeling and optimization
- TypeScript and TypeORM proficiency
- Testing and documentation skills
