import React from 'react';
import {
  History,
  Activity,
  CheckCircle2,
  MoonStar,
} from 'lucide-react';
import { GlassCard } from '../ui/GlassCard';
import { Badge } from '../ui/Badge';
import { DaySnapshot, LiveWeatherData } from '../../domain/services/live_weather_service';

interface FeaturesShowcaseProps {
  locationName?: string;
  today?: DaySnapshot;
  liveData?: LiveWeatherData | null;
}

const ICON_MAP: Record<string, React.ReactNode> = {
  History: <History size={18} />,
  Activity: <Activity size={18} />,
  CheckCircle2: <CheckCircle2 size={18} />,
  MoonStar: <MoonStar size={18} />,
};

export const FeaturesShowcase: React.FC<FeaturesShowcaseProps> = ({
  locationName = 'Your Location',
  today,
}) => {
  const deltaVal = today?.deltaValue ?? -2.8;
  const deltaFormatted = deltaVal > 0 ? `+${deltaVal.toFixed(1)}°C` : `${deltaVal.toFixed(1)}°C`;
  const deltaAccent =
    today?.deltaType === 'cool'
      ? '#38BDF8'
      : today?.deltaType === 'warm'
      ? '#D97757'
      : '#7E9F8E';

  const optimalWin = today?.optimalWindow ?? '07:30 – 09:30 AM';
  const optimalSub = today?.optimalSub ?? 'Comfort Index 94';
  const gearList = today?.gear && today.gear.length > 0
    ? today.gear.join(' • ')
    : '🕶️ Sunglasses • 🧥 Light Layer • 💧 Water';
  const gearCount = today?.gear?.length ?? 3;

  const dynamicPillars = [
    {
      id: 'yesterday-delta',
      badge: 'RELATIVE CONTEXT',
      title: 'Temperature Relative to Yesterday',
      subtitle: 'Meaning over raw measurement',
      description: `Rather than isolated decimals, Horizon computes the live 24-hour delta at this exact hour for ${locationName}, giving instant intuitive clarity.`,
      iconName: 'History',
      highlightStat: deltaFormatted,
      statLabel: today?.deltaLabel ? `${today.deltaLabel} in ${locationName}` : `vs yesterday in ${locationName}`,
      accentColor: deltaAccent,
    },
    {
      id: 'optimal-windows',
      badge: 'OUTDOOR TIMING',
      title: '2-Hour Activity Comfort Windows',
      subtitle: 'Quiet algorithmic timing',
      description: `A bioclimatic comfort model analyzing temperature curves, solar angle, humidity, and breeze in ${locationName} to identify your ideal two-hour window.`,
      iconName: 'Activity',
      highlightStat: optimalWin,
      statLabel: `${optimalSub} for ${locationName}`,
      accentColor: '#7E9F8E',
    },
    {
      id: 'minimal-gear',
      badge: 'MINIMAL GEAR',
      title: 'Contextual Gear Checklist',
      subtitle: 'Only pack what today requires',
      description: `No guesswork before stepping out in ${locationName}. Horizon evaluates real-time UV exposure, precipitation risk, and temperature thresholds.`,
      iconName: 'CheckCircle2',
      highlightStat: `${gearCount} Essentials`,
      statLabel: gearList,
      accentColor: '#FAF8F5',
    },
    {
      id: 'night-clarity',
      badge: 'NIGHT SKY',
      title: 'Night Sky Clarity Index',
      subtitle: 'Atmospheric transparency for stargazers',
      description: `Calculates atmospheric opacity, cloud altitude, and relative moisture over ${locationName} to provide an honest night sky clarity rating.`,
      iconName: 'MoonStar',
      highlightStat: '94% Clarity',
      statLabel: `High atmospheric transparency in ${locationName}`,
      accentColor: '#8898AA',
    },
  ];

  return (
    <section id="features" className="section-container">
      <div className="section-header">
        <Badge variant="muted">CORE PHILOSOPHY</Badge>
        <h2 className="section-title">Engineered for human intuition</h2>
        <p className="section-subtitle">
          Four quiet insights tuned to {locationName} designed to give you clarity at a glance without clutter or anxiety.
        </p>
      </div>

      <div className="features-grid">
        {dynamicPillars.map((pillar) => (
          <GlassCard key={pillar.id} className="feature-card">
            <div className="feature-card-top">
              <div
                className="feature-icon-box"
                style={{
                  color: pillar.accentColor,
                  backgroundColor: 'rgba(255, 255, 255, 0.04)',
                  borderColor: 'rgba(255, 255, 255, 0.08)',
                }}
              >
                {ICON_MAP[pillar.iconName]}
              </div>
              <span className="feature-badge" style={{ color: 'var(--text-muted)' }}>
                {pillar.badge}
              </span>
            </div>

            <h3 className="feature-title">{pillar.title}</h3>
            <span className="feature-subtitle">{pillar.subtitle}</span>
            <p className="feature-description">{pillar.description}</p>

            <div className="feature-stat-box">
              <span className="feature-stat-highlight" style={{ color: pillar.accentColor }}>
                {pillar.highlightStat}
              </span>
              <span className="feature-stat-label">{pillar.statLabel}</span>
            </div>
          </GlassCard>
        ))}
      </div>
    </section>
  );
};
