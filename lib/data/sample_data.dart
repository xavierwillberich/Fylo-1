import '../models/event.dart';
import '../models/post.dart';
import '../models/notification.dart';

class SampleData {
  static List<Event> getEvents() {
    return [
      Event(
        id: 1,
        date: '28',
        month: 'Oct',
        year: '2025',
        dayOfWeek: 'Tuesday',
        weather: Weather.clear,
        temperature: 68,
        category: 'Trips',
        title: 'Weekend Hiking Adventure - Mount Rainier Trail',
        description: 'Join us for a scenic 8-mile hike through alpine meadows and old-growth forests. Perfect for nature lovers and photography enthusiasts. All skill levels welcome!',
        time: '7:00 AM',
        location: 'Mount Rainier National Park, WA',
        participants: 12,
        budget: 45,
        recruiting: true,
        proficiency: ProficiencyLevel.intermediate,
        genderRestriction: GenderRestriction.noRestrictions,
        passwordRequired: false,
        images: [
          'https://images.unsplash.com/photo-1623622863859-2931a6c3bc80?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080',
          'https://images.unsplash.com/photo-1723470317938-6ec6fb0d4075?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080',
        ],
        attendeeAvatars: [
          'https://images.unsplash.com/photo-1581065178047-8ee15951ede6?w=100',
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
        ],
      ),
      Event(
        id: 2,
        date: '30',
        month: 'Oct',
        year: '2025',
        dayOfWeek: 'Thursday',
        weather: Weather.cloudy,
        temperature: 62,
        category: 'Board Games',
        title: 'Board Game Night - Strategy Games & Chill',
        description: 'Casual board game night featuring Catan, Ticket to Ride, and more. Snacks and drinks provided. Great for making new friends!',
        time: '7:00 PM',
        location: 'Cafe Meeple, Downtown Seattle',
        participants: 8,
        budget: 25,
        recruiting: true,
        proficiency: ProficiencyLevel.beginner,
        genderRestriction: GenderRestriction.noRestrictions,
        passwordRequired: false,
        images: [
          'https://images.unsplash.com/photo-1645652267295-769f5dc8b10d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080',
        ],
        attendeeAvatars: [
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
        ],
      ),
      Event(
        id: 3,
        date: '2',
        month: 'Nov',
        year: '2025',
        dayOfWeek: 'Sunday',
        weather: Weather.partlyCloudy,
        temperature: 65,
        category: 'Foods',
        title: 'Japanese Cuisine Cooking Class',
        description: 'Learn to make authentic sushi, ramen, and tempura from a professional chef. All ingredients and equipment provided.',
        time: '2:00 PM',
        location: 'Culinary Arts Studio, Capitol Hill',
        participants: 10,
        budget: 75,
        recruiting: true,
        proficiency: ProficiencyLevel.beginner,
        genderRestriction: GenderRestriction.noRestrictions,
        passwordRequired: false,
        images: [
          'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080',
        ],
        attendeeAvatars: [
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100',
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
        ],
      ),
      Event(
        id: 4,
        date: '5',
        month: 'Nov',
        year: '2025',
        dayOfWeek: 'Wednesday',
        weather: Weather.clear,
        temperature: 70,
        category: 'Sports',
        title: 'Beach Volleyball Tournament',
        description: 'Friendly beach volleyball tournament at Alki Beach. Teams of 4, all skill levels welcome. Prizes for winners!',
        time: '4:00 PM',
        location: 'Alki Beach, West Seattle',
        participants: 16,
        budget: 20,
        recruiting: true,
        proficiency: ProficiencyLevel.intermediate,
        genderRestriction: GenderRestriction.noRestrictions,
        passwordRequired: false,
        images: [
          'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&w=1080',
        ],
        attendeeAvatars: [
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
          'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=100',
        ],
      ),
    ];
  }

  static List<Post> getPosts() {
    return [
      Post(
        id: 1,
        user: PostUser(
          name: 'Sarah Chen',
          username: '@sarah_explorer',
          avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        ),
        content: PostContent(
          text: 'Just finished the most amazing hike at Mount Rainier! The views were absolutely breathtaking 🏔️✨ Can\'t wait for the next adventure!',
          images: [
            'https://images.unsplash.com/photo-1623622863859-2931a6c3bc80?w=800',
          ],
        ),
        timestamp: '2 hours ago',
        likes: 124,
        comments: 18,
        shares: 5,
        isLiked: false,
        isFollowing: false,
        relatedActivity: RelatedActivity(
          activityId: 'TRI-000001',
          title: 'Weekend Hiking Adventure',
          image: 'https://images.unsplash.com/photo-1623622863859-2931a6c3bc80?w=100',
        ),
      ),
      Post(
        id: 2,
        user: PostUser(
          name: 'Mike Johnson',
          username: '@mike_games',
          avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        ),
        content: PostContent(
          text: 'Board game night was epic! We played Catan for 3 hours straight 🎲 Already planning the next meetup!',
          images: [],
        ),
        timestamp: '5 hours ago',
        likes: 89,
        comments: 12,
        shares: 3,
        isLiked: true,
        isFollowing: true,
        relatedActivity: RelatedActivity(
          activityId: 'BOA-000002',
          title: 'Board Game Night',
          image: 'https://images.unsplash.com/photo-1645652267295-769f5dc8b10d?w=100',
        ),
      ),
      Post(
        id: 3,
        user: PostUser(
          name: 'Emma Wilson',
          username: '@emma_foodie',
          avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
        ),
        content: PostContent(
          text: 'The sushi I made today turned out perfect! 🍣 Thanks to everyone who joined the cooking class. Such a fun experience!',
          images: [
            'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800',
          ],
        ),
        timestamp: '1 day ago',
        likes: 203,
        comments: 34,
        shares: 12,
        isLiked: false,
        isFollowing: false,
        relatedActivity: null,
      ),
    ];
  }

  static List<AppNotification> getNotifications() {
    return [
      AppNotification(
        id: 1,
        type: NotificationType.like,
        title: '@helena_wanderlust liked your post',
        message: 'your post about hiking',
        timestamp: '2m ago',
        avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
        activityId: null,
        isRead: false,
      ),
      AppNotification(
        id: 2,
        type: NotificationType.comment,
        title: '@daniel_explorer commented',
        message: 'Count me in! This looks amazing 🔥',
        timestamp: '15m ago',
        avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
        activityId: null,
        isRead: false,
      ),
      AppNotification(
        id: 3,
        type: NotificationType.reminder,
        title: 'Activity Reminder',
        message: 'Hiking in George Bass starts tomorrow at 7:00 AM',
        timestamp: '1h ago',
        avatar: null,
        activityId: 'TRI-0001',
        isRead: false,
      ),
      AppNotification(
        id: 4,
        type: NotificationType.activityUpdate,
        title: '@sarah_m shared your activity',
        message: 'Basketball Pickup Game',
        timestamp: '3h ago',
        avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
        activityId: 'SPT-0004',
        isRead: true,
      ),
      AppNotification(
        id: 5,
        type: NotificationType.like,
        title: '@nebulanomad liked your comment',
        message: '',
        timestamp: '5h ago',
        avatar: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100',
        activityId: null,
        isRead: true,
      ),
    ];
  }
}
