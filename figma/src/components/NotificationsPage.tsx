import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { ArrowLeft, Heart, MessageCircle, Bookmark, Share2, Bell, CheckCheck } from 'lucide-react';
import { Avatar, AvatarFallback, AvatarImage } from './ui/avatar';
import { Button } from './ui/button';
import { ScrollArea } from './ui/scroll-area';

interface Notification {
  id: string;
  type: 'like' | 'comment' | 'share' | 'reminder';
  username: string;
  avatar: string;
  action: string;
  time: string;
  isUnread: boolean;
  thumbnail?: string;
  comment?: string;
  activityId?: string;
  activityTitle?: string;
}

interface NotificationsPageProps {
  onBack: () => void;
  onViewProfile: (username: string, avatar: string) => void;
}

export const NotificationsPage: React.FC<NotificationsPageProps> = ({ onBack, onViewProfile }) => {
  const [notifications, setNotifications] = useState<Notification[]>([
    {
      id: '1',
      type: 'like',
      username: '@helena_wanderlust',
      avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      action: 'liked your post about hiking',
      time: '2m',
      isUnread: true,
      thumbnail: 'https://images.unsplash.com/photo-1551632811-561632d1e306?w=100&h=100&fit=crop',
    },
    {
      id: '2',
      type: 'comment',
      username: '@daniel_explorer',
      avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100',
      action: 'commented on your activity',
      comment: 'Count me in! This looks amazing 🔥',
      time: '15m',
      isUnread: true,
    },
    {
      id: '3',
      type: 'reminder',
      username: '',
      avatar: '',
      action: 'Hiking in George Bass starts tomorrow at 7:00 AM',
      time: '1h',
      isUnread: true,
      activityId: 'TRI-0001',
      activityTitle: 'Hiking in George Bass',
    },
    {
      id: '4',
      type: 'share',
      username: '@sarah_m',
      avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100',
      action: 'shared your activity',
      time: '3h',
      isUnread: false,
      activityId: 'SPT-0004',
      activityTitle: 'Basketball Pickup Game',
    },
    {
      id: '5',
      type: 'like',
      username: '@nebulanomad',
      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      action: 'liked your comment',
      time: '5h',
      isUnread: false,
    },
    {
      id: '6',
      type: 'comment',
      username: '@emberecho',
      avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100',
      action: 'replied to your comment',
      comment: 'Totally agree! See you there 🎨',
      time: '1d',
      isUnread: false,
    },
    {
      id: '7',
      type: 'reminder',
      username: '',
      avatar: '',
      action: 'Board Game Night starts in 2 hours',
      time: '1d',
      isUnread: false,
      activityId: 'BOA-0002',
      activityTitle: 'Board Game Night',
    },
    {
      id: '8',
      type: 'share',
      username: '@lunavoyager',
      avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100',
      action: 'shared your post to their story',
      time: '2d',
      isUnread: false,
    },
  ]);

  const handleReadAll = () => {
    setNotifications(notifications.map(n => ({ ...n, isUnread: false })));
  };

  const getNotificationIcon = (type: string) => {
    switch (type) {
      case 'like':
        return <Heart className="w-5 h-5 text-white" fill="currentColor" />;
      case 'comment':
        return <MessageCircle className="w-5 h-5 text-white" />;
      case 'share':
        return <Share2 className="w-5 h-5 text-white" />;
      case 'reminder':
        return <Bell className="w-5 h-5 text-white" />;
      default:
        return null;
    }
  };

  const getIconGradient = (type: string) => {
    switch (type) {
      case 'like':
        return 'from-red-500 to-pink-500';
      case 'comment':
        return 'from-blue-500 to-cyan-500';
      case 'share':
        return 'from-green-500 to-emerald-500';
      case 'reminder':
        return 'from-orange-500 to-amber-500';
      default:
        return 'from-gray-500 to-gray-600';
    }
  };

  const unreadCount = notifications.filter(n => n.isUnread).length;

  return (
    <motion.div
      initial={{ opacity: 0, x: "100%" }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: "100%" }}
      transition={{ duration: 0.3, ease: "easeOut" }}
      className="fixed inset-0 z-[100] bg-gray-50"
    >
      <div className="fixed inset-0 max-w-md mx-auto bg-gray-50">
        <ScrollArea className="h-full">
          {/* Header - Gradient Background Section */}
          <div className="relative bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-500 overflow-hidden">
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
                onClick={onBack}
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
                Notifications
              </motion.h1>
              {unreadCount > 0 ? (
                <motion.button
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  transition={{ delay: 0.15, type: "spring", stiffness: 200 }}
                  whileHover={{ scale: 1.1, backgroundColor: "rgba(255,255,255,0.15)" }}
                  whileTap={{ scale: 0.9 }}
                  onClick={handleReadAll}
                  className="p-2.5 -mr-2 hover:bg-white/10 rounded-full transition-all"
                >
                  <CheckCheck className="w-6 h-6 text-white" />
                </motion.button>
              ) : (
                <div className="w-10" />
              )}
            </div>

            {/* Stats Card */}
            {unreadCount > 0 && (
              <motion.div
                initial={{ opacity: 0, y: 30, scale: 0.9 }}
                animate={{ opacity: 1, y: 0, scale: 1 }}
                transition={{ delay: 0.15, type: "spring", stiffness: 200, damping: 20 }}
                className="relative z-10 mx-5 mb-6 p-6 bg-white/15 backdrop-blur-xl rounded-[32px] shadow-2xl border border-white/20"
              >
                {/* Decorative elements */}
                <div className="absolute top-0 right-0 w-32 h-32 bg-gradient-to-br from-white/20 to-transparent rounded-full blur-2xl" />
                
                <div className="relative flex items-center justify-between">
                  <div>
                    <p className="text-white/80 text-sm mb-1">Unread Notifications</p>
                    <h2 className="text-white text-3xl">{unreadCount}</h2>
                  </div>
                  <motion.div
                    animate={{ rotate: [0, -10, 10, -10, 0] }}
                    transition={{ duration: 0.5, delay: 0.3 }}
                    className="p-4 bg-white/20 rounded-2xl backdrop-blur-sm"
                  >
                    <Bell className="w-8 h-8 text-white" />
                  </motion.div>
                </div>
              </motion.div>
            )}

            {/* Curved bottom edge */}
            <div className="relative h-8 overflow-hidden">
              <div className="absolute inset-x-0 bottom-0 h-16 bg-gray-50 rounded-t-[40px]" />
            </div>
          </div>

          {/* Notifications List */}
          <div className="px-5 py-6 pb-32 space-y-3">
            {notifications.map((notification, index) => (
              <motion.div
                key={notification.id}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.3 + index * 0.05, type: "spring" }}
                whileHover={{ scale: 1.02, y: -2 }}
                whileTap={{ scale: 0.98 }}
                className={`p-4 rounded-3xl border transition-all cursor-pointer ${
                  notification.isUnread
                    ? 'bg-gradient-to-br from-blue-50 to-purple-50 border-blue-200 shadow-md'
                    : 'bg-white border-gray-100 shadow-md hover:shadow-xl'
                }`}
              >
                <div className="flex gap-4">
                  {/* Icon or Avatar */}
                  <div className="flex-shrink-0 relative">
                    {notification.type === 'reminder' ? (
                      <motion.div
                        whileHover={{ rotate: 5 }}
                        className={`w-12 h-12 bg-gradient-to-br ${getIconGradient(notification.type)} rounded-2xl flex items-center justify-center shadow-lg`}
                      >
                        {getNotificationIcon(notification.type)}
                      </motion.div>
                    ) : (
                      <>
                        <motion.button
                          whileHover={{ scale: 1.05 }}
                          onClick={() => onViewProfile(notification.username, notification.avatar)}
                          className="block"
                        >
                          <Avatar className="w-12 h-12 border-2 border-white shadow-md">
                            <AvatarImage src={notification.avatar} />
                            <AvatarFallback>{notification.username.slice(1, 3).toUpperCase()}</AvatarFallback>
                          </Avatar>
                        </motion.button>
                        <motion.div
                          initial={{ scale: 0 }}
                          animate={{ scale: 1 }}
                          transition={{ delay: 0.4 + index * 0.05, type: "spring", stiffness: 300 }}
                          className={`absolute -bottom-1 -right-1 bg-gradient-to-br ${getIconGradient(notification.type)} rounded-full p-1.5 shadow-lg`}
                        >
                          {getNotificationIcon(notification.type)}
                        </motion.div>
                      </>
                    )}
                  </div>

                  {/* Content */}
                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between gap-2 mb-1">
                      <div className="flex-1">
                        {notification.type === 'reminder' ? (
                          <p className="text-sm text-gray-900">
                            <span className="text-black">
                              {notification.action}
                            </span>
                          </p>
                        ) : (
                          <p className="text-sm text-gray-900">
                            <button
                              onClick={() => onViewProfile(notification.username, notification.avatar)}
                              className="text-black hover:underline"
                            >
                              {notification.username}
                            </button>{' '}
                            <span className="text-gray-600">{notification.action}</span>
                          </p>
                        )}
                      </div>
                      <span className="text-xs text-gray-500 whitespace-nowrap">
                        {notification.time}
                      </span>
                    </div>
                    
                    {notification.comment && (
                      <motion.p
                        initial={{ opacity: 0, y: 5 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: 0.5 + index * 0.05 }}
                        className="text-sm text-gray-700 mt-2 bg-white/60 backdrop-blur-sm p-3 rounded-2xl border border-gray-100"
                      >
                        {notification.comment}
                      </motion.p>
                    )}
                    
                    {notification.activityTitle && (
                      <div className="flex items-center gap-2 mt-2">
                        <span className="text-xs font-mono text-purple-600 bg-purple-50 px-2 py-1 rounded-lg">
                          {notification.activityId}
                        </span>
                        <span className="text-xs text-gray-600">
                          {notification.activityTitle}
                        </span>
                      </div>
                    )}
                  </div>

                  {/* Thumbnail */}
                  {notification.thumbnail && (
                    <motion.div
                      whileHover={{ scale: 1.05 }}
                      className="flex-shrink-0"
                    >
                      <img
                        src={notification.thumbnail}
                        alt="Post thumbnail"
                        className="w-16 h-16 rounded-2xl object-cover shadow-md"
                      />
                    </motion.div>
                  )}
                </div>
              </motion.div>
            ))}
          </div>

          {/* Empty State */}
          {notifications.length === 0 && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
              className="flex flex-col items-center justify-center py-20 px-6 text-center"
            >
              <div className="w-24 h-24 bg-gradient-to-br from-purple-100 to-pink-100 rounded-full flex items-center justify-center mb-6 shadow-lg">
                <Bell className="w-12 h-12 text-purple-600" />
              </div>
              <h3 className="text-black text-lg mb-2">No notifications yet</h3>
              <p className="text-gray-600">
                When someone likes, comments, or shares your posts, you'll see it here
              </p>
            </motion.div>
          )}
        </ScrollArea>
      </div>
    </motion.div>
  );
};
