import React, { useState } from 'react';
import {
  Download,
  Compass,
  Sparkles,
  ArrowDownRight,
  ArrowUpRight,
  Minus,
  Sliders,
  Layers,
} from 'lucide-react';
import { Badge } from '../ui/Badge';
import { GlassCard } from '../ui/GlassCard';
import { AtmosphericCanvas } from '../ui/AtmosphericCanvas';

interface HeroSectionProps {
  onDownloadClick: () => void;
  onExploreFeatures: () => void;
}

interface TempScenario {
  id: string;
  name: string;
  temp: number;
  yesterdayTemp: number;
  summary: string;
  windowTime: string;
  windowSub: string;
  gear: string[];
}

const SCENARIOS: TempScenario[] = [
  {
    id: 'cool',
    name: 'Morning Crisp',
    temp: 22.4,
    yesterdayTemp: 25.2,
    summary:
      '"Crisp morning breeze with gentle warming towards noon. A quiet, comfortable window for a morning walk."',
    windowTime: '07:00 – 09:00 AM',
    windowSub: 'Gentle Breeze • Comfort 94',
    gear: ['🕶️ Sunglasses', '🧥 Light Windbreaker', '💧 Water Bottle'],
  },
  {
    id: 'warm',
    name: 'Afternoon Sun',
    temp: 29.1,
    yesterdayTemp: 25.7,
    summary:
      '"Warm solar peak with high UV index. Plan outdoor exertion before 11 AM or seek shaded canopy."',
    windowTime: '08:30 – 10:30 AM',
    windowSub: 'Low UV Window • Comfort 88',
    gear: ['🧢 Sun Cap', '🧴 SPF 50', '💧 Hydration Pack'],
  },
  {
    id: 'mild',
    name: 'Quiet Dusk',
    temp: 19.8,
    yesterdayTemp: 19.8,
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
  const [isSliderMode, setIsSliderMode] = useState(false);
  const [currentTemp, setCurrentTemp] = useState<number>(22.4);
  const yesterdayBase = 25.2;

  // Active values depending on mode
  const displayTemp = isSliderMode ? currentTemp : activeScenario.temp;
  const yesterdayRef = isSliderMode ? yesterdayBase : activeScenario.yesterdayTemp;
  const diffVal = parseFloat((displayTemp - yesterdayRef).toFixed(1));

  const deltaType: 'cool' | 'warm' | 'mild' =
    diffVal < -0.1 ? 'cool' : diffVal > 0.1 ? 'warm' : 'mild';

  const deltaFormatted =
    diffVal < -0.1
      ? `-${Math.abs(diffVal).toFixed(1)}° Cooler`
      : diffVal > 0.1
      ? `+${diffVal.toFixed(1)}° Warmer`
      : '±0.0° Steady';

  const deltaLabel = isSliderMode
    ? `vs yesterday's ${yesterdayBase}°C`
    : diffVal === 0
    ? 'identical to yesterday'
    : 'than yesterday at this hour';

  const dynamicSummary = isSliderMode
    ? diffVal < -2.0
      ? '"Noticeable cold front with brisk air. Layer up with a light jacket before stepping out."'
      : diffVal > 2.0
      ? '"Significant heat jump from yesterday. Stay hydrated and seek shade during peak midday hours."'
      : '"Mild, steady temperature closely matching yesterday. Ideal comfort window for outdoor activities."'
    : activeScenario.summary;

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

      {/* Hero Visual Card / Mockup with Atmospheric Canvas Backdrop */}
      <div className="hero-visual" style={{ position: 'relative' }}>
        <AtmosphericCanvas particleCount={36} />

        <GlassCard className="hero-mockup-card" style={{ position: 'relative', zIndex: 1 }}>
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

            {/* Mode Switcher: Presets vs Live Slider */}
            <div className="mockup-mode-switch">
              <button
                onClick={() => setIsSliderMode(false)}
                className={`mode-btn ${!isSliderMode ? 'active' : ''}`}
                title="Scenario Presets"
              >
                <Layers size={13} />
              </button>
              <button
                onClick={() => setIsSliderMode(true)}
                className={`mode-btn ${isSliderMode ? 'active' : ''}`}
                title="Interactive Delta Scrubber"
              >
                <Sliders size={13} />
              </button>
            </div>
          </div>

          {/* Scenario Tabs (when not in slider mode) */}
          {!isSliderMode ? (
            <div className="mockup-scenario-tabs mb-4">
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
          ) : (
            <div className="scrubber-box">
              <div className="scrubber-meta">
                <span className="scrubber-label">SCRUB TODAY'S TEMP</span>
                <span className="scrubber-val">{currentTemp.toFixed(1)}°C</span>
              </div>
              <input
                type="range"
                min="16.0"
                max="34.0"
                step="0.1"
                value={currentTemp}
                onChange={(e) => setCurrentTemp(parseFloat(e.target.value))}
                className="temp-slider-input"
              />
              <div className="scrubber-scale">
                <span>16°C (Brisk)</span>
                <span>Yesterday: 25.2°C</span>
                <span>34°C (Hot)</span>
              </div>
            </div>
          )}

          <div className="mockup-hero-temp">
            <div className="mockup-temp-main">{displayTemp.toFixed(1)}°</div>
            <div className="mockup-temp-delta">
              <span className={`delta-badge delta-${deltaType}`}>
                {deltaType === 'cool' && <ArrowDownRight size={14} />}
                {deltaType === 'warm' && <ArrowUpRight size={14} />}
                {deltaType === 'mild' && <Minus size={14} />}
                {deltaFormatted}
              </span>
              <span className="delta-sub">{deltaLabel}</span>
            </div>
          </div>

          <p className={`mockup-summary summary-${deltaType}`}>
            {dynamicSummary}
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
