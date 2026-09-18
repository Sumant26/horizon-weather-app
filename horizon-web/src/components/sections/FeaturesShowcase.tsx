import React from 'react';
import {
  History,
  Activity,
  CheckCircle2,
  MoonStar,
} from 'lucide-react';
import { FEATURE_PILLARS, FeaturePillar } from '../../domain/data/features';
import { GlassCard } from '../ui/GlassCard';
import { Badge } from '../ui/Badge';

const ICON_MAP: Record<string, React.ReactNode> = {
  History: <History size={18} />,
  Activity: <Activity size={18} />,
  CheckCircle2: <CheckCircle2 size={18} />,
  MoonStar: <MoonStar size={18} />,
};

export const FeaturesShowcase: React.FC = () => {
  return (
    <section id="features" className="section-container">
      <div className="section-header">
        <Badge variant="muted">CORE PHILOSOPHY</Badge>
        <h2 className="section-title">Engineered for human intuition</h2>
        <p className="section-subtitle">
          Four quiet insights designed to give you clarity at a glance without clutter, notifications, or anxiety.
        </p>
      </div>

      <div className="features-grid">
        {FEATURE_PILLARS.map((pillar: FeaturePillar) => (
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
