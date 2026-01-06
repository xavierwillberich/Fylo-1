import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import {
  Bell,
  Home as HomeIcon,
  Search,
  Plus,
  User,
  SlidersHorizontal,
  Users,
  Globe,
  Filter,
  MapPin,
  MessageSquare,
  Radio,
} from "lucide-react";
import {
  Avatar,
  AvatarFallback,
  AvatarImage,
} from "./components/ui/avatar";
import { Button } from "./components/ui/button";
import { Input } from "./components/ui/input";
import { Badge } from "./components/ui/badge";
import { EventCard } from "./components/EventCard";
import { ActivityDetail } from "./components/ActivityDetail";
import { SearchPage } from "./components/SearchPage";
import {
  FilterPage,
  FilterState,
} from "./components/FilterPage";
import { ChangeCityPage } from "./components/ChangeCityPage";
import { PoolPage } from "./components/PoolPage";
import { PostDetail } from "./components/PostDetail";
import { UserProfile } from "./components/UserProfile";
import { PostCreation } from "./components/PostCreation";
import { ActivityCreation } from "./components/ActivityCreation";
import { NotificationsPage } from "./components/NotificationsPage";
import { MessagesPage } from "./components/MessagesPage";
import { WalletPage } from "./components/WalletPage";
import { SettingsPage } from "./components/SettingsPage";
import { getUserDataOrDefault } from "./utils/users";
import { toast } from "sonner@2.0.3";
import { Toaster } from "./components/ui/sonner";

export default function App() {
  const [activeFilter, setActiveFilter] = useState("All");
  const [activeTab, setActiveTab] = useState("home");
  const [searchQuery, setSearchQuery] = useState("");
  const [currentTime, setCurrentTime] = useState(new Date());
  const [selectedEvent, setSelectedEvent] = useState<any>(null);
  const [favoriteEvents, setFavoriteEvents] = useState<
    number[]
  >([]);
  const [showSearchPage, setShowSearchPage] = useState(false);
  const [showFilterPage, setShowFilterPage] = useState(false);
  const [showChangeCityPage, setShowChangeCityPage] =
    useState(false);
  const [showPoolPage, setShowPoolPage] = useState(false);
  const [showPostDetail, setShowPostDetail] = useState(false);
  const [selectedPost, setSelectedPost] = useState<Post | null>(null);
  const [showPostCreation, setShowPostCreation] = useState(false);
  const [showActivityCreation, setShowActivityCreation] = useState(false);
  const [showCreateDialog, setShowCreateDialog] = useState(false);
  const [showUserProfile, setShowUserProfile] = useState(false);
  const [showMessagesPage, setShowMessagesPage] = useState(false);
  const [showWalletPage, setShowWalletPage] = useState(false);
  const [showSettingsPage, setShowSettingsPage] = useState(false);
  const [selectedUserProfile, setSelectedUserProfile] = useState<{
    username: string;
    avatar: string;
    isOwnProfile?: boolean;
  } | null>(null);
  const [appliedFilters, setAppliedFilters] =
    useState<FilterState | null>(null);
  const [selectedCity, setSelectedCity] = useState("Seattle");
  const [darkMode, setDarkMode] = useState(false);

  // Update time every minute
  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentTime(new Date());
    }, 60000);
    return () => clearInterval(timer);
  }, []);

  // Close all modals when tab changes
  useEffect(() => {
    setSelectedEvent(null);
    setShowPostDetail(false);
    setSelectedPost(null);
    setShowSearchPage(false);
    setShowFilterPage(false);
    setShowChangeCityPage(false);
    setShowPostCreation(false);
    setShowActivityCreation(false);
    setShowUserProfile(false);
    setSelectedUserProfile(null);
  }, [activeTab]);

  const filters = [
    "All",
    "Trips",
    "Board Games",
    "Foods",
    "Sports",
    "Coffee Chat",
    "KTV",
    "Others",
  ];

  // Helper function to get greeting based on time
  const getGreeting = () => {
    const hour = currentTime.getHours();
    if (hour < 12) return "Good morning";
    if (hour < 18) return "Good afternoon";
    if (hour < 22) return "Good evening";
    return "Good night";
  };

  // Helper function to generate activity ID
  const generateActivityId = (category: string, id: number) => {
    const categoryPrefix = category
      .substring(0, 3)
      .toUpperCase();
    return `${categoryPrefix}-${String(id).padStart(4, "0")}`;
  };

  // Helper function to generate password
  const generatePassword = () => {
    return Math.random()
      .toString(36)
      .substring(2, 8)
      .toUpperCase();
  };

  const allEvents = [
    {
      id: 1,
      date: "28",
      month: "Oct",
      year: "2025",
      dayOfWeek: "Tuesday",
      weather: "clear" as const,
      temperature: 68,
      category: "Trips",
      title: "Weekend Hiking Adventure - Mount Rainier Trail",
      description:
        "Join us for a scenic 8-mile hike through alpine meadows and old-growth forests. Perfect for nature lovers and photography enthusiasts. All skill levels welcome!",
      time: "7:00 AM",
      location: "Mount Rainier National Park, WA",
      participants: 12,
      budget: 45,
      recruiting: true,
      proficiency: "Intermediate" as const,
      genderRestriction: "no-restrictions" as const,
      passwordRequired: false,
      images: [
        "https://images.unsplash.com/photo-1623622863859-2931a6c3bc80?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb3VudGFpbiUyMGhpa2luZyUyMHRyYWlsfGVufDF8fHx8MTc2MTIxNjU4Nnww&ixlib=rb-4.1.0&q=80&w=1080",
        "https://images.unsplash.com/photo-1723470317938-6ec6fb0d4075?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmb3Jlc3QlMjBuYXR1cmUlMjBwYXRofGVufDF8fHx8MTc2MTIxNzc4NHww&ixlib=rb-4.1.0&q=80&w=1080",
        "https://images.unsplash.com/photo-1715761920143-23ec33f378d8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzY2VuaWMlMjBtb3VudGFpbiUyMHZpZXd8ZW58MXx8fHwxNzYxMTMzMjczfDA&ixlib=rb-4.1.0&q=80&w=1080",
      ],
      attendeeAvatars: [
        "https://images.unsplash.com/photo-1581065178047-8ee15951ede6?w=100",
        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
        "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
        "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100",
        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
        "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
        "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=100",
      ],
    },
    {
      id: 2,
      date: "30",
      month: "Oct",
      year: "2025",
      dayOfWeek: "Thursday",
      weather: "cloudy" as const,
      temperature: 62,
      category: "Board Games",
      title: "Board Game Night - Strategy Games & Chill",
      description:
        "Weekly board game meetup featuring Catan, Ticket to Ride, and more! Snacks and drinks available. Beginners are encouraged to join - we love teaching new games!",
      time: "7:00 PM",
      location: "Cafe Meeple, Downtown Seattle",
      participants: 8,
      budget: 25,
      recruiting: true,
      genderRestriction: "lgbt-friendly" as const,
      passwordRequired: false,
      images: [
        "https://images.unsplash.com/photo-1645652267295-769f5dc8b10d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxib2FyZCUyMGdhbWVzJTIwdGFibGV8ZW58MXx8fHwxNzYxMjE3Nzg0fDA&ixlib=rb-4.1.0&q=80&w=1080",
        "https://images.unsplash.com/photo-1677816156435-e844da620fa9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzdHJhdGVneSUyMGJvYXJkJTIwZ2FtZXxlbnwxfHx8fDE3NjEyMTE1NjR8MA&ixlib=rb-4.1.0&q=80&w=1080",
      ],
      attendeeAvatars: [
        "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100",
        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
        "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100",
        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
        "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
        "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
        "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=100",
      ],
    },
    {
      id: 3,
      date: "2",
      month: "Nov",
      year: "2025",
      dayOfWeek: "Sunday",
      weather: "light-rain" as const,
      temperature: 55,
      category: "Foods",
      title: "Japanese Cuisine Experience - Sushi Making Class",
      description:
        "Learn authentic sushi-making techniques from Chef Tanaka. Includes all ingredients, sake tasting, and take-home recipe book. Limited spots - registration closes Friday!",
      time: "6:30 PM",
      location: "Tanuki Restaurant, Capitol Hill",
      participants: 15,
      budget: 85,
      recruiting: false,
      genderRestriction: "female-only" as const,
      passwordRequired: true,
      password: generatePassword(),
      images: [
        "https://images.unsplash.com/photo-1700324822763-956100f79b0d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzdXNoaSUyMGphcGFuZXNlJTIwZm9vZHxlbnwxfHx8fDE3NjExNTEwNTN8MA&ixlib=rb-4.1.0&q=80&w=1080",
        "https://images.unsplash.com/photo-1628652336186-77d85188dab0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxqYXBhbmVzZSUyMGN1aXNpbmUlMjByZXN0YXVyYW50fGVufDF8fHx8MTc2MTIxNzc4NXww&ixlib=rb-4.1.0&q=80&w=1080",
      ],
      attendeeAvatars: [
        "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
        "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
        "https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?w=100",
        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
        "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100",
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
        "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100",
      ],
    },
    {
      id: 4,
      date: "5",
      month: "Nov",
      year: "2025",
      dayOfWeek: "Wednesday",
      weather: "clear" as const,
      temperature: 70,
      category: "Sports",
      title: "Basketball Pickup Game - All Levels Welcome",
      description:
        "Weekly pickup basketball game! We play full court 5v5. Bring your own water and sneakers. Great way to stay active and meet new people. First-timers welcome!",
      time: "5:00 PM",
      location: "Green Lake Community Center",
      participants: 20,
      budget: 10,
      recruiting: true,
      genderRestriction: "male-only" as const,
      passwordRequired: false,
      images: [
        "https://images.unsplash.com/photo-1751010942953-e48cb4b2ccf5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiYXNrZXRiYWxsJTIwZ2FtZSUyMGNvdXJ0fGVufDF8fHx8MTc2MTIxNzc4NXww&ixlib=rb-4.1.0&q=80&w=1080",
        "https://images.unsplash.com/photo-1547534171-243ab161cd20?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiYXNrZXRiYWxsJTIwcGxheWVycyUyMGFjdGlvbnxlbnwxfHx8fDE3NjEyMTc3ODZ8MA&ixlib=rb-4.1.0&q=80&w=1080",
      ],
      attendeeAvatars: [
        "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100",
        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
        "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100",
        "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
        "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
        "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=100",
      ],
    },
    {
      id: 5,
      date: "8",
      month: "Nov",
      year: "2025",
      dayOfWeek: "Friday",
      weather: "partly-cloudy" as const,
      temperature: 58,
      category: "Coffee Chat",
      title: "Friday Morning Coffee & Networking",
      time: "9:00 AM",
      location: "Storyville Coffee, Pike Place",
      participants: 6,
      budget: 15,
      recruiting: true,
      genderRestriction: "no-restrictions" as const,
      passwordRequired: false,
      images: [
        "https://images.unsplash.com/photo-1676506129134-c8aef41eb4d3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjb2ZmZWUlMjBzaG9wJTIwbGF0dGV8ZW58MXx8fHwxNzYxMTUwNTcyfDA&ixlib=rb-4.1.0&q=80&w=1080",
        "https://images.unsplash.com/photo-1739723745132-97df9db49db2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjYWZlJTIwY296eSUyMGludGVyaW9yfGVufDF8fHx8MTc2MTIxNzc4Nnww&ixlib=rb-4.1.0&q=80&w=1080",
      ],
      attendeeAvatars: [
        "https://images.unsplash.com/photo-1581065178047-8ee15951ede6?w=100",
        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
        "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100",
        "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
        "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100",
        "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
      ],
    },
    {
      id: 6,
      date: "10",
      month: "Nov",
      year: "2025",
      dayOfWeek: "Monday",
      weather: "light-snow" as const,
      temperature: 38,
      category: "KTV",
      title: "Karaoke Night - Pop & Rock Classics",
      time: "8:00 PM",
      location: "Voicebox Karaoke, Belltown",
      participants: 18,
      budget: 30,
      recruiting: false,
      genderRestriction: "lgbt-friendly" as const,
      passwordRequired: true,
      password: generatePassword(),
      images: [
        "https://images.unsplash.com/photo-1741594347991-4ad8bb863eb5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxrYXJhb2tlJTIwc2luZ2luZyUyMG1pY3JvcGhvbmV8ZW58MXx8fHwxNzYxMjE3Nzg3fDA&ixlib=rb-4.1.0&q=80&w=1080",
        "https://images.unsplash.com/photo-1760598742492-7ad941e658e5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxrYXJhb2tlJTIwcGFydHklMjBuaWdodHxlbnwxfHx8fDE3NjEyMTc3ODh8MA&ixlib=rb-4.1.0&q=80&w=1080",
      ],
      attendeeAvatars: [
        "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
        "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
        "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100",
        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
        "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100",
        "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=100",
      ],
    },
    {
      id: 7,
      date: "15",
      month: "Nov",
      year: "2025",
      dayOfWeek: "Saturday",
      weather: "clear" as const,
      temperature: 52,
      category: "Others",
      title: "Lunar Eclipse Stargazing & Astronomy Night",
      description:
        "Witness a rare lunar eclipse! Join us for an unforgettable night of astronomy and stargazing. We'll have telescopes set up for viewing the eclipse, constellation identification, and astrophotography tips. Hot chocolate and blankets provided!",
      time: "9:30 PM",
      location: "Discovery Park West Point, Seattle",
      participants: 25,
      budget: 20,
      recruiting: true,
      genderRestriction: "no-restrictions" as const,
      passwordRequired: false,
      images: [
        "https://images.unsplash.com/photo-1725034898440-709aa7291bf6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzdGFycnklMjBuaWdodCUyMHNreSUyMHRlbGVzY29wZXxlbnwxfHx8fDE3NjEyMjAxNjZ8MA&ixlib=rb-4.1.0&q=80&w=1080",
        "https://images.unsplash.com/photo-1583160594147-3acdd8c91840?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxuaWdodCUyMGFzdHJvbm9teSUyMHN0YXJzfGVufDF8fHx8MTc2MTIyMDE2Nnww&ixlib=rb-4.1.0&q=80&w=1080",
      ],
      attendeeAvatars: [
        "https://images.unsplash.com/photo-1581065178047-8ee15951ede6?w=100",
        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100",
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
        "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100",
        "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100",
        "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
        "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
        "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=100",
      ],
    },
  ];

  // Filter events by category, search, and advanced filters
  const filteredEvents = allEvents.filter((event) => {
    const matchesCategory =
      activeFilter === "All" || event.category === activeFilter;
    const activityId = generateActivityId(
      event.category,
      event.id,
    );
    const matchesSearch =
      searchQuery === "" ||
      event.title
        .toLowerCase()
        .includes(searchQuery.toLowerCase()) ||
      activityId
        .toLowerCase()
        .includes(searchQuery.toLowerCase());

    // If no advanced filters applied, only use category and search
    if (!appliedFilters) {
      return matchesCategory && matchesSearch;
    }

    // Apply advanced filters
    // Category filter from advanced filters
    if (
      appliedFilters.categories.length > 0 &&
      !appliedFilters.categories.includes(event.category)
    ) {
      return false;
    }

    // Budget filter
    if (
      event.budget < appliedFilters.budgetRange[0] ||
      event.budget > appliedFilters.budgetRange[1]
    ) {
      return false;
    }

    // Participants filter
    if (
      event.participants <
        appliedFilters.participantsRange[0] ||
      event.participants > appliedFilters.participantsRange[1]
    ) {
      return false;
    }

    // Weather filter
    if (
      appliedFilters.weather.length > 0 &&
      !appliedFilters.weather.includes(event.weather)
    ) {
      return false;
    }

    // Gender restriction filter
    if (
      appliedFilters.genderRestrictions.length > 0 &&
      !appliedFilters.genderRestrictions.includes(
        event.genderRestriction,
      )
    ) {
      return false;
    }

    // Recruiting only filter
    if (appliedFilters.recruitingOnly && !event.recruiting) {
      return false;
    }

    // Proficiency filter
    if (
      appliedFilters.proficiencyLevels.length > 0 &&
      event.proficiency &&
      !appliedFilters.proficiencyLevels.includes(
        event.proficiency,
      )
    ) {
      return false;
    }

    // Time range filter
    if (appliedFilters.timeRange.length > 0) {
      const eventTime = event.time.toLowerCase();
      const hour = parseInt(event.time.split(":")[0]);
      const isPM = eventTime.includes("pm");
      const hour24 = isPM && hour !== 12 ? hour + 12 : hour;

      let matchesTime = false;
      appliedFilters.timeRange.forEach((slot) => {
        if (
          slot.includes("Morning") &&
          hour24 >= 6 &&
          hour24 < 12
        )
          matchesTime = true;
        if (
          slot.includes("Afternoon") &&
          hour24 >= 12 &&
          hour24 < 18
        )
          matchesTime = true;
        if (
          slot.includes("Evening") &&
          hour24 >= 18 &&
          hour24 < 24
        )
          matchesTime = true;
        if (slot.includes("Night") && hour24 >= 0 && hour24 < 6)
          matchesTime = true;
      });

      if (!matchesTime) return false;
    }

    return matchesCategory && matchesSearch;
  });

  const handleViewProfile = (username: string, avatar: string, isOwnProfile: boolean = false) => {
    setSelectedUserProfile({ username, avatar, isOwnProfile });
    setShowUserProfile(true);
  };

  const handleViewActivityFromPool = (activityId: string) => {
    // Find the event by matching the activity ID
    const event = allEvents.find(e => generateActivityId(e.category, e.id) === activityId);
    if (event) {
      setSelectedEvent(event);
    }
  };

  const handleViewPost = (post: Post) => {
    setSelectedPost(post);
    setShowPostDetail(true);
  };

  return (
    <div className={`min-h-screen relative overflow-hidden transition-colors duration-300 ${darkMode ? 'bg-gray-900' : 'bg-white'}`}>
      <Toaster />
      {/* Mobile Container */}
      <div className={`max-w-md mx-auto min-h-screen relative transition-colors duration-300 ${darkMode ? 'bg-gray-900' : 'bg-white'}`}>
        {/* Main Content - Activities */}
        {activeTab === "home" && (
          <>
            {/* Header with Profile Avatar and Actions */}
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

              <div className="relative z-10 px-5 pt-4 pb-4">
                <div className="flex items-center justify-between">
                  {/* Profile Avatar - Left */}
                  <motion.button
                    whileHover={{ scale: 1.05 }}
                    whileTap={{ scale: 0.95 }}
                    onClick={() =>
                      handleViewProfile("@alice_chen", "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150", true)
                    }
                    className="p-1 transition-all"
                  >
                    <Avatar className="w-10 h-10 border-2 border-white/30 shadow-lg">
                      <AvatarImage src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150" />
                      <AvatarFallback>AC</AvatarFallback>
                    </Avatar>
                  </motion.button>

                  {/* Actions - Right */}
                  <div className="flex items-center gap-2">
                    <motion.button
                      whileHover={{ scale: 1.1, backgroundColor: "rgba(255,255,255,0.25)" }}
                      whileTap={{ scale: 0.9 }}
                      onClick={() => setShowSearchPage(true)}
                      className="p-2.5 bg-white/15 backdrop-blur-sm hover:bg-white/25 rounded-full transition-all shadow-lg border border-white/20"
                    >
                      <Search className="w-5 h-5 text-white" />
                    </motion.button>
                    <motion.button
                      whileHover={{ scale: 1.1, backgroundColor: "rgba(255,255,255,0.25)" }}
                      whileTap={{ scale: 0.9 }}
                      onClick={() => setActiveTab("notifications")}
                      className="p-2.5 bg-white/15 backdrop-blur-sm hover:bg-white/25 rounded-full transition-all relative shadow-lg border border-white/20"
                    >
                      <Bell className="w-5 h-5 text-white" />
                      <motion.span 
                        initial={{ scale: 0 }}
                        animate={{ scale: 1 }}
                        transition={{ 
                          delay: 0.5,
                          type: "spring",
                          stiffness: 260,
                          damping: 20 
                        }}
                        className="absolute top-1.5 right-1.5 w-2.5 h-2.5 bg-red-500 rounded-full shadow-lg border border-white"
                      />
                    </motion.button>
                    <motion.button
                      whileHover={{ scale: 1.1, rotate: 90 }}
                      whileTap={{ scale: 0.9 }}
                      onClick={() => setShowActivityCreation(true)}
                      className="p-2.5 bg-white hover:bg-white/90 rounded-full transition-all shadow-lg"
                    >
                      <Plus className="w-5 h-5 text-purple-600" />
                    </motion.button>
                  </div>
                </div>
              </div>

              {/* Filter Chips */}
              <div className="relative z-10 pb-6">
                <div className="px-5">
                  <div
                    className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide"
                    style={{ overflowY: "visible" }}
                  >
                    {filters.map((filter, index) => {
                      return (
                        <motion.button
                          key={filter}
                          initial={{ opacity: 0, scale: 0.9 }}
                          animate={{ opacity: 1, scale: 1 }}
                          transition={{ delay: index * 0.05, type: "spring" }}
                          whileHover={{ scale: 1.05, y: -2 }}
                          whileTap={{ scale: 0.95 }}
                          onClick={() => setActiveFilter(filter)}
                          className={`px-5 py-2.5 rounded-2xl whitespace-nowrap text-sm transition-all shadow-lg ${
                            activeFilter === filter
                              ? "bg-white text-purple-600 border-2 border-white"
                              : "bg-white/20 backdrop-blur-sm text-white border-2 border-white/30 hover:bg-white/30"
                          }`}
                        >
                          {filter}
                        </motion.button>
                      );
                    })}
                  </div>
                </div>
              </div>
            </div>

            {/* Events Feed */}
            <div className="bg-gray-50 pb-32 px-5 pt-5">
              {filteredEvents.length === 0 ? (
                <motion.div
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  className="text-center py-12 bg-white rounded-3xl shadow-md border border-gray-100"
                >
                  <div className="w-20 h-20 bg-gradient-to-br from-purple-100 to-pink-100 rounded-full flex items-center justify-center mx-auto mb-4">
                    <Search className="w-10 h-10 text-purple-600" />
                  </div>
                  <p className="text-gray-700 mb-2">
                    No activities found
                  </p>
                  <p className="text-sm text-gray-500">
                    Try adjusting your search or filter
                  </p>
                </motion.div>
              ) : (
                (() => {
                  // Group events by date
                  const groupedEvents: { [key: string]: typeof filteredEvents } = {};
                  filteredEvents.forEach((event) => {
                    const dateKey = `${event.date} ${event.month} ${event.year}`;
                    if (!groupedEvents[dateKey]) {
                      groupedEvents[dateKey] = [];
                    }
                    groupedEvents[dateKey].push(event);
                  });

                  return Object.entries(groupedEvents).map(([dateKey, events]) => {
                    const firstEvent = events[0];
                    return (
                      <div key={dateKey} className="mb-6">
                        {/* Date Header */}
                        <div className="px-5 py-4 bg-gray-50">
                          <h2 className="text-black">
                            <span className="mr-1">{firstEvent.date} {firstEvent.month}</span>
                            <span className="text-gray-400">/ {firstEvent.dayOfWeek}</span>
                          </h2>
                        </div>

                        {/* Events for this date */}
                        <div className="bg-white divide-y divide-gray-100">
                          {events.map((event) => (
                            <EventCard
                              key={event.id}
                              activityId={generateActivityId(
                                event.category,
                                event.id,
                              )}
                              date={event.date}
                              month={event.month}
                              year={event.year}
                              dayOfWeek={event.dayOfWeek}
                              weather={event.weather}
                              temperature={event.temperature}
                              category={event.category}
                              title={event.title}
                              description={event.description}
                              time={event.time}
                              location={event.location}
                              participants={event.participants}
                              budget={event.budget}
                              recruiting={event.recruiting}
                              proficiency={event.proficiency}
                              genderRestriction={event.genderRestriction}
                              passwordRequired={event.passwordRequired}
                              password={event.password}
                              images={event.images}
                              attendeeAvatars={event.attendeeAvatars}
                              onViewDetails={() => setSelectedEvent(event)}
                              onAddFavorite={() => {
                                if (!favoriteEvents.includes(event.id)) {
                                  setFavoriteEvents([
                                    ...favoriteEvents,
                                    event.id,
                                  ]);
                                  toast.success("Added to Library", {
                                    description: event.title,
                                    duration: 2000,
                                  });
                                } else {
                                  toast.info("Already in Library", {
                                    description: event.title,
                                    duration: 2000,
                                  });
                                }
                              }}
                            />
                          ))}
                        </div>
                      </div>
                    );
                  });
                })()
              )}
            </div>
          </>
        )}

        {/* Pool Page */}
        {activeTab === "pool" && (
          <PoolPage
            onViewPost={handleViewPost}
            onViewProfile={handleViewProfile}
            onCreatePost={() => setShowPostCreation(true)}
            onViewActivity={handleViewActivityFromPool}
            onBack={() => setActiveTab("home")}
          />
        )}

        {/* Messages/Notifications Page */}
        {activeTab === "notifications" && (
          <NotificationsPage
            onBack={() => setActiveTab("home")}
            onViewProfile={handleViewProfile}
          />
        )}

        {/* Messages Page */}
        {activeTab === "messages" && (
          <MessagesPage
            onBack={() => setActiveTab("home")}
            onViewProfile={handleViewProfile}
          />
        )}
      </div>

      {/* Bottom Navigation - Instagram Style Light */}
      <div className="fixed bottom-0 left-0 right-0 max-w-md mx-auto z-50 pointer-events-none">
        <div className="bg-white/95 backdrop-blur-xl border-t border-gray-100 px-4 py-2 pointer-events-auto shadow-2xl">
          <div className="flex items-center justify-around gap-2">
            <motion.button
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={() => setActiveTab("home")}
              className={`flex-1 flex flex-col items-center gap-1 py-2.5 px-3 rounded-2xl transition-all ${
                activeTab === "home"
                  ? "bg-gradient-to-br from-indigo-100 via-purple-100 to-pink-100"
                  : ""
              }`}
            >
              <motion.div
                animate={{
                  scale: activeTab === "home" ? 1.1 : 1,
                }}
                transition={{ duration: 0.2 }}
              >
                <HomeIcon
                  className={`w-6 h-6 transition-colors ${
                    activeTab === "home" 
                      ? "fill-purple-600 stroke-purple-600" 
                      : "stroke-gray-500 fill-none"
                  }`}
                />
              </motion.div>
              <span className={`text-xs transition-colors ${
                activeTab === "home" ? "text-purple-600" : "text-gray-500"
              }`}>
                Home
              </span>
            </motion.button>
            
            <motion.button
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={() => setActiveTab("pool")}
              className={`flex-1 flex flex-col items-center gap-1 py-2.5 px-3 rounded-2xl transition-all ${
                activeTab === "pool"
                  ? "bg-gradient-to-br from-indigo-100 via-purple-100 to-pink-100"
                  : ""
              }`}
            >
              <motion.div
                animate={{
                  scale: activeTab === "pool" ? 1.1 : 1,
                }}
                transition={{ duration: 0.2 }}
              >
                <Radio
                  className={`w-6 h-6 transition-colors ${
                    activeTab === "pool" 
                      ? "fill-purple-600 stroke-purple-600" 
                      : "stroke-gray-500 fill-none"
                  }`}
                />
              </motion.div>
              <span className={`text-xs transition-colors ${
                activeTab === "pool" ? "text-purple-600" : "text-gray-500"
              }`}>
                Discover
              </span>
            </motion.button>
            
            <motion.button
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              onClick={() => setActiveTab("messages")}
              className={`flex-1 flex flex-col items-center gap-1 py-2.5 px-3 rounded-2xl transition-all ${
                activeTab === "messages"
                  ? "bg-gradient-to-br from-indigo-100 via-purple-100 to-pink-100"
                  : ""
              }`}
            >
              <motion.div
                animate={{
                  scale: activeTab === "messages" ? 1.1 : 1,
                }}
                transition={{ duration: 0.2 }}
              >
                <MessageSquare
                  className={`w-6 h-6 transition-colors ${
                    activeTab === "messages" 
                      ? "fill-purple-600 stroke-purple-600" 
                      : "stroke-gray-500 fill-none"
                  }`}
                />
              </motion.div>
              <span className={`text-xs transition-colors ${
                activeTab === "messages" ? "text-purple-600" : "text-gray-500"
              }`}>
                Chat
              </span>
            </motion.button>
          </div>
        </div>

        {/* iOS Home Indicator */}
        <div className="absolute bottom-1.5 left-1/2 -translate-x-1/2 w-32 h-1 bg-black/20 rounded-full pointer-events-none"></div>
      </div>

      {/* Modals and Pages */}
      {selectedEvent && (
        <ActivityDetail
          event={selectedEvent}
          activityId={generateActivityId(
            selectedEvent.category,
            selectedEvent.id,
          )}
          onClose={() => setSelectedEvent(null)}
        />
      )}

      {showSearchPage && (
        <SearchPage
          onClose={() => setShowSearchPage(false)}
          onSearch={(query) => {
            setSearchQuery(query);
            setShowSearchPage(false);
          }}
        />
      )}

      {showFilterPage && (
        <FilterPage
          allEvents={allEvents}
          onClose={() => setShowFilterPage(false)}
          onApplyFilters={(filters) => {
            setAppliedFilters(filters);
            setShowFilterPage(false);
          }}
          currentFilters={appliedFilters}
          onClearFilters={() => {
            setAppliedFilters(null);
          }}
        />
      )}

      {showChangeCityPage && (
        <ChangeCityPage
          currentCity={selectedCity}
          onSelectCity={(city) => {
            setSelectedCity(city);
            setShowChangeCityPage(false);
          }}
          onClose={() => setShowChangeCityPage(false)}
        />
      )}

      {showPostDetail && selectedPost && (
        <PostDetail
          post={selectedPost}
          onClose={() => setShowPostDetail(false)}
          onViewProfile={handleViewProfile}
          onViewActivity={(activityId) => {
            setShowPostDetail(false);
            handleViewActivityFromPool(activityId);
          }}
        />
      )}

      {showPostCreation && (
        <PostCreation
          onClose={() => setShowPostCreation(false)}
          onPost={(post) => {
            toast.success("Post created successfully!");
            setShowPostCreation(false);
          }}
        />
      )}

      {showUserProfile && selectedUserProfile && (
        <UserProfile
          user={getUserDataOrDefault(selectedUserProfile.username, selectedUserProfile.avatar)}
          isOwnProfile={selectedUserProfile.isOwnProfile}
          isFollowing={false}
          onClose={() => setShowUserProfile(false)}
          onToggleFollow={() => {}}
          onViewSettings={() => setShowSettingsPage(true)}
          onViewWallet={() => setShowWalletPage(true)}
        />
      )}

      {showSettingsPage && selectedUserProfile && (
        <SettingsPage
          onClose={() => setShowSettingsPage(false)}
          user={getUserDataOrDefault(selectedUserProfile.username, selectedUserProfile.avatar)}
          darkMode={darkMode}
          onToggleDarkMode={setDarkMode}
        />
      )}

      {showWalletPage && (
        <WalletPage
          onClose={() => setShowWalletPage(false)}
        />
      )}

      {showActivityCreation && (
        <ActivityCreation
          onBack={() => setShowActivityCreation(false)}
        />
      )}

      {/* Create Dialog */}
      {showCreateDialog && (
        <div className="fixed inset-0 z-[200] flex items-end justify-center bg-black/50 animate-in fade-in duration-200">
          <div className="bg-white rounded-t-3xl w-full max-w-md mx-auto p-6 pb-8 animate-in slide-in-from-bottom duration-300">
            <div className="w-12 h-1.5 bg-gray-300 rounded-full mx-auto mb-6"></div>
            <h2 className="text-center mb-6">Create New</h2>
            
            <div className="space-y-3">
              <button
                onClick={() => {
                  setShowCreateDialog(false);
                  setShowPostCreation(true);
                }}
                className="w-full p-4 bg-gradient-to-r from-purple-50 to-pink-50 hover:from-purple-100 hover:to-pink-100 rounded-2xl transition-all text-left"
              >
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 bg-gradient-to-br from-purple-500 to-pink-500 rounded-xl flex items-center justify-center">
                    <MessageSquare className="w-6 h-6 text-white" />
                  </div>
                  <div>
                    <h3 className="text-black mb-1">Post to Pool</h3>
                    <p className="text-gray-600">Share your thoughts with the community</p>
                  </div>
                </div>
              </button>

              <button
                onClick={() => {
                  setShowCreateDialog(false);
                  toast.info("Activity creation coming soon!");
                }}
                className="w-full p-4 bg-gradient-to-r from-blue-50 to-teal-50 hover:from-blue-100 hover:to-teal-100 rounded-2xl transition-all text-left"
              >
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 bg-gradient-to-br from-blue-500 to-teal-500 rounded-xl flex items-center justify-center">
                    <Users className="w-6 h-6 text-white" />
                  </div>
                  <div>
                    <h3 className="text-black mb-1">Initiate an Activity</h3>
                    <p className="text-gray-600">Create a new event or gathering</p>
                  </div>
                </div>
              </button>
            </div>

            <button
              onClick={() => setShowCreateDialog(false)}
              className="w-full mt-4 p-3 text-gray-600 hover:bg-gray-100 rounded-xl transition-all"
            >
              Cancel
            </button>
          </div>
        </div>
      )}
    </div>
  );
}