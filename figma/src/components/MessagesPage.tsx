import { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { ArrowLeft, Users, MessageCircle, Search, MessageSquarePlus, UserPlus, UsersRound, ChevronDown, ChevronUp } from 'lucide-react';
import { ChatDetail } from './ChatDetail';
import { ScrollArea } from './ui/scroll-area';
import { Avatar, AvatarFallback, AvatarImage } from './ui/avatar';

interface Chat {
  id: string;
  name: string;
  avatar?: string;
  lastMessage: string;
  time: string;
  isUnread: boolean;
  isGroup: boolean;
  participants?: number;
  onlineCount?: number;
}

interface MessagesPageProps {
  onBack: () => void;
  onViewProfile: (username: string, avatar: string) => void;
}

export const MessagesPage: React.FC<MessagesPageProps> = ({ onBack, onViewProfile }) => {
  const [selectedChat, setSelectedChat] = useState<Chat | null>(null);
  const [showNewChatMenu, setShowNewChatMenu] = useState(false);
  const [isGroupChatsCollapsed, setIsGroupChatsCollapsed] = useState(false);
  const [isDirectMessagesCollapsed, setIsDirectMessagesCollapsed] = useState(false);

  // Group chats (5)
  const groupChats: Chat[] = [
    {
      id: 'g1',
      name: 'Hiking in George Bass',
      avatar: 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=100&h=100&fit=crop',
      lastMessage: 'Perfect! Just paid my share 💸',
      time: '2m',
      isUnread: true,
      isGroup: true,
      participants: 7,
      onlineCount: 7,
    },
    {
      id: 'g2',
      name: 'Beach Volleyball Squad',
      avatar: 'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=100&h=100&fit=crop',
      lastMessage: 'Same time next week?',
      time: '1h',
      isUnread: false,
      isGroup: true,
      participants: 8,
      onlineCount: 3,
    },
    {
      id: 'g3',
      name: 'Weekend Warriors',
      avatar: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=100&h=100&fit=crop',
      lastMessage: 'Who\'s in for the camping trip?',
      time: '3h',
      isUnread: true,
      isGroup: true,
      participants: 12,
      onlineCount: 5,
    },
    {
      id: 'g4',
      name: 'Morning Run Club',
      avatar: 'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=100&h=100&fit=crop',
      lastMessage: '6 AM tomorrow at the park',
      time: '5h',
      isUnread: false,
      isGroup: true,
      participants: 6,
      onlineCount: 2,
    },
    {
      id: 'g5',
      name: 'Foodies Adventure',
      avatar: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=100&h=100&fit=crop',
      lastMessage: 'Found an amazing new restaurant!',
      time: '1d',
      isUnread: false,
      isGroup: true,
      participants: 10,
      onlineCount: 0,
    },
  ];

  // Private chats (3)
  const privateChats: Chat[] = [
    {
      id: 'p1',
      name: 'Sarah Johnson',
      avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop',
      lastMessage: 'See you at the event tomorrow!',
      time: '30m',
      isUnread: true,
      isGroup: false,
    },
    {
      id: 'p2',
      name: 'Mike Chen',
      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
      lastMessage: 'Thanks for the recommendation 👍',
      time: '2h',
      isUnread: false,
      isGroup: false,
    },
    {
      id: 'p3',
      name: 'Emma Wilson',
      avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop',
      lastMessage: 'That hiking trail was amazing!',
      time: '1d',
      isUnread: false,
      isGroup: false,
    },
  ];

  const allChats = [...groupChats, ...privateChats];
  const unreadCount = allChats.filter(c => c.isUnread).length;

  if (selectedChat) {
    return (
      <ChatDetail 
        chat={selectedChat} 
        onBack={() => setSelectedChat(null)} 
      />
    );
  }

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
                Messages
              </motion.h1>
              <div className="flex items-center gap-1">
                <motion.button
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  transition={{ delay: 0.15, type: "spring", stiffness: 200 }}
                  whileHover={{ scale: 1.1, backgroundColor: "rgba(255,255,255,0.15)" }}
                  whileTap={{ scale: 0.9 }}
                  className="p-2.5 hover:bg-white/10 rounded-full transition-all"
                >
                  <Search className="w-6 h-6 text-white" />
                </motion.button>
                <motion.button
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  transition={{ delay: 0.2, type: "spring", stiffness: 200 }}
                  whileHover={{ scale: 1.1, backgroundColor: "rgba(255,255,255,0.15)" }}
                  whileTap={{ scale: 0.9 }}
                  onClick={() => setShowNewChatMenu(!showNewChatMenu)}
                  className="p-2.5 -mr-2 hover:bg-white/10 rounded-full transition-all relative"
                >
                  <MessageSquarePlus className="w-6 h-6 text-white" />
                </motion.button>
              </div>
            </div>

            {/* Stats Cards */}
            <div className="relative z-10 mx-5 pb-6 grid grid-cols-2 gap-2.5">
              <motion.div
                initial={{ opacity: 0, y: 30, scale: 0.9 }}
                animate={{ opacity: 1, y: 0, scale: 1 }}
                transition={{ delay: 0.15, type: "spring", stiffness: 200, damping: 20 }}
                className="p-2.5 bg-white/15 backdrop-blur-xl rounded-[18px] shadow-2xl border border-white/20"
              >
                <div className="flex items-center gap-2 mb-1">
                  <motion.div
                    whileHover={{ rotate: 5 }}
                    className="p-1.5 bg-white/20 rounded-lg backdrop-blur-sm"
                  >
                    <Users className="w-3.5 h-3.5 text-white" />
                  </motion.div>
                  <span className="text-white/80 text-[11px]">Groups</span>
                </div>
                <p className="text-white text-lg pl-0.5">{groupChats.length}</p>
              </motion.div>

              <motion.div
                initial={{ opacity: 0, y: 30, scale: 0.9 }}
                animate={{ opacity: 1, y: 0, scale: 1 }}
                transition={{ delay: 0.2, type: "spring", stiffness: 200, damping: 20 }}
                className="p-2.5 bg-white/15 backdrop-blur-xl rounded-[18px] shadow-2xl border border-white/20"
              >
                <div className="flex items-center gap-2 mb-1">
                  <motion.div
                    animate={unreadCount > 0 ? { rotate: [0, -10, 10, -10, 0] } : {}}
                    transition={{ duration: 0.5, delay: 0.3 }}
                    whileHover={{ rotate: 5 }}
                    className="p-1.5 bg-white/20 rounded-lg backdrop-blur-sm"
                  >
                    <MessageCircle className="w-3.5 h-3.5 text-white" />
                  </motion.div>
                  <span className="text-white/80 text-[11px]">Unread</span>
                </div>
                <p className="text-white text-lg pl-0.5">{unreadCount}</p>
              </motion.div>
            </div>
          </div>

          {/* Messages List */}
          <div className="px-5 py-5 pb-32">
            {/* Group Chats Section */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.25 }}
              className="mb-6"
            >
              <div className="flex items-center justify-between mb-4 px-2">
                <h2 className="text-gray-500 text-sm uppercase tracking-wide">
                  Group Chats
                </h2>
                <motion.button
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  onClick={() => setIsGroupChatsCollapsed(!isGroupChatsCollapsed)}
                  className="p-2 -mr-2 hover:bg-gray-100 rounded-full transition-colors"
                >
                  {isGroupChatsCollapsed ? (
                    <ChevronDown className="w-4 h-4 text-gray-500" />
                  ) : (
                    <ChevronUp className="w-4 h-4 text-gray-500" />
                  )}
                </motion.button>
              </div>
              <AnimatePresence>
                {!isGroupChatsCollapsed && (
                  <motion.div
                    initial={{ opacity: 0, height: 0 }}
                    animate={{ opacity: 1, height: "auto" }}
                    exit={{ opacity: 0, height: 0 }}
                    transition={{ duration: 0.3 }}
                    className="space-y-3 overflow-hidden"
                  >
                    {groupChats.map((chat, index) => (
                      <motion.button
                        key={chat.id}
                        initial={{ opacity: 0, x: -20 }}
                        animate={{ opacity: 1, x: 0 }}
                        exit={{ opacity: 0, x: -20 }}
                        transition={{ delay: index * 0.05, type: "spring" }}
                        whileHover={{ scale: 1.02, y: -2 }}
                        whileTap={{ scale: 0.98 }}
                        onClick={() => setSelectedChat(chat)}
                        className={`w-full flex items-center gap-4 p-4 rounded-3xl border transition-all text-left ${
                          chat.isUnread
                            ? 'bg-gradient-to-br from-blue-50 to-purple-50 border-blue-200 shadow-md'
                            : 'bg-white border-gray-100 shadow-md hover:shadow-xl'
                        }`}
                      >
                        {/* Avatar with Group Badge */}
                        <div className="relative flex-shrink-0">
                          <motion.img
                            whileHover={{ scale: 1.05 }}
                            src={chat.avatar}
                            alt={chat.name}
                            className="w-14 h-14 rounded-2xl object-cover shadow-md"
                          />
                          <motion.div
                            initial={{ scale: 0 }}
                            animate={{ scale: 1 }}
                            transition={{ delay: 0.4 + index * 0.05, type: "spring", stiffness: 300 }}
                            className="absolute -bottom-1 -right-1 w-7 h-7 bg-gradient-to-br from-blue-500 to-cyan-500 rounded-full flex items-center justify-center border-2 border-white shadow-lg"
                          >
                            <Users className="w-3.5 h-3.5 text-white" />
                          </motion.div>
                        </div>

                        {/* Content */}
                        <div className="flex-1 min-w-0">
                          <div className="flex items-baseline justify-between gap-2 mb-1">
                            <span className={`truncate ${chat.isUnread ? 'text-black' : 'text-gray-900'}`}>
                              {chat.name}
                            </span>
                            <span className="text-xs text-gray-500 flex-shrink-0">{chat.time}</span>
                          </div>
                          <p className={`text-sm truncate ${chat.isUnread ? 'text-gray-700' : 'text-gray-500'}`}>
                            {chat.lastMessage}
                          </p>
                          <div className="flex items-center gap-2 mt-1">
                            <span className="text-xs text-gray-400">
                              {chat.participants} participants
                            </span>
                            {chat.onlineCount && chat.onlineCount > 0 ? (
                              <>
                                <span className="text-xs text-gray-300">•</span>
                                <span className="text-xs text-green-600">
                                  {chat.onlineCount} online
                                </span>
                              </>
                            ) : null}
                          </div>
                        </div>

                        {/* Unread indicator */}
                        {chat.isUnread && (
                          <motion.div
                            initial={{ scale: 0 }}
                            animate={{ scale: 1 }}
                            transition={{ delay: 0.5 + index * 0.05, type: "spring", stiffness: 300 }}
                            className="w-3 h-3 bg-gradient-to-br from-blue-500 to-purple-500 rounded-full shadow-lg flex-shrink-0"
                          />
                        )}
                      </motion.button>
                    ))}
                  </motion.div>
                )}
              </AnimatePresence>
            </motion.div>

            {/* Private Chats Section */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.5 }}
            >
              <div className="flex items-center justify-between mb-4 px-2">
                <h2 className="text-gray-500 text-sm uppercase tracking-wide">
                  Direct Messages
                </h2>
                <motion.button
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  onClick={() => setIsDirectMessagesCollapsed(!isDirectMessagesCollapsed)}
                  className="p-2 -mr-2 hover:bg-gray-100 rounded-full transition-colors"
                >
                  {isDirectMessagesCollapsed ? (
                    <ChevronDown className="w-4 h-4 text-gray-500" />
                  ) : (
                    <ChevronUp className="w-4 h-4 text-gray-500" />
                  )}
                </motion.button>
              </div>
              <AnimatePresence>
                {!isDirectMessagesCollapsed && (
                  <motion.div
                    initial={{ opacity: 0, height: 0 }}
                    animate={{ opacity: 1, height: "auto" }}
                    exit={{ opacity: 0, height: 0 }}
                    transition={{ duration: 0.3 }}
                    className="space-y-3 overflow-hidden"
                  >
                    {privateChats.map((chat, index) => (
                      <motion.button
                        key={chat.id}
                        initial={{ opacity: 0, x: -20 }}
                        animate={{ opacity: 1, x: 0 }}
                        transition={{ delay: 0.55 + index * 0.05, type: "spring" }}
                        whileHover={{ scale: 1.02, y: -2 }}
                        whileTap={{ scale: 0.98 }}
                        onClick={() => setSelectedChat(chat)}
                        className={`w-full flex items-center gap-4 p-4 rounded-3xl border transition-all text-left ${
                          chat.isUnread
                            ? 'bg-gradient-to-br from-blue-50 to-purple-50 border-blue-200 shadow-md'
                            : 'bg-white border-gray-100 shadow-md hover:shadow-xl'
                        }`}
                      >
                        {/* Avatar */}
                        <div className="relative flex-shrink-0">
                          <motion.img
                            whileHover={{ scale: 1.05 }}
                            src={chat.avatar}
                            alt={chat.name}
                            className="w-14 h-14 rounded-2xl object-cover shadow-md border-2 border-white"
                          />
                          {/* Online status */}
                          <motion.div
                            initial={{ scale: 0 }}
                            animate={{ scale: 1 }}
                            transition={{ delay: 0.6 + index * 0.05, type: "spring", stiffness: 300 }}
                            className="absolute -bottom-1 -right-1 w-4 h-4 bg-green-500 rounded-full border-2 border-white shadow-lg"
                          />
                        </div>

                        {/* Content */}
                        <div className="flex-1 min-w-0">
                          <div className="flex items-baseline justify-between gap-2 mb-1">
                            <span className={`truncate ${chat.isUnread ? 'text-black' : 'text-gray-900'}`}>
                              {chat.name}
                            </span>
                            <span className="text-xs text-gray-500 flex-shrink-0">{chat.time}</span>
                          </div>
                          <p className={`text-sm truncate ${chat.isUnread ? 'text-gray-700' : 'text-gray-500'}`}>
                            {chat.lastMessage}
                          </p>
                        </div>

                        {/* Unread indicator */}
                        {chat.isUnread && (
                          <motion.div
                            initial={{ scale: 0 }}
                            animate={{ scale: 1 }}
                            transition={{ delay: 0.65 + index * 0.05, type: "spring", stiffness: 300 }}
                            className="w-3 h-3 bg-gradient-to-br from-blue-500 to-purple-500 rounded-full shadow-lg flex-shrink-0"
                          />
                        )}
                      </motion.button>
                    ))}
                  </motion.div>
                )}
              </AnimatePresence>
            </motion.div>
          </div>
        </ScrollArea>
      </div>

      {/* New Chat Menu */}
      <AnimatePresence>
        {showNewChatMenu && (
          <>
            {/* Backdrop */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setShowNewChatMenu(false)}
              className="fixed inset-0 bg-black/20 backdrop-blur-sm z-[60]"
            />
            
            {/* Menu Card */}
            <motion.div
              initial={{ opacity: 0, scale: 0.9, y: -10 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.9, y: -10 }}
              transition={{ type: "spring", stiffness: 300, damping: 25 }}
              className="fixed top-[72px] right-4 z-[70] bg-white/95 backdrop-blur-xl rounded-3xl shadow-2xl border border-gray-100 overflow-hidden max-w-md mx-auto"
            >
              <div className="p-3 space-y-2 min-w-[200px]">
                <motion.button
                  whileHover={{ scale: 1.02, x: 4 }}
                  whileTap={{ scale: 0.98 }}
                  onClick={() => {
                    setShowNewChatMenu(false);
                    // Handle new chat logic
                  }}
                  className="w-full flex items-center gap-3 p-3 rounded-2xl hover:bg-gradient-to-br hover:from-blue-50 hover:to-purple-50 transition-all text-left"
                >
                  <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-cyan-500 rounded-xl flex items-center justify-center"
                  >
                    <UserPlus className="w-5 h-5 text-white" />
                  </div>
                  <div>
                    <p className="text-sm text-black">New Chat</p>
                    <p className="text-xs text-gray-500">Start conversation</p>
                  </div>
                </motion.button>

                <motion.button
                  whileHover={{ scale: 1.02, x: 4 }}
                  whileTap={{ scale: 0.98 }}
                  onClick={() => {
                    setShowNewChatMenu(false);
                    // Handle new group chat logic
                  }}
                  className="w-full flex items-center gap-3 p-3 rounded-2xl hover:bg-gradient-to-br hover:from-purple-50 hover:to-pink-50 transition-all text-left"
                >
                  <div className="w-10 h-10 bg-gradient-to-br from-purple-500 to-pink-500 rounded-xl flex items-center justify-center">
                    <UsersRound className="w-5 h-5 text-white" />
                  </div>
                  <div>
                    <p className="text-sm text-black">New Group</p>
                    <p className="text-xs text-gray-500">Create group chat</p>
                  </div>
                </motion.button>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </motion.div>
  );
};