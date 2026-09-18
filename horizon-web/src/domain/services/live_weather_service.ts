export interface LiveWeatherData {
  locationName: string;
  microclimate: string;
  temperature: number;
  feelsLike: number;
  yesterdayTemperature: number;
  tempDelta: number;
  conditionCode: number;
  conditionName: string;
  optimalWindow: string;
  optimalSub: string;
  summary: string;
  gear: string[];
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

          // 1. Fetch current weather from Open-Meteo
          const forecastRes = await fetch(
            `https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,uv_index&hourly=temperature_2m,precipitation_probability&timezone=auto`
          );

          if (!forecastRes.ok) {
            throw new Error('Failed to fetch weather data.');
          }

          const forecastData = await forecastRes.json();
          const currentTemp = forecastData.current?.temperature_2m ?? 21.5;
          const feelsLike = forecastData.current?.apparent_temperature ?? currentTemp;
          const uvIndex = forecastData.current?.uv_index ?? 3.0;
          const weatherCode = forecastData.current?.weather_code ?? 0;
          const precipitation = forecastData.current?.precipitation ?? 0.0;

          // 2. Fetch yesterday's historical temperature at same hour
          const now = new Date();
          const yesterday = new Date(now.getTime() - 24 * 60 * 60 * 1000);
          const yesterdayStr = yesterday.toISOString().split('T')[0];

          let yesterdayTemp = currentTemp;
          try {
            const archiveRes = await fetch(
              `https://archive-api.open-meteo.com/v1/archive?latitude=${lat}&longitude=${lon}&start_date=${yesterdayStr}&end_date=${yesterdayStr}&hourly=temperature_2m&timezone=auto`
            );
            if (archiveRes.ok) {
              const archiveData = await archiveRes.json();
              const hourIndex = now.getHours();
              if (archiveData.hourly?.temperature_2m?.[hourIndex] !== undefined) {
                yesterdayTemp = archiveData.hourly.temperature_2m[hourIndex];
              }
            }
          } catch {
            yesterdayTemp = currentTemp - 1.2; // Fallback
          }

          const tempDelta = parseFloat((currentTemp - yesterdayTemp).toFixed(1));

          // 3. Reverse geocode location name
          let cityName = `Coordinates (${lat.toFixed(2)}°, ${lon.toFixed(2)}°)`;
          let neighborhood = 'Local Microclimate';
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
                neighborhood = `${geoData.locality} • Live GPS`;
              } else {
                neighborhood = 'GPS Microclimate Station';
              }
            }
          } catch {
            // Keep default
          }

          // 4. Map condition name and gear
          const isRainy = weatherCode >= 51 || precipitation > 0.5;
          const isCold = currentTemp < 15;
          const isWarm = currentTemp > 26;

          const gear: string[] = [];
          if (uvIndex >= 4) gear.push('🕶️ Sunglasses');
          if (isRainy) gear.push('☂️ Rain Umbrella');
          if (isCold) gear.push('🧥 Warm Layer');
          if (isWarm) gear.push('💧 Water Bottle');
          if (gear.length === 0) gear.push('🕶️ Sunglasses', '💧 Water Bottle');

          const conditionName = isRainy
            ? 'Passing Showers'
            : weatherCode === 0
            ? 'Clear Skies'
            : weatherCode <= 3
            ? 'Partly Cloudy'
            : 'Overcast';

          const summary = isRainy
            ? '"Light precipitation detected in your area. Keep an umbrella on hand and seek indoor corridors."'
            : tempDelta < -1.5
            ? `"Noticeably crisper than yesterday at this hour. A pleasant ${currentTemp}°C with calm breeze."`
            : tempDelta > 1.5
            ? `"Warming trend active over ${cityName}. Expect higher solar radiation through afternoon."`
            : `"Stable and steady conditions in ${cityName}. Ideal outdoor comfort corridor."`;

          resolve({
            locationName: cityName,
            microclimate: neighborhood,
            temperature: currentTemp,
            feelsLike,
            yesterdayTemperature: yesterdayTemp,
            tempDelta,
            conditionCode: weatherCode,
            conditionName,
            optimalWindow: '08:00 – 10:00 AM',
            optimalSub: `Comfort Index ${Math.min(96, Math.max(70, Math.round(100 - Math.abs(tempDelta) * 5)))}`,
            summary,
            gear: gear.slice(0, 3),
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
