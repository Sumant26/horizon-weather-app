import { describe, it, expect } from 'vitest';
import { detectPlatform } from '../../src/core/utils/platform_detector';

describe('Platform Detector', () => {
  it('detects Android user agent', () => {
    const androidUa = 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36';
    expect(detectPlatform(androidUa)).toBe('android');
  });

  it('detects iPhone / iPad iOS user agent', () => {
    const iphoneUa = 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_5 like Mac OS X) AppleWebKit/605.1.15';
    expect(detectPlatform(iphoneUa)).toBe('ios');
  });

  it('defaults to desktop for Windows / macOS / Linux', () => {
    const windowsUa = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36';
    expect(detectPlatform(windowsUa)).toBe('desktop');
  });
});
