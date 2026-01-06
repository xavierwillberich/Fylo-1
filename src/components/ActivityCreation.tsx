import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { ArrowLeft, Sparkles, Edit3, X, MapPin, Calendar, Clock, Users, DollarSign, Image as ImageIcon, Lock, ChevronDown, Upload, Zap } from 'lucide-react';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Label } from './ui/label';
import { Textarea } from './ui/textarea';
import { Avatar, AvatarImage, AvatarFallback } from './ui/avatar';
import { ScrollArea } from './ui/scroll-area';
import { toast } from 'sonner@2.0.3';

type ProficiencyLevel = 'Beginner' | 'Intermediate' | 'Advanced' | 'Expert';
type GenderRestriction = 'none' | 'male' | 'female' | 'male-friendly' | 'female-friendly' | 'friendly';

interface ActivityCreationProps {
  onBack: () => void;
}

export const ActivityCreation: React.FC<ActivityCreationProps> = ({ onBack }) => {
  const [step, setStep] = useState<'choice' | 'manual' | 'ai'>('choice');
  
  // Form state
  const [formData, setFormData] = useState({
    category: '',
    title: '',
    description: '',
    date: '',
    time: '',
    location: '',
    participants: '',
    budget: '',
    proficiency: '' as ProficiencyLevel | '',
    genderRestriction: 'none' as GenderRestriction,
    passwordRequired: false,
    password: '',
    images: [] as string[],
  });

  const categories = [
    'Triathlon',
    'Hiking',
    'Sports',
    'Food & Drink',
    'Arts & Culture',
    'Board Games',
    'Music',
    'Others',
  ];

  const proficiencyLevels: ProficiencyLevel[] = ['Beginner', 'Intermediate', 'Advanced', 'Expert'];
  const genderOptions: { value: GenderRestriction; label: string }[] = [
    { value: 'none', label: 'No Restrictions' },
    { value: 'male', label: 'Male Only' },
    { value: 'female', label: 'Female Only' },
    { value: 'male-friendly', label: 'Male Friendly' },
    { value: 'female-friendly', label: 'Female Friendly' },
    { value: 'friendly', label: 'LGBTQ+ Friendly' },
  ];

  const handleImageUpload = () => {
    toast.info('Image upload functionality coming soon!');
  };

  const handleSubmit = () => {
    // Validation
    if (!formData.category || !formData.title || !formData.date || !formData.time || !formData.location) {
      toast.error('Please fill in all required fields');
      return;
    }

    toast.success('Activity created successfully!');
    onBack();
  };

  // Choice Screen
  if (step === 'choice') {
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
                  Create Activity
                </motion.h1>
                <div className="w-10" />
              </div>

              {/* Info Card */}
              <motion.div
                initial={{ opacity: 0, y: 30, scale: 0.9 }}
                animate={{ opacity: 1, y: 0, scale: 1 }}
                transition={{ delay: 0.15, type: "spring", stiffness: 200, damping: 20 }}
                className="relative z-10 mx-5 mb-6 p-6 bg-white/15 backdrop-blur-xl rounded-[32px] shadow-2xl border border-white/20"
              >
                <div className="absolute top-0 right-0 w-32 h-32 bg-gradient-to-br from-white/20 to-transparent rounded-full blur-2xl" />
                <div className="relative">
                  <h2 className="text-white text-2xl mb-2">Choose Your Method</h2>
                  <p className="text-white/80 text-sm">Select how you'd like to create your activity</p>
                </div>
              </motion.div>

              {/* Curved bottom edge */}
              <div className="relative h-8 overflow-hidden">
                <div className="absolute inset-x-0 bottom-0 h-16 bg-gray-50 rounded-t-[40px]" />
              </div>
            </div>

            {/* Options */}
            <div className="px-5 py-6 pb-32 space-y-4">
              {/* Manual Creation Option */}
              <motion.button
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.2, type: "spring" }}
                whileHover={{ scale: 1.02, y: -2 }}
                whileTap={{ scale: 0.98 }}
                onClick={() => setStep('manual')}
                className="w-full p-6 bg-white rounded-3xl border border-gray-100 shadow-lg hover:shadow-2xl transition-all text-left"
              >
                <div className="flex items-start gap-4">
                  <motion.div
                    whileHover={{ rotate: 5 }}
                    className="w-14 h-14 bg-gradient-to-br from-gray-700 to-black rounded-2xl flex items-center justify-center flex-shrink-0 shadow-lg"
                  >
                    <Edit3 className="w-7 h-7 text-white" />
                  </motion.div>
                  <div className="flex-1">
                    <h3 className="text-black text-xl mb-2">Create Manually</h3>
                    <p className="text-gray-600 text-sm leading-relaxed">
                      Fill in the details yourself with complete control over every aspect of your activity
                    </p>
                  </div>
                </div>
              </motion.button>

              {/* AI Assistant Option */}
              <motion.button
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.3, type: "spring" }}
                whileHover={{ scale: 1.02, y: -2 }}
                whileTap={{ scale: 0.98 }}
                onClick={() => {
                  toast.info('AI Assistant coming soon!');
                }}
                className="w-full p-6 bg-gradient-to-br from-purple-50 to-pink-50 rounded-3xl border border-purple-200 shadow-lg hover:shadow-2xl transition-all text-left relative overflow-hidden"
              >
                {/* Coming Soon Badge */}
                <motion.div
                  initial={{ scale: 0, rotate: -12 }}
                  animate={{ scale: 1, rotate: -12 }}
                  transition={{ delay: 0.4, type: "spring", stiffness: 200 }}
                  className="absolute top-4 right-4 px-3 py-1.5 bg-gradient-to-r from-purple-500 to-pink-500 text-white text-xs rounded-full shadow-lg"
                >
                  Coming Soon
                </motion.div>

                <div className="flex items-start gap-4">
                  <motion.div
                    whileHover={{ rotate: 5 }}
                    animate={{ rotate: [0, -5, 5, -5, 0] }}
                    transition={{ duration: 2, repeat: Infinity, repeatDelay: 3 }}
                    className="w-14 h-14 bg-gradient-to-br from-purple-500 to-pink-500 rounded-2xl flex items-center justify-center flex-shrink-0 shadow-lg"
                  >
                    <Sparkles className="w-7 h-7 text-white" />
                  </motion.div>
                  <div className="flex-1 pr-24">
                    <h3 className="text-black text-xl mb-2 flex items-center gap-2">
                      AI Assistant
                      <motion.div
                        animate={{ scale: [1, 1.2, 1] }}
                        transition={{ duration: 1, repeat: Infinity }}
                      >
                        <Zap className="w-5 h-5 text-purple-600" />
                      </motion.div>
                    </h3>
                    <p className="text-gray-600 text-sm leading-relaxed">
                      Let AI help you create the perfect activity with smart suggestions and auto-fill
                    </p>
                  </div>
                </div>
              </motion.button>
            </div>
          </ScrollArea>
        </div>
      </motion.div>
    );
  }

  // Manual Creation Form
  if (step === 'manual') {
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

              {/* Header Bar */}
              <div className="relative z-10 flex items-center justify-between px-5 py-5">
                <motion.button
                  whileHover={{ scale: 1.1, backgroundColor: "rgba(255,255,255,0.15)" }}
                  whileTap={{ scale: 0.9 }}
                  onClick={() => setStep('choice')}
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
                  New Activity
                </motion.h1>
                <motion.button
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  onClick={handleSubmit}
                  className="px-4 py-2 bg-white/20 backdrop-blur-sm text-white rounded-2xl hover:bg-white/30 transition-all text-sm"
                >
                  Publish
                </motion.button>
              </div>

              {/* Curved bottom edge */}
              <div className="relative h-8 overflow-hidden">
                <div className="absolute inset-x-0 bottom-0 h-16 bg-gray-50 rounded-t-[40px]" />
              </div>
            </div>

            {/* Form */}
            <div className="px-5 py-6 pb-32 space-y-6">
              {/* Category Selection */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.2 }}
                className="space-y-3"
              >
                <Label className="text-gray-700 text-sm">Category *</Label>
                <div className="grid grid-cols-2 gap-2">
                  {categories.map((cat, idx) => (
                    <motion.button
                      key={cat}
                      initial={{ opacity: 0, scale: 0.9 }}
                      animate={{ opacity: 1, scale: 1 }}
                      transition={{ delay: 0.25 + idx * 0.03 }}
                      whileHover={{ scale: 1.03 }}
                      whileTap={{ scale: 0.97 }}
                      onClick={() => setFormData({ ...formData, category: cat })}
                      className={`px-4 py-3 rounded-2xl transition-all text-sm shadow-md ${
                        formData.category === cat
                          ? 'bg-gradient-to-br from-indigo-600 to-purple-600 text-white border-2 border-indigo-600 shadow-lg'
                          : 'bg-white text-gray-700 border-2 border-gray-100 hover:border-gray-300'
                      }`}
                    >
                      {cat}
                    </motion.button>
                  ))}
                </div>
              </motion.div>

              {/* Title */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.3 }}
                className="space-y-3"
              >
                <Label htmlFor="title" className="text-gray-700 text-sm">Activity Title *</Label>
                <Input
                  id="title"
                  placeholder="e.g., Hiking in George Bass"
                  value={formData.title}
                  onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                  className="border-gray-200 rounded-2xl h-12 bg-white shadow-md"
                />
              </motion.div>

              {/* Description */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.35 }}
                className="space-y-3"
              >
                <Label htmlFor="description" className="text-gray-700 text-sm">Description</Label>
                <Textarea
                  id="description"
                  placeholder="Tell people what this activity is about..."
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  className="border-gray-200 rounded-2xl min-h-[120px] bg-white shadow-md"
                />
              </motion.div>

              {/* Date and Time */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.4 }}
                className="grid grid-cols-2 gap-4"
              >
                <div className="space-y-3">
                  <Label htmlFor="date" className="text-gray-700 text-sm flex items-center gap-2">
                    <Calendar className="w-4 h-4" />
                    Date *
                  </Label>
                  <Input
                    id="date"
                    type="date"
                    value={formData.date}
                    onChange={(e) => setFormData({ ...formData, date: e.target.value })}
                    className="border-gray-200 rounded-2xl h-12 bg-white shadow-md"
                  />
                </div>
                <div className="space-y-3">
                  <Label htmlFor="time" className="text-gray-700 text-sm flex items-center gap-2">
                    <Clock className="w-4 h-4" />
                    Time *
                  </Label>
                  <Input
                    id="time"
                    type="time"
                    value={formData.time}
                    onChange={(e) => setFormData({ ...formData, time: e.target.value })}
                    className="border-gray-200 rounded-2xl h-12 bg-white shadow-md"
                  />
                </div>
              </motion.div>

              {/* Location */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.45 }}
                className="space-y-3"
              >
                <Label htmlFor="location" className="text-gray-700 text-sm flex items-center gap-2">
                  <MapPin className="w-4 h-4" />
                  Location *
                </Label>
                <Input
                  id="location"
                  placeholder="e.g., George Bass, NSW"
                  value={formData.location}
                  onChange={(e) => setFormData({ ...formData, location: e.target.value })}
                  className="border-gray-200 rounded-2xl h-12 bg-white shadow-md"
                />
              </motion.div>

              {/* Participants and Budget */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.5 }}
                className="grid grid-cols-2 gap-4"
              >
                <div className="space-y-3">
                  <Label htmlFor="participants" className="text-gray-700 text-sm flex items-center gap-2">
                    <Users className="w-4 h-4" />
                    Max Participants
                  </Label>
                  <Input
                    id="participants"
                    type="number"
                    placeholder="e.g., 10"
                    value={formData.participants}
                    onChange={(e) => setFormData({ ...formData, participants: e.target.value })}
                    className="border-gray-200 rounded-2xl h-12 bg-white shadow-md"
                  />
                </div>
                <div className="space-y-3">
                  <Label htmlFor="budget" className="text-gray-700 text-sm flex items-center gap-2">
                    <DollarSign className="w-4 h-4" />
                    Budget/Person
                  </Label>
                  <Input
                    id="budget"
                    type="number"
                    placeholder="e.g., 50"
                    value={formData.budget}
                    onChange={(e) => setFormData({ ...formData, budget: e.target.value })}
                    className="border-gray-200 rounded-2xl h-12 bg-white shadow-md"
                  />
                </div>
              </motion.div>

              {/* Proficiency Level */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.55 }}
                className="space-y-3"
              >
                <Label className="text-gray-700 text-sm">Proficiency Level</Label>
                <div className="grid grid-cols-2 gap-2">
                  {proficiencyLevels.map((level, idx) => (
                    <motion.button
                      key={level}
                      initial={{ opacity: 0, scale: 0.9 }}
                      animate={{ opacity: 1, scale: 1 }}
                      transition={{ delay: 0.6 + idx * 0.03 }}
                      whileHover={{ scale: 1.03 }}
                      whileTap={{ scale: 0.97 }}
                      onClick={() => setFormData({ ...formData, proficiency: level })}
                      className={`px-4 py-3 rounded-2xl transition-all text-sm shadow-md ${
                        formData.proficiency === level
                          ? 'bg-gradient-to-br from-blue-500 to-cyan-500 text-white border-2 border-blue-500 shadow-lg'
                          : 'bg-white text-gray-700 border-2 border-gray-100 hover:border-gray-300'
                      }`}
                    >
                      {level}
                    </motion.button>
                  ))}
                </div>
              </motion.div>

              {/* Gender Restriction */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.65 }}
                className="space-y-3"
              >
                <Label className="text-gray-700 text-sm">Gender Restriction</Label>
                <div className="grid grid-cols-2 gap-2">
                  {genderOptions.map((option, idx) => (
                    <motion.button
                      key={option.value}
                      initial={{ opacity: 0, scale: 0.9 }}
                      animate={{ opacity: 1, scale: 1 }}
                      transition={{ delay: 0.7 + idx * 0.03 }}
                      whileHover={{ scale: 1.03 }}
                      whileTap={{ scale: 0.97 }}
                      onClick={() => setFormData({ ...formData, genderRestriction: option.value })}
                      className={`px-4 py-3 rounded-2xl transition-all text-sm shadow-md ${
                        formData.genderRestriction === option.value
                          ? 'bg-gradient-to-br from-purple-500 to-pink-500 text-white border-2 border-purple-500 shadow-lg'
                          : 'bg-white text-gray-700 border-2 border-gray-100 hover:border-gray-300'
                      }`}
                    >
                      {option.label}
                    </motion.button>
                  ))}
                </div>
              </motion.div>

              {/* Password Protection */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.75 }}
                className="space-y-3 p-5 bg-white rounded-3xl border border-gray-100 shadow-md"
              >
                <div className="flex items-center justify-between">
                  <Label className="text-gray-700 text-sm flex items-center gap-2">
                    <Lock className="w-4 h-4" />
                    Password Protection
                  </Label>
                  <button
                    onClick={() => setFormData({ ...formData, passwordRequired: !formData.passwordRequired })}
                    className={`relative inline-flex h-7 w-12 items-center rounded-full transition-colors ${
                      formData.passwordRequired ? 'bg-gradient-to-r from-blue-500 to-purple-500' : 'bg-gray-300'
                    }`}
                  >
                    <motion.span
                      animate={{ x: formData.passwordRequired ? 20 : 2 }}
                      transition={{ type: "spring", stiffness: 500, damping: 30 }}
                      className="inline-block h-5 w-5 transform rounded-full bg-white shadow-lg"
                    />
                  </button>
                </div>
                <AnimatePresence>
                  {formData.passwordRequired && (
                    <motion.div
                      initial={{ opacity: 0, height: 0 }}
                      animate={{ opacity: 1, height: "auto" }}
                      exit={{ opacity: 0, height: 0 }}
                      transition={{ duration: 0.2 }}
                    >
                      <Input
                        placeholder="Set a password"
                        value={formData.password}
                        onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                        className="border-gray-200 rounded-2xl h-12 bg-gray-50"
                      />
                    </motion.div>
                  )}
                </AnimatePresence>
              </motion.div>

              {/* Images */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.8 }}
                className="space-y-3"
              >
                <Label className="text-gray-700 text-sm flex items-center gap-2">
                  <ImageIcon className="w-4 h-4" />
                  Activity Images
                </Label>
                <motion.button
                  whileHover={{ scale: 1.01 }}
                  whileTap={{ scale: 0.99 }}
                  onClick={handleImageUpload}
                  className="w-full p-8 border-2 border-dashed border-gray-300 rounded-3xl hover:border-purple-400 bg-white hover:bg-purple-50 transition-all flex flex-col items-center justify-center gap-3 shadow-md"
                >
                  <motion.div
                    animate={{ y: [0, -5, 0] }}
                    transition={{ duration: 2, repeat: Infinity }}
                    className="p-4 bg-gradient-to-br from-purple-100 to-pink-100 rounded-2xl"
                  >
                    <Upload className="w-8 h-8 text-purple-600" />
                  </motion.div>
                  <div>
                    <p className="text-sm text-gray-700 mb-1">Click to upload images</p>
                    <p className="text-xs text-gray-400">Support JPG, PNG (max 5MB)</p>
                  </div>
                </motion.button>
              </motion.div>

              {/* Submit Button */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.85 }}
              >
                <Button
                  onClick={handleSubmit}
                  className="w-full bg-gradient-to-r from-indigo-600 to-purple-600 text-white hover:from-indigo-700 hover:to-purple-700 h-14 rounded-2xl shadow-lg hover:shadow-xl transition-all"
                >
                  Create Activity
                </Button>
              </motion.div>
            </div>
          </ScrollArea>
        </div>
      </motion.div>
    );
  }

  return null;
};
