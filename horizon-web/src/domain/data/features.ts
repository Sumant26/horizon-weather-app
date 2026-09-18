export interface FeaturePillar {
  id: string;
  badge: string;
  title: string;
  subtitle: string;
  description: string;
  iconName: string;
  highlightStat: string;
  statLabel: string;
  accentColor: string;
}

export const FEATURE_PILLARS: FeaturePillar[] = [
  {
    id: 'yesterday-delta',
    badge: 'HUMAN GLANCEABILITY',
    title: 'Temperature Relative to Yesterday',
    subtitle: 'Context over raw numbers',
    description:
      'Knowing it is 22°C tells you little without context. Horizon computes the exact 24-hour historical delta at this exact hour, immediately showing whether it feels warmer, crisper, or identical to yesterday.',
    iconName: 'History',
    highlightStat: '-2.5°C',
    statLabel: 'Cooler than yesterday at this hour',
    accentColor: '#E6A23C',
  },
  {
    id: 'optimal-windows',
    badge: 'SMART SCHEDULING',
    title: '2-Hour Activity Comfort Windows',
    subtitle: 'Algorithmic outdoor timing',
    description:
      'Dynamic scoring engine analyzing temperature, wind velocity, humidity, and precipitation probability to pinpoint the best 2-hour window in the day for running, cycling, stargazing, photography, or outdoor dining.',
    iconName: 'Activity',
    highlightStat: '07:00 - 09:00',
    statLabel: 'Optimal morning running corridor',
    accentColor: '#8BC34A',
  },
  {
    id: 'biophilic-health',
    badge: 'PHYSIOLOGICAL RADAR',
    title: 'Biophilic Health & Migraine Alerts',
    subtitle: 'Proactive atmospheric wellness',
    description:
      'Rapid barometric pressure drops are the #1 environmental trigger for migraines. Horizon monitors pressure variance per 3 hours, dew point breathability, and circadian UV synthesis windows to protect your health.',
    iconName: 'HeartPulse',
    highlightStat: '1013.2 hPa',
    statLabel: 'Barometric front: Stable comfort',
    accentColor: '#E68A6C',
  },
  {
    id: 'celestial-arc',
    badge: 'ASTRONOMICAL SPECTRUM',
    title: 'Night-Sky Clarity & Celestial Arc',
    subtitle: 'Sun, Moon & Stargazing physics',
    description:
      'Continuous astronomical trajectory computing sun altitude, lunar phases, golden hour photography illumination, blue hour, and celestial night-sky clarity index for stargazers.',
    iconName: 'MoonStar',
    highlightStat: '92% Clarity',
    statLabel: 'Superb Stargazing conditions',
    accentColor: '#4ED8E6',
  },
  {
    id: 'ambient-soundscapes',
    badge: 'ATMOSPHERIC AUDIO',
    title: 'Procedural Ambient Soundscapes',
    subtitle: 'Relaxing environmental synthesizers',
    description:
      'Built-in audio synthesizer generating relaxing, continuous ambient audio: gentle rain on glass, alpine breeze, morning songbirds, and cozy hearth crackle auto-synced to current outdoor conditions.',
    iconName: 'Headphones',
    highlightStat: '4 Soundscapes',
    statLabel: 'Zero loops • Pure procedural sound',
    accentColor: '#A78BFA',
  },
  {
    id: 'oled-themes',
    badge: 'EDITORIAL AESTHETICS',
    title: 'High-Contrast OLED Visual Themes',
    subtitle: 'Curated Scandinavian palettes',
    description:
      'Four tailored visual modes: Deep OLED Black for maximum battery conservation, Cozy Warm for sunset amber comfort, Slate Minimalist for neutral focus, and Nordic Frosted Pine for high-contrast clarity.',
    iconName: 'Palette',
    highlightStat: '0.000 nits',
    statLabel: 'True OLED pitch black #000000',
    accentColor: '#F472B6',
  },
];
