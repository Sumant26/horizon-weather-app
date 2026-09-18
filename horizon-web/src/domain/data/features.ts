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
    badge: 'RELATIVE CONTEXT',
    title: 'Temperature Relative to Yesterday',
    subtitle: 'Meaning over raw measurement',
    description:
      'Knowing it is 22°C means little on its own. Horizon computes the exact 24-hour delta at this specific hour, instantly letting you know if it feels crisper, warmer, or unchanged from yesterday.',
    iconName: 'History',
    highlightStat: '-2.8°C',
    statLabel: 'Cooler than yesterday at this hour',
    accentColor: '#38BDF8', // Cool cyan for cooler temperature delta
  },
  {
    id: 'optimal-windows',
    badge: 'OUTDOOR TIMING',
    title: '2-Hour Activity Comfort Windows',
    subtitle: 'Quiet algorithmic timing',
    description:
      'A bioclimatic comfort model analyzing temperature curves, solar angle, humidity, and breeze to find the most comfortable two-hour window of the day for walks, cycling, or dining.',
    iconName: 'Activity',
    highlightStat: '07:00 – 09:00 AM',
    statLabel: 'Optimal morning comfort window',
    accentColor: '#7E9F8E', // Calming sage for comfort window
  },
  {
    id: 'minimal-gear',
    badge: 'MINIMAL GEAR',
    title: 'Contextual Gear Checklist',
    subtitle: 'Only pack what today requires',
    description:
      'No guesswork before stepping out. Horizon evaluates real-time UV exposure, precipitation risk, and temperature thresholds to recommend only the items you actually need.',
    iconName: 'CheckCircle2',
    highlightStat: '3 Essentials',
    statLabel: 'Sunglasses • Windbreaker • Water',
    accentColor: '#FAF8F5', // Clean ivory for essentials
  },
  {
    id: 'night-clarity',
    badge: 'NIGHT SKY',
    title: 'Night Sky Clarity Index',
    subtitle: 'Atmospheric transparency for stargazers',
    description:
      'Active only after dusk. Calculates atmospheric opacity, cloud altitude, and relative moisture to give an honest clarity rating for stargazing and evening walks.',
    iconName: 'MoonStar',
    highlightStat: '94% Clarity',
    statLabel: 'High atmospheric transparency',
    accentColor: '#8898AA', // Slate for starry skies
  },
];
