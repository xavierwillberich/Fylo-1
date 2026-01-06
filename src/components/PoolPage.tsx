import { useState, useRef, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import {
  Heart,
  MessageCircle,
  Share2,
  MoreVertical,
  X,
  ArrowLeft,
  Plus,
  TrendingUp,
  Users as UsersIcon,
  MapPin,
  Sparkles,
} from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "./ui/avatar";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { ScrollArea } from "./ui/scroll-area";

export interface Post {
  id: number;
  user: {
    name: string;
    username: string;
    avatar: string;
    isFollowing: boolean;
  };
  timestamp: string;
  content: {
    text?: string;
    images?: string[];
    video?: string;
  };
  relatedActivity?: {
    id: string;
    title: string;
  };
  likes: number;
  comments: number;
  isLiked: boolean;
  isPublic: boolean;
}

interface PoolPageProps {
  onViewPost: (post: Post) => void;
  onViewProfile: (username: string, avatar: string) => void;
  onCreatePost: () => void;
  onViewActivity?: (activityId: string) => void;
  onBack?: () => void;
}

export function PoolPage({ onViewPost, onViewProfile, onCreatePost, onViewActivity, onBack }: PoolPageProps) {
  const [activeTab, setActiveTab] = useState<"following" | "worldwide" | "nearby">("worldwide");
  const [posts, setPosts] = useState<Post[]>([
    {
      id: 1,
      user: {
        name: "Helena",
        username: "@helena_wanderlust",
        avatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
        isFollowing: true,
      },
      timestamp: "3 min ago",
      content: {
        text: "Just got back from this amazing Pink Lake tour! The colors were absolutely surreal 🌸💗",
        images: ["https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600"],
      },
      relatedActivity: {
        id: "TRI-0023",
        title: "Pink Lake 3 Days Tour",
      },
      likes: 21,
      comments: 4,
      isLiked: false,
      isPublic: true,
    },
    {
      id: 2,
      user: {
        name: "Daniel",
        username: "@daniel_explorer",
        avatar: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100",
        isFollowing: true,
      },
      timestamp: "2 hrs ago",
      content: {
        text: "Body text for a post. Since it's a social app, sometimes it's a hot take, and sometimes it's a question.",
      },
      likes: 6,
      comments: 18,
      isLiked: false,
      isPublic: true,
    },
    {
      id: 3,
      user: {
        name: "Sarah Mitchell",
        username: "@sarah_m",
        avatar: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
        isFollowing: true,
      },
      timestamp: "5 hrs ago",
      content: {
        text: "Just finished the most amazing hike at Rattlesnake Ledge! The views were absolutely breathtaking 🏔️",
        images: [
          "https://images.unsplash.com/photo-1501555088652-021faa106b9b?w=600",
          "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600",
        ],
      },
      relatedActivity: {
        id: "TRI-0015",
        title: "Rattlesnake Ledge Morning Hike",
      },
      likes: 142,
      comments: 23,
      isLiked: true,
      isPublic: true,
    },
    {
      id: 4,
      user: {
        name: "Alex Thompson",
        username: "@alex_foodie",
        avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
        isFollowing: false,
      },
      timestamp: "8 hrs ago",
      content: {
        text: "Best sushi in Seattle? Just tried this new place and I'm blown away! 🍣",
        images: [
          "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=600",
        ],
      },
      likes: 87,
      comments: 31,
      isLiked: false,
      isPublic: true,
    },
    {
      id: 5,
      user: {
        name: "Jessica Park",
        username: "@jess_runs",
        avatar: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
        isFollowing: true,
      },
      timestamp: "12 hrs ago",
      content: {
        text: "Early morning run club was amazing today! Who else loves sunrise runs? 🌅",
        images: [
          "https://images.unsplash.com/photo-1452626038306-9aae5e071dd3?w=600",
        ],
      },
      relatedActivity: {
        id: "SPO-0042",
        title: "Sunrise Run Club",
      },
      likes: 234,
      comments: 45,
      isLiked: true,
      isPublic: true,
    },
  ]);

  const handleLike = (postId: number) => {
    setPosts(posts.map(post => {
      if (post.id === postId) {
        return {
          ...post,
          isLiked: !post.isLiked,
          likes: post.isLiked ? post.likes - 1 : post.likes + 1,
        };
      }
      return post;
    }));
  };

  const handleFollow = (postId: number) => {
    setPosts(posts.map(post => {
      if (post.id === postId) {
        return {
          ...post,
          user: {
            ...post.user,
            isFollowing: !post.user.isFollowing,
          },
        };
      }
      return post;
    }));
  };

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      transition={{ duration: 0.2 }}
      className="bg-gray-50 min-h-screen"
    >
      <div className="max-w-md mx-auto bg-gray-50 min-h-screen pb-24">
        <ScrollArea className="h-screen">
          {/* Header - Gradient Background Section */}
          <div className="relative bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-500 overflow-hidden rounded-b-[40px] shadow-xl">
            {/* Animated Background Blobs */}
            <motion.div
              animate={{
                scale: [1, 1.2, 1],
                rotate: [0, 90, 0],
              }}
              transition={{
                duration: 20,
                repeat: Infinity,
                ease: "linear",
              }}
              className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl"
            />
            <motion.div
              animate={{
                scale: [1.2, 1, 1.2],
                rotate: [0, -90, 0],
              }}
              transition={{
                duration: 15,
                repeat: Infinity,
                ease: "linear",
              }}
              className="absolute bottom-0 left-0 w-64 h-64 bg-white/10 rounded-full blur-3xl"
            />

            {/* Header Bar */}
            <div className="relative z-10 px-5 py-5">
              <motion.h1
                initial={{ opacity: 0, y: -10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.1 }}
                className="text-white text-xl text-center"
              >
                Pool
              </motion.h1>
            </div>

            {/* Tab Navigation */}
            <div className="relative z-10 px-5 pb-6">
              <div className="flex gap-2 bg-white/15 backdrop-blur-xl p-1.5 rounded-2xl border border-white/20 shadow-2xl">
                {(["following", "worldwide", "nearby"] as const).map((tab, idx) => (
                  <motion.button
                    key={tab}
                    initial={{ opacity: 0, scale: 0.9 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ delay: 0.15 + idx * 0.05, type: "spring" }}
                    whileHover={{ scale: 1.03 }}
                    whileTap={{ scale: 0.97 }}
                    onClick={() => setActiveTab(tab)}
                    className={`flex-1 px-4 py-2.5 rounded-xl text-sm transition-all ${
                      activeTab === tab
                        ? "bg-white text-purple-600 shadow-lg"
                        : "text-white hover:bg-white/10"
                    }`}
                  >
                    {tab.charAt(0).toUpperCase() + tab.slice(1)}
                  </motion.button>
                ))}
              </div>
            </div>
          </div>

          {/* Posts Feed */}
          <div className="px-5 py-5 pb-40 space-y-4">
            {posts.map((post, index) => (
              <motion.div
                key={post.id}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.3 + index * 0.05, type: "spring" }}
                whileHover={{ scale: 1.01, y: -2 }}
                className="bg-white rounded-3xl border border-gray-100 shadow-lg hover:shadow-xl transition-all overflow-hidden"
              >
                {/* User Info */}
                <div className="p-4 flex items-center justify-between">
                  <motion.button
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    onClick={() => onViewProfile(post.user.username, post.user.avatar)}
                    className="flex items-center gap-3"
                  >
                    <Avatar className="w-11 h-11 border-2 border-white shadow-md">
                      <AvatarImage src={post.user.avatar} />
                      <AvatarFallback>{post.user.name.slice(0, 2).toUpperCase()}</AvatarFallback>
                    </Avatar>
                    <div className="text-left">
                      <p className="text-black">{post.user.name}</p>
                      <p className="text-sm text-gray-500">{post.timestamp}</p>
                    </div>
                  </motion.button>

                  {!post.user.isFollowing && (
                    <motion.button
                      whileHover={{ scale: 1.05 }}
                      whileTap={{ scale: 0.95 }}
                      onClick={() => handleFollow(post.id)}
                      className="px-4 py-1.5 bg-gradient-to-r from-indigo-600 to-purple-600 text-white rounded-full text-sm shadow-md hover:shadow-lg transition-all"
                    >
                      Follow
                    </motion.button>
                  )}
                </div>

                {/* Post Content */}
                {post.content.text && (
                  <motion.div
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    transition={{ delay: 0.35 + index * 0.05 }}
                    className="px-4 pb-3"
                  >
                    <p className="text-gray-800">{post.content.text}</p>
                  </motion.div>
                )}

                {/* Post Images */}
                {post.content.images && post.content.images.length > 0 && (
                  <motion.div
                    initial={{ opacity: 0, scale: 0.98 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ delay: 0.4 + index * 0.05 }}
                    className={`grid gap-2 ${
                      post.content.images.length === 1 
                        ? 'grid-cols-1 px-4' 
                        : post.content.images.length === 2 
                        ? 'grid-cols-2 px-4' 
                        : 'grid-cols-2 px-4'
                    } ${post.relatedActivity ? 'pb-4' : 'pb-3'}`}
                  >
                    {post.content.images.map((img, idx) => (
                      <motion.button
                        key={idx}
                        whileHover={{ scale: 1.02 }}
                        whileTap={{ scale: 0.98 }}
                        onClick={() => onViewPost(post)}
                        className={`relative overflow-hidden shadow-md ${
                          post.content.images!.length === 1 
                            ? 'rounded-2xl' 
                            : 'rounded-2xl'
                        }`}
                      >
                        <img
                          src={img}
                          alt={`Post image ${idx + 1}`}
                          className={`w-full object-cover ${
                            post.content.images!.length === 1 
                              ? 'h-[400px]' 
                              : 'h-48'
                          }`}
                        />
                      </motion.button>
                    ))}
                  </motion.div>
                )}

                {/* Related Activity */}
                {post.relatedActivity && (
                  <motion.div
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: 0.45 + index * 0.05 }}
                    className="px-4 pb-4"
                  >
                    <motion.button
                      whileHover={{ scale: 1.02, y: -1 }}
                      whileTap={{ scale: 0.98 }}
                      onClick={() => onViewActivity?.(post.relatedActivity!.id)}
                      className="w-full p-4 bg-gradient-to-br from-purple-50 to-pink-50 rounded-2xl border-2 border-purple-200 hover:border-purple-400 transition-all text-left shadow-sm hover:shadow-md"
                    >
                      <div className="flex items-center gap-3">
                        <div className="p-2.5 bg-gradient-to-br from-purple-500 to-pink-500 rounded-xl shadow-md">
                          <Sparkles className="w-5 h-5 text-white" />
                        </div>
                        <div className="flex-1">
                          <p className="text-xs font-mono text-purple-600 mb-0.5">{post.relatedActivity.id}</p>
                          <p className="text-sm text-black leading-snug">{post.relatedActivity.title}</p>
                        </div>
                      </div>
                    </motion.button>
                  </motion.div>
                )}

                {/* Actions */}
                <div className="px-4 pb-4 flex items-center gap-6">
                  <motion.button
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.9 }}
                    onClick={() => handleLike(post.id)}
                    className="flex items-center gap-2 group"
                  >
                    <motion.div
                      animate={post.isLiked ? { scale: [1, 1.3, 1] } : {}}
                      transition={{ duration: 0.3 }}
                    >
                      <Heart
                        className={`w-6 h-6 transition-colors ${
                          post.isLiked
                            ? "fill-red-500 text-red-500"
                            : "text-gray-600 group-hover:text-red-500"
                        }`}
                      />
                    </motion.div>
                    <span className={`text-sm ${post.isLiked ? "text-red-500" : "text-gray-600"}`}>
                      {post.likes}
                    </span>
                  </motion.button>

                  <motion.button
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.9 }}
                    onClick={() => onViewPost(post)}
                    className="flex items-center gap-2 group"
                  >
                    <MessageCircle className="w-6 h-6 text-gray-600 group-hover:text-blue-500 transition-colors" />
                    <span className="text-sm text-gray-600 group-hover:text-blue-500 transition-colors">
                      {post.comments}
                    </span>
                  </motion.button>

                  <motion.button
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.9 }}
                    className="flex items-center gap-2 group"
                  >
                    <Share2 className="w-6 h-6 text-gray-600 group-hover:text-green-500 transition-colors" />
                  </motion.button>
                </div>
              </motion.div>
            ))}

            {/* Empty State */}
            {posts.length === 0 && (
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.3 }}
                className="flex flex-col items-center justify-center py-20 px-6 text-center bg-white rounded-3xl shadow-md border border-gray-100"
              >
                <div className="w-24 h-24 bg-gradient-to-br from-purple-100 to-pink-100 rounded-full flex items-center justify-center mb-6 shadow-lg">
                  <TrendingUp className="w-12 h-12 text-purple-600" />
                </div>
                <h3 className="text-black text-lg mb-2">No posts yet</h3>
                <p className="text-gray-600 mb-6">
                  Be the first to share something!
                </p>
                <Button
                  onClick={onCreatePost}
                  className="bg-gradient-to-r from-indigo-600 to-purple-600 text-white hover:from-indigo-700 hover:to-purple-700 rounded-2xl shadow-lg"
                >
                  Create Post
                </Button>
              </motion.div>
            )}
          </div>
        </ScrollArea>
      </div>
    </motion.div>
  );
}