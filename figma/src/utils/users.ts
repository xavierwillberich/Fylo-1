// User profile data with gender and sexual orientation information
export interface UserData {
  name: string;
  username: string;
  avatar: string;
  bio: string;
  location: string;
  joinDate: string;
  followers: number;
  following: number;
  eventsAttended: number;
  mbti?: string;
  gender?: 'male' | 'female';
  isSexualMinority?: boolean;
  showSexualOrientation?: boolean;
  academicBadge?: string;
  joinedActivities?: Array<{ id: string; title: string }>;
  poolPosts?: number;
}

// Sample user database
export const users: Record<string, UserData> = {
  '@alice_chen': {
    name: 'Alice Chen',
    username: '@alice_chen',
    avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    bio: 'Love exploring Seattle and meeting new people through activities! 🌈',
    location: 'Seattle, WA',
    joinDate: 'March 2024',
    followers: 342,
    following: 189,
    eventsAttended: 27,
    mbti: 'ENFP',
    gender: 'female',
    isSexualMinority: true,
    showSexualOrientation: true,
    academicBadge: 'University of Washington',
    joinedActivities: [
      { id: 'ACT-HIK-2024-001', title: 'Hiking in George Bass' },
      { id: 'ACT-SPT-2024-042', title: 'Beach Volleyball' },
    ],
    poolPosts: 24,
  },
  '@helena_wanderlust': {
    name: 'Helena',
    username: '@helena_wanderlust',
    avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
    bio: 'Travel enthusiast and adventure seeker ✈️',
    location: 'Seattle, WA',
    joinDate: 'January 2024',
    followers: 512,
    following: 234,
    eventsAttended: 45,
    mbti: 'INFJ',
    gender: 'female',
    isSexualMinority: false,
    showSexualOrientation: false,
    academicBadge: 'Seattle University',
    poolPosts: 38,
  },
  '@daniel_explorer': {
    name: 'Daniel',
    username: '@daniel_explorer',
    avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
    bio: 'Exploring the Pacific Northwest one trail at a time 🏔️',
    location: 'Portland, OR',
    joinDate: 'February 2024',
    followers: 289,
    following: 156,
    eventsAttended: 32,
    mbti: 'ESTP',
    gender: 'male',
    isSexualMinority: true,
    showSexualOrientation: true,
    academicBadge: 'Portland State University',
    poolPosts: 19,
  },
  '@sarah_m': {
    name: 'Sarah Mitchell',
    username: '@sarah_m',
    avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
    bio: 'Coffee lover and outdoor enthusiast ☕',
    location: 'Seattle, WA',
    joinDate: 'April 2024',
    followers: 421,
    following: 198,
    eventsAttended: 18,
    mbti: 'ISFJ',
    gender: 'female',
    isSexualMinority: false,
    showSexualOrientation: false,
    academicBadge: 'University of Washington',
    poolPosts: 15,
  },
  '@starryskies23': {
    name: 'Starry Skies',
    username: '@starryskies23',
    avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop',
    bio: 'Stargazer and night owl 🌙',
    location: 'Seattle, WA',
    joinDate: 'May 2024',
    followers: 167,
    following: 145,
    eventsAttended: 12,
    mbti: 'INTP',
    gender: 'female',
    isSexualMinority: false,
    showSexualOrientation: false,
    poolPosts: 8,
  },
  '@nebulanomad': {
    name: 'Nebula Nomad',
    username: '@nebulanomad',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
    bio: 'Digital nomad and tech enthusiast 💻',
    location: 'Seattle, WA',
    joinDate: 'March 2024',
    followers: 389,
    following: 267,
    eventsAttended: 21,
    mbti: 'INTJ',
    gender: 'male',
    isSexualMinority: false,
    showSexualOrientation: false,
    academicBadge: 'MIT',
    poolPosts: 29,
  },
  '@emberecho': {
    name: 'Ember Echo',
    username: '@emberecho',
    avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop',
    bio: 'Artist and music lover 🎨🎵',
    location: 'Seattle, WA',
    joinDate: 'June 2024',
    followers: 234,
    following: 178,
    eventsAttended: 16,
    mbti: 'ISFP',
    gender: 'female',
    isSexualMinority: true,
    showSexualOrientation: true,
    academicBadge: 'Cornish College of the Arts',
    poolPosts: 22,
  },
  '@lunavoyager': {
    name: 'Luna Voyager',
    username: '@lunavoyager',
    avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&h=100&fit=crop',
    bio: 'Space enthusiast and sci-fi fan 🚀',
    location: 'Seattle, WA',
    joinDate: 'April 2024',
    followers: 298,
    following: 201,
    eventsAttended: 19,
    mbti: 'ENFJ',
    gender: 'female',
    isSexualMinority: false,
    showSexualOrientation: false,
    academicBadge: 'University of Washington',
    poolPosts: 17,
  },
  '@shadowlynx': {
    name: 'Shadow Lynx',
    username: '@shadowlynx',
    avatar: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100&h=100&fit=crop',
    bio: 'Gamer and night explorer 🎮',
    location: 'Seattle, WA',
    joinDate: 'February 2024',
    followers: 456,
    following: 312,
    eventsAttended: 28,
    mbti: 'ISTP',
    gender: 'male',
    isSexualMinority: false,
    showSexualOrientation: false,
    poolPosts: 34,
  },
};

// Get user data by username
export function getUserData(username: string): UserData | null {
  return users[username] || null;
}

// Generate default user data if not found
export function getUserDataOrDefault(username: string, avatar: string): UserData {
  const existingUser = getUserData(username);
  if (existingUser) return existingUser;

  // Generate default data
  const name = username.replace('@', '').split('_').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
  return {
    name,
    username,
    avatar,
    bio: 'Love exploring and meeting new people through activities!',
    location: 'Seattle, WA',
    joinDate: 'March 2024',
    followers: Math.floor(Math.random() * 500),
    following: Math.floor(Math.random() * 300),
    eventsAttended: Math.floor(Math.random() * 50),
    mbti: ['ENFP', 'INFJ', 'ESTP', 'ISFJ'][Math.floor(Math.random() * 4)],
    gender: Math.random() > 0.5 ? 'male' : 'female',
    isSexualMinority: false,
    showSexualOrientation: false,
    poolPosts: Math.floor(Math.random() * 30),
  };
}