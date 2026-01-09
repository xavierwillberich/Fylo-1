#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Firebase Data Upload Script
将所有示例数据上传到 Firebase Firestore
"""

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import json
from datetime import datetime
import sys
import io

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# ==================== 配置 ====================
# Firebase 项目配置
import os
PROJECT_ID = "lezgo-4d9fb"
CREDENTIALS_PATH = r"C:\Users\lenovo\Downloads\firebase-service-account.json"

# 如果存在服务账户密钥文件，设置环境变量
if os.path.exists(CREDENTIALS_PATH):
    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = CREDENTIALS_PATH

# ==================== 数据定义 ====================

EVENTS_DATA = [
    {
        "id": 1,
        "date": "28",
        "month": "Oct",
        "year": "2025",
        "dayOfWeek": "Tuesday",
        "weather": "clear",
        "temperature": 68,
        "category": "Trips",
        "title": "Weekend Hiking Adventure - Mount Rainier Trail",
        "description": "Join us for a scenic 8-mile hike through alpine meadows and old-growth forests. Perfect for nature lovers and photography enthusiasts. All skill levels welcome!",
        "time": "7:00 AM",
        "location": "Mount Rainier National Park, WA",
        "participants": 12,
        "budget": 45,
        "recruiting": True,
        "proficiency": "intermediate",
        "genderRestriction": "noRestrictions",
        "passwordRequired": False,
        "password": None,
        "images": [
            "https://images.unsplash.com/photo-1623622863859-2931a6c3bc80?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080",
            "https://images.unsplash.com/photo-1723470317938-6ec6fb0d4075?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080",
        ],
        "attendeeAvatars": [
            "https://images.unsplash.com/photo-1581065178047-8ee15951ede6?w=100",
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
        ],
        "isUserParticipating": False,
    },
    {
        "id": 2,
        "date": "30",
        "month": "Oct",
        "year": "2025",
        "dayOfWeek": "Thursday",
        "weather": "cloudy",
        "temperature": 62,
        "category": "Board Games",
        "title": "Board Game Night - Strategy Games & Chill",
        "description": "Casual board game night featuring Catan, Ticket to Ride, and more. Snacks and drinks provided. Great for making new friends!",
        "time": "7:00 PM",
        "location": "Cafe Meeple, Downtown Seattle",
        "participants": 8,
        "budget": 25,
        "recruiting": True,
        "proficiency": "beginner",
        "genderRestriction": "noRestrictions",
        "passwordRequired": False,
        "password": None,
        "images": [
            "https://images.unsplash.com/photo-1645652267295-769f5dc8b10d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080",
        ],
        "attendeeAvatars": [
            "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100",
        ],
        "isUserParticipating": False,
    },
    {
        "id": 3,
        "date": "2",
        "month": "Nov",
        "year": "2025",
        "dayOfWeek": "Sunday",
        "weather": "partlyCloudy",
        "temperature": 65,
        "category": "Foods",
        "title": "Japanese Cuisine Cooking Class",
        "description": "Learn to make authentic sushi, ramen, and tempura from a professional chef. All ingredients and equipment provided.",
        "time": "2:00 PM",
        "location": "Culinary Arts Studio, Capitol Hill",
        "participants": 10,
        "budget": 75,
        "recruiting": True,
        "proficiency": "beginner",
        "genderRestriction": "noRestrictions",
        "passwordRequired": False,
        "password": None,
        "images": [
            "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080",
        ],
        "attendeeAvatars": [
            "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100",
            "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100",
            "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
        ],
        "isUserParticipating": False,
    },
    {
        "id": 4,
        "date": "5",
        "month": "Nov",
        "year": "2025",
        "dayOfWeek": "Wednesday",
        "weather": "clear",
        "temperature": 70,
        "category": "Sports",
        "title": "Beach Volleyball Tournament",
        "description": "Friendly beach volleyball tournament at Alki Beach. Teams of 4, all skill levels welcome. Prizes for winners!",
        "time": "4:00 PM",
        "location": "Alki Beach, West Seattle",
        "participants": 16,
        "budget": 20,
        "recruiting": True,
        "proficiency": "intermediate",
        "genderRestriction": "noRestrictions",
        "passwordRequired": False,
        "password": None,
        "images": [
            "https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080",
        ],
        "attendeeAvatars": [
            "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
            "https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=100",
        ],
        "isUserParticipating": False,
    },
    {
        "id": 5,
        "date": "8",
        "month": "Nov",
        "year": "2025",
        "dayOfWeek": "Friday",
        "weather": "partlyCloudy",
        "temperature": 58,
        "category": "Coffee Chat",
        "title": "Friday Morning Coffee & Networking",
        "description": "Casual coffee meetup for professionals and entrepreneurs. Great opportunity to network and share ideas over coffee.",
        "time": "9:00 AM",
        "location": "Storyville Coffee, Pike Place",
        "participants": 6,
        "budget": 15,
        "recruiting": True,
        "proficiency": "beginner",
        "genderRestriction": "noRestrictions",
        "passwordRequired": False,
        "password": None,
        "images": [
            "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080",
        ],
        "attendeeAvatars": [
            "https://images.unsplash.com/photo-1581065178047-8ee15951ede6?w=100",
            "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
        ],
        "isUserParticipating": False,
    },
    {
        "id": 6,
        "date": "10",
        "month": "Nov",
        "year": "2025",
        "dayOfWeek": "Monday",
        "weather": "snowy",
        "temperature": 38,
        "category": "KTV",
        "title": "Karaoke Night - Pop & Rock Classics",
        "description": "Sing your heart out! Private karaoke room with great sound system. All skill levels welcome, just come and have fun!",
        "time": "8:00 PM",
        "location": "Voicebox Karaoke, Belltown",
        "participants": 18,
        "budget": 30,
        "recruiting": False,
        "proficiency": "beginner",
        "genderRestriction": "noRestrictions",
        "passwordRequired": True,
        "password": "SING123",
        "images": [
            "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080",
        ],
        "attendeeAvatars": [
            "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
            "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
        ],
        "isUserParticipating": False,
    },
    {
        "id": 7,
        "date": "4",
        "month": "January",
        "year": "2026",
        "dayOfWeek": "Saturday",
        "weather": "clear",
        "temperature": 52,
        "category": "Sports",
        "title": "Morning Basketball Pickup Game",
        "description": "Casual basketball game at the local court. All skill levels welcome. Bring your A-game!",
        "time": "9:00 AM",
        "location": "Green Lake Community Center",
        "participants": 10,
        "budget": 0,
        "recruiting": True,
        "proficiency": "intermediate",
        "genderRestriction": "noRestrictions",
        "passwordRequired": False,
        "password": None,
        "images": [
            "https://images.unsplash.com/photo-1546519638-68e109498ffc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080",
        ],
        "attendeeAvatars": [
            "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100",
        ],
        "isUserParticipating": True,
    },
    {
        "id": 8,
        "date": "10",
        "month": "January",
        "year": "2026",
        "dayOfWeek": "Friday",
        "weather": "partlyCloudy",
        "temperature": 48,
        "category": "Foods",
        "title": "Italian Pasta Making Workshop",
        "description": "Learn to make fresh pasta from scratch! We'll cover fettuccine, ravioli, and more. Wine included!",
        "time": "6:00 PM",
        "location": "Belltown Culinary Studio",
        "participants": 8,
        "budget": 65,
        "recruiting": True,
        "proficiency": "beginner",
        "genderRestriction": "noRestrictions",
        "passwordRequired": False,
        "password": None,
        "images": [
            "https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080",
        ],
        "attendeeAvatars": [
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
            "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
        ],
        "isUserParticipating": True,
    },
    {
        "id": 9,
        "date": "14",
        "month": "January",
        "year": "2026",
        "dayOfWeek": "Tuesday",
        "weather": "cloudy",
        "temperature": 45,
        "category": "Board Games",
        "title": "Dungeons & Dragons Campaign Night",
        "description": "Join our ongoing D&D campaign! New players welcome. We provide dice and character sheets.",
        "time": "7:30 PM",
        "location": "Mox Boarding House, Ballard",
        "participants": 6,
        "budget": 20,
        "recruiting": True,
        "proficiency": "beginner",
        "genderRestriction": "noRestrictions",
        "passwordRequired": False,
        "password": None,
        "images": [
            "https://images.unsplash.com/photo-1645652267295-769f5dc8b10d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080",
        ],
        "attendeeAvatars": [
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
            "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
        ],
        "isUserParticipating": True,
    },
    {
        "id": 10,
        "date": "20",
        "month": "January",
        "year": "2026",
        "dayOfWeek": "Monday",
        "weather": "rainy",
        "temperature": 42,
        "category": "Coffee Chat",
        "title": "Tech Professionals Meetup",
        "description": "Monthly meetup for tech professionals. Discuss latest trends, network, and share experiences over coffee.",
        "time": "8:00 AM",
        "location": "Starbucks Reserve, Capitol Hill",
        "participants": 12,
        "budget": 10,
        "recruiting": True,
        "proficiency": "intermediate",
        "genderRestriction": "noRestrictions",
        "passwordRequired": False,
        "password": None,
        "images": [
            "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080",
        ],
        "attendeeAvatars": [
            "https://images.unsplash.com/photo-1581065178047-8ee15951ede6?w=100",
            "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
        ],
        "isUserParticipating": False,
    },
]

POSTS_DATA = [
    {
        "id": 1,
        "user": {
            "name": "Sarah Chen",
            "username": "@sarah_explorer",
            "avatar": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150",
        },
        "content": {
            "text": "Just finished the most amazing hike at Mount Rainier! The views were absolutely breathtaking 🏔️✨ Can't wait for the next adventure!",
            "images": [
                "https://images.unsplash.com/photo-1623622863859-2931a6c3bc80?w=800",
            ],
        },
        "timestamp": "2 hours ago",
        "likes": 124,
        "comments": 18,
        "shares": 5,
        "isLiked": False,
        "isFollowing": False,
        "relatedActivity": {
            "activityId": "TRI-000001",
            "title": "Weekend Hiking Adventure",
            "image": "https://images.unsplash.com/photo-1623622863859-2931a6c3bc80?w=100",
        },
    },
    {
        "id": 2,
        "user": {
            "name": "Mike Johnson",
            "username": "@mike_games",
            "avatar": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150",
        },
        "content": {
            "text": "Board game night was epic! We played Catan for 3 hours straight 🎲 Already planning the next meetup!",
            "images": [],
        },
        "timestamp": "5 hours ago",
        "likes": 89,
        "comments": 12,
        "shares": 3,
        "isLiked": True,
        "isFollowing": True,
        "relatedActivity": {
            "activityId": "BOA-000002",
            "title": "Board Game Night",
            "image": "https://images.unsplash.com/photo-1645652267295-769f5dc8b10d?w=100",
        },
    },
    {
        "id": 3,
        "user": {
            "name": "Emma Wilson",
            "username": "@emma_foodie",
            "avatar": "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150",
        },
        "content": {
            "text": "The sushi I made today turned out perfect! 🍣 Thanks to everyone who joined the cooking class. Such a fun experience!",
            "images": [
                "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800",
            ],
        },
        "timestamp": "1 day ago",
        "likes": 203,
        "comments": 34,
        "shares": 12,
        "isLiked": False,
        "isFollowing": False,
        "relatedActivity": None,
    },
    {
        "id": 4,
        "user": {
            "name": "Alex Turner",
            "username": "@alex_sports",
            "avatar": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150",
        },
        "content": {
            "text": "Amazing volleyball game today! 🏐 The weather was perfect and we had such a great turnout. Can't wait for next week!",
            "images": [
                "https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=800",
            ],
        },
        "timestamp": "3 hours ago",
        "likes": 156,
        "comments": 23,
        "shares": 8,
        "isLiked": True,
        "isFollowing": False,
        "relatedActivity": {
            "activityId": "SPO-000004",
            "title": "Beach Volleyball Tournament",
            "image": "https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=100",
        },
    },
    {
        "id": 5,
        "user": {
            "name": "Jessica Lee",
            "username": "@jess_coffee",
            "avatar": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150",
        },
        "content": {
            "text": "Great networking session this morning! ☕ Met so many interesting people and got some amazing business ideas. Seattle coffee scene is the best!",
            "images": [],
        },
        "timestamp": "6 hours ago",
        "likes": 92,
        "comments": 15,
        "shares": 4,
        "isLiked": False,
        "isFollowing": True,
        "relatedActivity": {
            "activityId": "COF-000005",
            "title": "Friday Morning Coffee & Networking",
            "image": "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=100",
        },
    },
]

NOTIFICATIONS_DATA = [
    {
        "id": 1,
        "type": "invitation",
        "title": "New Activity Invitation",
        "message": "Sarah invited you to Beach Volleyball",
        "timestamp": "2024-01-09T17:15:00Z",
        "avatar": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
        "activityId": "ACT-000004",
        "isRead": False,
    },
    {
        "id": 2,
        "type": "activityUpdate",
        "title": "Activity Update",
        "message": "Hiking in George Bass starts in 2 hours",
        "timestamp": "2024-01-09T16:45:00Z",
        "avatar": "https://images.unsplash.com/photo-1551632811-561732d1e306?w=100",
        "activityId": "ACT-000001",
        "isRead": False,
    },
    {
        "id": 3,
        "type": "newFollower",
        "title": "New Follower",
        "message": "Mike Chen started following you",
        "timestamp": "2024-01-09T14:30:00Z",
        "avatar": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
        "activityId": None,
        "isRead": True,
    },
    {
        "id": 4,
        "type": "like",
        "title": "Activity Liked",
        "message": "Emma liked your Morning Run Club activity",
        "timestamp": "2024-01-09T12:20:00Z",
        "avatar": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
        "activityId": "ACT-000005",
        "isRead": True,
    },
    {
        "id": 5,
        "type": "comment",
        "title": "New Comment",
        "message": "James commented on your post",
        "timestamp": "2024-01-09T10:15:00Z",
        "avatar": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
        "activityId": None,
        "isRead": True,
    },
    {
        "id": 6,
        "type": "reminder",
        "title": "Activity Reminder",
        "message": "Board Game Night starts tomorrow at 7:00 PM",
        "timestamp": "2024-01-08T18:00:00Z",
        "avatar": None,
        "activityId": "ACT-000002",
        "isRead": True,
    },
]

CONVERSATIONS_DATA = [
    {
        "id": "conv-001",
        "type": "group",
        "name": "Hiking in George Bass",
        "avatar": "https://images.unsplash.com/photo-1551632811-561732d1e306?w=100&h=100&fit=crop",
        "participantIds": ["user-001", "user-002", "user-003", "user-004"],
        "participantNames": {
            "user-001": "Sarah Johnson",
            "user-002": "Mike Chen",
            "user-003": "Emma Wilson",
            "user-004": "James Brown",
        },
        "participantAvatars": {
            "user-001": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
            "user-002": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
            "user-003": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
            "user-004": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
        },
        "lastMessageContent": "Perfect! Just paid my share 💸",
        "lastMessageSenderId": "user-001",
        "lastMessageTime": "2024-01-09T17:25:00Z",
        "unreadCount": 1,
        "createdAt": "2024-01-05T10:00:00Z",
        "updatedAt": "2024-01-09T17:25:00Z",
        "activityId": "ACT-000001",
        "isActive": True,
        "mutedBy": {},
    },
    {
        "id": "conv-002",
        "type": "group",
        "name": "Beach Volleyball Squad",
        "avatar": "https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=100&h=100&fit=crop",
        "participantIds": ["user-001", "user-002", "user-005", "user-006"],
        "participantNames": {
            "user-001": "Sarah Johnson",
            "user-002": "Mike Chen",
            "user-005": "Lisa Park",
            "user-006": "David Lee",
        },
        "participantAvatars": {
            "user-001": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
            "user-002": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
            "user-005": "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
            "user-006": "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100",
        },
        "lastMessageContent": "Same time next week?",
        "lastMessageSenderId": "user-002",
        "lastMessageTime": "2024-01-09T16:00:00Z",
        "unreadCount": 0,
        "createdAt": "2024-01-03T14:30:00Z",
        "updatedAt": "2024-01-09T16:00:00Z",
        "activityId": "ACT-000004",
        "isActive": True,
        "mutedBy": {},
    },
    {
        "id": "conv-003",
        "type": "group",
        "name": "Weekend Warriors",
        "avatar": "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=100&h=100&fit=crop",
        "participantIds": ["user-001", "user-003", "user-004", "user-007"],
        "participantNames": {
            "user-001": "Sarah Johnson",
            "user-003": "Emma Wilson",
            "user-004": "James Brown",
            "user-007": "Rachel Green",
        },
        "participantAvatars": {
            "user-001": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
            "user-003": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
            "user-004": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
            "user-007": "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100",
        },
        "lastMessageContent": "Who's in for the camping trip?",
        "lastMessageSenderId": "user-003",
        "lastMessageTime": "2024-01-09T14:45:00Z",
        "unreadCount": 1,
        "createdAt": "2024-01-02T09:15:00Z",
        "updatedAt": "2024-01-09T14:45:00Z",
        "activityId": None,
        "isActive": True,
        "mutedBy": {},
    },
    {
        "id": "conv-004",
        "type": "direct",
        "name": "Sarah Johnson",
        "avatar": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
        "participantIds": ["user-current", "user-001"],
        "participantNames": {
            "user-current": "You",
            "user-001": "Sarah Johnson",
        },
        "participantAvatars": {
            "user-current": "https://images.unsplash.com/photo-1581065178047-8ee15951ede6?w=100",
            "user-001": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
        },
        "lastMessageContent": "See you at the event tomorrow!",
        "lastMessageSenderId": "user-001",
        "lastMessageTime": "2024-01-09T17:00:00Z",
        "unreadCount": 1,
        "createdAt": "2024-01-01T12:00:00Z",
        "updatedAt": "2024-01-09T17:00:00Z",
        "activityId": None,
        "isActive": True,
        "mutedBy": {},
    },
    {
        "id": "conv-005",
        "type": "direct",
        "name": "Mike Chen",
        "avatar": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
        "participantIds": ["user-current", "user-002"],
        "participantNames": {
            "user-current": "You",
            "user-002": "Mike Chen",
        },
        "participantAvatars": {
            "user-current": "https://images.unsplash.com/photo-1581065178047-8ee15951ede6?w=100",
            "user-002": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
        },
        "lastMessageContent": "Thanks for the recommendation 👍",
        "lastMessageSenderId": "user-002",
        "lastMessageTime": "2024-01-09T15:30:00Z",
        "unreadCount": 0,
        "createdAt": "2024-01-04T08:45:00Z",
        "updatedAt": "2024-01-09T15:30:00Z",
        "activityId": None,
        "isActive": True,
        "mutedBy": {},
    },
    {
        "id": "conv-006",
        "type": "direct",
        "name": "Emma Wilson",
        "avatar": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
        "participantIds": ["user-current", "user-003"],
        "participantNames": {
            "user-current": "You",
            "user-003": "Emma Wilson",
        },
        "participantAvatars": {
            "user-current": "https://images.unsplash.com/photo-1581065178047-8ee15951ede6?w=100",
            "user-003": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
        },
        "lastMessageContent": "That hiking trail was amazing!",
        "lastMessageSenderId": "user-003",
        "lastMessageTime": "2024-01-08T19:20:00Z",
        "unreadCount": 0,
        "createdAt": "2023-12-28T16:30:00Z",
        "updatedAt": "2024-01-08T19:20:00Z",
        "activityId": None,
        "isActive": True,
        "mutedBy": {},
    },
]

MESSAGES_DATA = {
    "conv-001": [
        {
            "id": "msg-001-001",
            "conversationId": "conv-001",
            "senderId": "user-002",
            "senderName": "Mike Chen",
            "senderAvatar": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
            "type": "text",
            "content": "Hey everyone! Looking forward to the hike this weekend!",
            "mediaUrls": None,
            "activityId": None,
            "timestamp": "2024-01-09T10:30:00Z",
            "status": "read",
            "readBy": ["user-001", "user-003", "user-004"],
            "replyToMessageId": None,
        },
        {
            "id": "msg-001-002",
            "conversationId": "conv-001",
            "senderId": "user-003",
            "senderName": "Emma Wilson",
            "senderAvatar": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
            "type": "text",
            "content": "Count me in! What should I bring?",
            "mediaUrls": None,
            "activityId": None,
            "timestamp": "2024-01-09T11:15:00Z",
            "status": "read",
            "readBy": ["user-001", "user-002", "user-004"],
            "replyToMessageId": None,
        },
        {
            "id": "msg-001-003",
            "conversationId": "conv-001",
            "senderId": "user-004",
            "senderName": "James Brown",
            "senderAvatar": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
            "type": "text",
            "content": "I'll bring snacks and water for everyone!",
            "mediaUrls": None,
            "activityId": None,
            "timestamp": "2024-01-09T12:00:00Z",
            "status": "read",
            "readBy": ["user-001", "user-002", "user-003"],
            "replyToMessageId": None,
        },
        {
            "id": "msg-001-004",
            "conversationId": "conv-001",
            "senderId": "user-001",
            "senderName": "Sarah Johnson",
            "senderAvatar": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
            "type": "text",
            "content": "Perfect! Just paid my share 💸",
            "mediaUrls": None,
            "activityId": None,
            "timestamp": "2024-01-09T17:25:00Z",
            "status": "sent",
            "readBy": ["user-001"],
            "replyToMessageId": None,
        },
    ],
    "conv-002": [
        {
            "id": "msg-002-001",
            "conversationId": "conv-002",
            "senderId": "user-005",
            "senderName": "Lisa Park",
            "senderAvatar": "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
            "type": "text",
            "content": "Great game last time! Who's ready for next week?",
            "mediaUrls": None,
            "activityId": None,
            "timestamp": "2024-01-09T14:00:00Z",
            "status": "read",
            "readBy": ["user-001", "user-002", "user-006"],
            "replyToMessageId": None,
        },
        {
            "id": "msg-002-002",
            "conversationId": "conv-002",
            "senderId": "user-002",
            "senderName": "Mike Chen",
            "senderAvatar": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
            "type": "text",
            "content": "Same time next week?",
            "mediaUrls": None,
            "activityId": None,
            "timestamp": "2024-01-09T16:00:00Z",
            "status": "read",
            "readBy": ["user-001", "user-005", "user-006"],
            "replyToMessageId": None,
        },
    ],
    "conv-003": [
        {
            "id": "msg-003-001",
            "conversationId": "conv-003",
            "senderId": "user-004",
            "senderName": "James Brown",
            "senderAvatar": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
            "type": "text",
            "content": "Who's in for the camping trip?",
            "mediaUrls": None,
            "activityId": None,
            "timestamp": "2024-01-09T14:45:00Z",
            "status": "sent",
            "readBy": ["user-004"],
            "replyToMessageId": None,
        },
    ],
    "conv-004": [
        {
            "id": "msg-004-001",
            "conversationId": "conv-004",
            "senderId": "user-001",
            "senderName": "Sarah Johnson",
            "senderAvatar": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
            "type": "text",
            "content": "See you at the event tomorrow!",
            "mediaUrls": None,
            "activityId": None,
            "timestamp": "2024-01-09T17:00:00Z",
            "status": "sent",
            "readBy": ["user-001"],
            "replyToMessageId": None,
        },
    ],
    "conv-005": [
        {
            "id": "msg-005-001",
            "conversationId": "conv-005",
            "senderId": "user-002",
            "senderName": "Mike Chen",
            "senderAvatar": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
            "type": "text",
            "content": "Thanks for the recommendation 👍",
            "mediaUrls": None,
            "activityId": None,
            "timestamp": "2024-01-09T15:30:00Z",
            "status": "read",
            "readBy": ["user-002", "user-current"],
            "replyToMessageId": None,
        },
    ],
    "conv-006": [
        {
            "id": "msg-006-001",
            "conversationId": "conv-006",
            "senderId": "user-003",
            "senderName": "Emma Wilson",
            "senderAvatar": "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
            "type": "text",
            "content": "That hiking trail was amazing!",
            "mediaUrls": None,
            "activityId": None,
            "timestamp": "2024-01-08T19:20:00Z",
            "status": "read",
            "readBy": ["user-003", "user-current"],
            "replyToMessageId": None,
        },
    ],
}

# ==================== Firebase 操作 ====================

def initialize_firebase():
    """初始化 Firebase"""
    try:
        if os.path.exists(CREDENTIALS_PATH):
            cred = credentials.Certificate(CREDENTIALS_PATH)
            firebase_admin.initialize_app(cred)
        else:
            firebase_admin.initialize_app(options={'projectId': PROJECT_ID})
        print("✓ Firebase 初始化成功")
        return firestore.client()
    except Exception as e:
        print(f"✗ Firebase 初始化失败: {e}")
        print(f"\n请确保以下之一成立:")
        print(f"1. 将服务账户密钥文件放在: {CREDENTIALS_PATH}")
        print(f"2. 设置 GOOGLE_APPLICATION_CREDENTIALS 环境变量")
        print(f"3. 在 Google Cloud 上配置应用默认凭据")
        exit(1)

def upload_events(db):
    """上传事件数据"""
    print("\n📤 上传事件数据...")
    try:
        for event in EVENTS_DATA:
            doc_id = str(event["id"])
            retry_count = 0
            max_retries = 3
            while retry_count < max_retries:
                try:
                    db.collection("events").document(doc_id).set(event)
                    print(f"  ✓ 事件 {doc_id}: {event['title']}")
                    break
                except Exception as retry_error:
                    retry_count += 1
                    if retry_count >= max_retries:
                        raise retry_error
                    print(f"  ⚠️  重试 {retry_count}/{max_retries}...")
        print(f"✓ 成功上传 {len(EVENTS_DATA)} 个事件")
    except Exception as e:
        print(f"✗ 上传事件失败: {e}")

def upload_posts(db):
    """上传帖子数据"""
    print("\n📤 上传帖子数据...")
    try:
        for post in POSTS_DATA:
            doc_id = str(post["id"])
            retry_count = 0
            max_retries = 3
            while retry_count < max_retries:
                try:
                    db.collection("posts").document(doc_id).set(post)
                    print(f"  ✓ 帖子 {doc_id}: {post['user']['name']}")
                    break
                except Exception as retry_error:
                    retry_count += 1
                    if retry_count >= max_retries:
                        raise retry_error
                    print(f"  ⚠️  重试 {retry_count}/{max_retries}...")
        print(f"✓ 成功上传 {len(POSTS_DATA)} 个帖子")
    except Exception as e:
        print(f"✗ 上传帖子失败: {e}")

def upload_notifications(db):
    """上传通知数据"""
    print("\n📤 上传通知数据...")
    try:
        for notification in NOTIFICATIONS_DATA:
            doc_id = str(notification["id"])
            retry_count = 0
            max_retries = 3
            while retry_count < max_retries:
                try:
                    db.collection("notifications").document(doc_id).set(notification)
                    print(f"  ✓ 通知 {doc_id}: {notification['title']}")
                    break
                except Exception as retry_error:
                    retry_count += 1
                    if retry_count >= max_retries:
                        raise retry_error
                    print(f"  ⚠️  重试 {retry_count}/{max_retries}...")
        print(f"✓ 成功上传 {len(NOTIFICATIONS_DATA)} 个通知")
    except Exception as e:
        print(f"✗ 上传通知失败: {e}")

def upload_conversations(db):
    """上传对话数据"""
    print("\n📤 上传对话数据...")
    try:
        for conversation in CONVERSATIONS_DATA:
            doc_id = conversation["id"]
            retry_count = 0
            max_retries = 3
            while retry_count < max_retries:
                try:
                    db.collection("conversations").document(doc_id).set(conversation)
                    print(f"  ✓ 对话 {doc_id}: {conversation['name']}")
                    break
                except Exception as retry_error:
                    retry_count += 1
                    if retry_count >= max_retries:
                        raise retry_error
                    print(f"  ⚠️  重试 {retry_count}/{max_retries}...")
        print(f"✓ 成功上传 {len(CONVERSATIONS_DATA)} 个对话")
    except Exception as e:
        print(f"✗ 上传对话失败: {e}")

def upload_messages(db):
    """上传消息数据"""
    print("\n📤 上传消息数据...")
    try:
        total_messages = 0
        for conversation_id, messages in MESSAGES_DATA.items():
            for message in messages:
                retry_count = 0
                max_retries = 3
                while retry_count < max_retries:
                    try:
                        db.collection("conversations").document(conversation_id).collection("messages").document(message["id"]).set(message)
                        total_messages += 1
                        break
                    except Exception as retry_error:
                        retry_count += 1
                        if retry_count >= max_retries:
                            raise retry_error
                        print(f"  ⚠️  重试 {retry_count}/{max_retries}...")
            print(f"  ✓ 对话 {conversation_id}: 上传 {len(messages)} 条消息")
        print(f"✓ 成功上传 {total_messages} 条消息")
    except Exception as e:
        print(f"✗ 上传消息失败: {e}")

def main():
    """主函数"""
    print("=" * 50)
    print("Firebase 数据上传脚本")
    print("=" * 50)
    
    # 初始化 Firebase
    db = initialize_firebase()
    
    # 上传数据
    upload_events(db)
    upload_posts(db)
    upload_notifications(db)
    upload_conversations(db)
    upload_messages(db)
    
    print("\n" + "=" * 50)
    print("✓ 所有数据上传完成！")
    print("=" * 50)
    print("\n后续步骤:")
    print("1. 在 Firebase Console 中验证数据")
    print("2. 删除 lib/data/sample_data.dart 中的模拟数据")
    print("3. 更新应用代码以使用 Firebase 数据")

if __name__ == "__main__":
    main()
