#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

BASE_URL="http://localhost:3000/api"

# Global variables to store created IDs
USER1_ID=""
USER2_ID=""
USER3_ID=""
POST1_ID=""
POST2_ID=""
POST3_ID=""
LIKE_ID=""
FOLLOW_ID=""
HASHTAG_ID=""
ACTIVITY_ID=""

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Social Media Platform - API Test Suite              ║${NC}"
echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo ""

# Function to print test headers
print_test() {
    echo -e "\n${YELLOW}▶ $1${NC}"
}

# Function to print success
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print error
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Function to make API call and check response
api_call() {
    local method=$1
    local endpoint=$2
    local data=$3
    local expected_status=$4
    
    if [ -z "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X $method "$BASE_URL$endpoint" \
            -H "Content-Type: application/json")
    else
        response=$(curl -s -w "\n%{http_code}" -X $method "$BASE_URL$endpoint" \
            -H "Content-Type: application/json" \
            -d "$data")
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" == "$expected_status" ]; then
        print_success "Status: $http_code"
        echo "$body" | jq '.' 2>/dev/null || echo "$body"
        echo "$body"
        return 0
    else
        print_error "Expected status $expected_status, got $http_code"
        echo "$body" | jq '.' 2>/dev/null || echo "$body"
        return 1
    fi
}

# Test menu system
show_main_menu() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              MAIN MENU - Select Entity                   ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "1. Users"
    echo "2. Posts"
    echo "3. Likes"
    echo "4. Follows"
    echo "5. Hashtags"
    echo "6. Activities"
    echo "7. Special Endpoints (Feed, Hashtag Search, etc.)"
    echo "8. Run Full Test Suite"
    echo "0. Exit"
    echo ""
    read -p "Select an option: " choice
    
    case $choice in
        1) user_menu ;;
        2) post_menu ;;
        3) like_menu ;;
        4) follow_menu ;;
        5) hashtag_menu ;;
        6) activity_menu ;;
        7) special_endpoints_menu ;;
        8) run_full_test_suite ;;
        0) exit 0 ;;
        *) echo "Invalid option"; sleep 1; show_main_menu ;;
    esac
}

# Entity menus
user_menu() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                     USERS MENU                           ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "1. Get All Users"
    echo "2. Get User by ID"
    echo "3. Create User"
    echo "4. Update User"
    echo "5. Delete User"
    echo "6. Get User Followers"
    echo "7. Get User Activity"
    echo "0. Back to Main Menu"
    echo ""
    read -p "Select an option: " choice
    
    case $choice in
        1) test_get_all_users; read -p "Press enter to continue..."; user_menu ;;
        2) test_get_user_by_id; read -p "Press enter to continue..."; user_menu ;;
        3) test_create_user; read -p "Press enter to continue..."; user_menu ;;
        4) test_update_user; read -p "Press enter to continue..."; user_menu ;;
        5) test_delete_user; read -p "Press enter to continue..."; user_menu ;;
        6) test_get_user_followers; read -p "Press enter to continue..."; user_menu ;;
        7) test_get_user_activity; read -p "Press enter to continue..."; user_menu ;;
        0) show_main_menu ;;
        *) echo "Invalid option"; sleep 1; user_menu ;;
    esac
}

post_menu() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                     POSTS MENU                           ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "1. Get All Posts"
    echo "2. Get Post by ID"
    echo "3. Create Post"
    echo "4. Update Post"
    echo "5. Delete Post"
    echo "0. Back to Main Menu"
    echo ""
    read -p "Select an option: " choice
    
    case $choice in
        1) test_get_all_posts; read -p "Press enter to continue..."; post_menu ;;
        2) test_get_post_by_id; read -p "Press enter to continue..."; post_menu ;;
        3) test_create_post; read -p "Press enter to continue..."; post_menu ;;
        4) test_update_post; read -p "Press enter to continue..."; post_menu ;;
        5) test_delete_post; read -p "Press enter to continue..."; post_menu ;;
        0) show_main_menu ;;
        *) echo "Invalid option"; sleep 1; post_menu ;;
    esac
}

like_menu() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                     LIKES MENU                           ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "1. Get All Likes"
    echo "2. Get Like by ID"
    echo "3. Create Like"
    echo "4. Delete Like"
    echo "0. Back to Main Menu"
    echo ""
    read -p "Select an option: " choice
    
    case $choice in
        1) test_get_all_likes; read -p "Press enter to continue..."; like_menu ;;
        2) test_get_like_by_id; read -p "Press enter to continue..."; like_menu ;;
        3) test_create_like; read -p "Press enter to continue..."; like_menu ;;
        4) test_delete_like; read -p "Press enter to continue..."; like_menu ;;
        0) show_main_menu ;;
        *) echo "Invalid option"; sleep 1; like_menu ;;
    esac
}

follow_menu() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                    FOLLOWS MENU                          ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "1. Get All Follows"
    echo "2. Get Follow by ID"
    echo "3. Create Follow"
    echo "4. Delete Follow (Unfollow)"
    echo "0. Back to Main Menu"
    echo ""
    read -p "Select an option: " choice
    
    case $choice in
        1) test_get_all_follows; read -p "Press enter to continue..."; follow_menu ;;
        2) test_get_follow_by_id; read -p "Press enter to continue..."; follow_menu ;;
        3) test_create_follow; read -p "Press enter to continue..."; follow_menu ;;
        4) test_delete_follow; read -p "Press enter to continue..."; follow_menu ;;
        0) show_main_menu ;;
        *) echo "Invalid option"; sleep 1; follow_menu ;;
    esac
}

hashtag_menu() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                   HASHTAGS MENU                          ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "1. Get All Hashtags"
    echo "2. Get Hashtag by ID"
    echo "3. Create Hashtag"
    echo "4. Update Hashtag"
    echo "5. Delete Hashtag"
    echo "0. Back to Main Menu"
    echo ""
    read -p "Select an option: " choice
    
    case $choice in
        1) test_get_all_hashtags; read -p "Press enter to continue..."; hashtag_menu ;;
        2) test_get_hashtag_by_id; read -p "Press enter to continue..."; hashtag_menu ;;
        3) test_create_hashtag; read -p "Press enter to continue..."; hashtag_menu ;;
        4) test_update_hashtag; read -p "Press enter to continue..."; hashtag_menu ;;
        5) test_delete_hashtag; read -p "Press enter to continue..."; hashtag_menu ;;
        0) show_main_menu ;;
        *) echo "Invalid option"; sleep 1; hashtag_menu ;;
    esac
}

activity_menu() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                  ACTIVITIES MENU                         ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "1. Get All Activities"
    echo "2. Get Activity by ID"
    echo "3. Create Activity"
    echo "4. Delete Activity"
    echo "0. Back to Main Menu"
    echo ""
    read -p "Select an option: " choice
    
    case $choice in
        1) test_get_all_activities; read -p "Press enter to continue..."; activity_menu ;;
        2) test_get_activity_by_id; read -p "Press enter to continue..."; activity_menu ;;
        3) test_create_activity; read -p "Press enter to continue..."; activity_menu ;;
        4) test_delete_activity; read -p "Press enter to continue..."; activity_menu ;;
        0) show_main_menu ;;
        *) echo "Invalid option"; sleep 1; activity_menu ;;
    esac
}

special_endpoints_menu() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              SPECIAL ENDPOINTS MENU                      ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "1. Get Feed (Personalized content stream)"
    echo "2. Get Posts by Hashtag"
    echo "3. Get User Followers"
    echo "4. Get User Activity History"
    echo "0. Back to Main Menu"
    echo ""
    read -p "Select an option: " choice
    
    case $choice in
        1) test_get_feed; read -p "Press enter to continue..."; special_endpoints_menu ;;
        2) test_get_posts_by_hashtag; read -p "Press enter to continue..."; special_endpoints_menu ;;
        3) test_get_user_followers; read -p "Press enter to continue..."; special_endpoints_menu ;;
        4) test_get_user_activity; read -p "Press enter to continue..."; special_endpoints_menu ;;
        0) show_main_menu ;;
        *) echo "Invalid option"; sleep 1; special_endpoints_menu ;;
    esac
}

# USER TESTS
test_create_user() {
    print_test "Creating User 1"
    response=$(api_call POST "/users" '{
        "username": "johndoe",
        "email": "john@example.com",
        "fullName": "John Doe",
        "bio": "Software developer and tech enthusiast"
    }' 201)
    USER1_ID=$(echo "$response" | jq -r '.id' 2>/dev/null)
    
    print_test "Creating User 2"
    response=$(api_call POST "/users" '{
        "username": "janedoe",
        "email": "jane@example.com",
        "fullName": "Jane Doe",
        "bio": "Product manager"
    }' 201)
    USER2_ID=$(echo "$response" | jq -r '.id' 2>/dev/null)
    
    print_test "Creating User 3"
    response=$(api_call POST "/users" '{
        "username": "bobsmith",
        "email": "bob@example.com",
        "fullName": "Bob Smith",
        "bio": "Designer"
    }' 201)
    USER3_ID=$(echo "$response" | jq -r '.id' 2>/dev/null)
}

test_get_all_users() {
    print_test "Getting all users"
    api_call GET "/users?limit=10&offset=0" "" 200
}

test_get_user_by_id() {
    if [ -z "$USER1_ID" ]; then
        read -p "Enter User ID: " USER1_ID
    fi
    print_test "Getting user by ID: $USER1_ID"
    api_call GET "/users/$USER1_ID" "" 200
}

test_update_user() {
    if [ -z "$USER1_ID" ]; then
        read -p "Enter User ID: " USER1_ID
    fi
    print_test "Updating user: $USER1_ID"
    api_call PUT "/users/$USER1_ID" '{
        "bio": "Updated bio - Full stack developer"
    }' 200
}

test_delete_user() {
    read -p "Enter User ID to delete: " delete_id
    print_test "Deleting user: $delete_id"
    api_call DELETE "/users/$delete_id" "" 204
}

test_get_user_followers() {
    if [ -z "$USER2_ID" ]; then
        read -p "Enter User ID: " USER2_ID
    fi
    print_test "Getting followers for user: $USER2_ID"
    api_call GET "/users/$USER2_ID/followers?limit=10&offset=0" "" 200
}

test_get_user_activity() {
    if [ -z "$USER1_ID" ]; then
        read -p "Enter User ID: " USER1_ID
    fi
    print_test "Getting activity for user: $USER1_ID"
    api_call GET "/users/$USER1_ID/activity?limit=10&offset=0" "" 200
}

# POST TESTS
test_create_post() {
    if [ -z "$USER1_ID" ]; then
        echo "Please create users first"
        return
    fi
    
    print_test "Creating Post 1 with hashtags"
    response=$(api_call POST "/posts" "{
        \"content\": \"Just deployed my new app! #coding #webdev\",
        \"authorId\": \"$USER1_ID\",
        \"hashtags\": [\"coding\", \"webdev\"]
    }" 201)
    POST1_ID=$(echo "$response" | jq -r '.id' 2>/dev/null)
    
    print_test "Creating Post 2"
    response=$(api_call POST "/posts" "{
        \"content\": \"Beautiful sunset today #nature #photography\",
        \"authorId\": \"$USER2_ID\",
        \"hashtags\": [\"nature\", \"photography\"]
    }" 201)
    POST2_ID=$(echo "$response" | jq -r '.id' 2>/dev/null)
    
    print_test "Creating Post 3"
    response=$(api_call POST "/posts" "{
        \"content\": \"Working on a new design project #design #ui\",
        \"authorId\": \"$USER3_ID\",
        \"hashtags\": [\"design\", \"ui\"]
    }" 201)
    POST3_ID=$(echo "$response" | jq -r '.id' 2>/dev/null)
}

test_get_all_posts() {
    print_test "Getting all posts"
    api_call GET "/posts?limit=10&offset=0" "" 200
}

test_get_post_by_id() {
    if [ -z "$POST1_ID" ]; then
        read -p "Enter Post ID: " POST1_ID
    fi
    print_test "Getting post by ID: $POST1_ID"
    api_call GET "/posts/$POST1_ID" "" 200
}

test_update_post() {
    if [ -z "$POST1_ID" ]; then
        read -p "Enter Post ID: " POST1_ID
    fi
    print_test "Updating post: $POST1_ID"
    api_call PUT "/posts/$POST1_ID" '{
        "content": "Updated: Just deployed my new app! It works great! #coding #webdev"
    }' 200
}

test_delete_post() {
    read -p "Enter Post ID to delete: " delete_id
    print_test "Deleting post: $delete_id"
    api_call DELETE "/posts/$delete_id" "" 204
}

# LIKE TESTS
test_create_like() {
    if [ -z "$USER1_ID" ] || [ -z "$POST2_ID" ]; then
        echo "Please create users and posts first"
        return
    fi
    
    print_test "User 1 likes Post 2"
    response=$(api_call POST "/likes" "{
        \"userId\": \"$USER1_ID\",
        \"postId\": \"$POST2_ID\"
    }" 201)
    LIKE_ID=$(echo "$response" | jq -r '.id' 2>/dev/null)
}

test_get_all_likes() {
    print_test "Getting all likes"
    api_call GET "/likes?limit=10&offset=0" "" 200
}

test_get_like_by_id() {
    if [ -z "$LIKE_ID" ]; then
        read -p "Enter Like ID: " LIKE_ID
    fi
    print_test "Getting like by ID: $LIKE_ID"
    api_call GET "/likes/$LIKE_ID" "" 200
}

test_delete_like() {
    if [ -z "$LIKE_ID" ]; then
        read -p "Enter Like ID to delete: " LIKE_ID
    fi
    print_test "Deleting like: $LIKE_ID"
    api_call DELETE "/likes/$LIKE_ID" "" 204
}

# FOLLOW TESTS
test_create_follow() {
    if [ -z "$USER1_ID" ] || [ -z "$USER2_ID" ]; then
        echo "Please create users first"
        return
    fi
    
    print_test "User 1 follows User 2"
    response=$(api_call POST "/follows" "{
        \"followerId\": \"$USER1_ID\",
        \"followingId\": \"$USER2_ID\"
    }" 201)
    FOLLOW_ID=$(echo "$response" | jq -r '.id' 2>/dev/null)
    
    print_test "User 1 follows User 3"
    api_call POST "/follows" "{
        \"followerId\": \"$USER1_ID\",
        \"followingId\": \"$USER3_ID\"
    }" 201
}

test_get_all_follows() {
    print_test "Getting all follows"
    api_call GET "/follows?limit=10&offset=0" "" 200
}

test_get_follow_by_id() {
    if [ -z "$FOLLOW_ID" ]; then
        read -p "Enter Follow ID: " FOLLOW_ID
    fi
    print_test "Getting follow by ID: $FOLLOW_ID"
    api_call GET "/follows/$FOLLOW_ID" "" 200
}

test_delete_follow() {
    if [ -z "$FOLLOW_ID" ]; then
        read -p "Enter Follow ID to delete: " FOLLOW_ID
    fi
    print_test "Deleting follow (unfollow): $FOLLOW_ID"
    api_call DELETE "/follows/$FOLLOW_ID" "" 204
}

# HASHTAG TESTS
test_create_hashtag() {
    print_test "Creating hashtag"
    response=$(api_call POST "/hashtags" '{
        "name": "technology"
    }' 201)
    HASHTAG_ID=$(echo "$response" | jq -r '.id' 2>/dev/null)
}

test_get_all_hashtags() {
    print_test "Getting all hashtags"
    api_call GET "/hashtags?limit=10&offset=0" "" 200
}

test_get_hashtag_by_id() {
    if [ -z "$HASHTAG_ID" ]; then
        read -p "Enter Hashtag ID: " HASHTAG_ID
    fi
    print_test "Getting hashtag by ID: $HASHTAG_ID"
    api_call GET "/hashtags/$HASHTAG_ID" "" 200
}

test_update_hashtag() {
    if [ -z "$HASHTAG_ID" ]; then
        read -p "Enter Hashtag ID: " HASHTAG_ID
    fi
    print_test "Updating hashtag: $HASHTAG_ID"
    api_call PUT "/hashtags/$HASHTAG_ID" '{
        "name": "tech"
    }' 200
}

test_delete_hashtag() {
    read -p "Enter Hashtag ID to delete: " delete_id
    print_test "Deleting hashtag: $delete_id"
    api_call DELETE "/hashtags/$delete_id" "" 204
}

# ACTIVITY TESTS
test_create_activity() {
    if [ -z "$USER1_ID" ]; then
        echo "Please create users first"
        return
    fi
    
    print_test "Creating activity"
    response=$(api_call POST "/activities" "{
        \"userId\": \"$USER1_ID\",
        \"activityType\": \"POST_CREATED\",
        \"targetId\": \"$POST1_ID\",
        \"metadata\": {\"test\": \"data\"}
    }" 201)
    ACTIVITY_ID=$(echo "$response" | jq -r '.id' 2>/dev/null)
}

test_get_all_activities() {
    print_test "Getting all activities"
    api_call GET "/activities?limit=10&offset=0" "" 200
}

test_get_activity_by_id() {
    if [ -z "$ACTIVITY_ID" ]; then
        read -p "Enter Activity ID: " ACTIVITY_ID
    fi
    print_test "Getting activity by ID: $ACTIVITY_ID"
    api_call GET "/activities/$ACTIVITY_ID" "" 200
}

test_delete_activity() {
    read -p "Enter Activity ID to delete: " delete_id
    print_test "Deleting activity: $delete_id"
    api_call DELETE "/activities/$delete_id" "" 204
}

# SPECIAL ENDPOINT TESTS
test_get_feed() {
    if [ -z "$USER1_ID" ]; then
        echo "Please create users and follows first"
        return
    fi
    
    print_test "Getting feed for User 1"
    api_call GET "/feed?userId=$USER1_ID&limit=10&offset=0" "" 200
}

test_get_posts_by_hashtag() {
    print_test "Getting posts by hashtag: coding"
    api_call GET "/posts/hashtag/coding?limit=10&offset=0" "" 200
}

# FULL TEST SUITE
run_full_test_suite() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║           Running Full Test Suite                       ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    
    echo -e "\n${YELLOW}═══════════════ USERS ═══════════════${NC}"
    test_create_user
    sleep 1
    test_get_all_users
    sleep 1
    
    echo -e "\n${YELLOW}═══════════════ POSTS ═══════════════${NC}"
    test_create_post
    sleep 1
    test_get_all_posts
    sleep 1
    
    echo -e "\n${YELLOW}═══════════════ FOLLOWS ═══════════════${NC}"
    test_create_follow
    sleep 1
    test_get_all_follows
    sleep 1
    
    echo -e "\n${YELLOW}═══════════════ LIKES ═══════════════${NC}"
    test_create_like
    sleep 1
    test_get_all_likes
    sleep 1
    
    echo -e "\n${YELLOW}═══════════════ HASHTAGS ═══════════════${NC}"
    test_get_all_hashtags
    sleep 1
    
    echo -e "\n${YELLOW}═══════════════ ACTIVITIES ═══════════════${NC}"
    test_get_all_activities
    sleep 1
    
    echo -e "\n${YELLOW}═══════════════ SPECIAL ENDPOINTS ═══════════════${NC}"
    test_get_feed
    sleep 1
    test_get_posts_by_hashtag
    sleep 1
    test_get_user_followers
    sleep 1
    test_get_user_activity
    
    echo -e "\n${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}           Full Test Suite Completed!                      ${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    
    read -p "Press enter to return to main menu..."
    show_main_menu
}

# Check if server is running
echo -e "${YELLOW}Checking if server is running...${NC}"
if curl -s "$BASE_URL/../health" > /dev/null 2>&1; then
    print_success "Server is running"
else
    print_error "Server is not running. Please start the server first with: npm run dev"
    exit 1
fi

# Start the interactive menu
show_main_menu
