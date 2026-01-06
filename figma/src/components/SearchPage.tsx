import { useState, useEffect } from "react";
import { motion } from "motion/react";
import { X, Search, TrendingUp, Clock, Hash } from "lucide-react";
import { Input } from './ui/input';
import { Button } from './ui/button';
import { Badge } from './ui/badge';
import { ScrollArea } from './ui/scroll-area';
import { Separator } from './ui/separator';

interface SearchPageProps {
  onClose: () => void;
  onSearch: (query: string) => void;
}

export function SearchPage({ onClose, onSearch }: SearchPageProps) {
  const [searchInput, setSearchInput] = useState('');
  const [searchHistory, setSearchHistory] = useState<string[]>([]);

  // Hot search list - trending topics
  const hotSearches = [
    { id: 1, text: 'Hiking', trend: '+120%' },
    { id: 2, text: 'Board Games', trend: '+85%' },
    { id: 3, text: 'Coffee Chat', trend: '+64%' },
    { id: 4, text: 'TRI-', trend: '+52%' }, // Activity ID search
    { id: 5, text: 'Mount Rainier', trend: '+43%' },
    { id: 6, text: 'Seattle', trend: '+38%' },
    { id: 7, text: 'Weekend', trend: '+29%' },
    { id: 8, text: 'Beginner', trend: '+21%' },
  ];

  // Load search history from localStorage on mount
  useEffect(() => {
    const savedHistory = localStorage.getItem('searchHistory');
    if (savedHistory) {
      setSearchHistory(JSON.parse(savedHistory));
    }
  }, []);

  // Save search history to localStorage
  const saveSearchHistory = (history: string[]) => {
    localStorage.setItem('searchHistory', JSON.stringify(history));
    setSearchHistory(history);
  };

  // Handle search
  const handleSearch = (query: string) => {
    if (!query.trim()) return;
    
    // Add to search history
    if (!searchHistory.includes(query)) {
      const newHistory = [query, ...searchHistory].slice(0, 10); // Keep last 10 searches
      saveSearchHistory(newHistory);
    }
    
    onSearch(query);
  };

  // Handle Enter key
  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      handleSearch(searchInput);
    }
  };

  // Clear individual search history
  const clearHistoryItem = (item: string) => {
    const newHistory = searchHistory.filter(h => h !== item);
    saveSearchHistory(newHistory);
  };

  // Clear all search history
  const clearAllHistory = () => {
    saveSearchHistory([]);
  };

  return (
    <motion.div 
      initial={{ opacity: 0, y: "100%" }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: "100%" }}
      transition={{ duration: 0.3, ease: "easeOut" }}
      className="fixed inset-0 z-[200] bg-gray-50"
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
                onClick={onClose}
                className="p-2.5 -ml-2 hover:bg-white/10 rounded-full transition-all"
              >
                <X className="w-6 h-6 text-white" />
              </motion.button>
              <motion.h1
                initial={{ opacity: 0, y: -10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.1 }}
                className="text-white text-xl"
              >
                Search
              </motion.h1>
              <div className="w-10" />
            </div>

            {/* Search Bar */}
            <div className="relative z-10 px-5 pb-6">
              <motion.div
                initial={{ opacity: 0, scale: 0.95 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.15, type: "spring" }}
                className="relative"
              >
                <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-purple-400" />
                <Input
                  type="text"
                  value={searchInput}
                  onChange={(e) => setSearchInput(e.target.value)}
                  onKeyPress={handleKeyPress}
                  placeholder="Search activities, locations, ID..."
                  className="w-full pl-12 pr-4 py-6 bg-white/15 backdrop-blur-xl border-2 border-white/20 rounded-2xl text-white placeholder:text-white/60 text-lg focus:bg-white/25 focus:border-white/40 transition-all shadow-2xl"
                />
              </motion.div>
            </div>
          </div>

          {/* Content */}
          <div className="px-5 py-5 pb-32">
            {/* Search History */}
            {searchHistory.length > 0 && (
              <motion.div 
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.1 }}
                className="mb-8"
              >
                <div className="flex items-center justify-between mb-4">
                  <div className="flex items-center gap-2">
                    <Clock className="w-4 h-4 text-gray-600" />
                    <h2 className="text-black">Recent Searches</h2>
                  </div>
                  <motion.div whileHover={{ scale: 1.05 }} whileTap={{ scale: 0.95 }}>
                    <Button
                      variant="ghost"
                      size="sm"
                      onClick={clearAllHistory}
                      className="text-gray-600 hover:text-black h-auto p-0"
                    >
                      Clear All
                    </Button>
                  </motion.div>
                </div>
                
                <div className="space-y-2">
                  {searchHistory.map((item, index) => (
                    <motion.div
                      key={index}
                      initial={{ opacity: 0, x: -20 }}
                      animate={{ opacity: 1, x: 0 }}
                      transition={{ delay: 0.15 + index * 0.05 }}
                      whileHover={{ scale: 1.02, backgroundColor: "#f9fafb" }}
                      whileTap={{ scale: 0.98 }}
                      className="flex items-center justify-between group p-3 rounded-lg transition-all cursor-pointer"
                      onClick={() => handleSearch(item)}
                    >
                      <div className="flex items-center gap-3 flex-1">
                        <Search className="w-4 h-4 text-gray-400" />
                        <span className="text-gray-700">{item}</span>
                      </div>
                      <motion.button
                        whileHover={{ scale: 1.2, rotate: 90 }}
                        whileTap={{ scale: 0.8 }}
                        onClick={(e) => {
                          e.stopPropagation();
                          clearHistoryItem(item);
                        }}
                        className="opacity-0 group-hover:opacity-100 p-1 hover:bg-gray-200 rounded-full transition-all"
                      >
                        <X className="w-3.5 h-3.5 text-gray-500" />
                      </motion.button>
                    </motion.div>
                  ))}
                </div>
              </motion.div>
            )}

            {searchHistory.length > 0 && (
              <Separator className="my-6" />
            )}

            {/* Hot Searches */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: searchHistory.length > 0 ? 0.3 : 0.1 }}
            >
              <div className="flex items-center gap-2 mb-4">
                <TrendingUp className="w-4 h-4 text-orange-500" />
                <h2 className="text-black">Trending Searches</h2>
              </div>
              
              <div className="grid grid-cols-2 gap-3">
                {hotSearches.map((item, index) => (
                  <motion.button
                    key={item.id}
                    initial={{ opacity: 0, scale: 0.8 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ delay: 0.35 + index * 0.05 }}
                    whileHover={{ scale: 1.05, y: -2 }}
                    whileTap={{ scale: 0.95 }}
                    onClick={() => handleSearch(item.text)}
                    className="flex items-center justify-between p-4 bg-gradient-to-br from-orange-50 to-red-50 hover:from-orange-100 hover:to-red-100 rounded-xl transition-all group border border-orange-100"
                  >
                    <div className="flex items-center gap-2 flex-1">
                      {item.text.includes('-') ? (
                        <Hash className="w-4 h-4 text-orange-600" />
                      ) : (
                        <TrendingUp className="w-4 h-4 text-orange-600" />
                      )}
                      <span className="text-black group-hover:text-orange-900 transition-colors">
                        {item.text}
                      </span>
                    </div>
                    <Badge variant="outline" className="border-orange-300 text-orange-700 text-xs bg-white/50">
                      {item.trend}
                    </Badge>
                  </motion.button>
                ))}
              </div>
            </motion.div>
          </div>
        </ScrollArea>
      </div>
    </motion.div>
  );
}