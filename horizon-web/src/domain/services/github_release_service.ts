export interface GitHubRelease {
  tagName: string;
  name: string;
  publishedAt: string;
  htmlUrl: string;
  apkDownloadUrl: string;
  apkSize: string;
  body: string;
}

export async function fetchLatestRelease(
  owner: string = 'Sumant26',
  repo: string = 'horizon-weather-app'
): Promise<GitHubRelease | null> {
  try {
    const response = await fetch(
      `https://api.github.com/repos/${owner}/${repo}/releases/latest`,
      {
        headers: {
          Accept: 'application/vnd.github.v3+json',
        },
      }
    );

    if (!response.ok) {
      return null;
    }

    const data = await response.json();
    const apkAsset = data.assets?.find((asset: { name: string }) =>
      asset.name.endsWith('.apk')
    );

    const formatBytes = (bytes: number): string => {
      if (!bytes) return '18.4 MB';
      const mb = bytes / (1024 * 1024);
      return `${mb.toFixed(1)} MB`;
    };

    return {
      tagName: data.tag_name || 'v1.0.0',
      name: data.name || 'Horizon v1.0.0',
      publishedAt: data.published_at || new Date().toISOString(),
      htmlUrl: data.html_url || `https://github.com/${owner}/${repo}/releases`,
      apkDownloadUrl:
        apkAsset?.browser_download_url ||
        `https://github.com/${owner}/${repo}/releases/latest/download/app-release.apk`,
      apkSize: formatBytes(apkAsset?.size || 19300000),
      body: data.body || '',
    };
  } catch {
    return null;
  }
}
