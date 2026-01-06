import { useEffect, useState } from 'react';

type Weather = 'clear' | 'partly-cloudy' | 'cloudy' | 'overcast' | 'light-rain' | 'heavy-rain' | 'thunderstorm' | 'light-snow' | 'heavy-snow' | 'foggy';

interface WeatherBackgroundProps {
  weather: Weather;
  time: string; // format: "10:00 AM" or "8:00 PM"
  date: string; // format: "15" or day of month
}

export function WeatherBackground({ weather, time, date }: WeatherBackgroundProps) {
  const [isNight, setIsNight] = useState(false);
  const [moonPhase, setMoonPhase] = useState(0);

  useEffect(() => {
    // Determine if it's night time
    const isPM = time.toLowerCase().includes('pm');
    const hour = parseInt(time.split(':')[0]);
    const actualHour = isPM && hour !== 12 ? hour + 12 : hour === 12 && !isPM ? 0 : hour;
    
    // Night is from 6 PM to 6 AM
    setIsNight(actualHour >= 18 || actualHour < 6);

    // Calculate moon phase based on date (simplified lunar cycle approximation)
    const day = parseInt(date);
    const phase = ((day % 29.53) / 29.53) * 100; // Lunar cycle is ~29.53 days
    setMoonPhase(phase);
  }, [time, date]);

  // Create rain drops
  const rainDrops = Array.from({ length: 100 }, (_, i) => ({
    id: i,
    left: Math.random() * 100,
    delay: Math.random() * 2,
    duration: 0.5 + Math.random() * 0.5,
  }));

  // Create snow flakes
  const snowFlakes = Array.from({ length: 50 }, (_, i) => ({
    id: i,
    left: Math.random() * 100,
    delay: Math.random() * 3,
    duration: 3 + Math.random() * 2,
  }));

  // Create clouds
  const clouds = Array.from({ length: 5 }, (_, i) => ({
    id: i,
    top: 10 + Math.random() * 40,
    delay: i * 2,
    duration: 20 + Math.random() * 10,
  }));

  return (
    <div className="absolute inset-0 overflow-hidden pointer-events-none z-0">
      {/* Clear Day - Sun */}
      {weather === 'clear' && !isNight && (
        <>
          {/* Sunny gradient background */}
          <div className="absolute inset-0 bg-gradient-to-br from-yellow-100/70 via-orange-100/50 to-amber-50/30" />
          <div className="absolute top-8 right-8 animate-pulse">
            <div className="relative">
              {/* Sun core */}
              <div className="w-16 h-16 bg-yellow-300/90 rounded-full shadow-[0_0_60px_25px_rgba(253,224,71,0.6)]" />
              {/* Sun rays */}
              <div className="absolute inset-0 animate-spin-slow">
                {Array.from({ length: 8 }).map((_, i) => (
                  <div
                    key={i}
                    className="absolute w-1.5 h-7 bg-yellow-300/80 rounded-full"
                    style={{
                      top: '50%',
                      left: '50%',
                      transform: `translate(-50%, -50%) rotate(${i * 45}deg) translateY(-40px)`,
                    }}
                  />
                ))}
              </div>
            </div>
          </div>
        </>
      )}

      {/* Clear Night - Moon with phases */}
      {weather === 'clear' && isNight && (
        <>
          {/* Night gradient background - Darker */}
          <div className="absolute inset-0 bg-gradient-to-br from-indigo-950/70 via-blue-950/60 to-slate-900/55" />
          <div className="absolute top-8 right-8">
            <div className="relative w-16 h-16">
              {/* Check if it's eclipse date (15th) */}
              {parseInt(date) === 15 ? (
                <>
                  {/* Eclipse - Moon with dramatic shadow */}
                  <div className="w-16 h-16 bg-gray-100 rounded-full shadow-[0_0_80px_35px_rgba(239,68,68,0.5)]" />
                  {/* Eclipse shadow - darker and more dramatic */}
                  <div className="absolute top-0 left-0 w-16 h-16 bg-gradient-to-br from-red-900/95 via-orange-900/90 to-gray-900 rounded-full" 
                       style={{
                         clipPath: 'circle(50% at 65% 50%)',
                       }} 
                  />
                  {/* Outer glow for eclipse */}
                  <div className="absolute -inset-2 rounded-full bg-gradient-to-br from-red-500/40 via-orange-500/30 to-transparent blur-xl" />
                  {/* Craters */}
                  <div className="absolute top-3 left-2 w-2 h-2 bg-gray-400/70 rounded-full" />
                  <div className="absolute top-6 right-3 w-1.5 h-1.5 bg-gray-400/70 rounded-full" />
                  <div className="absolute bottom-4 left-5 w-3 h-3 bg-gray-400/70 rounded-full" />
                </>
              ) : (
                <>
                  {/* Regular full moon */}
                  <div className="w-16 h-16 bg-gray-100 rounded-full shadow-[0_0_70px_30px_rgba(229,231,235,0.7)]" />
                  {/* Moon shadow for phases */}
                  <div
                    className="absolute top-0 right-0 w-16 h-16 bg-gray-400/50 rounded-full transition-all duration-1000"
                    style={{
                      clipPath: `inset(0 ${100 - moonPhase}% 0 0)`,
                    }}
                  />
                  {/* Craters */}
                  <div className="absolute top-3 left-2 w-2 h-2 bg-gray-300/80 rounded-full" />
                  <div className="absolute top-6 right-3 w-1.5 h-1.5 bg-gray-300/80 rounded-full" />
                  <div className="absolute bottom-4 left-5 w-3 h-3 bg-gray-300/80 rounded-full" />
                </>
              )}
            </div>
            {/* Twinkling stars - More, bigger, and brighter */}
            {Array.from({ length: 60 }).map((_, i) => {
              const size = Math.random() > 0.7 ? 2.5 : 1.5;
              const brightness = Math.random() > 0.5 ? 95 : 85;
              return (
                <div
                  key={i}
                  className="absolute bg-white rounded-full animate-twinkle"
                  style={{
                    width: `${size}px`,
                    height: `${size}px`,
                    opacity: `${brightness}%`,
                    top: `${-120 + Math.random() * 700}px`,
                    left: `${-250 + Math.random() * 500}px`,
                    animationDelay: `${Math.random() * 4}s`,
                    boxShadow: `0 0 ${size * 4}px ${size * 1.5}px rgba(255, 255, 255, 0.6)`,
                  }}
                />
              );
            })}
          </div>
        </>
      )}

      {/* Partly Cloudy Weather - Day */}
      {weather === 'partly-cloudy' && !isNight && (
        <>
          {/* Partly cloudy gradient background - Day */}
          <div className="absolute inset-0 bg-gradient-to-br from-blue-100/60 via-gray-50/40 to-yellow-50/30" />
          {clouds.slice(0, 3).map((cloud) => (
            <div
              key={cloud.id}
              className="absolute w-28 h-14 animate-float-cloud"
              style={{
                top: `${cloud.top}%`,
                animationDelay: `${cloud.delay}s`,
                animationDuration: `${cloud.duration}s`,
              }}
            >
              <div className="relative">
                <div className="absolute w-10 h-10 bg-gray-200/50 rounded-full blur-sm" />
                <div className="absolute left-6 w-14 h-14 bg-gray-200/60 rounded-full blur-sm" />
                <div className="absolute left-14 w-12 h-12 bg-gray-200/50 rounded-full blur-sm" />
                <div className="absolute left-3 top-5 w-20 h-6 bg-gray-200/40 rounded-full blur-sm" />
              </div>
            </div>
          ))}
        </>
      )}

      {/* Partly Cloudy Weather - Night */}
      {weather === 'partly-cloudy' && isNight && (
        <>
          {/* Partly cloudy gradient background - Night */}
          <div className="absolute inset-0 bg-gradient-to-br from-indigo-900/60 via-slate-800/55 to-slate-700/50" />
          {clouds.slice(0, 3).map((cloud) => (
            <div
              key={cloud.id}
              className="absolute w-32 h-16 animate-float-cloud"
              style={{
                top: `${cloud.top}%`,
                animationDelay: `${cloud.delay}s`,
                animationDuration: `${cloud.duration}s`,
              }}
            >
              <div className="relative">
                <div className="absolute w-12 h-12 bg-gray-700/60 rounded-full blur-md" />
                <div className="absolute left-6 w-16 h-16 bg-gray-700/70 rounded-full blur-md" />
                <div className="absolute left-14 w-14 h-14 bg-gray-700/60 rounded-full blur-md" />
                <div className="absolute left-4 top-6 w-24 h-8 bg-gray-700/55 rounded-full blur-md" />
              </div>
            </div>
          ))}
          {/* Stars visible */}
          {Array.from({ length: 40 }).map((_, i) => (
            <div
              key={i}
              className="absolute w-1.5 h-1.5 bg-white/70 rounded-full animate-twinkle"
              style={{
                top: `${Math.random() * 100}%`,
                left: `${Math.random() * 100}%`,
                animationDelay: `${Math.random() * 3}s`,
              }}
            />
          ))}
        </>
      )}

      {/* Cloudy Weather - Clouds */}
      {(weather === 'cloudy' || weather === 'overcast') && !isNight && (
        <>
          {/* Cloudy gradient background - Day */}
          <div className="absolute inset-0 bg-gradient-to-br from-gray-200/70 via-slate-100/50 to-gray-50/30" />
          {clouds.map((cloud) => (
            <div
              key={cloud.id}
              className="absolute w-28 h-14 animate-float-cloud"
              style={{
                top: `${cloud.top}%`,
                animationDelay: `${cloud.delay}s`,
                animationDuration: `${cloud.duration}s`,
              }}
            >
              <div className="relative">
                <div className="absolute w-10 h-10 bg-gray-300/60 rounded-full blur-sm" />
                <div className="absolute left-6 w-14 h-14 bg-gray-300/70 rounded-full blur-sm" />
                <div className="absolute left-14 w-12 h-12 bg-gray-300/60 rounded-full blur-sm" />
                <div className="absolute left-3 top-5 w-20 h-6 bg-gray-300/50 rounded-full blur-sm" />
              </div>
            </div>
          ))}
        </>
      )}

      {/* Cloudy Weather - Clouds at Night */}
      {(weather === 'cloudy' || weather === 'overcast') && isNight && (
        <>
          {/* Cloudy gradient background - Night - Much Darker */}
          <div className="absolute inset-0 bg-gradient-to-br from-slate-800/70 via-gray-800/65 to-slate-700/60" />
          {clouds.map((cloud) => (
            <div
              key={cloud.id}
              className="absolute w-32 h-16 animate-float-cloud"
              style={{
                top: `${cloud.top}%`,
                animationDelay: `${cloud.delay}s`,
                animationDuration: `${cloud.duration}s`,
              }}
            >
              <div className="relative">
                <div className="absolute w-12 h-12 bg-gray-700/70 rounded-full blur-md" />
                <div className="absolute left-6 w-16 h-16 bg-gray-700/80 rounded-full blur-md" />
                <div className="absolute left-14 w-14 h-14 bg-gray-700/70 rounded-full blur-md" />
                <div className="absolute left-4 top-6 w-24 h-8 bg-gray-700/65 rounded-full blur-md" />
              </div>
            </div>
          ))}
          {/* Dim stars behind clouds - More visible */}
          {Array.from({ length: 25 }).map((_, i) => (
            <div
              key={i}
              className="absolute w-1.5 h-1.5 bg-gray-200/80 rounded-full animate-twinkle"
              style={{
                top: `${Math.random() * 100}%`,
                left: `${Math.random() * 100}%`,
                animationDelay: `${Math.random() * 3}s`,
              }}
            />
          ))}
        </>
      )}

      {/* Light Rain Weather - Day */}
      {weather === 'light-rain' && !isNight && (
        <>
          {/* Light rainy gradient background - Day */}
          <div className="absolute inset-0 bg-gradient-to-br from-blue-100/60 via-slate-100/50 to-gray-50/35" />
          {/* Light clouds */}
          <div className="absolute top-0 left-0 w-full h-32 bg-gradient-to-b from-gray-400/40 to-transparent" />
          {rainDrops.slice(0, 50).map((drop) => (
            <div
              key={drop.id}
              className="absolute w-0.5 h-5 bg-gradient-to-b from-blue-300/70 to-transparent animate-rain"
              style={{
                left: `${drop.left}%`,
                animationDelay: `${drop.delay}s`,
                animationDuration: `${drop.duration * 1.5}s`,
              }}
            />
          ))}
        </>
      )}

      {/* Light Rain Weather - Night */}
      {weather === 'light-rain' && isNight && (
        <>
          {/* Light rainy gradient background - Night */}
          <div className="absolute inset-0 bg-gradient-to-br from-slate-800/60 via-blue-900/55 to-slate-700/50" />
          {/* Dark clouds */}
          <div className="absolute top-0 left-0 w-full h-32 bg-gradient-to-b from-gray-800/50 to-transparent" />
          {rainDrops.slice(0, 50).map((drop) => (
            <div
              key={drop.id}
              className="absolute w-0.5 h-5 bg-gradient-to-b from-blue-200/65 to-transparent animate-rain"
              style={{
                left: `${drop.left}%`,
                animationDelay: `${drop.delay}s`,
                animationDuration: `${drop.duration * 1.5}s`,
              }}
            />
          ))}
        </>
      )}

      {/* Heavy Rain / Thunderstorm - Day */}
      {(weather === 'heavy-rain' || weather === 'thunderstorm') && !isNight && (
        <>
          {/* Rainy gradient background - Day */}
          <div className="absolute inset-0 bg-gradient-to-br from-blue-200/70 via-slate-200/55 to-gray-100/40" />
          {/* Dark clouds */}
          <div className="absolute top-0 left-0 w-full h-32 bg-gradient-to-b from-gray-500/50 to-transparent" />
          {rainDrops.map((drop) => (
            <div
              key={drop.id}
              className="absolute w-0.5 h-7 bg-gradient-to-b from-blue-400/85 to-transparent animate-rain"
              style={{
                left: `${drop.left}%`,
                animationDelay: `${drop.delay}s`,
                animationDuration: `${drop.duration}s`,
              }}
            />
          ))}
        </>
      )}

      {/* Heavy Rain / Thunderstorm - Night */}
      {(weather === 'heavy-rain' || weather === 'thunderstorm') && isNight && (
        <>
          {/* Rainy gradient background - Night - Darker */}
          <div className="absolute inset-0 bg-gradient-to-br from-slate-800/65 via-blue-900/60 to-slate-700/55" />
          {/* Very dark clouds */}
          <div className="absolute top-0 left-0 w-full h-32 bg-gradient-to-b from-gray-800/60 to-transparent" />
          {rainDrops.map((drop) => (
            <div
              key={drop.id}
              className="absolute w-0.5 h-7 bg-gradient-to-b from-blue-300/75 to-transparent animate-rain"
              style={{
                left: `${drop.left}%`,
                animationDelay: `${drop.delay}s`,
                animationDuration: `${drop.duration}s`,
              }}
            />
          ))}
        </>
      )}

      {/* Light Snow Weather - Day */}
      {weather === 'light-snow' && !isNight && (
        <>
          {/* Light snowy gradient background - Day */}
          <div className="absolute inset-0 bg-gradient-to-br from-blue-50/70 via-cyan-50/55 to-gray-50/40" />
          {snowFlakes.slice(0, 30).map((flake) => (
            <div
              key={flake.id}
              className="absolute animate-snow"
              style={{
                left: `${flake.left}%`,
                animationDelay: `${flake.delay}s`,
                animationDuration: `${flake.duration * 1.3}s`,
              }}
            >
              <div className="w-1.5 h-1.5 bg-white rounded-full shadow-sm" />
            </div>
          ))}
        </>
      )}

      {/* Light Snow Weather - Night */}
      {weather === 'light-snow' && isNight && (
        <>
          {/* Light snowy gradient background - Night */}
          <div className="absolute inset-0 bg-gradient-to-br from-slate-800/60 via-blue-900/55 to-indigo-900/50" />
          {snowFlakes.slice(0, 30).map((flake) => (
            <div
              key={flake.id}
              className="absolute animate-snow"
              style={{
                left: `${flake.left}%`,
                animationDelay: `${flake.delay}s`,
                animationDuration: `${flake.duration * 1.3}s`,
              }}
            >
              <div className="w-1.5 h-1.5 bg-white rounded-full shadow-md" />
            </div>
          ))}
        </>
      )}

      {/* Heavy Snow Weather - Day */}
      {weather === 'heavy-snow' && !isNight && (
        <>
          {/* Snowy gradient background - Day */}
          <div className="absolute inset-0 bg-gradient-to-br from-blue-100/75 via-cyan-100/60 to-gray-100/45" />
          {snowFlakes.map((flake) => (
            <div
              key={flake.id}
              className="absolute animate-snow"
              style={{
                left: `${flake.left}%`,
                animationDelay: `${flake.delay}s`,
                animationDuration: `${flake.duration}s`,
              }}
            >
              <div className="w-2 h-2 bg-white rounded-full shadow-md" />
            </div>
          ))}
        </>
      )}

      {/* Heavy Snow Weather - Night */}
      {weather === 'heavy-snow' && isNight && (
        <>
          {/* Snowy gradient background - Night - Darker */}
          <div className="absolute inset-0 bg-gradient-to-br from-slate-800/65 via-blue-900/60 to-indigo-900/55" />
          {snowFlakes.map((flake) => (
            <div
              key={flake.id}
              className="absolute animate-snow"
              style={{
                left: `${flake.left}%`,
                animationDelay: `${flake.delay}s`,
                animationDuration: `${flake.duration}s`,
              }}
            >
              <div className="w-2 h-2 bg-white rounded-full shadow-lg" />
            </div>
          ))}
        </>
      )}

      {/* Foggy Weather - Day */}
      {weather === 'foggy' && !isNight && (
        <>
          {/* Foggy gradient background - Day */}
          <div className="absolute inset-0 bg-gradient-to-br from-gray-300/80 via-slate-200/70 to-gray-100/60" />
          {/* Fog layers */}
          <div className="absolute inset-0">
            <div className="absolute top-0 w-full h-1/3 bg-gradient-to-b from-gray-400/60 to-transparent blur-3xl" />
            <div className="absolute top-1/4 w-full h-1/2 bg-gradient-to-b from-gray-300/50 to-transparent blur-2xl" />
            <div className="absolute bottom-0 w-full h-1/3 bg-gradient-to-t from-gray-400/70 to-transparent blur-3xl" />
          </div>
        </>
      )}

      {/* Foggy Weather - Night */}
      {weather === 'foggy' && isNight && (
        <>
          {/* Foggy gradient background - Night */}
          <div className="absolute inset-0 bg-gradient-to-br from-slate-700/75 via-gray-800/70 to-slate-800/65" />
          {/* Fog layers - darker */}
          <div className="absolute inset-0">
            <div className="absolute top-0 w-full h-1/3 bg-gradient-to-b from-gray-700/70 to-transparent blur-3xl" />
            <div className="absolute top-1/4 w-full h-1/2 bg-gradient-to-b from-gray-600/60 to-transparent blur-2xl" />
            <div className="absolute bottom-0 w-full h-1/3 bg-gradient-to-t from-gray-700/75 to-transparent blur-3xl" />
          </div>
        </>
      )}

      <style>{`
        @keyframes rain {
          0% {
            transform: translateY(-100px);
            opacity: 0;
          }
          10% {
            opacity: 1;
          }
          100% {
            transform: translateY(100vh);
            opacity: 0.3;
          }
        }

        @keyframes snow {
          0% {
            transform: translateY(-10px) translateX(0);
            opacity: 0;
          }
          10% {
            opacity: 1;
          }
          100% {
            transform: translateY(100vh) translateX(50px);
            opacity: 0.5;
          }
        }

        @keyframes float-cloud {
          0% {
            transform: translateX(-150px);
          }
          100% {
            transform: translateX(calc(100vw + 150px));
          }
        }

        @keyframes twinkle {
          0%, 100% {
            opacity: 0.3;
            transform: scale(1);
          }
          50% {
            opacity: 1;
            transform: scale(1.5);
          }
        }

        .animate-rain {
          animation: rain linear infinite;
        }

        .animate-snow {
          animation: snow linear infinite;
        }

        .animate-float-cloud {
          animation: float-cloud linear infinite;
        }

        .animate-twinkle {
          animation: twinkle ease-in-out infinite;
        }

        .animate-spin-slow {
          animation: spin 20s linear infinite;
        }

        @keyframes spin {
          from {
            transform: rotate(0deg);
          }
          to {
            transform: rotate(360deg);
          }
        }
      `}</style>
    </div>
  );
}
