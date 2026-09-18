import { describe, it, expect, vi, beforeEach } from 'vitest';
import { fetchUserLiveWeather } from '../../src/domain/services/live_weather_service';

describe('Live Weather Service', () => {
  beforeEach(() => {
    vi.restoreAllMocks();
  });

  it('rejects if geolocation is not supported', async () => {
    Object.defineProperty(global.navigator, 'geolocation', {
      value: undefined,
      configurable: true,
      writable: true,
    });

    await expect(fetchUserLiveWeather()).rejects.toThrow(
      'Geolocation is not supported by your browser.'
    );
  });

  it('fetches and computes user live weather for yesterday, today, and tomorrow successfully', async () => {
    const mockPosition = {
      coords: {
        latitude: 37.7749,
        longitude: -122.4194,
      },
    };

    Object.defineProperty(global.navigator, 'geolocation', {
      value: {
        getCurrentPosition: vi.fn().mockImplementation((success) => success(mockPosition)),
      },
      configurable: true,
      writable: true,
    });

    // Mock hourly array with 72 items
    const mockHourlyTemps = new Array(72).fill(20.0);
    const mockHourlyCodes = new Array(72).fill(0);

    // Give variation for current hour (e.g. index 12, 36, 60)
    mockHourlyTemps[12] = 22.5; // yesterday
    mockHourlyTemps[36] = 19.4; // today
    mockHourlyTemps[60] = 21.0; // tomorrow

    global.fetch = vi.fn().mockImplementation((url: string) => {
      if (url.includes('api.open-meteo.com/v1/forecast')) {
        return Promise.resolve({
          ok: true,
          json: async () => ({
            current: {
              temperature_2m: 19.4,
              apparent_temperature: 18.8,
              uv_index: 3.5,
              weather_code: 1,
              precipitation: 0.0,
            },
            hourly: {
              temperature_2m: mockHourlyTemps,
              weather_code: mockHourlyCodes,
            },
            daily: {
              temperature_2m_min: [17.0, 16.0, 18.0],
              temperature_2m_max: [26.0, 24.0, 27.0],
              weather_code: [0, 1, 0],
            },
          }),
        });
      }
      if (url.includes('bigdatacloud.net/data/reverse-geocode')) {
        return Promise.resolve({
          ok: true,
          json: async () => ({
            city: 'San Francisco',
            countryCode: 'US',
            locality: 'Mission District',
          }),
        });
      }
      return Promise.reject(new Error('Unknown URL'));
    });

    const data = await fetchUserLiveWeather();
    expect(data.locationName).toContain('San Francisco');
    expect(data.microclimate).toContain('Mission District');
    expect(data.today.temperature).toBe(19.4);
    expect(data.today.gear.length).toBeGreaterThan(0);
    expect(data.yesterday.temperature).toBeDefined();
    expect(data.tomorrow.temperature).toBeDefined();
    expect(data.today.deltaLabel).toBeDefined();
    expect(data.tomorrow.deltaLabel).toBeDefined();
  });
});
