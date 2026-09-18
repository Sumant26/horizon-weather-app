import React from 'react';
import { Download, Compass, Sparkles } from 'lucide-react';
import { Badge } from '../ui/Badge';
import { GlassCard } from '../ui/GlassCard';

interface HeroSectionProps {
  onDownloadClick: () => void;
  onExploreFeatures: () => void;
}

export const HeroSection: React.FC<HeroSectionProps> = ({
  onDownloadClick,
  onExploreFeatures,
}) => {
  return (
    <section className="hero-section">
      <div className="hero-content">
        {/* Editorial Eyebrow Tag */}
        <div className="hero-tag-wrap" onClick={onExploreFeatures} style={{ cursor: 'pointer' }}>
          <Badge variant="muted">HORIZON v1.0</Badge>
          <span className="hero-subtag">
            Weather for humans, not meteorologists
          </span>
        </div>

        {/* Clean, Confident Headline */}
        <h1 className="hero-title">
          A quieter, more human <br />
          way to feel the weather.
        </h1>

        {/* Subtitle */}
        <p className="hero-desc">
          Most weather apps overwhelm with raw radar maps and decimal points. Horizon tells you what matters in two seconds:
          <strong className="text-white"> how today compares to yesterday</strong>, your best 2-hour outdoor window, and only the gear you need.
        </p>

        {/* CTA Buttons */}
        <div className="hero-cta-group">
          <button onClick={onDownloadClick} className="btn btn-primary btn-lg">
            <Download size={17} />
            <span>Get Horizon App</span>
          </button>
          <button onClick={onExploreFeatures} className="btn btn-secondary btn-lg">
            <Sparkles size={17} />
            <span>Philosophy</span>
          </button>
        </div>

        {/* Quick Editorial Glance Metrics */}
        <div className="hero-stats-grid">
          <div className="hero-stat-card">
            <span className="hero-stat-number">-2.8°C</span>
            <span className="hero-stat-label">vs yesterday</span>
          </div>
          <div className="hero-stat-card">
            <span className="hero-stat-number">07:00 AM</span>
            <span className="hero-stat-label">Best comfort window</span>
          </div>
          <div className="hero-stat-card">
            <span className="hero-stat-number">94%</span>
            <span className="hero-stat-label">Night sky clarity</span>
          </div>
        </div>
      </div>

      {/* Hero Visual Card / Mockup */}
      <div className="hero-visual">
        <GlassCard className="hero-mockup-card">
          <div className="mockup-header">
            <div className="mockup-brand">
              <img
                src="/assets/app_logo.jpg"
                alt="Horizon Logo"
                className="mockup-logo"
                width={26}
                height={26}
              />
              <span className="mockup-node">HORIZON • GLANCEABLE</span>
            </div>
            <span className="mockup-live-badge">LIVE INSIGHT</span>
          </div>

          <div className="mockup-hero-temp">
            <div className="mockup-temp-main">22.4°</div>
            <div className="mockup-temp-delta">
              <span className="delta-badge">-2.8° Cooler</span>
              <span className="delta-sub">than yesterday at this hour</span>
            </div>
          </div>

          <p className="mockup-summary">
            "Crisp morning breeze with gentle warming towards noon. A quiet, comfortable window for a morning walk."
          </p>

          <div className="mockup-window-box">
            <div className="window-header">
              <Compass size={14} className="text-sage" />
              <span>OPTIMAL 2-HOUR WINDOW</span>
            </div>
            <div className="window-time">07:00 – 09:00 AM • Gentle Breeze (Comfort 94)</div>
          </div>

          <div className="mockup-footer">
            <div className="mockup-gear">
              <span className="gear-chip">🕶️ Sunglasses</span>
              <span className="gear-chip">🧥 Light Windbreaker</span>
              <span className="gear-chip">💧 Water Bottle</span>
            </div>
          </div>
        </GlassCard>
      </div>
    </section>
  );
};
