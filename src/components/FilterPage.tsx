import { useState, useEffect } from 'react';
import { ArrowLeft, DollarSign, Users as UsersIcon, Calendar as CalendarIcon, CloudRain, Sun, Cloud, Snowflake, Clock, User, Filter as FilterIcon } from 'lucide-react';
import { Button } from './ui/button';
import { Badge } from './ui/badge';
import { Separator } from './ui/separator';
import { Slider } from './ui/slider';
import { Calendar } from './ui/calendar';
import { Popover, PopoverContent, PopoverTrigger } from './ui/popover';
import { Label } from './ui/label';
import { Switch } from './ui/switch';

type ProficiencyLevel = 'Beginner' | 'Intermediate' | 'Advanced' | 'Expert';
type GenderRestriction = 'no-restrictions' | 'male-only' | 'female-only' | 'lgbt-friendly';
type Weather = 'clear' | 'partly-cloudy' | 'cloudy' | 'overcast' | 'light-rain' | 'heavy-rain' | 'thunderstorm' | 'light-snow' | 'heavy-snow' | 'foggy';

interface Event {
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
}

interface FilterPageProps {
  onClose: () => void;
  allEvents?: Event[];
  onApplyFilters: (filters: FilterState) => void;
  currentFilters?: FilterState;
  onClearFilters?: () => void;
}

export interface FilterState {
  categories: string[];
  budgetRange: [number, number];
  participantsRange: [number, number];
  weather: Weather[];
  genderRestrictions: GenderRestriction[];
  dateRange: { from?: Date; to?: Date };
  timeRange: string[];
  recruitingOnly: boolean;
  proficiencyLevels: ProficiencyLevel[];
}

export function FilterPage({ onClose, allEvents = [], onApplyFilters, currentFilters, onClearFilters }: FilterPageProps) {
  // Calculate min/max values from events
  const maxBudget = allEvents.length > 0 ? Math.max(...allEvents.map(e => e.budget)) : 100;
  const maxParticipants = allEvents.length > 0 ? Math.max(...allEvents.map(e => e.participants)) : 50;

  const [filters, setFilters] = useState<FilterState>(currentFilters || {
    categories: [],
    budgetRange: [0, maxBudget],
    participantsRange: [0, maxParticipants],
    weather: [],
    genderRestrictions: [],
    dateRange: {},
    timeRange: [],
    recruitingOnly: false,
    proficiencyLevels: [],
  });

  const categories = ['Trips', 'Board Games', 'Foods', 'Sports', 'Coffee Chat', 'KTV', 'Others'];
  const weatherOptions: { type: Weather; icon: any; label: string; color: string }[] = [
    { type: 'clear', icon: Sun, label: 'Clear', color: 'bg-yellow-100 text-yellow-700 border-yellow-300' },
    { type: 'partly-cloudy', icon: Cloud, label: 'Partly Cloudy', color: 'bg-blue-50 text-blue-600 border-blue-200' },
    { type: 'cloudy', icon: Cloud, label: 'Cloudy', color: 'bg-gray-100 text-gray-700 border-gray-300' },
    { type: 'overcast', icon: Cloud, label: 'Overcast', color: 'bg-gray-200 text-gray-800 border-gray-400' },
    { type: 'light-rain', icon: CloudRain, label: 'Light Rain', color: 'bg-blue-100 text-blue-700 border-blue-300' },
    { type: 'heavy-rain', icon: CloudRain, label: 'Heavy Rain', color: 'bg-blue-200 text-blue-800 border-blue-400' },
    { type: 'thunderstorm', icon: CloudRain, label: 'Thunderstorm', color: 'bg-purple-100 text-purple-700 border-purple-300' },
    { type: 'light-snow', icon: Snowflake, label: 'Light Snow', color: 'bg-cyan-50 text-cyan-600 border-cyan-200' },
    { type: 'heavy-snow', icon: Snowflake, label: 'Heavy Snow', color: 'bg-cyan-100 text-cyan-700 border-cyan-300' },
    { type: 'foggy', icon: Cloud, label: 'Foggy', color: 'bg-slate-100 text-slate-700 border-slate-300' },
  ];

  const genderOptions: { type: GenderRestriction; label: string; icon: string }[] = [
    { type: 'no-restrictions', label: 'No Restrictions', icon: '👥' },
    { type: 'male-only', label: 'Male Only', icon: '👨' },
    { type: 'female-only', label: 'Female Only', icon: '👩' },
    { type: 'lgbt-friendly', label: 'LGBT+ Friendly', icon: '🏳️‍🌈' },
  ];

  const timeSlots = ['Morning (6AM-12PM)', 'Afternoon (12PM-6PM)', 'Evening (6PM-12AM)', 'Night (12AM-6AM)'];
  
  const proficiencyOptions: ProficiencyLevel[] = ['Beginner', 'Intermediate', 'Advanced', 'Expert'];

  // Toggle category
  const toggleCategory = (category: string) => {
    setFilters(prev => ({
      ...prev,
      categories: prev.categories.includes(category)
        ? prev.categories.filter(c => c !== category)
        : [...prev.categories, category]
    }));
  };

  // Toggle weather
  const toggleWeather = (weather: Weather) => {
    setFilters(prev => ({
      ...prev,
      weather: prev.weather.includes(weather)
        ? prev.weather.filter(w => w !== weather)
        : [...prev.weather, weather]
    }));
  };

  // Toggle gender restriction with mutual exclusivity
  const toggleGenderRestriction = (gender: GenderRestriction) => {
    setFilters(prev => {
      let newRestrictions = [...prev.genderRestrictions];
      
      if (newRestrictions.includes(gender)) {
        // Remove if already selected
        newRestrictions = newRestrictions.filter(g => g !== gender);
      } else {
        // Add the new selection
        newRestrictions.push(gender);
        
        // Make male-only, female-only, and no-restrictions mutually exclusive
        if (gender === 'male-only') {
          newRestrictions = newRestrictions.filter(g => g !== 'female-only' && g !== 'no-restrictions');
        } else if (gender === 'female-only') {
          newRestrictions = newRestrictions.filter(g => g !== 'male-only' && g !== 'no-restrictions');
        } else if (gender === 'no-restrictions') {
          newRestrictions = newRestrictions.filter(g => g !== 'male-only' && g !== 'female-only');
        }
      }
      
      return {
        ...prev,
        genderRestrictions: newRestrictions
      };
    });
  };

  // Toggle time slot
  const toggleTimeSlot = (slot: string) => {
    setFilters(prev => ({
      ...prev,
      timeRange: prev.timeRange.includes(slot)
        ? prev.timeRange.filter(t => t !== slot)
        : [...prev.timeRange, slot]
    }));
  };

  // Toggle proficiency level
  const toggleProficiency = (level: ProficiencyLevel) => {
    setFilters(prev => ({
      ...prev,
      proficiencyLevels: prev.proficiencyLevels.includes(level)
        ? prev.proficiencyLevels.filter(p => p !== level)
        : [...prev.proficiencyLevels, level]
    }));
  };

  // Calculate matching results
  const getMatchingCount = () => {
    return allEvents.filter(event => {
      // Category filter
      if (filters.categories.length > 0 && !filters.categories.includes(event.category)) {
        return false;
      }

      // Budget filter
      if (event.budget < filters.budgetRange[0] || event.budget > filters.budgetRange[1]) {
        return false;
      }

      // Participants filter
      if (event.participants < filters.participantsRange[0] || event.participants > filters.participantsRange[1]) {
        return false;
      }

      // Weather filter
      if (filters.weather.length > 0 && !filters.weather.includes(event.weather)) {
        return false;
      }

      // Gender restriction filter
      if (filters.genderRestrictions.length > 0 && !filters.genderRestrictions.includes(event.genderRestriction)) {
        return false;
      }

      // Recruiting only filter
      if (filters.recruitingOnly && !event.recruiting) {
        return false;
      }

      // Proficiency filter
      if (filters.proficiencyLevels.length > 0 && event.proficiency && !filters.proficiencyLevels.includes(event.proficiency)) {
        return false;
      }

      // Time range filter
      if (filters.timeRange.length > 0) {
        const eventTime = event.time.toLowerCase();
        const hour = parseInt(event.time.split(':')[0]);
        const isPM = eventTime.includes('pm');
        const hour24 = isPM && hour !== 12 ? hour + 12 : hour;

        let matchesTime = false;
        filters.timeRange.forEach(slot => {
          if (slot.includes('Morning') && hour24 >= 6 && hour24 < 12) matchesTime = true;
          if (slot.includes('Afternoon') && hour24 >= 12 && hour24 < 18) matchesTime = true;
          if (slot.includes('Evening') && hour24 >= 18 && hour24 < 24) matchesTime = true;
          if (slot.includes('Night') && (hour24 >= 0 && hour24 < 6)) matchesTime = true;
        });

        if (!matchesTime) return false;
      }

      return true;
    }).length;
  };

  const matchingCount = getMatchingCount();

  // Reset all filters
  const resetFilters = () => {
    setFilters({
      categories: [],
      budgetRange: [0, maxBudget],
      participantsRange: [0, maxParticipants],
      weather: [],
      genderRestrictions: [],
      dateRange: {},
      timeRange: [],
      recruitingOnly: false,
      proficiencyLevels: [],
    });
  };

  // Apply filters
  const handleApply = () => {
    onApplyFilters(filters);
    onClose();
  };

  return (
    <div className="fixed inset-0 z-[200] bg-white animate-in slide-in-from-right duration-300">
      <div className="fixed inset-0 max-w-md mx-auto bg-white flex flex-col">
        {/* Header */}
        <div className="flex-none bg-white border-b border-gray-200">
          <div className="flex items-center justify-between px-5 py-4">
            <div className="flex items-center gap-3">
              <button
                onClick={onClose}
                className="p-2 hover:bg-gray-100 rounded-full transition-all"
              >
                <ArrowLeft className="w-5 h-5 text-black" />
              </button>
              <div>
                <h1 className="text-black">Filters</h1>
                <p className="text-xs text-gray-500">{matchingCount} activities match</p>
              </div>
            </div>
            
            <Button
              variant="ghost"
              onClick={resetFilters}
              className="text-gray-600 hover:text-black"
            >
              Reset
            </Button>
          </div>
        </div>

        {/* Content */}
        <div className="flex-1 overflow-y-auto">
          <div className="px-5 py-6 space-y-8 pb-32">
            {/* Categories */}
            <div>
              <div className="flex items-center gap-2 mb-4">
                <FilterIcon className="w-4 h-4 text-black" />
                <Label className="text-black">Categories</Label>
              </div>
              <div className="flex flex-wrap gap-2">
                {categories.map((category) => (
                  <button
                    key={category}
                    onClick={() => toggleCategory(category)}
                    className={`px-4 py-2 rounded-full text-sm transition-all ${
                      filters.categories.includes(category)
                        ? 'bg-black text-white'
                        : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                    }`}
                  >
                    {category}
                  </button>
                ))}
              </div>
            </div>

            <Separator />

            {/* Budget Range */}
            <div>
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-2">
                  <DollarSign className="w-4 h-4 text-green-600" />
                  <Label className="text-black">Budget Range</Label>
                </div>
                <Badge variant="outline" className="bg-green-50 text-green-700 border-green-200">
                  ${filters.budgetRange[0]} - ${filters.budgetRange[1]}
                </Badge>
              </div>
              <Slider
                min={0}
                max={maxBudget}
                step={5}
                value={filters.budgetRange}
                onValueChange={(value) => setFilters(prev => ({ ...prev, budgetRange: value as [number, number] }))}
                className="mt-6"
              />
              <div className="flex justify-between text-xs text-gray-500 mt-2">
                <span>$0</span>
                <span>${maxBudget}</span>
              </div>
            </div>

            <Separator />

            {/* Participants Range */}
            <div>
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-2">
                  <UsersIcon className="w-4 h-4 text-purple-600" />
                  <Label className="text-black">Number of Participants</Label>
                </div>
                <Badge variant="outline" className="bg-purple-50 text-purple-700 border-purple-200">
                  {filters.participantsRange[0]} - {filters.participantsRange[1]}
                </Badge>
              </div>
              <Slider
                min={0}
                max={maxParticipants}
                step={1}
                value={filters.participantsRange}
                onValueChange={(value) => setFilters(prev => ({ ...prev, participantsRange: value as [number, number] }))}
                className="mt-6"
              />
              <div className="flex justify-between text-xs text-gray-500 mt-2">
                <span>0 people</span>
                <span>{maxParticipants} people</span>
              </div>
            </div>

            <Separator />

            {/* Weather Conditions */}
            <div>
              <div className="flex items-center gap-2 mb-4">
                <Sun className="w-4 h-4 text-orange-600" />
                <Label className="text-black">Weather Conditions</Label>
              </div>
              <div className="grid grid-cols-2 gap-2">
                {weatherOptions.map((option) => {
                  const Icon = option.icon;
                  const isSelected = filters.weather.includes(option.type);
                  return (
                    <button
                      key={option.type}
                      onClick={() => toggleWeather(option.type)}
                      className={`flex items-center gap-2 p-2.5 rounded-lg border-2 transition-all ${
                        isSelected
                          ? option.color + ' border-current'
                          : 'bg-gray-50 text-gray-600 border-gray-200 hover:bg-gray-100'
                      }`}
                    >
                      <Icon className="w-4 h-4 flex-shrink-0" />
                      <span className="text-xs truncate">{option.label}</span>
                    </button>
                  );
                })}
              </div>
            </div>

            <Separator />

            {/* Gender Restrictions */}
            <div>
              <div className="flex items-center gap-2 mb-4">
                <User className="w-4 h-4 text-blue-600" />
                <Label className="text-black">Gender Restrictions</Label>
              </div>
              <div className="space-y-2">
                {genderOptions.map((option) => {
                  const isSelected = filters.genderRestrictions.includes(option.type);
                  const isDisabled = 
                    (option.type === 'male-only' && (filters.genderRestrictions.includes('female-only') || filters.genderRestrictions.includes('no-restrictions'))) ||
                    (option.type === 'female-only' && (filters.genderRestrictions.includes('male-only') || filters.genderRestrictions.includes('no-restrictions'))) ||
                    (option.type === 'no-restrictions' && (filters.genderRestrictions.includes('male-only') || filters.genderRestrictions.includes('female-only')));
                  
                  return (
                    <button
                      key={option.type}
                      onClick={() => toggleGenderRestriction(option.type)}
                      disabled={isDisabled}
                      className={`w-full flex items-center gap-3 p-3 rounded-lg border-2 transition-all ${
                        isSelected
                          ? 'bg-blue-100 text-blue-700 border-blue-300'
                          : isDisabled
                          ? 'bg-gray-100 text-gray-400 border-gray-200 cursor-not-allowed opacity-50'
                          : 'bg-gray-50 text-gray-600 border-gray-200 hover:bg-gray-100'
                      }`}
                    >
                      <span className="text-xl">{option.icon}</span>
                      <span className="text-sm">{option.label}</span>
                    </button>
                  );
                })}
              </div>
              <p className="text-xs text-gray-500 mt-2 italic">
                * Male Only, Female Only, and No Restrictions are mutually exclusive
              </p>
            </div>

            <Separator />

            {/* Time Slots */}
            <div>
              <div className="flex items-center gap-2 mb-4">
                <Clock className="w-4 h-4 text-indigo-600" />
                <Label className="text-black">Time of Day</Label>
              </div>
              <div className="space-y-2">
                {timeSlots.map((slot) => {
                  const isSelected = filters.timeRange.includes(slot);
                  return (
                    <button
                      key={slot}
                      onClick={() => toggleTimeSlot(slot)}
                      className={`w-full flex items-center gap-3 p-3 rounded-lg border-2 transition-all ${
                        isSelected
                          ? 'bg-indigo-100 text-indigo-700 border-indigo-300'
                          : 'bg-gray-50 text-gray-600 border-gray-200 hover:bg-gray-100'
                      }`}
                    >
                      <Clock className="w-4 h-4" />
                      <span className="text-sm">{slot}</span>
                    </button>
                  );
                })}
              </div>
            </div>

            <Separator />

            {/* Proficiency Levels */}
            <div>
              <div className="flex items-center gap-2 mb-4">
                <Badge className="w-4 h-4 bg-amber-600" />
                <Label className="text-black">Proficiency Level</Label>
              </div>
              <div className="flex flex-wrap gap-2">
                {proficiencyOptions.map((level) => {
                  const isSelected = filters.proficiencyLevels.includes(level);
                  return (
                    <button
                      key={level}
                      onClick={() => toggleProficiency(level)}
                      className={`px-4 py-2 rounded-full text-sm transition-all ${
                        isSelected
                          ? 'bg-amber-600 text-white'
                          : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                      }`}
                    >
                      {level}
                    </button>
                  );
                })}
              </div>
            </div>

            <Separator />

            {/* Recruiting Only Toggle */}
            <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
              <div className="flex items-center gap-2">
                <UsersIcon className="w-4 h-4 text-red-600" />
                <div>
                  <Label className="text-black">Recruiting Only</Label>
                  <p className="text-xs text-gray-500">Show activities that are currently recruiting</p>
                </div>
              </div>
              <Switch
                checked={filters.recruitingOnly}
                onCheckedChange={(checked) => setFilters(prev => ({ ...prev, recruitingOnly: checked }))}
              />
            </div>
          </div>
        </div>

        {/* Footer with Apply Button */}
        <div className="flex-none bg-white border-t border-gray-200 p-5">
          <Button
            onClick={handleApply}
            className="w-full bg-black text-white hover:bg-gray-800 h-12"
          >
            Show {matchingCount} Results
          </Button>
        </div>
      </div>
    </div>
  );
}
