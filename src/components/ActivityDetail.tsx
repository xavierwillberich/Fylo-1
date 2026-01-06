import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import {
  ArrowLeft,
  MapPin,
  Clock,
  DollarSign,
  Users,
  Shield,
  Lock,
  Heart,
  Send,
  ChevronLeft,
  ChevronRight,
  Calendar,
  Sun,
  CloudRain,
  Cloud,
  Snowflake,
  Hash,
  Star,
} from "lucide-react";
import {
  Avatar,
  AvatarFallback,
  AvatarImage,
} from "./ui/avatar";
import { Badge } from "./ui/badge";
import { Button } from "./ui/button";
import { Separator } from "./ui/separator";
import { ScrollArea } from "./ui/scroll-area";
import { Textarea } from "./ui/textarea";
import { WeatherBackground } from "./WeatherBackground";

type ProficiencyLevel =
  | "Beginner"
  | "Intermediate"
  | "Advanced"
  | "Expert";
type GenderRestriction =
  | "no-restrictions"
  | "male-only"
  | "female-only"
  | "lgbt-friendly";
type Weather =
  | "clear"
  | "partly-cloudy"
  | "cloudy"
  | "overcast"
  | "light-rain"
  | "heavy-rain"
  | "thunderstorm"
  | "light-snow"
  | "heavy-snow"
  | "foggy";

interface ActivityDetailProps {
  event: {
    id: number;
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
    proficiency?: ProficiencyLevel;
    genderRestriction: GenderRestriction;
    passwordRequired?: boolean;
    password?: string;
    images: string[];
    attendeeAvatars?: string[];
  };
  activityId: string;
  onClose: () => void;
}

export function ActivityDetail({
  event,
  activityId,
  onClose,
}: ActivityDetailProps) {
  const [currentImageIndex, setCurrentImageIndex] = useState(0);
  const [isFavorite, setIsFavorite] = useState(false);
  const [swipeDistance, setSwipeDistance] = useState(0);
  const [isDragging, setIsDragging] = useState(false);
  const [startX, setStartX] = useState(0);
  const [commentText, setCommentText] = useState("");
  const [comments, setComments] = useState([
    {
      id: 1,
      user: "Mike R.",
      avatar:
        "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100",
      text: "Really excited for this! Can't wait to meet everyone!",
      timestamp: "2 hours ago",
    },
    {
      id: 2,
      user: "Sarah M.",
      avatar:
        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
      text: "Should we bring anything specific?",
      timestamp: "1 hour ago",
    },
  ]);
  const [showAllParticipants, setShowAllParticipants] =
    useState(false);

  // Convert Fahrenheit to Celsius
  const fahrenheitToCelsius = (fahrenheit: number) => {
    return Math.round(((fahrenheit - 32) * 5) / 9);
  };

  // Get temperature in Celsius
  const tempCelsius = fahrenheitToCelsius(event.temperature);

  // Generate weather advice based on activity, weather, and time
  const getWeatherAdvice = () => {
    const timeHour = parseInt(event.time.split(":")[0]);
    const isPM = event.time.toLowerCase().includes("pm");
    const hour =
      isPM && timeHour !== 12 ? timeHour + 12 : timeHour;
    const isEvening = hour >= 18 || hour < 6;
    const isOutdoor = [
      "Trips",
      "Sports",
      "Coffee Chat",
    ].includes(event.category);

    const advice: {
      icon: React.ReactNode;
      title: string;
      message: string;
      variant: "default" | "destructive";
    } = {
      icon: <Sun className="w-5 h-5" />,
      title: "Weather Update",
      message: "",
      variant: "default",
    };

    switch (event.weather) {
      case "light-rain":
        advice.icon = <CloudRain className="w-5 h-5" />;
        advice.title = "Light Rain Expected";
        advice.variant = "destructive";
        if (isOutdoor) {
          advice.message = `Light rain at ${tempCelsius}°C. ${isEvening ? "Bring an umbrella and waterproof jacket." : "Consider bringing rain gear just in case."}`;
        } else {
          advice.message = `Light rain expected. Temperature: ${tempCelsius}°C. Indoor venue recommended.`;
        }
        break;

      case "heavy-rain":
        advice.icon = <CloudRain className="w-5 h-5" />;
        advice.title = "Heavy Rain Expected";
        advice.variant = "destructive";
        if (isOutdoor) {
          advice.message = `Don't forget your umbrella and waterproof gear! ${isEvening ? "Evening rain can make trails slippery." : "Consider bringing a change of clothes."}`;
        } else {
          advice.message = `Heavy rain expected during activity time. Temperature: ${tempCelsius}°C.`;
        }
        break;

      case "thunderstorm":
        advice.icon = <CloudRain className="w-5 h-5" />;
        advice.title = "Thunderstorm Warning";
        advice.variant = "destructive";
        if (isOutdoor) {
          advice.message = `⚠️ Severe weather alert! Thunderstorms expected at ${tempCelsius}°C. ${event.category === "Trips" ? "Consider rescheduling outdoor activities." : "Stay indoors and avoid open areas."}`;
        } else {
          advice.message = `Thunderstorms expected. Temperature: ${tempCelsius}°C. Stay safe indoors.`;
        }
        break;

      case "light-snow":
        advice.icon = <Snowflake className="w-5 h-5" />;
        advice.title = "Light Snow Expected";
        advice.variant = "destructive";
        if (isOutdoor) {
          advice.message = `Light snow at ${tempCelsius}°C. Dress warmly! ${event.category === "Trips" ? "Check trail conditions before heading out." : "Roads may be slippery."}`;
        } else {
          advice.message = `Light snow expected. Temperature: ${tempCelsius}°C. Allow extra travel time.`;
        }
        break;

      case "heavy-snow":
        advice.icon = <Snowflake className="w-5 h-5" />;
        advice.title = "Heavy Snow Conditions";
        advice.variant = "destructive";
        if (isOutdoor) {
          advice.message = `Dress warmly in layers! Heavy snow expected at ${tempCelsius}°C. ${event.category === "Trips" ? "Check trail conditions and bring extra supplies." : "Allow extra travel time."}`;
        } else {
          advice.message = `Heavy snow expected. Temperature: ${tempCelsius}°C. Roads may be hazardous.`;
        }
        break;

      case "partly-cloudy":
        advice.icon = <Cloud className="w-5 h-5" />;
        advice.title = "Partly Cloudy";
        if (isOutdoor) {
          advice.message = `Nice weather at ${tempCelsius}°C with some clouds. ${isEvening ? "Bring a light jacket as temperature may drop." : "Perfect conditions for outdoor activities!"}`;
        } else {
          advice.message = `Pleasant partly cloudy weather. Temperature: ${tempCelsius}°C.`;
        }
        break;

      case "cloudy":
        advice.icon = <Cloud className="w-5 h-5" />;
        advice.title = "Cloudy Skies";
        if (isOutdoor) {
          advice.message = `Comfortable weather at ${tempCelsius}°C. ${isEvening ? "Bring a light jacket as temperature may drop." : "Good conditions for outdoor activities!"}`;
        } else {
          advice.message = `Cloudy weather with temperatures around ${tempCelsius}°C.`;
        }
        break;

      case "overcast":
        advice.icon = <Cloud className="w-5 h-5" />;
        advice.title = "Overcast Conditions";
        if (isOutdoor) {
          advice.message = `Gray skies at ${tempCelsius}°C. ${isEvening ? "Dress in layers." : "Rain may develop, bring an umbrella."}`;
        } else {
          advice.message = `Overcast weather. Temperature: ${tempCelsius}°C.`;
        }
        break;

      case "foggy":
        advice.icon = <Cloud className="w-5 h-5" />;
        advice.title = "Foggy Conditions";
        advice.variant = "destructive";
        if (isOutdoor) {
          advice.message = `Low visibility expected at ${tempCelsius}°C. ${event.category === "Trips" ? "Exercise caution on trails and bring extra lighting." : "Drive carefully and allow extra time."}`;
        } else {
          advice.message = `Foggy conditions. Temperature: ${tempCelsius}°C. Allow extra travel time.`;
        }
        break;

      case "clear":
        advice.icon = <Sun className="w-5 h-5" />;
        advice.title = "Clear Skies";
        if (isOutdoor) {
          if (event.temperature > 75) {
            advice.message = `It'll be warm at ${tempCelsius}°C! Bring sunscreen, sunglasses, and plenty of water. ${event.category === "Trips" ? "Consider starting early to avoid peak heat." : "Stay hydrated!"}`;
          } else {
            advice.message = `Beautiful clear day at ${tempCelsius}°C! ${isEvening ? "Perfect evening weather." : "Great conditions - don't forget sunscreen!"}`;
          }
        } else {
          advice.message = `Clear and ${tempCelsius}°C. ${event.temperature > 75 ? "Stay cool and hydrated!" : "Enjoy the pleasant weather!"}`;
        }
        break;
    }

    return advice;
  };

  const weatherAdvice = getWeatherAdvice();

  // Determine if background is dark (nighttime)
  const isPM = event.time.toLowerCase().includes("pm");
  const hour = parseInt(event.time.split(":")[0]);
  const actualHour =
    isPM && hour !== 12
      ? hour + 12
      : hour === 12 && !isPM
        ? 0
        : hour;
  const isNight = actualHour >= 18 || actualHour < 6;

  // Adaptive text colors based on background darkness
  const textColors = {
    primary: isNight ? "text-white" : "text-black",
    secondary: isNight ? "text-gray-200" : "text-gray-700",
    muted: isNight ? "text-gray-300" : "text-gray-600",
    heading: isNight ? "text-white" : "text-black",
    separator: isNight ? "bg-white/20" : "bg-gray-200",
  };

  // Handle double click to add to favorites
  const handleDoubleClick = () => {
    setIsFavorite(true);
  };

  // Swipe handlers - Horizontal left to right
  const handleTouchStart = (e: React.TouchEvent) => {
    const touch = e.touches[0];
    setStartX(touch.clientX);
    setIsDragging(true);
  };

  const handleTouchMove = (e: React.TouchEvent) => {
    if (!isDragging) return;
    const touch = e.touches[0];
    const currentX = touch.clientX;
    const distance = currentX - startX;
    if (distance > 0) {
      setSwipeDistance(Math.min(distance, 280));
    } else {
      setSwipeDistance(0);
    }
  };

  const handleTouchEnd = () => {
    if (swipeDistance > 200) {
      // Trigger join action
      setSwipeDistance(280);
      setTimeout(() => {
        alert(
          event.recruiting
            ? "Successfully Joined Activity!"
            : "Join Request Sent!",
        );
        setTimeout(() => {
          setSwipeDistance(0);
          setIsDragging(false);
        }, 500);
      }, 200);
    } else {
      setSwipeDistance(0);
      setIsDragging(false);
    }
  };

  // Mouse handlers for desktop testing
  const handleMouseDown = (e: React.MouseEvent) => {
    setStartX(e.clientX);
    setIsDragging(true);
  };

  const handleMouseMove = (e: React.MouseEvent) => {
    if (!isDragging) return;
    const currentX = e.clientX;
    const distance = currentX - startX;
    if (distance > 0) {
      setSwipeDistance(Math.min(distance, 280));
    } else {
      setSwipeDistance(0);
    }
  };

  const handleMouseUp = () => {
    if (swipeDistance > 200) {
      // Trigger join action
      setSwipeDistance(280);
      setTimeout(() => {
        alert(
          event.recruiting
            ? "Successfully Joined Activity!"
            : "Join Request Sent!",
        );
        setTimeout(() => {
          setSwipeDistance(0);
          setIsDragging(false);
        }, 500);
      }, 200);
    } else {
      setSwipeDistance(0);
      setIsDragging(false);
    }
  };

  const getWeatherIcon = () => {
    switch (event.weather) {
      case "clear":
        return "☀️";
      case "partly-cloudy":
        return "⛅";
      case "cloudy":
        return "☁️";
      case "overcast":
        return "☁️";
      case "light-rain":
        return "🌦️";
      case "heavy-rain":
        return "🌧️";
      case "thunderstorm":
        return "⛈️";
      case "light-snow":
        return "🌨️";
      case "heavy-snow":
        return "❄️";
      case "foggy":
        return "🌫️";
      default:
        return "☀️";
    }
  };

  const getGenderRestrictionDisplay = () => {
    // Don't show if no restrictions
    if (event.genderRestriction === "no-restrictions") {
      return null;
    }

    let text = "";
    if (event.genderRestriction === "male-only") {
      text = "Male Only";
    } else if (event.genderRestriction === "female-only") {
      text = "Female Only";
    } else if (event.genderRestriction === "lgbt-friendly") {
      text = "🏳️‍🌈 LGBT+ Friendly";
    }

    return text || null;
  };

  const getProficiencyColor = () => {
    switch (event.proficiency) {
      case "Beginner":
        return "from-green-400 to-emerald-500";
      case "Intermediate":
        return "from-yellow-400 to-orange-500";
      case "Advanced":
        return "from-orange-500 to-red-500";
      case "Expert":
        return "from-red-500 to-pink-600";
      default:
        return "from-gray-400 to-gray-500";
    }
  };

  const nextImage = () => {
    setCurrentImageIndex(
      (prev) => (prev + 1) % event.images.length,
    );
  };

  const prevImage = () => {
    setCurrentImageIndex(
      (prev) =>
        (prev - 1 + event.images.length) % event.images.length,
    );
  };

  const handleAddComment = () => {
    if (commentText.trim()) {
      const newComment = {
        id: comments.length + 1,
        user: "Alice Chen",
        avatar:
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
        text: commentText,
        timestamp: "Just now",
      };
      setComments([...comments, newComment]);
      setCommentText("");
    }
  };

  return (
    <div
      className="fixed inset-0 z-[100] bg-gray-50 animate-in fade-in duration-200"
      onDoubleClick={handleDoubleClick}
    >
      <div className="fixed inset-0 max-w-md mx-auto bg-gray-50 animate-in slide-in-from-bottom duration-300">
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
                Activity Details
              </motion.h1>
              <div className="w-10" />
            </div>

            {/* Activity ID Badge */}
            <div className="relative z-10 px-5 pb-6">
              <motion.div
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.15, type: "spring" }}
                className="inline-flex items-center gap-2 px-4 py-2 bg-white/20 backdrop-blur-xl rounded-full border border-white/30 shadow-lg"
              >
                <Hash className="w-4 h-4 text-white" />
                <span className="text-white font-mono text-sm">{activityId}</span>
              </motion.div>
            </div>
          </div>

          {/* Hero Image Section */}
          <div className="relative -mt-4 mx-5">
            <motion.div
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: 0.2, type: "spring" }}
              className="relative h-[300px] rounded-3xl overflow-hidden shadow-2xl"
            >
              <img
                src={event.images[currentImageIndex]}
                alt={event.title}
                className="w-full h-full object-cover"
              />

              {/* Gradient Overlay - darker at bottom */}
              <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent"></div>

              {/* Image Navigation Dots */}
              {event.images.length > 1 && (
                <div className="absolute top-4 right-4 flex gap-1.5">
                  {event.images.map((_, idx) => (
                    <button
                      key={idx}
                      onClick={() => setCurrentImageIndex(idx)}
                      className={`h-2 rounded-full transition-all ${
                        idx === currentImageIndex
                          ? "w-6 bg-white"
                          : "w-2 bg-white/40"
                      }`}
                    />
                  ))}
                </div>
              )}

              {/* Title on Image */}
              <div className="absolute bottom-0 left-0 right-0 p-5">
                <h2 className="text-white text-2xl">{event.title}</h2>
              </div>
            </motion.div>
          </div>

          {/* Content Section - With Weather Background */}
          <div
            className={`relative bg-gray-50 px-5 py-5 space-y-5 overflow-hidden transition-colors duration-300 pb-32`}
          >
            {/* Weather Background Effects - Hidden as requested */}
            {/* <WeatherBackground
              weather={event.weather}
              time={event.time}
              date={event.date}
            /> */}

            {/* All content with relative positioning to be above weather */}
            <div className="relative z-10 space-y-5">
              {/* Date and Location Section */}
              <div className="space-y-3">
                <h2
                  className={`${textColors.heading} text-4xl`}
                >
                  Date and Location
                </h2>

                <div
                  className={`flex items-center gap-2 ${textColors.secondary} flex-wrap`}
                >
                  <Calendar className="w-4 h-4" />
                  <span>
                    {event.dayOfWeek}, {event.date}{" "}
                    {event.month}
                  </span>
                  <Clock className="w-4 h-4 ml-2" />
                  <span>{event.time}</span>
                </div>

                <div
                  className={`flex items-start gap-2 ${textColors.secondary}`}
                >
                  <MapPin className="w-4 h-4 mt-0.5 flex-shrink-0" />
                  <span className="text-sm">
                    {event.location}
                  </span>
                </div>
              </div>

              <Separator className={textColors.separator} />

              {/* Weather Section - Hidden as requested */}
              {/* <div className="space-y-4">
                <h2
                  className={`${textColors.heading} text-4xl`}
                >
                  Weather
                </h2>

                <div
                  className={`flex items-start gap-4 p-4 rounded-lg ${
                    weatherAdvice.variant === "destructive"
                      ? isNight
                        ? "bg-orange-900/30 border border-orange-700/50"
                        : "bg-orange-50 border border-orange-200"
                      : isNight
                        ? "bg-blue-900/30 border border-blue-700/50"
                        : "bg-blue-50 border border-blue-200"
                  }`}
                >
                  <div
                    className={
                      weatherAdvice.variant === "destructive"
                        ? isNight
                          ? "text-orange-400 mt-0.5"
                          : "text-orange-600 mt-0.5"
                        : isNight
                          ? "text-blue-400 mt-0.5"
                          : "text-blue-600 mt-0.5"
                    }
                  >
                    {weatherAdvice.icon}
                  </div>
                  <div className="flex-1 space-y-1">
                    <p
                      className={`font-medium ${
                        weatherAdvice.variant === "destructive"
                          ? isNight
                            ? "text-orange-200"
                            : "text-orange-900"
                          : isNight
                            ? "text-blue-200"
                            : "text-blue-900"
                      }`}
                    >
                      {weatherAdvice.title}
                    </p>
                    <p
                      className={`text-sm leading-relaxed ${
                        weatherAdvice.variant === "destructive"
                          ? isNight
                            ? "text-orange-300"
                            : "text-orange-800"
                          : isNight
                            ? "text-blue-300"
                            : "text-blue-800"
                      }`}
                    >
                      {weatherAdvice.message}
                    </p>
                  </div>
                </div>
              </div> */}

              <Separator className={textColors.separator} />

              {/* Details Section */}
              <div className="space-y-4">
                <h2
                  className={`${textColors.heading} text-4xl`}
                >
                  Details
                </h2>

                {/* Activity ID and Status Badges */}
                <div className="flex items-center gap-2 flex-wrap">
                  <Badge
                    variant="outline"
                    className={
                      isNight
                        ? "border-gray-600 bg-gray-800/50 text-gray-200"
                        : "border-gray-300 bg-gray-50 text-gray-700"
                    }
                  >
                    <Hash className="w-3 h-3 mr-1" />
                    {activityId}
                  </Badge>
                  <Badge
                    variant="outline"
                    className={
                      isNight
                        ? "border-gray-600 bg-gray-800/50 text-gray-200"
                        : "border-gray-300 bg-gray-50 text-gray-700"
                    }
                  >
                    {event.category}
                  </Badge>
                  {event.recruiting && (
                    <Badge className="bg-green-500 text-white border-0">
                      Recruiting
                    </Badge>
                  )}
                  {event.passwordRequired && (
                    <Badge
                      variant="outline"
                      className={
                        isNight
                          ? "border-gray-600 bg-gray-800/50 text-gray-200"
                          : "border-gray-300 bg-gray-50 text-gray-700"
                      }
                    >
                      <Lock className="w-3 h-3 mr-1" />
                      Password Required
                    </Badge>
                  )}
                </div>

                {/* Description */}
                {event.description && (
                  <p
                    className={`${textColors.secondary} leading-relaxed`}
                  >
                    {event.description}
                  </p>
                )}
              </div>

              <Separator className={textColors.separator} />

              {/* Key Information */}
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <div
                    className={`flex items-center gap-3 ${textColors.secondary}`}
                  >
                    <DollarSign
                      className={`w-5 h-5 ${textColors.muted}`}
                    />
                    <span>Budget per person</span>
                  </div>
                  <span className={textColors.primary}>
                    ${event.budget}
                  </span>
                </div>

                {getGenderRestrictionDisplay() && (
                  <div className="flex items-center justify-between">
                    <div
                      className={`flex items-center gap-3 ${textColors.secondary}`}
                    >
                      <Shield
                        className={`w-5 h-5 ${textColors.muted}`}
                      />
                      <span>Gender Restriction</span>
                    </div>
                    <span className={textColors.primary}>
                      {getGenderRestrictionDisplay()}
                    </span>
                  </div>
                )}
              </div>

              <Separator className={textColors.separator} />

              {/* Host Information */}
              <div className="space-y-4">
                <h2
                  className={`${textColors.heading} text-4xl`}
                >
                  Host
                </h2>
                <div className="flex items-center gap-4">
                  <Avatar className="w-14 h-14">
                    <AvatarImage src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100" />
                    <AvatarFallback>AC</AvatarFallback>
                  </Avatar>
                  <div>
                    <p className={textColors.primary}>
                      Alice Chen
                    </p>
                    <p
                      className={`text-sm ${textColors.muted}`}
                    >
                      Event Organizer
                    </p>
                  </div>
                </div>
              </div>

              {/* Special Requirements */}
              {(event.proficiency ||
                event.passwordRequired) && (
                <>
                  <Separator className={textColors.separator} />
                  <div className="space-y-4">
                    {event.proficiency && (
                      <div className="flex items-center justify-between">
                        <div
                          className={`flex items-center gap-3 ${textColors.secondary}`}
                        >
                          <Star
                            className={`w-5 h-5 ${textColors.muted}`}
                          />
                          <span>Proficiency Level</span>
                        </div>
                        <span className={textColors.primary}>
                          {event.proficiency}
                        </span>
                      </div>
                    )}

                    {event.passwordRequired &&
                      event.password && (
                        <div className="flex items-center justify-between">
                          <div
                            className={`flex items-center gap-3 ${textColors.secondary}`}
                          >
                            <Lock
                              className={`w-5 h-5 ${textColors.muted}`}
                            />
                            <span>Access Password</span>
                          </div>
                          <span
                            className={`${textColors.primary} font-mono`}
                          >
                            {event.password}
                          </span>
                        </div>
                      )}
                  </div>
                </>
              )}

              {/* Participants Preview */}
              {event.attendeeAvatars &&
                event.attendeeAvatars.length > 0 && (
                  <>
                    <Separator
                      className={textColors.separator}
                    />
                    <div className="space-y-4">
                      {/* Going Header with Stacked Avatars */}
                      <div className="space-y-4">
                        <h2 className={`text-3xl ${textColors.primary}`}>
                          {event.participants} Going
                        </h2>
                        
                        {/* Stacked Avatars */}
                        <div className="flex items-center">
                          <div className="flex items-center -space-x-3">
                            {event.attendeeAvatars.slice(0, 4).map((avatar, idx) => (
                              <Avatar
                                key={idx}
                                className="w-14 h-14 border-4 border-white relative"
                                style={{ zIndex: 4 - idx }}
                              >
                                <AvatarImage src={avatar} />
                                <AvatarFallback>U{idx + 1}</AvatarFallback>
                              </Avatar>
                            ))}
                            {event.participants > 4 && (
                              <div 
                                className="w-14 h-14 rounded-full bg-gray-600 flex items-center justify-center border-4 border-white relative text-white"
                                style={{ zIndex: 0 }}
                              >
                                +{event.participants - 4}
                              </div>
                            )}
                          </div>
                        </div>

                        {/* Participant Names List */}
                        <div>
                          <p className={textColors.primary}>
                            {(() => {
                              const attendeeNames = [
                                "曾根悠一",
                                "Harry Singh", 
                                "chaitra nagaraj",
                                "Shourya",
                              ];
                              const firstFour = attendeeNames.slice(0, Math.min(4, event.participants));
                              const remaining = event.participants - 4;
                              
                              if (remaining > 0) {
                                return `${firstFour.join(", ")}, and ${remaining} more`;
                              } else {
                                return firstFour.slice(0, event.participants).join(", ");
                              }
                            })()}
                          </p>
                        </div>
                      </div>
                    </div>
                  </>
                )}

              {/* Comments Section */}
              <Separator className={textColors.separator} />
              <div className="space-y-4">
                <h3 className={textColors.primary}>
                  Comments ({comments.length})
                </h3>

                {/* Comment List */}
                <div className="space-y-4">
                  {comments.map((comment) => (
                    <div
                      key={comment.id}
                      className="flex gap-3"
                    >
                      <Avatar className="w-10 h-10 flex-shrink-0">
                        <AvatarImage src={comment.avatar} />
                        <AvatarFallback>
                          {comment.user.charAt(0)}
                        </AvatarFallback>
                      </Avatar>
                      <div className="flex-1 space-y-1">
                        <div className="flex items-center gap-2">
                          <span
                            className={`text-sm ${textColors.primary}`}
                          >
                            {comment.user}
                          </span>
                          <span
                            className={`text-xs ${textColors.muted}`}
                          >
                            {comment.timestamp}
                          </span>
                        </div>
                        <p
                          className={`text-sm ${textColors.secondary}`}
                        >
                          {comment.text}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>

                {/* Add Comment */}
                <div className="space-y-3">
                  <Textarea
                    placeholder="Add a comment..."
                    value={commentText}
                    onChange={(e) =>
                      setCommentText(e.target.value)
                    }
                    className={`resize-none min-h-[80px] ${isNight ? "bg-gray-800/30 border-gray-600 text-white placeholder:text-gray-400" : ""}`}
                  />
                  <Button
                    onClick={handleAddComment}
                    disabled={!commentText.trim()}
                    className="w-full"
                  >
                    <Send className="w-4 h-4 mr-2" />
                    Post Comment
                  </Button>
                </div>
              </div>

              {/* Spacer for bottom section */}
              <div className="h-32"></div>
            </div>
          </div>

          {/* Fixed Bottom Section - Swipe to Join */}
          <div className="fixed bottom-0 left-0 right-0 max-w-md mx-auto bg-white border-t border-gray-200 p-5 safe-area-inset-bottom z-50">
            <div
              className="relative h-16 bg-gradient-to-r from-gray-50 to-gray-100 border border-gray-200 rounded-2xl overflow-hidden touch-none select-none"
              onTouchStart={handleTouchStart}
              onTouchMove={handleTouchMove}
              onTouchEnd={handleTouchEnd}
              onMouseDown={handleMouseDown}
              onMouseMove={handleMouseMove}
              onMouseUp={handleMouseUp}
              onMouseLeave={handleMouseUp}
            >
              {/* Success fill - expands from left */}
              <div
                className="absolute inset-y-0 left-0 bg-gradient-to-r from-green-400 to-emerald-500 transition-all duration-300 ease-out"
                style={{
                  width: `${(swipeDistance / 280) * 100}%`,
                  opacity: swipeDistance > 180 ? 1 : 0,
                }}
              />

              {/* Slider Track */}
              <div className="absolute inset-0 flex items-center px-2">
                {/* Slider Thumb */}
                <div
                  className="relative z-10 h-12 w-12 bg-white rounded-xl shadow-lg flex items-center justify-center transition-all duration-100 cursor-grab active:cursor-grabbing"
                  style={{
                    transform: `translateX(${swipeDistance}px)`,
                  }}
                >
                  <div className="text-xl">
                    {swipeDistance > 200 ? "✓" : "→"}
                  </div>
                </div>
              </div>

              {/* Text instruction */}
              <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
                <span
                  className="transition-all duration-200"
                  style={{
                    color:
                      swipeDistance > 180
                        ? "#ffffff"
                        : "#9CA3AF",
                    opacity: swipeDistance > 100 ? 0 : 1,
                    transform: `translateX(${Math.min(swipeDistance * 0.3, 30)}px)`,
                  }}
                >
                  {event.recruiting
                    ? "Slide to Join Activity"
                    : "Slide to Request to Join"}
                </span>
              </div>

              {/* Success text */}
              {swipeDistance > 180 && (
                <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
                  <span className="text-white animate-in fade-in duration-200">
                    {event.recruiting
                      ? "Joining..."
                      : "Sending Request..."}
                  </span>
                </div>
              )}
            </div>
          </div>
        </ScrollArea>
      </div>
    </div>
  );
}