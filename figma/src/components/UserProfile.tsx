import { motion, AnimatePresence } from "motion/react";
import { ArrowLeft, MapPin, Calendar, Users, Wallet, Settings, GraduationCap, Heart, MessageCircle } from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "./ui/avatar";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { Separator } from "./ui/separator";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./ui/tabs";
import { ScrollArea } from "./ui/scroll-area";

interface UserProfileProps {
  user: {
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
    gender?: 'male' | 'female' | string;
    isSexualMinority?: boolean;
    showSexualOrientation?: boolean;
    academicBadge?: string;
    joinedActivities?: Array<{ id: string; title: string; }>;
    poolPosts?: number;
  };
  isOwnProfile?: boolean;
  isFollowing?: boolean;
  onClose: () => void;
  onToggleFollow?: () => void;
  onViewSettings?: () => void;
  onViewWallet?: () => void;
}

export function UserProfile({
  user,
  isOwnProfile = false,
  isFollowing = false,
  onClose,
  onToggleFollow,
  onViewSettings,
  onViewWallet,
}: UserProfileProps) {
  return (
    <motion.div
      initial={{ opacity: 0, x: "100%" }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: "100%" }}
      transition={{ duration: 0.3, ease: "easeOut" }}
      className={`fixed inset-0 ${isOwnProfile ? 'z-[40]' : 'z-[100]'} bg-gray-50`}
    >
      <div className="fixed inset-0 max-w-md mx-auto bg-white">
        <ScrollArea className="h-full">
          {/* Header - Gradient Background Section */}
          <div className="relative bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-500 overflow-hidden rounded-b-[40px] shadow-xl pb-8">
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
            <div className="relative z-10 flex items-center justify-between px-5 py-5">
              <motion.button
                whileHover={{ scale: 1.1, backgroundColor: "rgba(255,255,255,0.15)" }}
                whileTap={{ scale: 0.9 }}
                onClick={onClose}
                className="p-2.5 -ml-2 hover:bg-white/10 rounded-full transition-all"
              >
                <ArrowLeft className="w-6 h-6 text-white" />
              </motion.button>
              <motion.h1
                initial={{ opacity: 0, y: -10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.1 }}
                className="text-white text-xl"
              >
                {user.username}
              </motion.h1>
              {isOwnProfile && onViewSettings ? (
                <motion.button
                  whileHover={{ scale: 1.1, backgroundColor: "rgba(255,255,255,0.15)", rotate: 90 }}
                  whileTap={{ scale: 0.9 }}
                  onClick={onViewSettings}
                  className="p-2.5 -mr-2 hover:bg-white/10 rounded-full transition-all"
                >
                  <Settings className="w-6 h-6 text-white" />
                </motion.button>
              ) : (
                <div className="w-10"></div>
              )}
            </div>

            {/* Profile Card - Glassmorphism Style */}
            <motion.div
              initial={{ opacity: 0, y: 30, scale: 0.9 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              transition={{ delay: 0.15, type: "spring", stiffness: 200, damping: 20 }}
              className="relative z-10 mx-5 mb-6 p-6 bg-white/15 backdrop-blur-xl rounded-[32px] shadow-2xl border border-white/20"
            >
              {/* Decorative elements */}
              <div className="absolute top-0 right-0 w-32 h-32 bg-gradient-to-br from-white/20 to-transparent rounded-full blur-2xl" />
              <div className="absolute bottom-0 left-0 w-24 h-24 bg-gradient-to-tr from-white/20 to-transparent rounded-full blur-2xl" />

              <div className="relative">
                {/* Avatar and Action Buttons */}
                <div className="flex items-start justify-between mb-4">
                  <motion.div
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    transition={{ delay: 0.2, type: "spring", stiffness: 200 }}
                    whileHover={{ scale: 1.05 }}
                  >
                    <Avatar className="w-24 h-24 border-3 border-white/40 shadow-xl">
                      <AvatarImage src={user.avatar} />
                      <AvatarFallback>{user.name.substring(0, 2)}</AvatarFallback>
                    </Avatar>
                  </motion.div>
                  <div className="flex gap-2">
                    {isOwnProfile && onViewWallet && (
                      <motion.button
                        initial={{ opacity: 0, x: 20 }}
                        animate={{ opacity: 1, x: 0 }}
                        transition={{ delay: 0.25, type: "spring" }}
                        whileHover={{ scale: 1.05, y: -2 }}
                        whileTap={{ scale: 0.95 }}
                        onClick={onViewWallet}
                        className="flex items-center gap-2 px-4 py-2.5 bg-white/20 backdrop-blur-sm text-white rounded-2xl border border-white/30 hover:bg-white/30 transition-all shadow-lg"
                      >
                        <Wallet className="w-4 h-4" />
                        <span className="text-sm">Wallet</span>
                      </motion.button>
                    )}
                    {!isOwnProfile && onToggleFollow && (
                      <motion.button
                        initial={{ opacity: 0, x: 20 }}
                        animate={{ opacity: 1, x: 0 }}
                        transition={{ delay: 0.25, type: "spring" }}
                        whileHover={{ scale: 1.05, y: -2 }}
                        whileTap={{ scale: 0.95 }}
                        onClick={onToggleFollow}
                        className={`flex items-center gap-2 px-4 py-2.5 rounded-2xl transition-all shadow-lg ${
                          isFollowing
                            ? "bg-white/20 backdrop-blur-sm text-white border border-white/30 hover:bg-white/30"
                            : "bg-white text-purple-600 hover:shadow-xl"
                        }`}
                      >
                        <span className="text-sm">{isFollowing ? "Following" : "Follow"}</span>
                      </motion.button>
                    )}
                  </div>
                </div>

                {/* Name and Bio */}
                <motion.div
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.3 }}
                  className="mb-4"
                >
                  <h2 className="text-white text-2xl mb-2">{user.name}</h2>
                  <p className="text-white/80 text-sm leading-relaxed">{user.bio}</p>
                </motion.div>

                {/* Stats Grid */}
                <motion.div
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.35, type: "spring" }}
                  className="grid grid-cols-4 gap-3"
                >
                  {[
                    { label: 'Followers', value: user.followers },
                    { label: 'Following', value: user.following },
                    { label: 'Events', value: user.eventsAttended },
                    { label: 'Posts', value: user.poolPosts || 0 },
                  ].map((stat, index) => (
                    <motion.button
                      key={stat.label}
                      initial={{ opacity: 0, scale: 0 }}
                      animate={{ opacity: 1, scale: 1 }}
                      transition={{ delay: 0.4 + index * 0.05, type: "spring", stiffness: 200 }}
                      whileHover={{ scale: 1.05, y: -2 }}
                      whileTap={{ scale: 0.95 }}
                      className="text-center p-3 bg-white/20 backdrop-blur-sm rounded-2xl border border-white/30 hover:bg-white/30 transition-all"
                    >
                      <p className="text-white text-xl mb-1">{stat.value}</p>
                      <p className="text-white/70 text-xs">{stat.label}</p>
                    </motion.button>
                  ))}
                </motion.div>
              </div>
            </motion.div>
          </div>

          {/* Content - Tabs Section */}
          <div className="px-5 py-5 pb-32">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.5 }}
            >
              <Tabs defaultValue="activities" className="w-full">
                <TabsList className={`grid w-full ${isOwnProfile ? 'grid-cols-3' : 'grid-cols-2'} bg-white rounded-2xl shadow-md p-1`}>
                  <TabsTrigger value="activities" className="rounded-xl">Activities</TabsTrigger>
                  {isOwnProfile && <TabsTrigger value="schedule" className="rounded-xl">Schedule</TabsTrigger>}
                  <TabsTrigger value="posts" className="rounded-xl">Posts</TabsTrigger>
                </TabsList>

                <TabsContent value="activities" className="space-y-3 mt-6">
                  {user.joinedActivities && user.joinedActivities.length > 0 ? (
                    user.joinedActivities.map((activity, idx) => (
                      <motion.div
                        key={idx}
                        initial={{ opacity: 0, x: -20 }}
                        animate={{ opacity: 1, x: 0 }}
                        transition={{ delay: 0.6 + idx * 0.05 }}
                        whileHover={{ scale: 1.02, y: -2 }}
                        whileTap={{ scale: 0.98 }}
                        className="p-4 bg-white rounded-3xl border border-gray-100 shadow-md hover:shadow-xl transition-all cursor-pointer"
                      >
                        <p className="text-xs text-purple-600 mb-2 font-mono">{activity.id}</p>
                        <p className="text-sm text-black">{activity.title}</p>
                      </motion.div>
                    ))
                  ) : (
                    <motion.div
                      initial={{ opacity: 0 }}
                      animate={{ opacity: 1 }}
                      transition={{ delay: 0.6 }}
                      className="text-center py-12"
                    >
                      <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <Users className="w-8 h-8 text-gray-400" />
                      </div>
                      <p className="text-sm text-gray-500">No activities joined yet</p>
                    </motion.div>
                  )}
                </TabsContent>

                {isOwnProfile && (
                  <TabsContent value="schedule" className="space-y-4 mt-6">
                    <motion.div
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: 0.6 }}
                      className="p-5 bg-gradient-to-br from-blue-500 to-teal-500 rounded-3xl shadow-xl"
                    >
                      <div className="flex items-center justify-between mb-4">
                        <h3 className="text-white text-lg">Today</h3>
                        <span className="text-white/80 text-sm">Nov 4</span>
                      </div>
                      <div className="space-y-3">
                        {[
                          { time: '6:00', period: 'AM', title: 'Morning Run Club', location: 'Green Lake Park' },
                          { time: '2:00', period: 'PM', title: 'Hiking in George Bass', location: '7 participants' },
                        ].map((event, idx) => (
                          <motion.div
                            key={idx}
                            initial={{ opacity: 0, x: -20 }}
                            animate={{ opacity: 1, x: 0 }}
                            transition={{ delay: 0.7 + idx * 0.1 }}
                            whileHover={{ scale: 1.02 }}
                            className="flex gap-4 p-3 bg-white/20 backdrop-blur-sm rounded-2xl border border-white/30"
                          >
                            <div className="text-center flex-shrink-0">
                              <p className="text-white text-lg">{event.time}</p>
                              <p className="text-white/70 text-xs">{event.period}</p>
                            </div>
                            <div className="flex-1">
                              <h4 className="text-white mb-1">{event.title}</h4>
                              <p className="text-white/70 text-sm">{event.location}</p>
                            </div>
                          </motion.div>
                        ))}
                      </div>
                    </motion.div>

                    <motion.div
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: 0.8 }}
                      className="p-5 bg-gradient-to-br from-purple-500 to-pink-500 rounded-3xl shadow-xl"
                    >
                      <div className="flex items-center justify-between mb-4">
                        <h3 className="text-white text-lg">Tomorrow</h3>
                        <span className="text-white/80 text-sm">Nov 5</span>
                      </div>
                      <motion.div
                        initial={{ opacity: 0, x: -20 }}
                        animate={{ opacity: 1, x: 0 }}
                        transition={{ delay: 0.9 }}
                        whileHover={{ scale: 1.02 }}
                        className="flex gap-4 p-3 bg-white/20 backdrop-blur-sm rounded-2xl border border-white/30"
                      >
                        <div className="text-center flex-shrink-0">
                          <p className="text-white text-lg">4:00</p>
                          <p className="text-white/70 text-xs">PM</p>
                        </div>
                        <div className="flex-1">
                          <h4 className="text-white mb-1">Beach Volleyball</h4>
                          <p className="text-white/70 text-sm">Alki Beach</p>
                        </div>
                      </motion.div>
                    </motion.div>

                    <motion.div
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: 1 }}
                      className="p-5 bg-white rounded-3xl shadow-lg border border-gray-100"
                    >
                      <div className="flex items-center justify-between mb-4">
                        <h3 className="text-black text-lg">This Weekend</h3>
                        <span className="text-gray-600 text-sm">Nov 6-7</span>
                      </div>
                      <div className="space-y-3">
                        {[
                          { day: 'Sat', time: '7PM', title: 'KTV Night', location: 'Downtown' },
                          { day: 'Sun', time: '9AM', title: 'Coffee Chat', location: 'Starbucks Reserve' },
                        ].map((event, idx) => (
                          <motion.div
                            key={idx}
                            initial={{ opacity: 0, x: -20 }}
                            animate={{ opacity: 1, x: 0 }}
                            transition={{ delay: 1.1 + idx * 0.1 }}
                            whileHover={{ scale: 1.02 }}
                            className="flex gap-4 p-3 bg-gray-50 rounded-2xl"
                          >
                            <div className="text-center flex-shrink-0">
                              <p className="text-gray-700">{event.day}</p>
                              <p className="text-gray-500 text-xs">{event.time}</p>
                            </div>
                            <div className="flex-1">
                              <h4 className="text-black mb-1">{event.title}</h4>
                              <p className="text-gray-600 text-sm">{event.location}</p>
                            </div>
                          </motion.div>
                        ))}
                      </div>
                    </motion.div>
                  </TabsContent>
                )}

                <TabsContent value="posts" className="mt-6">
                  <motion.div
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                    transition={{ delay: 0.6 }}
                    className="text-center py-12"
                  >
                    <div className="w-16 h-16 bg-gradient-to-br from-purple-100 to-pink-100 rounded-full flex items-center justify-center mx-auto mb-4">
                      <MessageCircle className="w-8 h-8 text-purple-600" />
                    </div>
                    <p className="text-gray-700">{user.poolPosts || 0} posts in the pool</p>
                    <p className="text-sm text-gray-500 mt-2">Share your thoughts with the community</p>
                  </motion.div>
                </TabsContent>
              </Tabs>
            </motion.div>
          </div>
        </ScrollArea>
      </div>
    </motion.div>
  );
}