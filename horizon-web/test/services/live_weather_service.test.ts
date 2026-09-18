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

  it('fetches and computes user live weather successfully', async () => {
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
          }),
        });
      }
      if (url.includes('archive-api.open-meteo.com/v1/archive')) {
        return Promise.resolve({
          ok: true,
          json: async () => ({
            hourly: {
              temperature_2m: [22.2, 22.2, 22.2, 22.2, 22.2],
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
    expect(data.temperature).toBe(19.4);
    expect(data.gear.length).toBeGreaterThan(0);
  });
});
