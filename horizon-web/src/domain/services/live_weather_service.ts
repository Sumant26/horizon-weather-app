export interface DaySnapshot {
  id: 'yesterday' | 'today' | 'tomorrow';
  dateLabel: string;
  dateStr: string;
  temperature: number;
  tempMin: number;
  tempMax: number;
  feelsLike: number;
  weatherCode: number;
  conditionName: string;
  deltaLabel: string;
  deltaValue: number;
  deltaType: 'cool' | 'warm' | 'mild';
  summary: string;
  optimalWindow: string;
  optimalSub: string;
  gear: string[];
}

export interface LiveWeatherData {
  locationName: string;
  microclimate: string;
  latitude: number;
  longitude: number;
  yesterday: DaySnapshot;
  today: DaySnapshot;
  tomorrow: DaySnapshot;
}

function getWeatherConditionName(code: number): string {
  if (code === 0) return 'Clear Skies';
  if (code <= 2) return 'Partly Cloudy';
  if (code === 3) return 'Overcast';
  if (code === 45 || code === 48) return 'Morning Fog';
  if (code >= 51 && code <= 67) return 'Passing Rain';
  if (code >= 71 && code <= 77) return 'Light Snow';
  if (code >= 80 && code <= 82) return 'Showers';
  if (code >= 95) return 'Thunderstorms';
  return 'Clear Skies';
}

function computeGear(temp: number, weatherCode: number, uvIndex: number): string[] {
  const gear: string[] = [];
  const isRain = weatherCode >= 51 && weatherCode <= 82;
  const isStorm = weatherCode >= 95;
  const isSnow = weatherCode >= 71 && weatherCode <= 77;

  if (uvIndex >= 4) gear.push('🕶️ Sunglasses');
  if (isRain || isStorm) gear.push('☂️ Rain Umbrella');
  if (isSnow || temp < 10) gear.push('🧣 Heavy Coat');
  else if (temp < 18) gear.push('🧥 Light Jacket');

  if (temp > 25) gear.push('💧 Hydration Bottle');
  if (uvIndex >= 6) gear.push('🧴 SPF 50');

  if (gear.length === 0) {
    gear.push('🕶️ Sunglasses', '💧 Water Bottle');
  }
  return gear.slice(0, 3);
}

function computeDeltaType(delta: number): 'cool' | 'warm' | 'mild' {
  if (delta < -0.2) return 'cool';
  if (delta > 0.2) return 'warm';
  return 'mild';
}

function formatDateLabel(date: Date): string {
  return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
}

export async function fetchUserLiveWeather(): Promise<LiveWeatherData> {
  return new Promise((resolve, reject) => {
    if (!navigator.geolocation) {
      reject(new Error('Geolocation is not supported by your browser.'));
      return;
    }

    navigator.geolocation.getCurrentPosition(
      async (position) => {
        try {
          const lat = position.coords.latitude;
          const lon = position.coords.longitude;

          // 1. Fetch 3-day weather (past_days=1, forecast_days=2)
          const forecastUrl = `https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,uv_index&hourly=temperature_2m,precipitation_probability,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum&past_days=1&forecast_days=2&timezone=auto`;
          const forecastRes = await fetch(forecastUrl);

          if (!forecastRes.ok) {
            throw new Error('Failed to fetch weather data.');
          }

          const forecastData = await forecastRes.json();
          const now = new Date();
          const currentHour = now.getHours();

          // Hourly indices: 0..23 (Yesterday), 24..47 (Today), 48..71 (Tomorrow)
          const hourlyTemps: number[] = forecastData.hourly?.temperature_2m ?? [];
          const hourlyCodes: number[] = forecastData.hourly?.weather_code ?? [];

          const currentTemp = forecastData.current?.temperature_2m ?? 21.5;
          const currentFeelsLike = forecastData.current?.apparent_temperature ?? currentTemp;
          const currentCode = forecastData.current?.weather_code ?? 0;
          const uvIndex = forecastData.current?.uv_index ?? 3.5;

          const yesterdayTemp =
            hourlyTemps[currentHour] !== undefined ? hourlyTemps[currentHour] : currentTemp - 1.2;
          const tomorrowTemp =
            hourlyTemps[48 + currentHour] !== undefined
              ? hourlyTemps[48 + currentHour]
              : currentTemp + 1.5;

          const yesterdayCode = hourlyCodes[currentHour] ?? 0;
          const tomorrowCode = hourlyCodes[48 + currentHour] ?? currentCode;

          const dailyMin = forecastData.daily?.temperature_2m_min ?? [
            yesterdayTemp - 4,
            currentTemp - 4,
            tomorrowTemp - 4,
          ];
          const dailyMax = forecastData.daily?.temperature_2m_max ?? [
            yesterdayTemp + 5,
            currentTemp + 5,
            tomorrowTemp + 5,
          ];

          // 2. Reverse geocode location
          let cityName = `Location (${lat.toFixed(2)}°, ${lon.toFixed(2)}°)`;
          let neighborhood = 'Live GPS Coordinates';

          try {
            const geoRes = await fetch(
              `https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${lat}&longitude=${lon}&localityLanguage=en`
            );
            if (geoRes.ok) {
              const geoData = await geoRes.json();
              const city = geoData.city || geoData.locality || geoData.principalSubdivision;
              const country = geoData.countryCode || geoData.countryName;
              if (city) {
                cityName = `${city}${country ? `, ${country}` : ''}`;
              }
              if (geoData.locality && geoData.locality !== city) {
                neighborhood = `${geoData.locality} • Local Microclimate`;
              } else {
                neighborhood = 'GPS Microclimate Station';
              }
            }
          } catch {
            // keep fallback
          }

          // Dates
          const yesterdayDate = new Date(now.getTime() - 24 * 60 * 60 * 1000);
          const tomorrowDate = new Date(now.getTime() + 24 * 60 * 60 * 1000);

          // Deltas
          const todayVsYesterdayDelta = parseFloat((currentTemp - yesterdayTemp).toFixed(1));
          const tomorrowVsTodayDelta = parseFloat((tomorrowTemp - currentTemp).toFixed(1));

          const yesterdayDeltaType = 'mild';
          const todayDeltaType = computeDeltaType(todayVsYesterdayDelta);
          const tomorrowDeltaType = computeDeltaType(tomorrowVsTodayDelta);

          // Summaries
          const yesterdaySummary = `"Recorded baseline at ${yesterdayTemp.toFixed(1)}°C with ${getWeatherConditionName(
            yesterdayCode
          ).toLowerCase()} over ${cityName}."`;

          const todaySummary =
            todayDeltaType === 'cool'
              ? `"Crisper than yesterday at this hour by ${Math.abs(todayVsYesterdayDelta).toFixed(
                  1
                )}°C in ${cityName}. Clean comfort corridor for morning activity."`
              : todayDeltaType === 'warm'
              ? `"Noticeable warming trend active over ${cityName} (+${todayVsYesterdayDelta.toFixed(
                  1
                )}°C vs yesterday). Peak UV window in early afternoon."`
              : `"Steady temperatures closely matching yesterday in ${cityName}. Calm atmospheric conditions."`;

          const tomorrowSummary =
            tomorrowDeltaType === 'cool'
              ? `"Cooler weather forecasted for tomorrow (${Math.abs(tomorrowVsTodayDelta).toFixed(
                  1
                )}°C below today). Layer up for the morning."`
              : tomorrowDeltaType === 'warm'
              ? `"Warmer conditions expected tomorrow (+${tomorrowVsTodayDelta.toFixed(
                  1
                )}°C over today). High solar peak expected."`
              : `"Tomorrow will stay steady with today's temperatures in ${cityName}. Ideal outdoor conditions continue."`;

          const yesterdaySnapshot: DaySnapshot = {
            id: 'yesterday',
            dateLabel: 'Yesterday',
            dateStr: formatDateLabel(yesterdayDate),
            temperature: yesterdayTemp,
            tempMin: dailyMin[0] ?? yesterdayTemp - 3,
            tempMax: dailyMax[0] ?? yesterdayTemp + 4,
            feelsLike: yesterdayTemp,
            weatherCode: yesterdayCode,
            conditionName: getWeatherConditionName(yesterdayCode),
            deltaLabel: 'Baseline historical reference',
            deltaValue: 0,
            deltaType: yesterdayDeltaType,
            summary: yesterdaySummary,
            optimalWindow: '08:00 – 10:00 AM',
            optimalSub: 'Historical Peak Clarity',
            gear: computeGear(yesterdayTemp, yesterdayCode, 3.0),
          };

          const todaySnapshot: DaySnapshot = {
            id: 'today',
            dateLabel: 'Today',
            dateStr: formatDateLabel(now),
            temperature: currentTemp,
            tempMin: dailyMin[1] ?? currentTemp - 4,
            tempMax: dailyMax[1] ?? currentTemp + 5,
            feelsLike: currentFeelsLike,
            weatherCode: currentCode,
            conditionName: getWeatherConditionName(currentCode),
            deltaLabel:
              todayVsYesterdayDelta < -0.1
                ? `-${Math.abs(todayVsYesterdayDelta).toFixed(1)}° Cooler than yesterday`
                : todayVsYesterdayDelta > 0.1
                ? `+${todayVsYesterdayDelta.toFixed(1)}° Warmer than yesterday`
                : '±0.0° Steady vs yesterday',
            deltaValue: todayVsYesterdayDelta,
            deltaType: todayDeltaType,
            summary: todaySummary,
            optimalWindow: '07:30 – 09:30 AM',
            optimalSub: `Comfort Index ${Math.min(
              98,
              Math.max(75, Math.round(96 - Math.abs(todayVsYesterdayDelta) * 3))
            )}`,
            gear: computeGear(currentTemp, currentCode, uvIndex),
          };

          const tomorrowSnapshot: DaySnapshot = {
            id: 'tomorrow',
            dateLabel: 'Tomorrow',
            dateStr: formatDateLabel(tomorrowDate),
            temperature: tomorrowTemp,
            tempMin: dailyMin[2] ?? tomorrowTemp - 3,
            tempMax: dailyMax[2] ?? tomorrowTemp + 6,
            feelsLike: tomorrowTemp,
            weatherCode: tomorrowCode,
            conditionName: getWeatherConditionName(tomorrowCode),
            deltaLabel:
              tomorrowVsTodayDelta < -0.1
                ? `-${Math.abs(tomorrowVsTodayDelta).toFixed(1)}° Cooler than today`
                : tomorrowVsTodayDelta > 0.1
                ? `+${tomorrowVsTodayDelta.toFixed(1)}° Warmer than today`
                : '±0.0° Steady vs today',
            deltaValue: tomorrowVsTodayDelta,
            deltaType: tomorrowDeltaType,
            summary: tomorrowSummary,
            optimalWindow: '08:00 – 10:00 AM',
            optimalSub: 'Forecast Optimal Window',
            gear: computeGear(tomorrowTemp, tomorrowCode, uvIndex),
          };

          resolve({
            locationName: cityName,
            microclimate: neighborhood,
            latitude: lat,
            longitude: lon,
            yesterday: yesterdaySnapshot,
            today: todaySnapshot,
            tomorrow: tomorrowSnapshot,
          });
        } catch (err) {
          reject(err);
        }
      },
      (error) => {
        reject(error);
      },
      { timeout: 10000, enableHighAccuracy: true }
    );
  });
}
