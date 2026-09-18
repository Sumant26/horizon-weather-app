import React from 'react';
import {
  History,
  Activity,
  HeartPulse,
  MoonStar,
  Headphones,
  Palette,
} from 'lucide-react';
import { FEATURE_PILLARS, FeaturePillar } from '../../domain/data/features';
import { GlassCard } from '../ui/GlassCard';
import { Badge } from '../ui/Badge';

const ICON_MAP: Record<string, React.ReactNode> = {
  History: <History size={22} />,
  Activity: <Activity size={22} />,
  HeartPulse: <HeartPulse size={22} />,
  MoonStar: <MoonStar size={22} />,
  Headphones: <Headphones size={22} />,
  Palette: <Palette size={22} />,
};

export const FeaturesShowcase: React.FC = () => {
  return (
    <section id="features" className="section-container">
      <div className="section-header">
        <Badge variant="cyan">CORE PHILOSOPHY</Badge>
        <h2 className="section-title">Engineered for Human Perception</h2>
        <p className="section-subtitle">
          Six foundational capabilities designed from the ground up to replace sensory overload with effortless clarity.
        </p>
      </div>

      <div className="features-grid">
        {FEATURE_PILLARS.map((pillar: FeaturePillar) => (
          <GlassCard key={pillar.id} className="feature-card">
            <div className="feature-card-top">
              <div
                className="feature-icon-box"
                style={{ color: pillar.accentColor, backgroundColor: `${pillar.accentColor}18` }}
              >
                {ICON_MAP[pillar.iconName]}
              </div>
              <span className="feature-badge" style={{ color: pillar.accentColor }}>
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
