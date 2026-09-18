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
    badge: 'GLANCEABLE CONTEXT',
    title: 'Temperature Relative to Yesterday',
    subtitle: 'Context over raw numbers',
    description:
      'Knowing it is 22°C means little without context. Horizon computes the exact 24-hour historical delta at this exact hour, immediately showing whether it feels warmer, crisper, or identical to yesterday.',
    iconName: 'History',
    highlightStat: '-2.8°C',
    statLabel: 'Cooler than yesterday at this hour',
    accentColor: '#F6AD55',
  },
  {
    id: 'optimal-windows',
    badge: 'COMFORT TIMING',
    title: '2-Hour Activity Comfort Windows',
    subtitle: 'Algorithmic outdoor timing',
    description:
      'A dynamic comfort model analyzing temperature, gentle breeze, humidity, and atmospheric clarity to pinpoint the best 2-hour window in the day for running, cycling, walks, or dining.',
    iconName: 'Activity',
    highlightStat: '07:00 – 09:00 AM',
    statLabel: 'Optimal morning comfort window',
    accentColor: '#9AE6B4',
  },
  {
    id: 'minimal-gear',
    badge: 'MINIMAL GEAR',
    title: 'Contextual Gear Checklist',
    subtitle: 'Only pack what you actually need',
    description:
      'Zero unnecessary packing anxiety. Horizon assesses real-time UV exposure, precipitation likelihood, and thermal chill to recommend only the essentials.',
    iconName: 'CheckCircle2',
    highlightStat: '3 Essentials',
    statLabel: 'Sunglasses • Windbreaker • Water',
    accentColor: '#ED8936',
  },
  {
    id: 'night-clarity',
    badge: 'STARRY SKIES',
    title: 'Night Sky Clarity Index',
    subtitle: 'Atmospheric transparency for stargazing',
    description:
      'Computed solely during twilight and night hours using cloud opacity, barometric stability, and relative humidity to rate night-sky visibility for stargazers.',
    iconName: 'MoonStar',
    highlightStat: '94% Clarity',
    statLabel: 'High atmospheric transparency',
    accentColor: '#81E6D9',
  },
];
