export type PlatformType = 'android' | 'ios' | 'desktop';

export function detectPlatform(userAgent?: string): PlatformType {
  const ua = userAgent || (typeof navigator !== 'undefined' ? navigator.userAgent : '');
  
  if (/android/i.test(ua)) {
    return 'android';
  }
  
  if (/iPad|iPhone|iPod/.test(ua) || (typeof navigator !== 'undefined' && navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1)) {
    return 'ios';
  }
  
  return 'desktop';
}

export function copyToClipboard(text: string): Promise<boolean> {
  if (typeof navigator !== 'undefined' && navigator.clipboard) {
    return navigator.clipboard
      .writeText(text)
      .then(() => true)
      .catch(() => false);
  }
  return Promise.resolve(false);
}
