import { MapPin, Clock, Users } from 'lucide-react';
import { motion } from 'framer-motion';

type ProficiencyLevel = 'Beginner' | 'Intermediate' | 'Advanced' | 'Expert';
type GenderRestriction = 'no-restrictions' | 'male-only' | 'female-only' | 'lgbt-friendly';
type Weather = 'clear' | 'partly-cloudy' | 'cloudy' | 'overcast' | 'light-rain' | 'heavy-rain' | 'thunderstorm' | 'light-snow' | 'heavy-snow' | 'foggy';

interface EventCardProps {
  activityId?: string;
  date: string;
  month: string;
  year: string;
  dayOfWeek: string;
  weather: Weather;
  temperature: number;
  category: string;
  title: string;
  description?: string;
  time: string;
  location: string;
  participants: number;
  budget: number;
  recruiting: boolean;
  images: string[];
  proficiency?: ProficiencyLevel;
  genderRestriction: GenderRestriction;
  passwordRequired?: boolean;
  password?: string;
  attendeeAvatars?: string[];
  onJoinClick?: () => void;
  onViewDetails?: () => void;
  onAddFavorite?: () => void;
}

export function EventCard({
  activityId,
  date,
  month,
  year,
  dayOfWeek,
  weather,
  temperature,
  category,
  title,
  description,
  time,
  location,
  participants,
  budget,
  recruiting,
  images,
  proficiency,
  genderRestriction,
  passwordRequired = false,
  password,
  attendeeAvatars = [],
  onJoinClick,
  onViewDetails,
  onAddFavorite
}: EventCardProps) {
  
  return (
    <motion.div 
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      whileHover={{ scale: 1.01 }}
      whileTap={{ scale: 0.98 }}
      transition={{ duration: 0.2 }}
      className="flex gap-4 p-4 bg-white cursor-pointer hover:bg-gray-50 transition-colors"
      onClick={onViewDetails}
    >
      {/* Left - Event Image */}
      <motion.div 
        className="w-32 h-32 rounded-2xl overflow-hidden flex-shrink-0 bg-gray-100"
        whileHover={{ scale: 1.05 }}
        transition={{ duration: 0.3 }}
      >
        <img 
          src={images[0]} 
          alt={title}
          className="w-full h-full object-cover"
        />
      </motion.div>

      {/* Right - Event Info */}
      <div className="flex-1 flex flex-col justify-center min-w-0">
        {/* Organizer/Category */}
        <motion.div 
          className="flex items-center gap-2 mb-2"
          initial={{ opacity: 0, x: -10 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ delay: 0.1 }}
        >
          <div className="w-5 h-5 rounded bg-gray-900 flex items-center justify-center flex-shrink-0">
            <span className="text-white text-xs">📍</span>
          </div>
          <p className="text-gray-600 text-sm truncate">{category}</p>
        </motion.div>

        {/* Title */}
        <motion.h3 
          className="text-black text-lg mb-3 line-clamp-2 leading-tight"
          initial={{ opacity: 0, x: -10 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ delay: 0.15 }}
        >
          {title}
        </motion.h3>

        {/* Time and Location */}
        <motion.div 
          className="space-y-1"
          initial={{ opacity: 0, x: -10 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ delay: 0.2 }}
        >
          <div className="flex items-center gap-2 text-gray-500 text-sm">
            <Clock className="w-4 h-4 flex-shrink-0" />
            <span className="truncate">{time}</span>
          </div>
          <div className="flex items-center gap-2 text-gray-500 text-sm">
            <MapPin className="w-4 h-4 flex-shrink-0" />
            <span className="truncate">{location}</span>
          </div>
        </motion.div>
      </div>
    </motion.div>
  );
}