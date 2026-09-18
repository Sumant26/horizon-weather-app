import React, { useState } from 'react';
import { Download, Compass, Sparkles, ArrowDownRight, ArrowUpRight, Minus } from 'lucide-react';
import { Badge } from '../ui/Badge';
import { GlassCard } from '../ui/GlassCard';

interface HeroSectionProps {
  onDownloadClick: () => void;
  onExploreFeatures: () => void;
}

interface TempScenario {
  id: string;
  name: string;
  temp: string;
  delta: string;
  deltaType: 'cool' | 'warm' | 'mild';
  deltaLabel: string;
  summary: string;
  windowTime: string;
  windowSub: string;
  gear: string[];
}

const SCENARIOS: TempScenario[] = [
  {
    id: 'cool',
    name: 'Morning Crisp',
    temp: '22.4°',
    delta: '-2.8° Cooler',
    deltaType: 'cool',
    deltaLabel: 'than yesterday at this hour',
    summary:
      '"Crisp morning breeze with gentle warming towards noon. A quiet, comfortable window for a morning walk."',
    windowTime: '07:00 – 09:00 AM',
    windowSub: 'Gentle Breeze • Comfort 94',
    gear: ['🕶️ Sunglasses', '🧥 Light Windbreaker', '💧 Water Bottle'],
  },
  {
    id: 'warm',
    name: 'Afternoon Sun',
    temp: '29.1°',
    delta: '+3.4° Warmer',
    deltaType: 'warm',
    deltaLabel: 'than yesterday at this hour',
    summary:
      '"Warm solar peak with high UV index. Plan outdoor exertion before 11 AM or seek shaded canopy."',
    windowTime: '08:30 – 10:30 AM',
    windowSub: 'Low UV Window • Comfort 88',
    gear: ['🧢 Sun Cap', '🧴 SPF 50', '💧 Hydration Pack'],
  },
  {
    id: 'mild',
    name: 'Quiet Dusk',
    temp: '19.8°',
    delta: '±0.0° Steady',
    deltaType: 'mild',
    deltaLabel: 'identical to yesterday',
    summary:
      '"Still air and crystal atmospheric clarity. Perfect conditions for evening stargazing and porch reading."',
    windowTime: '06:00 – 08:00 PM',
    windowSub: '94% Sky Transparency',
    gear: ['🧣 Light Layer', '☕ Hot Drink', '🔭 Clear Sky'],
  },
];

export const HeroSection: React.FC<HeroSectionProps> = ({
  onDownloadClick,
  onExploreFeatures,
}) => {
  const [activeScenario, setActiveScenario] = useState<TempScenario>(SCENARIOS[0]);

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
            <span className="hero-stat-number text-cool">-2.8°C</span>
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
            {/* Scenario Switcher Tabs */}
            <div className="mockup-scenario-tabs">
              {SCENARIOS.map((scenario) => (
                <button
                  key={scenario.id}
                  onClick={() => setActiveScenario(scenario)}
                  className={`scenario-pill ${activeScenario.id === scenario.id ? 'active' : ''}`}
                >
                  {scenario.name}
                </button>
              ))}
            </div>
          </div>

          <div className="mockup-hero-temp">
            <div className="mockup-temp-main">{activeScenario.temp}</div>
            <div className="mockup-temp-delta">
              <span className={`delta-badge delta-${activeScenario.deltaType}`}>
                {activeScenario.deltaType === 'cool' && <ArrowDownRight size={14} />}
                {activeScenario.deltaType === 'warm' && <ArrowUpRight size={14} />}
                {activeScenario.deltaType === 'mild' && <Minus size={14} />}
                {activeScenario.delta}
              </span>
              <span className="delta-sub">{activeScenario.deltaLabel}</span>
            </div>
          </div>

          <p className={`mockup-summary summary-${activeScenario.deltaType}`}>
            {activeScenario.summary}
          </p>

          <div className="mockup-window-box">
            <div className="window-header">
              <Compass size={14} className="text-sage" />
              <span>OPTIMAL 2-HOUR WINDOW</span>
            </div>
            <div className="window-time">
              {activeScenario.windowTime} • {activeScenario.windowSub}
            </div>
          </div>

          <div className="mockup-footer">
            <div className="mockup-gear">
              {activeScenario.gear.map((item, idx) => (
                <span key={idx} className="gear-chip">
                  {item}
                </span>
              ))}
            </div>
          </div>
        </GlassCard>
      </div>
    </section>
  );
};
