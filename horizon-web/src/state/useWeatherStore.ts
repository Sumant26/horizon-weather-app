import { useState, useEffect, useCallback } from 'react';
import {
  fetchUserLiveWeather,
  getCachedUserWeather,
  LiveWeatherData,
  DaySnapshot,
} from '../domain/services/live_weather_service';

export const DEFAULT_YESTERDAY: DaySnapshot = {
  id: 'yesterday',
  dateLabel: 'Yesterday',
  dateStr: 'Past 24h',
  temperature: 25.2,
  tempMin: 18.0,
  tempMax: 27.5,
  feelsLike: 25.2,
  weatherCode: 0,
  conditionName: 'Clear Skies',
  deltaLabel: 'Baseline historical reference',
  deltaValue: 0,
  deltaType: 'mild',
  summary: '"Recorded baseline temperature with clear conditions over your location."',
  optimalWindow: '08:00 – 10:00 AM',
  optimalSub: 'Historical Peak Clarity',
  gear: ['🕶️ Sunglasses', '💧 Water Bottle'],
};

export const DEFAULT_TODAY: DaySnapshot = {
  id: 'today',
  dateLabel: 'Today',
  dateStr: 'Live',
  temperature: 22.4,
  tempMin: 16.5,
  tempMax: 26.0,
  feelsLike: 21.8,
  weatherCode: 1,
  conditionName: 'Partly Cloudy',
  deltaLabel: '-2.8° Cooler than yesterday',
  deltaValue: -2.8,
  deltaType: 'cool',
  summary: '"Crisp morning breeze with gentle warming towards noon. A quiet, comfortable window for outdoor activity."',
  optimalWindow: '07:00 – 09:00 AM',
  optimalSub: 'Gentle Breeze • Comfort 94',
  gear: ['🕶️ Sunglasses', '🧥 Light Windbreaker', '💧 Water Bottle'],
};

export const DEFAULT_TOMORROW: DaySnapshot = {
  id: 'tomorrow',
  dateLabel: 'Tomorrow',
  dateStr: 'Forecast',
  temperature: 23.8,
  tempMin: 17.0,
  tempMax: 27.0,
  feelsLike: 23.5,
  weatherCode: 0,
  conditionName: 'Sunny & Clear',
  deltaLabel: '+1.4° Warmer than today',
  deltaValue: 1.4,
  deltaType: 'warm',
  summary: '"Warmer solar trend continuing into tomorrow. Great outdoor conditions expected all morning."',
  optimalWindow: '07:30 – 09:30 AM',
  optimalSub: 'Comfort Index 92',
  gear: ['🧢 Sun Cap', '🕶️ Sunglasses', '💧 Hydration Pack'],
};

export function useWeatherStore() {
  const [liveData, setLiveData] = useState<LiveWeatherData | null>(() => getCachedUserWeather());
  const [isLocating, setIsLocating] = useState<boolean>(() => getCachedUserWeather() === null);
  const [locationError, setLocationError] = useState<string | null>(null);

  const refreshWeather = useCallback(async (force = false) => {
    // If we have cached data, don't show full loading spinner unless forced
    if (!liveData) {
      setIsLocating(true);
    }
    setLocationError(null);
    try {
      const data = await fetchUserLiveWeather({ forceRefresh: force });
      setLiveData(data);
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : 'Location detection unavailable';
      setLocationError(msg);
    } finally {
      setIsLocating(false);
    }
  }, [liveData]);

  useEffect(() => {
    refreshWeather();
  }, [refreshWeather]);

  const locationName = liveData?.locationName ?? (isLocating ? 'Detecting location...' : 'Your Location');
  const microclimate = liveData?.microclimate ?? (locationError ? 'GPS Permission Needed' : 'Local Microclimate');
  const yesterday = liveData?.yesterday ?? DEFAULT_YESTERDAY;
  const today = liveData?.today ?? DEFAULT_TODAY;
  const tomorrow = liveData?.tomorrow ?? DEFAULT_TOMORROW;

  return {
    liveData,
    locationName,
    microclimate,
    yesterday,
    today,
    tomorrow,
    isLocating,
    locationError,
    refreshWeather: () => refreshWeather(true),
  };
}
