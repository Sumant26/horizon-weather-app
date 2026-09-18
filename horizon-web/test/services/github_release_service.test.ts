import { describe, it, expect, vi } from 'vitest';
import { fetchLatestRelease } from '../../src/domain/services/github_release_service';

describe('GitHub Release Service', () => {
  it('handles network failure gracefully and returns null', async () => {
    global.fetch = vi.fn().mockRejectedValue(new Error('Network error'));

    const result = await fetchLatestRelease();
    expect(result).toBeNull();
  });

  it('parses GitHub release payload correctly', async () => {
    const mockRelease = {
      tag_name: 'v1.2.0',
      name: 'Horizon v1.2.0 Release',
      published_at: '2026-09-18T10:00:00Z',
      html_url: 'https://github.com/Sumant26/horizon-weather-app/releases/tag/v1.2.0',
      assets: [
        {
          name: 'horizon-v1.2.0.apk',
          browser_download_url: 'https://github.com/Sumant26/horizon-weather-app/releases/download/v1.2.0/horizon-v1.2.0.apk',
          size: 20971520, // 20 MB
        },
      ],
      body: 'Changelog: New circadian themes and in-browser APK verifier.',
    };

    global.fetch = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => mockRelease,
    });

    const result = await fetchLatestRelease();
    expect(result).not.toBeNull();
    expect(result?.tagName).toBe('v1.2.0');
    expect(result?.apkSize).toBe('20.0 MB');
    expect(result?.apkDownloadUrl).toContain('horizon-v1.2.0.apk');
  });
});
