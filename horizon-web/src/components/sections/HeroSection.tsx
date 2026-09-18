import React from 'react';
import { Download, Sparkles, Compass, Shield } from 'lucide-react';
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
        {/* Top Tag */}
        <div className="hero-tag-wrap" onClick={onExploreFeatures} style={{ cursor: 'pointer' }}>
          <Badge variant="gold">NEW RELEASE • v1.0.0</Badge>
          <span className="hero-subtag">
            <Shield size={13} className="text-sage" /> Zero tracking • Open-Meteo live engine
          </span>
        </div>

        {/* Headline */}
        <h1 className="hero-title">
          Weather for <span className="text-gradient-gold">Humans</span>,<br />
          Not Meteorologists.
        </h1>

        {/* Subtitle */}
        <p className="hero-desc">
          An editorial, high-contrast atmospheric companion focused on what actually matters:
          <strong className="text-white"> temperature relative to yesterday</strong>, optimal 2-hour outdoor comfort windows, and calming ambient soundscapes.
        </p>

        {/* CTA Buttons */}
        <div className="hero-cta-group">
          <button onClick={onDownloadClick} className="btn btn-primary btn-lg">
            <Download size={20} />
            <span>Download for Android / iOS</span>
          </button>
          <button onClick={onExploreFeatures} className="btn btn-secondary btn-lg">
            <Sparkles size={20} />
            <span>Explore Pillars</span>
          </button>
        </div>

        {/* Quick Highlights */}
        <div className="hero-stats-grid">
          <div className="hero-stat-card">
            <span className="hero-stat-number">-2.5°C</span>
            <span className="hero-stat-label">Yesterday Delta</span>
          </div>
          <div className="hero-stat-card">
            <span className="hero-stat-number">07:00</span>
            <span className="hero-stat-label">Optimal Running Window</span>
          </div>
          <div className="hero-stat-card">
            <span className="hero-stat-number">92%</span>
            <span className="hero-stat-label">Night-Sky Clarity</span>
          </div>
          <div className="hero-stat-card">
            <span className="hero-stat-number">0%</span>
            <span className="hero-stat-label">Ad Trackers / Bloat</span>
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
                width={28}
                height={28}
              />
              <span className="mockup-node">HORIZON NODE • PUNE</span>
            </div>
            <span className="mockup-live-badge">LIVE 24H DELTA</span>
          </div>

          <div className="mockup-hero-temp">
            <div className="mockup-temp-main">22.4°</div>
            <div className="mockup-temp-delta">
              <span className="delta-badge">-2.8° Cooler</span>
              <span className="delta-sub">vs yesterday at this hour</span>
            </div>
          </div>

          <p className="mockup-summary">
            "Crisp morning breeze with gentle warming towards noon. Ideal conditions for an early outdoor run."
          </p>

          <div className="mockup-window-box">
            <div className="window-header">
              <Compass size={14} className="text-gold" />
              <span>OPTIMAL ACTIVITY WINDOW</span>
            </div>
            <div className="window-time">07:00 - 09:00 AM • High Comfort (Score 94)</div>
          </div>

          <div className="mockup-footer">
            <div className="mockup-gear">
              <span className="gear-chip">🧢 Sunglasses</span>
              <span className="gear-chip">🧥 Windbreaker</span>
              <span className="gear-chip">💧 Hydration</span>
            </div>
          </div>
        </GlassCard>
      </div>
    </section>
  );
};
