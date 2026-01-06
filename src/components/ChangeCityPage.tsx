import { useState } from 'react';
import { ArrowLeft, MapPin, Search, Globe } from 'lucide-react';
import { Button } from './ui/button';
import { Input } from './ui/input';

interface ChangeCityPageProps {
  onClose: () => void;
  currentCity: string;
  onCitySelect: (city: string) => void;
}

const cities = [
  { name: 'Seattle', country: 'United States', region: 'North America' },
  { name: 'San Francisco', country: 'United States', region: 'North America' },
  { name: 'New York', country: 'United States', region: 'North America' },
  { name: 'Los Angeles', country: 'United States', region: 'North America' },
  { name: 'Chicago', country: 'United States', region: 'North America' },
  { name: 'Boston', country: 'United States', region: 'North America' },
  { name: 'Austin', country: 'United States', region: 'North America' },
  { name: 'Portland', country: 'United States', region: 'North America' },
  { name: 'Vancouver', country: 'Canada', region: 'North America' },
  { name: 'Toronto', country: 'Canada', region: 'North America' },
  { name: 'Montreal', country: 'Canada', region: 'North America' },
  { name: 'London', country: 'United Kingdom', region: 'Europe' },
  { name: 'Paris', country: 'France', region: 'Europe' },
  { name: 'Berlin', country: 'Germany', region: 'Europe' },
  { name: 'Amsterdam', country: 'Netherlands', region: 'Europe' },
  { name: 'Barcelona', country: 'Spain', region: 'Europe' },
  { name: 'Rome', country: 'Italy', region: 'Europe' },
  { name: 'Tokyo', country: 'Japan', region: 'Asia' },
  { name: 'Seoul', country: 'South Korea', region: 'Asia' },
  { name: 'Singapore', country: 'Singapore', region: 'Asia' },
  { name: 'Hong Kong', country: 'Hong Kong', region: 'Asia' },
  { name: 'Bangkok', country: 'Thailand', region: 'Asia' },
  { name: 'Dubai', country: 'UAE', region: 'Middle East' },
  { name: 'Sydney', country: 'Australia', region: 'Oceania' },
  { name: 'Melbourne', country: 'Australia', region: 'Oceania' },
];

export function ChangeCityPage({ onClose, currentCity, onCitySelect }: ChangeCityPageProps) {
  const [searchQuery, setSearchQuery] = useState('');

  const filteredCities = cities.filter(city =>
    city.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    city.country.toLowerCase().includes(searchQuery.toLowerCase())
  );

  // Group cities by region
  const citiesByRegion = filteredCities.reduce((acc, city) => {
    if (!acc[city.region]) {
      acc[city.region] = [];
    }
    acc[city.region].push(city);
    return acc;
  }, {} as Record<string, typeof cities>);

  const handleCitySelect = (cityName: string) => {
    onCitySelect(cityName);
    onClose();
  };

  return (
    <div className="fixed inset-0 z-[200] bg-white animate-in slide-in-from-right duration-300">
      <div className="fixed inset-0 max-w-md mx-auto bg-white flex flex-col">
        {/* Header */}
        <div className="flex-none bg-white border-b border-gray-200">
          <div className="flex items-center gap-3 px-5 py-4">
            <button
              onClick={onClose}
              className="p-2 hover:bg-gray-100 rounded-full transition-all"
            >
              <ArrowLeft className="w-5 h-5 text-black" />
            </button>
            <div>
              <h1 className="text-black">Change City</h1>
              <p className="text-xs text-gray-500">Select your location</p>
            </div>
          </div>

          {/* Search */}
          <div className="px-5 pb-4">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
              <Input
                type="text"
                placeholder="Search cities..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="pl-10 pr-4 py-2 bg-gray-50 border-gray-200"
              />
            </div>
          </div>
        </div>

        {/* Content */}
        <div className="flex-1 overflow-y-auto">
          <div className="p-5 space-y-6">
            {/* Current Location */}
            <div>
              <div className="flex items-center gap-2 mb-3">
                <MapPin className="w-4 h-4 text-blue-600" />
                <h2 className="text-sm text-gray-500">Current Location</h2>
              </div>
              <button
                className="w-full flex items-center justify-between p-4 bg-blue-50 border-2 border-blue-200 rounded-lg"
              >
                <div className="flex items-center gap-3">
                  <MapPin className="w-5 h-5 text-blue-600" />
                  <div className="text-left">
                    <p className="text-black">{currentCity}</p>
                    <p className="text-xs text-gray-500">Current location</p>
                  </div>
                </div>
              </button>
            </div>

            {/* Cities by Region */}
            {Object.entries(citiesByRegion).map(([region, regionCities]) => (
              <div key={region}>
                <div className="flex items-center gap-2 mb-3">
                  <Globe className="w-4 h-4 text-gray-600" />
                  <h2 className="text-sm text-gray-500">{region}</h2>
                </div>
                <div className="space-y-2">
                  {regionCities.map((city) => {
                    const isCurrent = city.name === currentCity;
                    return (
                      <button
                        key={city.name}
                        onClick={() => handleCitySelect(city.name)}
                        className={`w-full flex items-center justify-between p-4 rounded-lg border-2 transition-all ${
                          isCurrent
                            ? 'bg-blue-50 border-blue-200'
                            : 'bg-gray-50 border-gray-200 hover:bg-gray-100'
                        }`}
                      >
                        <div className="flex items-center gap-3">
                          <MapPin className={`w-5 h-5 ${isCurrent ? 'text-blue-600' : 'text-gray-400'}`} />
                          <div className="text-left">
                            <p className="text-black">{city.name}</p>
                            <p className="text-xs text-gray-500">{city.country}</p>
                          </div>
                        </div>
                      </button>
                    );
                  })}
                </div>
              </div>
            ))}

            {filteredCities.length === 0 && (
              <div className="text-center py-12">
                <Globe className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                <p className="text-gray-500">No cities found</p>
                <p className="text-xs text-gray-400 mt-1">Try a different search term</p>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
