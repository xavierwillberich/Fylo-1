import { useState } from "react";
import { motion, AnimatePresence } from "motion/react";
import {
  ArrowLeft,
  User,
  Bell,
  Lock,
  Globe,
  Palette,
  HelpCircle,
  Shield,
  CreditCard,
  LogOut,
  ChevronRight,
  Moon,
  Sun,
  Languages,
  Volume2,
  Eye,
  MapPin,
  Heart,
  Users,
  Mail,
  Smartphone,
  Check,
  Camera,
  Save,
  Trash2,
  Ban,
  MessageCircle,
  Star,
  Info,
} from "lucide-react";
import { ScrollArea } from "./ui/scroll-area";
import { Separator } from "./ui/separator";
import { Avatar, AvatarFallback, AvatarImage } from "./ui/avatar";
import { Switch } from "./ui/switch";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Textarea } from "./ui/textarea";

interface SettingsPageProps {
  onClose: () => void;
  user: {
    name: string;
    username: string;
    avatar: string;
    email?: string;
  };
  darkMode: boolean;
  onToggleDarkMode: (value: boolean) => void;
}

export function SettingsPage({ onClose, user, darkMode, onToggleDarkMode }: SettingsPageProps) {
  const [pushNotifications, setPushNotifications] = useState(true);
  const [emailNotifications, setEmailNotifications] = useState(true);
  const [activityReminders, setActivityReminders] = useState(true);
  const [newFollowers, setNewFollowers] = useState(true);
  const [soundEffects, setSoundEffects] = useState(true);
  const [locationSharing, setLocationSharing] = useState(true);
  const [profileVisibility, setProfileVisibility] = useState(true);
  const [showOnlineStatus, setShowOnlineStatus] = useState(true);

  const [showLanguageModal, setShowLanguageModal] = useState(false);
  const [selectedLanguage, setSelectedLanguage] = useState('English');
  
  // Sub-page states
  const [currentSubPage, setCurrentSubPage] = useState<string | null>(null);

  const languages = [
    { code: 'en', name: 'English', nativeName: 'English' },
    { code: 'zh', name: 'Chinese', nativeName: '中文' },
    { code: 'es', name: 'Spanish', nativeName: 'Español' },
    { code: 'fr', name: 'French', nativeName: 'Français' },
    { code: 'de', name: 'German', nativeName: 'Deutsch' },
    { code: 'ja', name: 'Japanese', nativeName: '日本語' },
    { code: 'ko', name: 'Korean', nativeName: '한국어' },
  ];

  const settingsSections = [
    {
      title: 'Account',
      items: [
        { icon: User, label: 'Edit Profile', description: 'Name, bio, avatar', color: 'text-blue-600', bgColor: 'bg-blue-50', action: () => setCurrentSubPage('edit-profile') },
        { icon: Mail, label: 'Email', description: user.email || 'Add email address', color: 'text-green-600', bgColor: 'bg-green-50', action: () => setCurrentSubPage('email') },
        { icon: Smartphone, label: 'Phone Number', description: 'Verify your phone', color: 'text-purple-600', bgColor: 'bg-purple-50', action: () => setCurrentSubPage('phone') },
        { icon: Lock, label: 'Change Password', description: 'Update your password', color: 'text-red-600', bgColor: 'bg-red-50', action: () => setCurrentSubPage('password') },
      ],
    },
    {
      title: 'Privacy & Security',
      items: [
        { icon: Shield, label: 'Privacy Settings', description: 'Control who sees your info', color: 'text-indigo-600', bgColor: 'bg-indigo-50', action: () => setCurrentSubPage('privacy') },
        { icon: Eye, label: 'Blocked Users', description: 'Manage blocked accounts', color: 'text-gray-600', bgColor: 'bg-gray-50', action: () => setCurrentSubPage('blocked') },
        { icon: MapPin, label: 'Location Services', description: locationSharing ? 'Enabled' : 'Disabled', color: 'text-orange-600', bgColor: 'bg-orange-50', toggle: true, value: locationSharing, onChange: setLocationSharing },
      ],
    },
    {
      title: 'Preferences',
      items: [
        { icon: Languages, label: 'Language', description: selectedLanguage, color: 'text-teal-600', bgColor: 'bg-teal-50', action: () => setShowLanguageModal(true) },
        { icon: Volume2, label: 'Sound Effects', description: soundEffects ? 'On' : 'Off', color: 'text-pink-600', bgColor: 'bg-pink-50', toggle: true, value: soundEffects, onChange: setSoundEffects },
        { icon: Palette, label: 'Appearance', description: darkMode ? 'Dark Mode' : 'Light Mode', color: 'text-yellow-600', bgColor: 'bg-yellow-50', toggle: true, value: darkMode, onChange: onToggleDarkMode },
      ],
    },
    {
      title: 'Support',
      items: [
        { icon: HelpCircle, label: 'Help Center', description: 'FAQs and support', color: 'text-cyan-600', bgColor: 'bg-cyan-50', action: () => setCurrentSubPage('help') },
        { icon: Users, label: 'Community Guidelines', description: 'Learn our rules', color: 'text-violet-600', bgColor: 'bg-violet-50', action: () => setCurrentSubPage('guidelines') },
        { icon: Heart, label: 'Rate Us', description: 'Share your feedback', color: 'text-rose-600', bgColor: 'bg-rose-50', action: () => setCurrentSubPage('rate') },
      ],
    },
  ];

  return (
    <>
      <motion.div
        initial={{ opacity: 0, x: "100%" }}
        animate={{ opacity: 1, x: 0 }}
        exit={{ opacity: 0, x: "100%" }}
        transition={{ duration: 0.3, ease: "easeOut" }}
        className="fixed inset-0 z-[150] bg-gray-50"
      >
        <div className="fixed inset-0 max-w-md mx-auto bg-gray-50">
          <ScrollArea className="h-full">
            {/* Header - Gradient Background Section */}
            <div className="relative bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-500 overflow-hidden rounded-b-[40px]">
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
                  Settings
                </motion.h1>
                <div className="w-10" />
              </div>

              {/* User Info Card - Glassmorphism Style */}
              <motion.div
                initial={{ opacity: 0, y: 30, scale: 0.9 }}
                animate={{ opacity: 1, y: 0, scale: 1 }}
                transition={{ delay: 0.15, type: "spring", stiffness: 200, damping: 20 }}
                className="relative z-10 mx-5 mb-6 p-6 bg-white/15 backdrop-blur-xl rounded-[32px] shadow-2xl border border-white/20"
              >
                {/* Decorative elements */}
                <div className="absolute top-0 right-0 w-32 h-32 bg-gradient-to-br from-white/20 to-transparent rounded-full blur-2xl" />
                <div className="absolute bottom-0 left-0 w-24 h-24 bg-gradient-to-tr from-white/20 to-transparent rounded-full blur-2xl" />

                <div className="relative flex items-center gap-4">
                  <motion.div
                    whileHover={{ scale: 1.05 }}
                    whileTap={{ scale: 0.95 }}
                  >
                    <Avatar className="w-16 h-16 border-2 border-white/30">
                      <AvatarImage src={user.avatar} />
                      <AvatarFallback>{user.name.substring(0, 2)}</AvatarFallback>
                    </Avatar>
                  </motion.div>
                  <div className="flex-1">
                    <h3 className="text-white text-lg">{user.name}</h3>
                    <p className="text-white/70 text-sm">@{user.username}</p>
                  </div>
                  <ChevronRight className="w-5 h-5 text-white/50" />
                </div>
              </motion.div>
            </div>

            {/* Content */}
            <div className="px-5 py-6 pb-32">
              {/* Notifications Section */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.2, type: "spring" }}
                className="mb-8"
              >
                <div className="flex items-center gap-3 mb-4">
                  <motion.div 
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    transition={{ delay: 0.25, type: "spring", stiffness: 200 }}
                    className="p-3 bg-gradient-to-br from-orange-500 to-pink-500 rounded-2xl shadow-lg"
                  >
                    <Bell className="w-5 h-5 text-white" />
                  </motion.div>
                  <h2 className="text-black text-lg">Notifications</h2>
                </div>

                <motion.div 
                  initial={{ opacity: 0, scale: 0.95 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: 0.3, type: "spring" }}
                  className="space-y-3 bg-white rounded-3xl p-5 shadow-lg border border-gray-100"
                >
                  {[
                    { label: 'Push Notifications', desc: 'Receive push notifications', value: pushNotifications, onChange: setPushNotifications },
                    { label: 'Email Notifications', desc: 'Get updates via email', value: emailNotifications, onChange: setEmailNotifications },
                    { label: 'Activity Reminders', desc: 'Upcoming event alerts', value: activityReminders, onChange: setActivityReminders },
                    { label: 'New Followers', desc: 'When someone follows you', value: newFollowers, onChange: setNewFollowers },
                  ].map((item, index) => (
                    <motion.div
                      key={item.label}
                      initial={{ opacity: 0, x: -20 }}
                      animate={{ opacity: 1, x: 0 }}
                      transition={{ delay: 0.35 + index * 0.05 }}
                    >
                      {index > 0 && <Separator className="my-3" />}
                      <div className="flex items-center justify-between">
                        <div>
                          <p className="text-black">{item.label}</p>
                          <p className="text-xs text-gray-500">{item.desc}</p>
                        </div>
                        <Switch checked={item.value} onCheckedChange={item.onChange} />
                      </div>
                    </motion.div>
                  ))}
                </motion.div>
              </motion.div>

              {/* Settings Sections */}
              {settingsSections.map((section, sectionIndex) => (
                <motion.div
                  key={section.title}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.5 + sectionIndex * 0.1, type: "spring" }}
                  className="mb-8"
                >
                  <h2 className="text-gray-500 text-sm uppercase tracking-wide mb-4 px-2">
                    {section.title}
                  </h2>

                  <div className="space-y-3">
                    {section.items.map((item, itemIndex) => {
                      const Icon = item.icon;
                      const isClickable = !item.toggle && item.action;
                      
                      const content = (
                        <>
                          <motion.div 
                            whileHover={{ rotate: 5 }}
                            className={`p-3 bg-gradient-to-br ${item.bgColor.replace('bg-', 'from-')} ${item.bgColor.replace('50', '100').replace('bg-', 'to-')} rounded-2xl shadow-lg`}
                          >
                            <Icon className={`w-5 h-5 ${item.color}`} />
                          </motion.div>
                          <div className="flex-1 min-w-0">
                            <p className="text-black">{item.label}</p>
                            <p className="text-sm text-gray-500 truncate">{item.description}</p>
                          </div>
                          {item.toggle ? (
                            <Switch
                              checked={item.value}
                              onCheckedChange={item.onChange}
                            />
                          ) : (
                            <ChevronRight className="w-5 h-5 text-gray-400" />
                          )}
                        </>
                      );
                      
                      return (
                        <motion.div
                          key={item.label}
                          initial={{ opacity: 0, x: -20 }}
                          animate={{ opacity: 1, x: 0 }}
                          transition={{ delay: 0.55 + sectionIndex * 0.1 + itemIndex * 0.05, type: "spring" }}
                        >
                          {isClickable ? (
                            <motion.button
                              whileHover={{ scale: 1.02, y: -2 }}
                              whileTap={{ scale: 0.98 }}
                              onClick={item.action}
                              className="w-full flex items-center gap-4 p-4 bg-white rounded-3xl border border-gray-100 shadow-md hover:shadow-xl transition-all text-left"
                            >
                              {content}
                            </motion.button>
                          ) : (
                            <motion.div
                              whileHover={!item.toggle ? { scale: 1.02, y: -2 } : {}}
                              className="w-full flex items-center gap-4 p-4 bg-white rounded-3xl border border-gray-100 shadow-md hover:shadow-xl transition-all"
                            >
                              {content}
                            </motion.div>
                          )}
                        </motion.div>
                      );
                    })}
                  </div>
                </motion.div>
              ))}

              {/* Danger Zone */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.9, type: "spring" }}
                className="mb-8"
              >
                <h2 className="text-gray-500 text-sm uppercase tracking-wide mb-4 px-2">
                  Danger Zone
                </h2>

                <motion.button
                  whileHover={{ scale: 1.02, y: -2 }}
                  whileTap={{ scale: 0.98 }}
                  className="w-full flex items-center gap-4 p-5 bg-gradient-to-br from-red-50 to-pink-50 rounded-3xl border border-red-200 shadow-lg hover:shadow-xl transition-all text-left"
                >
                  <motion.div 
                    whileHover={{ rotate: 5 }}
                    className="p-3 bg-gradient-to-br from-red-500 to-pink-500 rounded-2xl shadow-lg"
                  >
                    <LogOut className="w-5 h-5 text-white" />
                  </motion.div>
                  <div className="flex-1">
                    <p className="text-red-700">Log Out</p>
                    <p className="text-sm text-red-600">Sign out of your account</p>
                  </div>
                  <ChevronRight className="w-5 h-5 text-red-400" />
                </motion.button>
              </motion.div>

              {/* App Info */}
              <motion.div 
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 1 }}
                className="text-center text-sm text-gray-400 space-y-1"
              >
                <p>Social Activity App</p>
                <p>Version 1.0.0</p>
                <p className="text-xs">Made with ❤️ for connecting people</p>
              </motion.div>
            </div>
          </ScrollArea>
        </div>
      </motion.div>

      {/* Language Selection Modal */}
      <AnimatePresence>
        {showLanguageModal && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 z-[160] bg-black/50 backdrop-blur-sm flex items-end justify-center"
            onClick={() => setShowLanguageModal(false)}
          >
            <motion.div
              initial={{ y: "100%" }}
              animate={{ y: 0 }}
              exit={{ y: "100%" }}
              transition={{ type: "spring", damping: 30, stiffness: 300 }}
              className="w-full max-w-md bg-white rounded-t-[40px] p-6 pb-8 shadow-2xl"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="w-12 h-1.5 bg-gray-300 rounded-full mx-auto mb-6" />
              <h3 className="text-black text-xl mb-6">Select Language</h3>

              <div className="space-y-3 max-h-96 overflow-y-auto">
                {languages.map((lang, index) => (
                  <motion.button
                    key={lang.code}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: index * 0.05, type: "spring" }}
                    whileHover={{ scale: 1.02, x: 4 }}
                    whileTap={{ scale: 0.98 }}
                    onClick={() => {
                      setSelectedLanguage(lang.name);
                      setShowLanguageModal(false);
                    }}
                    className={`w-full flex items-center justify-between p-4 rounded-2xl transition-all ${
                      selectedLanguage === lang.name
                        ? 'bg-gradient-to-r from-teal-50 to-cyan-50 border-2 border-teal-400 shadow-lg'
                        : 'bg-gray-50 border-2 border-transparent hover:bg-gray-100'
                    }`}
                  >
                    <div className="text-left">
                      <p className="text-black">{lang.name}</p>
                      <p className="text-sm text-gray-500">{lang.nativeName}</p>
                    </div>
                    {selectedLanguage === lang.name && (
                      <motion.div
                        initial={{ scale: 0 }}
                        animate={{ scale: 1 }}
                        transition={{ type: "spring", stiffness: 300 }}
                        className="w-7 h-7 bg-gradient-to-br from-teal-500 to-cyan-500 rounded-full flex items-center justify-center shadow-lg"
                      >
                        <Check className="w-4 h-4 text-white" />
                      </motion.div>
                    )}
                  </motion.button>
                ))}
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Sub-Pages Modal */}
      <AnimatePresence>
        {currentSubPage && (
          <motion.div
            initial={{ opacity: 0, x: "100%" }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: "100%" }}
            transition={{ duration: 0.3, ease: "easeOut" }}
            className="fixed inset-0 z-[170] bg-gray-50"
          >
            <div className="fixed inset-0 max-w-md mx-auto bg-gray-50">
              <ScrollArea className="h-full">
                {/* Sub-page Header */}
                <div className="relative bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-500 overflow-hidden rounded-b-[40px]">
                  {/* Animated Background Blobs */}
                  <motion.div
                    animate={{ scale: [1, 1.2, 1], rotate: [0, 90, 0] }}
                    transition={{ duration: 20, repeat: Infinity, ease: "linear" }}
                    className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl"
                  />
                  <motion.div
                    animate={{ scale: [1.2, 1, 1.2], rotate: [0, -90, 0] }}
                    transition={{ duration: 15, repeat: Infinity, ease: "linear" }}
                    className="absolute bottom-0 left-0 w-64 h-64 bg-white/10 rounded-full blur-3xl"
                  />

                  {/* Header Bar */}
                  <div className="relative z-10 flex items-center justify-between px-5 py-5">
                    <motion.button
                      whileHover={{ scale: 1.1, backgroundColor: "rgba(255,255,255,0.15)" }}
                      whileTap={{ scale: 0.9 }}
                      onClick={() => setCurrentSubPage(null)}
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
                      {currentSubPage === 'edit-profile' && 'Edit Profile'}
                      {currentSubPage === 'blocked' && 'Blocked Users'}
                      {currentSubPage === 'privacy' && 'Privacy Settings'}
                      {currentSubPage === 'help' && 'Help Center'}
                      {currentSubPage === 'email' && 'Email Settings'}
                      {currentSubPage === 'phone' && 'Phone Number'}
                      {currentSubPage === 'password' && 'Change Password'}
                      {currentSubPage === 'guidelines' && 'Community Guidelines'}
                      {currentSubPage === 'rate' && 'Rate Us'}
                    </motion.h1>
                    <div className="w-10" />
                  </div>

                  <div className="h-4" />
                </div>

                {/* Sub-page Content */}
                <div className="px-5 py-6 pb-32">
                  {currentSubPage === 'edit-profile' && (
                    <motion.div
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      className="space-y-6"
                    >
                      {/* Avatar Section */}
                      <div className="flex justify-center">
                        <div className="relative">
                          <Avatar className="w-32 h-32 border-4 border-white shadow-2xl">
                            <AvatarImage src={user.avatar} />
                            <AvatarFallback>{user.name.substring(0, 2)}</AvatarFallback>
                          </Avatar>
                          <motion.button
                            whileHover={{ scale: 1.1 }}
                            whileTap={{ scale: 0.9 }}
                            className="absolute bottom-0 right-0 w-10 h-10 bg-gradient-to-br from-blue-500 to-cyan-500 rounded-full flex items-center justify-center shadow-lg border-4 border-white"
                          >
                            <Camera className="w-5 h-5 text-white" />
                          </motion.button>
                        </div>
                      </div>

                      {/* Form Fields */}
                      <div className="space-y-4">
                        <div>
                          <label className="text-sm text-gray-600 mb-2 block">Full Name</label>
                          <Input defaultValue={user.name} className="rounded-2xl" />
                        </div>

                        <div>
                          <label className="text-sm text-gray-600 mb-2 block">Username</label>
                          <Input defaultValue={user.username} className="rounded-2xl" />
                        </div>

                        <div>
                          <label className="text-sm text-gray-600 mb-2 block">Bio</label>
                          <Textarea 
                            defaultValue="Adventurer 🏔️ | Coffee lover ☕ | Weekend hiker"
                            className="rounded-2xl min-h-[100px] resize-none"
                          />
                        </div>

                        <div>
                          <label className="text-sm text-gray-600 mb-2 block">Location</label>
                          <Input defaultValue="San Francisco, CA" className="rounded-2xl" />
                        </div>
                      </div>

                      {/* Save Button */}
                      <Button className="w-full h-14 bg-gradient-to-r from-blue-500 to-cyan-500 hover:from-blue-600 hover:to-cyan-600 rounded-2xl shadow-lg">
                        <Save className="w-5 h-5 mr-2" />
                        Save Changes
                      </Button>
                    </motion.div>
                  )}

                  {currentSubPage === 'blocked' && (
                    <motion.div
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      className="space-y-4"
                    >
                      {[1, 2, 3].map((item, index) => (
                        <motion.div
                          key={item}
                          initial={{ opacity: 0, x: -20 }}
                          animate={{ opacity: 1, x: 0 }}
                          transition={{ delay: index * 0.1 }}
                          className="flex items-center justify-between p-4 bg-white rounded-3xl border border-gray-100 shadow-md"
                        >
                          <div className="flex items-center gap-3">
                            <Avatar className="w-12 h-12">
                              <AvatarImage src={`https://images.unsplash.com/photo-${1500000000000 + item}?w=100`} />
                              <AvatarFallback>U{item}</AvatarFallback>
                            </Avatar>
                            <div>
                              <p className="text-black">User {item}</p>
                              <p className="text-sm text-gray-500">@user{item}</p>
                            </div>
                          </div>
                          <motion.button
                            whileHover={{ scale: 1.05 }}
                            whileTap={{ scale: 0.95 }}
                            className="px-4 py-2 bg-red-50 text-red-600 rounded-full text-sm hover:bg-red-100 transition-colors"
                          >
                            Unblock
                          </motion.button>
                        </motion.div>
                      ))}
                      
                      {/* Empty State */}
                      <motion.div
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        transition={{ delay: 0.3 }}
                        className="text-center py-12"
                      >
                        <Ban className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                        <p className="text-gray-500">No more blocked users</p>
                      </motion.div>
                    </motion.div>
                  )}

                  {currentSubPage === 'privacy' && (
                    <motion.div
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      className="space-y-6"
                    >
                      <div className="bg-white rounded-3xl p-5 shadow-lg border border-gray-100 space-y-4">
                        <div className="flex items-center justify-between">
                          <div>
                            <p className="text-black">Profile Visibility</p>
                            <p className="text-xs text-gray-500">Make profile public</p>
                          </div>
                          <Switch checked={profileVisibility} onCheckedChange={setProfileVisibility} />
                        </div>
                        <Separator />
                        <div className="flex items-center justify-between">
                          <div>
                            <p className="text-black">Show Online Status</p>
                            <p className="text-xs text-gray-500">Let others see when you're online</p>
                          </div>
                          <Switch checked={showOnlineStatus} onCheckedChange={setShowOnlineStatus} />
                        </div>
                      </div>
                    </motion.div>
                  )}

                  {currentSubPage === 'help' && (
                    <motion.div
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      className="space-y-4"
                    >
                      {[
                        { title: 'Getting Started', desc: 'Learn the basics', icon: Info },
                        { title: 'Account Management', desc: 'Manage your account', icon: User },
                        { title: 'Privacy & Safety', desc: 'Stay safe on the platform', icon: Shield },
                        { title: 'Contact Support', desc: 'Get help from our team', icon: MessageCircle },
                      ].map((item, index) => {
                        const Icon = item.icon;
                        return (
                          <motion.button
                            key={item.title}
                            initial={{ opacity: 0, x: -20 }}
                            animate={{ opacity: 1, x: 0 }}
                            transition={{ delay: index * 0.1 }}
                            whileHover={{ scale: 1.02, y: -2 }}
                            whileTap={{ scale: 0.98 }}
                            className="w-full flex items-center gap-4 p-4 bg-white rounded-3xl border border-gray-100 shadow-md hover:shadow-xl transition-all text-left"
                          >
                            <div className="w-12 h-12 bg-gradient-to-br from-cyan-500 to-blue-500 rounded-2xl flex items-center justify-center shadow-lg">
                              <Icon className="w-6 h-6 text-white" />
                            </div>
                            <div className="flex-1">
                              <p className="text-black">{item.title}</p>
                              <p className="text-sm text-gray-500">{item.desc}</p>
                            </div>
                            <ChevronRight className="w-5 h-5 text-gray-400" />
                          </motion.button>
                        );
                      })}
                    </motion.div>
                  )}

                  {/* Placeholder for other sub-pages */}
                  {!['edit-profile', 'blocked', 'privacy', 'help'].includes(currentSubPage!) && (
                    <motion.div
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      className="text-center py-20"
                    >
                      <div className="w-20 h-20 bg-gradient-to-br from-purple-100 to-pink-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <Star className="w-10 h-10 text-purple-500" />
                      </div>
                      <h3 className="text-xl text-black mb-2">Coming Soon</h3>
                      <p className="text-gray-500">This feature is under development</p>
                    </motion.div>
                  )}
                </div>
              </ScrollArea>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
}