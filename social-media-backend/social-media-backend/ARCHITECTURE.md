# Architecture & Design Decisions

## Overview

This document explains the technical decisions, architecture patterns, and design choices made in building this social media backend.

## Technology Stack Rationale

### TypeScript
**Why:** 
- Strong typing prevents runtime errors
- Better IDE support and autocomplete
- Easier refactoring and maintenance
- Self-documenting code through interfaces

### Express.js
**Why:**
- Lightweight and flexible
- Large ecosystem of middleware
- Simple routing and request handling
- Industry standard for Node.js APIs

### TypeORM
**Why:**
- Type-safe database operations
- Migration support (required by assignment)
- Active Record and Data Mapper patterns
- PostgreSQL feature support
- Entity relationship management

### PostgreSQL
**Why:**
- ACID compliance for data integrity
- JSON/JSONB support for flexible metadata
- Powerful indexing capabilities
- UUID support for distributed systems
- Rich feature set (CTEs, window functions, etc.)

### Joi Validation
**Why:**
- Schema-based validation
- Clear error messages
- Chainable validation rules
- Widely adopted in Express apps

## Database Design

### Schema Design Principles

1. **Normalization**: All tables are in 3NF to eliminate redundancy
2. **UUIDs over Auto-increment**: Better for distributed systems and security
3. **Timestamps**: All entities track creation/update times
4. **Soft Deletes**: Not implemented to keep it simple, using CASCADE deletes
5. **JSONB for Metadata**: Flexible storage in Activity table

### Indexing Strategy

#### User Table
```sql
- PRIMARY KEY (id)
- UNIQUE INDEX (username)
- UNIQUE INDEX (email)
```
**Rationale**: Username and email are frequently used for lookups and must be unique.

#### Post Table
```sql
- PRIMARY KEY (id)
- INDEX (authorId, createdAt)  -- Composite
- INDEX (createdAt)
- FOREIGN KEY (authorId) -> users(id)
```
**Rationale**: 
- Composite index on (authorId, createdAt) optimizes feed queries
- Single createdAt index for global post sorting
- Foreign key ensures referential integrity

#### Like Table
```sql
- PRIMARY KEY (id)
- UNIQUE INDEX (userId, postId)  -- Prevents duplicate likes
- INDEX (postId, createdAt)
- INDEX (userId, createdAt)
- FOREIGN KEYs with CASCADE delete
```
**Rationale**:
- Unique constraint prevents double-liking
- Composite indexes optimize like counts and user like history

#### Follow Table
```sql
- PRIMARY KEY (id)
- UNIQUE INDEX (followerId, followingId)
- INDEX (followingId, createdAt)
- INDEX (followerId, createdAt)
- FOREIGN KEYs with CASCADE delete
```
**Rationale**:
- Unique constraint prevents duplicate follows
- followingId index for follower lists
- followerId index for following lists

#### Hashtag & Post_Hashtags
```sql
hashtags:
- PRIMARY KEY (id)
- UNIQUE INDEX (name)

post_hashtags (join table):
- COMPOSITE PRIMARY KEY (postId, hashtagId)
- FOREIGN KEYs with CASCADE delete
```
**Rationale**:
- Many-to-many relationship
- Hashtag names are unique and case-insensitive
- Cascade delete removes orphaned relationships

#### Activity Table
```sql
- PRIMARY KEY (id)
- INDEX (userId, createdAt)
- INDEX (activityType, createdAt)
- JSONB column for flexible metadata
```
**Rationale**:
- Supports filtering by user and activity type
- JSONB allows storing varied activity context
- Sorted by creation time for chronological history

### Relationship Design

```
User 1:N Post (one user, many posts)
User 1:N Like (one user, many likes)
User 1:N Follow (as follower)
User 1:N Follow (as following)
User 1:N Activity

Post 1:N Like
Post N:M Hashtag (many-to-many)

Like N:1 User
Like N:1 Post

Follow N:1 User (follower)
Follow N:1 User (following)

Hashtag N:M Post

Activity N:1 User
```

## API Design

### RESTful Principles

1. **Resource-Based URLs**: `/api/users`, `/api/posts`
2. **HTTP Methods**: GET, POST, PUT, DELETE
3. **Status Codes**: Proper HTTP status codes (200, 201, 204, 400, 404, 409, 500)
4. **Stateless**: Each request contains all necessary information
5. **Pagination**: All list endpoints support limit/offset

### Error Handling

Consistent error format:
```json
{
  "error": "Descriptive error message"
}
```

Status codes:
- `400`: Validation errors
- `404`: Resource not found
- `409`: Conflict (duplicates)
- `500`: Server errors

### Special Endpoints

#### Feed Endpoint Design
```
GET /api/feed?userId={id}&limit={n}&offset={m}
```

**Algorithm**:
1. Query follows table for user's following list
2. Query posts where authorId IN (following list)
3. Sort by createdAt DESC
4. Include author details, hashtags, like count
5. Apply pagination

**Performance**: Single query with JOIN, indexed on (authorId, createdAt)

#### Hashtag Search Design
```
GET /api/posts/hashtag/:tag
```

**Algorithm**:
1. Normalize hashtag (lowercase, remove #)
2. Find hashtag in hashtags table (case-insensitive)
3. JOIN through post_hashtags to get posts
4. Include author, other hashtags, like count
5. Sort and paginate

**Performance**: Uses hashtag name index, JOIN optimization

## Code Organization

### Layered Architecture

```
Routes (HTTP) -> Controllers (Business Logic) -> Repositories (Data Access) -> Database
```

1. **Routes**: Define endpoints and map to controllers
2. **Controllers**: Handle request/response, validation, business logic
3. **Repositories**: TypeORM handles this layer
4. **Entities**: Database models with relationships

### Validation Layer

Joi schemas validate:
- Data types
- String lengths
- Email formats
- UUID formats
- Required vs optional fields

Benefits:
- Early error detection
- Clear error messages
- Prevents invalid data from reaching database

### Activity Tracking

Automatic activity creation for:
- `POST_CREATED`: When a post is created
- `POST_LIKED`: When a post is liked
- `USER_FOLLOWED`: When a user follows another
- `USER_UNFOLLOWED`: When a user unfollows

**Metadata field** allows storing context-specific data:
```json
{
  "content": "First 100 chars of post",
  "likeId": "uuid",
  "followId": "uuid"
}
```

## Performance Considerations

### Query Optimization

1. **Eager vs Lazy Loading**: Relations loaded only when needed
2. **Select Specific Columns**: Avoid `SELECT *` where possible
3. **Use Indexes**: All frequent query patterns indexed
4. **Pagination**: Prevents loading large datasets
5. **Connection Pooling**: TypeORM handles this

### Indexing Trade-offs

**Benefits**:
- Faster reads on indexed columns
- Enforces uniqueness
- Speeds up JOINs

**Costs**:
- Slower writes (index updates)
- Storage overhead
- Maintenance overhead

**Decision**: Index based on read-heavy workload typical of social media

### Pagination Strategy

Using LIMIT/OFFSET:
- Simple to implement
- Standard REST pattern
- Works well for small-medium datasets

**Alternative considered**: Cursor-based pagination
- Better for large datasets
- More complex to implement
- Not required for MVP

## Security Considerations

### Implemented

1. **Input Validation**: All inputs validated with Joi
2. **SQL Injection Prevention**: TypeORM parameterized queries
3. **Foreign Key Constraints**: Referential integrity enforced
4. **Unique Constraints**: Prevent duplicate data
5. **Cascade Deletes**: Clean up orphaned records

### Not Implemented (Future)

1. **Authentication**: JWT/OAuth
2. **Authorization**: Role-based access control
3. **Rate Limiting**: Prevent abuse
4. **HTTPS**: SSL/TLS
5. **Password Hashing**: bcrypt/argon2
6. **CORS Configuration**: Currently allows all origins

## Testing Strategy

### Test Script Design

Interactive menu system:
- Tests all CRUD operations
- Tests special endpoints
- Provides immediate feedback
- Color-coded output

**Structure**:
1. Main menu for entity selection
2. Submenus for each entity
3. Automated full test suite option

**Benefits**:
- Easy to use
- Clear test results
- Tests real API endpoints
- No additional testing framework needed

## Migration Strategy

### Why Migrations Over Synchronize

Assignment requirement: "Do not use synchronize: true"

**Benefits of Migrations**:
1. Version control for schema changes
2. Reproducible database setup
3. Rollback capability
4. Production-safe deployments
5. Team collaboration

**Migration Workflow**:
```
1. Modify entity
2. Generate migration: npm run migration:generate
3. Review generated SQL
4. Run migration: npm run migration:run
5. Commit migration file
```

## Scalability Considerations

### Current Architecture

- Single server, single database
- Synchronous request handling
- In-memory sessions

### Future Scaling Paths

1. **Horizontal Scaling**:
   - Load balancer + multiple app servers
   - Session store (Redis)
   - Read replicas for database

2. **Caching**:
   - Redis for feed caching
   - CDN for static content

3. **Database Optimization**:
   - Partitioning large tables
   - Materialized views for feeds
   - Separate read/write databases

4. **Microservices**:
   - Split into: User Service, Post Service, Feed Service
   - Message queue for async operations
   - Event sourcing for activities

## Development Workflow

### Best Practices

1. **Type Safety**: Leverage TypeScript for compile-time checks
2. **Error Handling**: Try-catch in all async operations
3. **Consistent Naming**: camelCase for code, snake_case for DB
4. **Documentation**: JSDoc for complex functions
5. **Git Workflow**: Feature branches, descriptive commits

### Code Quality

- TypeScript strict mode enabled
- Consistent error responses
- Separation of concerns
- DRY principle
- Single Responsibility Principle

## Lessons & Trade-offs

### What Went Well

✅ Clear separation of concerns
✅ Comprehensive indexing
✅ Type-safe codebase
✅ Interactive test suite
✅ Migration-based schema management

### Trade-offs Made

⚖️ **LIMIT/OFFSET vs Cursor Pagination**: Chose simpler approach
⚖️ **No Authentication**: Focus on core functionality first
⚖️ **Synchronous Operations**: Async operations (like email) would need queues
⚖️ **Single Database**: Multi-database would require connection pooling logic

### What I'd Do Differently at Scale

1. Implement cursor-based pagination
2. Add caching layer (Redis)
3. Use message queues for activities
4. Implement database read replicas
5. Add comprehensive logging (Winston/Bunyan)
6. Implement circuit breakers for resilience
7. Add API versioning (/api/v1/)

## Conclusion

This architecture prioritizes:
- **Correctness**: Strong typing, validation, constraints
- **Performance**: Strategic indexing, pagination
- **Maintainability**: Clear structure, TypeScript, migrations
- **Testability**: Interactive test suite

The design is production-ready for an MVP while being architected for future scaling.
