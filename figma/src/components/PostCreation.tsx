import { useState } from "react";
import { motion, AnimatePresence } from "motion/react";
import {
  ArrowLeft,
  Image as ImageIcon,
  Video,
  X,
  Globe,
  Users,
  Lock,
  Link2,
} from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "./ui/avatar";
import { Button } from "./ui/button";
import { Textarea } from "./ui/textarea";
import { RadioGroup, RadioGroupItem } from "./ui/radio-group";
import { Label } from "./ui/label";
import { Badge } from "./ui/badge";
import { ScrollArea } from "./ui/scroll-area";

interface PostCreationProps {
  onClose: () => void;
  onPost: (post: {
    text: string;
    images: string[];
    privacy: "worldwide" | "friends" | "private";
    relatedActivity?: string;
  }) => void;
}

export function PostCreation({ onClose, onPost }: PostCreationProps) {
  const [postText, setPostText] = useState("");
  const [selectedImages, setSelectedImages] = useState<string[]>([]);
  const [privacy, setPrivacy] = useState<"worldwide" | "friends" | "private">("worldwide");
  const [relatedActivity, setRelatedActivity] = useState<string | undefined>(undefined);

  const handlePost = () => {
    if (postText.trim() || selectedImages.length > 0) {
      onPost({
        text: postText,
        images: selectedImages,
        privacy,
        relatedActivity,
      });
      onClose();
    }
  };

  // Mock activities for linking
  const recentActivities = [
    { id: "TRI-0023", title: "Pink Lake 3 Days Tour" },
    { id: "TRI-0015", title: "Rattlesnake Ledge Morning Hike" },
    { id: "BOA-0008", title: "Weekly Board Game Night" },
  ];

  const privacyOptions = [
    {
      value: "worldwide",
      label: "Worldwide",
      description: "Anyone can see this post",
      icon: Globe,
      color: "text-blue-500",
      gradient: "from-blue-500 to-cyan-500",
    },
    {
      value: "friends",
      label: "Friends Only",
      description: "Only mutual followers can see",
      icon: Users,
      color: "text-green-500",
      gradient: "from-green-500 to-emerald-500",
    },
    {
      value: "private",
      label: "Private",
      description: "Only you can see this post",
      icon: Lock,
      color: "text-gray-500",
      gradient: "from-gray-500 to-gray-600",
    },
  ];

  return (
    <motion.div
      initial={{ opacity: 0, y: "100%" }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: "100%" }}
      transition={{ duration: 0.3, ease: "easeOut" }}
      className="fixed inset-0 z-[100] bg-gray-50"
    >
      <div className="fixed inset-0 max-w-md mx-auto bg-gray-50">
        <ScrollArea className="h-full">
          {/* Header - Gradient Background */}
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
                New Post
              </motion.h1>
              <motion.button
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                onClick={handlePost}
                disabled={!postText.trim() && selectedImages.length === 0}
                className={`px-4 py-2 rounded-2xl transition-all text-sm ${
                  !postText.trim() && selectedImages.length === 0
                    ? "bg-white/20 text-white/50 cursor-not-allowed"
                    : "bg-white text-purple-600 hover:shadow-lg"
                }`}
              >
                Post
              </motion.button>
            </div>

            {/* User Info Card */}
            <motion.div
              initial={{ opacity: 0, y: 20, scale: 0.9 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              transition={{ delay: 0.15, type: "spring", stiffness: 200, damping: 20 }}
              className="relative z-10 mx-5 mb-6 p-5 bg-white/15 backdrop-blur-xl rounded-[28px] shadow-2xl border border-white/20"
            >
              <div className="flex items-center gap-3">
                <motion.div whileHover={{ scale: 1.05 }}>
                  <Avatar className="w-14 h-14 border-2 border-white/40 shadow-lg">
                    <AvatarImage src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100" />
                    <AvatarFallback>AC</AvatarFallback>
                  </Avatar>
                </motion.div>
                <div>
                  <p className="text-white">Alice Chen</p>
                  <p className="text-sm text-white/70">@alice_chen</p>
                </div>
              </div>
            </motion.div>

            {/* Curved bottom edge */}
            <div className="relative h-8 overflow-hidden">
              <div className="absolute inset-x-0 bottom-0 h-16 bg-gray-50 rounded-t-[40px]" />
            </div>
          </div>

          {/* Content */}
          <div className="p-5 pb-32 space-y-6">
            {/* Post Text */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2 }}
              className="bg-white rounded-3xl p-5 shadow-md border border-gray-100"
            >
              <Textarea
                placeholder="What's on your mind?"
                value={postText}
                onChange={(e) => setPostText(e.target.value)}
                className="min-h-[150px] resize-none border-none text-lg p-0 focus-visible:ring-0 bg-transparent"
              />
            </motion.div>

            {/* Selected Images Preview */}
            <AnimatePresence>
              {selectedImages.length > 0 && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: "auto" }}
                  exit={{ opacity: 0, height: 0 }}
                  className="grid grid-cols-3 gap-3"
                >
                  {selectedImages.map((image, idx) => (
                    <motion.div
                      key={idx}
                      initial={{ opacity: 0, scale: 0.8 }}
                      animate={{ opacity: 1, scale: 1 }}
                      exit={{ opacity: 0, scale: 0.8 }}
                      transition={{ delay: idx * 0.05 }}
                      className="relative aspect-square rounded-2xl overflow-hidden shadow-md"
                    >
                      <img src={image} alt={`Selected ${idx + 1}`} className="w-full h-full object-cover" />
                      <motion.button
                        whileHover={{ scale: 1.1 }}
                        whileTap={{ scale: 0.9 }}
                        onClick={() => setSelectedImages(selectedImages.filter((_, i) => i !== idx))}
                        className="absolute top-2 right-2 w-7 h-7 bg-black/70 backdrop-blur-sm rounded-full flex items-center justify-center hover:bg-black/90 transition-all shadow-lg"
                      >
                        <X className="w-4 h-4 text-white" />
                      </motion.button>
                    </motion.div>
                  ))}
                </motion.div>
              )}
            </AnimatePresence>

            {/* Privacy Settings */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
              className="space-y-3"
            >
              <h3 className="text-gray-700 text-sm px-2">Who can see this post?</h3>
              <RadioGroup value={privacy} onValueChange={(v) => setPrivacy(v as any)}>
                {privacyOptions.map((option, idx) => {
                  const Icon = option.icon;
                  const isSelected = privacy === option.value;
                  return (
                    <motion.div
                      key={option.value}
                      initial={{ opacity: 0, x: -20 }}
                      animate={{ opacity: 1, x: 0 }}
                      transition={{ delay: 0.35 + idx * 0.05 }}
                      whileHover={{ scale: 1.02 }}
                      className={`flex items-center space-x-3 p-4 rounded-3xl transition-all cursor-pointer ${
                        isSelected
                          ? "bg-gradient-to-br from-blue-50 to-purple-50 border-2 border-blue-300 shadow-md"
                          : "bg-white border-2 border-gray-100 hover:border-gray-300 shadow-md"
                      }`}
                    >
                      <RadioGroupItem value={option.value} id={option.value} />
                      <Label htmlFor={option.value} className="flex items-center gap-3 flex-1 cursor-pointer">
                        <motion.div
                          whileHover={{ rotate: 5 }}
                          className={`p-2.5 rounded-2xl ${
                            isSelected ? `bg-gradient-to-br ${option.gradient}` : "bg-gray-100"
                          }`}
                        >
                          <Icon className={`w-5 h-5 ${isSelected ? "text-white" : option.color}`} />
                        </motion.div>
                        <div className="flex-1">
                          <p className="text-black">{option.label}</p>
                          <p className="text-sm text-gray-500">{option.description}</p>
                        </div>
                      </Label>
                    </motion.div>
                  );
                })}
              </RadioGroup>
            </motion.div>

            {/* Link to Activity */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.5 }}
              className="space-y-3"
            >
              <h3 className="text-gray-700 text-sm px-2 flex items-center gap-2">
                <Link2 className="w-4 h-4" />
                Link to an activity (optional)
              </h3>
              <div className="space-y-3">
                {recentActivities.map((activity, idx) => {
                  const isSelected = relatedActivity === activity.id;
                  return (
                    <motion.button
                      key={activity.id}
                      initial={{ opacity: 0, x: -20 }}
                      animate={{ opacity: 1, x: 0 }}
                      transition={{ delay: 0.55 + idx * 0.05 }}
                      whileHover={{ scale: 1.02, y: -2 }}
                      whileTap={{ scale: 0.98 }}
                      onClick={() => setRelatedActivity(relatedActivity === activity.id ? undefined : activity.id)}
                      className={`w-full p-4 rounded-3xl transition-all text-left shadow-md ${
                        isSelected
                          ? "bg-gradient-to-br from-purple-50 to-pink-50 border-2 border-purple-300"
                          : "bg-white border-2 border-gray-100 hover:border-gray-300"
                      }`}
                    >
                      <div className="flex items-center justify-between">
                        <div>
                          <p className="text-xs font-mono text-purple-600 mb-1">{activity.id}</p>
                          <p className="text-black">{activity.title}</p>
                        </div>
                        {isSelected && (
                          <motion.div
                            initial={{ scale: 0 }}
                            animate={{ scale: 1 }}
                            transition={{ type: "spring", stiffness: 300 }}
                          >
                            <Badge className="bg-gradient-to-r from-purple-500 to-pink-500 text-white border-0">
                              Selected
                            </Badge>
                          </motion.div>
                        )}
                      </div>
                    </motion.button>
                  );
                })}
              </div>
            </motion.div>

            {/* Media Buttons */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.65 }}
              className="p-5 bg-white rounded-3xl shadow-md border border-gray-100"
            >
              <p className="text-gray-700 text-sm mb-3">Add to your post</p>
              <div className="flex items-center gap-3">
                <motion.button
                  whileHover={{ scale: 1.05, y: -2 }}
                  whileTap={{ scale: 0.95 }}
                  className="flex-1 flex items-center justify-center gap-2 px-4 py-3 rounded-2xl bg-gradient-to-br from-green-50 to-emerald-50 hover:from-green-100 hover:to-emerald-100 border border-green-200 transition-all"
                >
                  <ImageIcon className="w-5 h-5 text-green-600" />
                  <span className="text-black text-sm">Photo</span>
                </motion.button>
                <motion.button
                  whileHover={{ scale: 1.05, y: -2 }}
                  whileTap={{ scale: 0.95 }}
                  className="flex-1 flex items-center justify-center gap-2 px-4 py-3 rounded-2xl bg-gradient-to-br from-red-50 to-pink-50 hover:from-red-100 hover:to-pink-100 border border-red-200 transition-all"
                >
                  <Video className="w-5 h-5 text-red-600" />
                  <span className="text-black text-sm">Video</span>
                </motion.button>
              </div>
            </motion.div>
          </div>
        </ScrollArea>
      </div>
    </motion.div>
  );
}