import React, { useState, useEffect, useCallback } from 'react';
import {
  Download,
  Compass,
  Sparkles,
  ArrowDownRight,
  ArrowUpRight,
  Minus,
  Sliders,
  MapPin,
  RotateCw,
  Loader2,
  Calendar,
  Sun,
  CloudSun,
} from 'lucide-react';
import { Badge } from '../ui/Badge';
import { GlassCard } from '../ui/GlassCard';
import { AtmosphericCanvas } from '../ui/AtmosphericCanvas';
import {
  fetchUserLiveWeather,
  LiveWeatherData,
  DaySnapshot,
} from '../../domain/services/live_weather_service';

interface HeroSectionProps {
  onDownloadClick: () => void;
  onExploreFeatures: () => void;
}

const DEFAULT_YESTERDAY: DaySnapshot = {
  id: 'yesterday',
  dateLabel: 'Yesterday',
  dateStr: 'Past 24h',
  temperature: 25.2,
  tempMin: 18.0,
  tempMax: 27.5,
  feelsLike: 25.2,
  weatherCode: 0,
  conditionName: 'Clear Skies',
  deltaLabel: 'Baseline historical reference',
  deltaValue: 0,
  deltaType: 'mild',
  summary: '"Recorded baseline temperature with clear conditions over your location."',
  optimalWindow: '08:00 – 10:00 AM',
  optimalSub: 'Historical Peak Clarity',
  gear: ['🕶️ Sunglasses', '💧 Water Bottle'],
};

const DEFAULT_TODAY: DaySnapshot = {
  id: 'today',
  dateLabel: 'Today',
  dateStr: 'Live',
  temperature: 22.4,
  tempMin: 16.5,
  tempMax: 26.0,
  feelsLike: 21.8,
  weatherCode: 1,
  conditionName: 'Partly Cloudy',
  deltaLabel: '-2.8° Cooler than yesterday',
  deltaValue: -2.8,
  deltaType: 'cool',
  summary: '"Crisp morning breeze with gentle warming towards noon. A quiet, comfortable window for outdoor activity."',
  optimalWindow: '07:00 – 09:00 AM',
  optimalSub: 'Gentle Breeze • Comfort 94',
  gear: ['🕶️ Sunglasses', '🧥 Light Windbreaker', '💧 Water Bottle'],
};

const DEFAULT_TOMORROW: DaySnapshot = {
  id: 'tomorrow',
  dateLabel: 'Tomorrow',
  dateStr: 'Forecast',
  temperature: 23.8,
  tempMin: 17.0,
  tempMax: 27.0,
  feelsLike: 23.5,
  weatherCode: 0,
  conditionName: 'Sunny & Clear',
  deltaLabel: '+1.4° Warmer than today',
  deltaValue: 1.4,
  deltaType: 'warm',
  summary: '"Warmer solar trend continuing into tomorrow. Great outdoor conditions expected all morning."',
  optimalWindow: '07:30 – 09:30 AM',
  optimalSub: 'Comfort Index 92',
  gear: ['🧢 Sun Cap', '🕶️ Sunglasses', '💧 Hydration Pack'],
};

export const HeroSection: React.FC<HeroSectionProps> = ({
  onDownloadClick,
  onExploreFeatures,
}) => {
  const [selectedDayId, setSelectedDayId] = useState<'yesterday' | 'today' | 'tomorrow'>('today');
  const [isSliderMode, setIsSliderMode] = useState(false);
  const [scrubbedTemp, setScrubbedTemp] = useState<number>(22.4);
  const [liveData, setLiveData] = useState<LiveWeatherData | null>(null);
  const [isLocating, setIsLocating] = useState(false);
  const [locationError, setLocationError] = useState<string | null>(null);

  const loadUserLocationWeather = useCallback(async () => {
    setIsLocating(true);
    setLocationError(null);
    try {
      const data = await fetchUserLiveWeather();
      setLiveData(data);
      setScrubbedTemp(data.today.temperature);
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : 'Location detection unavailable';
      setLocationError(msg);
    } finally {
      setIsLocating(false);
    }
  }, []);

  useEffect(() => {
    loadUserLocationWeather();
  }, [loadUserLocationWeather]);

  // Current active snapshots from live data or graceful fallback
  const yesterdaySnapshot = liveData?.yesterday ?? DEFAULT_YESTERDAY;
  const todaySnapshot = liveData?.today ?? DEFAULT_TODAY;
  const tomorrowSnapshot = liveData?.tomorrow ?? DEFAULT_TOMORROW;

  const activeDaySnapshot: DaySnapshot =
    selectedDayId === 'yesterday'
      ? yesterdaySnapshot
      : selectedDayId === 'tomorrow'
      ? tomorrowSnapshot
      : todaySnapshot;

  // Compute values for Today in Slider Mode vs Standard Live Mode
  const displayedTemp =
    isSliderMode && selectedDayId === 'today'
      ? scrubbedTemp
      : activeDaySnapshot.temperature;

  const yesterdayRef = yesterdaySnapshot.temperature;

  let deltaFormatted = activeDaySnapshot.deltaLabel;
  let deltaType: 'cool' | 'warm' | 'mild' = activeDaySnapshot.deltaType;
  let dynamicSummary = activeDaySnapshot.summary;

  if (isSliderMode && selectedDayId === 'today') {
    const diffVal = parseFloat((scrubbedTemp - yesterdayRef).toFixed(1));
    deltaType = diffVal < -0.1 ? 'cool' : diffVal > 0.1 ? 'warm' : 'mild';
    deltaFormatted =
      diffVal < -0.1
        ? `-${Math.abs(diffVal).toFixed(1)}° Cooler`
        : diffVal > 0.1
        ? `+${diffVal.toFixed(1)}° Warmer`
        : '±0.0° Steady';

    dynamicSummary =
      diffVal < -2.0
        ? '"Noticeable cold front with brisk air. Layer up with a light jacket before stepping out."'
        : diffVal > 2.0
        ? '"Significant heat jump from yesterday. Stay hydrated and seek shade during peak midday hours."'
        : '"Mild, steady temperature closely matching yesterday. Ideal comfort window for outdoor activities."';
  }

  const locationTitle = liveData?.locationName ?? (isLocating ? 'Detecting your city...' : 'Your Location');
  const microclimateTitle = liveData?.microclimate ?? (locationError ? 'GPS Permission Needed' : 'Local Microclimate');

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
          Most weather apps overwhelm with complex charts and raw decimals. Horizon tells you what matters at a glance:
          <strong className="text-white"> how today compares to yesterday and tomorrow</strong>, your best 2-hour outdoor window, and only the gear you need.
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

        {/* Quick Editorial Glance Metrics for Today */}
        <div className="hero-stats-grid">
          <div className="hero-stat-card">
            <span
              className={`hero-stat-number ${
                todaySnapshot.deltaValue < -0.1
                  ? 'text-cool'
                  : todaySnapshot.deltaValue > 0.1
                  ? 'text-warm'
                  : ''
              }`}
            >
              {todaySnapshot.deltaValue > 0 ? `+${todaySnapshot.deltaValue.toFixed(1)}°` : `${todaySnapshot.deltaValue.toFixed(1)}°`}
            </span>
            <span className="hero-stat-label">today vs yesterday</span>
          </div>
          <div className="hero-stat-card">
            <span className="hero-stat-number">{todaySnapshot.optimalWindow.split('–')[0]?.trim() || '07:30 AM'}</span>
            <span className="hero-stat-label">Best comfort window</span>
          </div>
          <div className="hero-stat-card">
            <span className="hero-stat-number">{tomorrowSnapshot.temperature.toFixed(1)}°</span>
            <span className="hero-stat-label">tomorrow forecast</span>
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
                src="/assets/app_logo.jpg?v=2"
                alt="Horizon Logo"
                className="mockup-logo"
                width={30}
                height={30}
              />
              <div className="mockup-location-group">
                <div className="mockup-location-title">
                  <MapPin size={13} className="text-sage" />
                  <span className="city-title-text">{locationTitle}</span>
                  {liveData && <span className="live-pulse-dot" title="Live Location Connected" />}
                </div>
                <span className="mockup-location-sub">{microclimateTitle}</span>
              </div>
            </div>

            {/* Location Refresh & Day Controls */}
            <div className="mockup-header-actions">
              <button
                onClick={loadUserLocationWeather}
                className="location-refresh-btn"
                title="Refresh live weather for your location"
                disabled={isLocating}
              >
                {isLocating ? (
                  <Loader2 size={13} className="spinner" />
                ) : (
                  <RotateCw size={13} />
                )}
              </button>
            </div>
          </div>

          {/* 3-Day Perspective Selector: Yesterday / Today / Tomorrow / Scrub */}
          <div className="three-day-tab-bar">
            <button
              onClick={() => {
                setSelectedDayId('yesterday');
                setIsSliderMode(false);
              }}
              className={`day-tab-pill ${selectedDayId === 'yesterday' && !isSliderMode ? 'active' : ''}`}
            >
              <Calendar size={11} />
              <span>Yesterday</span>
            </button>

            <button
              onClick={() => {
                setSelectedDayId('today');
                setIsSliderMode(false);
              }}
              className={`day-tab-pill ${selectedDayId === 'today' && !isSliderMode ? 'active' : ''}`}
            >
              <Sun size={11} />
              <span>Today (Live)</span>
            </button>

            <button
              onClick={() => {
                setSelectedDayId('tomorrow');
                setIsSliderMode(false);
              }}
              className={`day-tab-pill ${selectedDayId === 'tomorrow' && !isSliderMode ? 'active' : ''}`}
            >
              <CloudSun size={11} />
              <span>Tomorrow</span>
            </button>

            <button
              onClick={() => {
                setSelectedDayId('today');
                setIsSliderMode(!isSliderMode);
              }}
              className={`day-tab-pill scrub-tab-pill ${isSliderMode ? 'active' : ''}`}
              title="Interactive Temperature Scrubber"
            >
              <Sliders size={11} />
              <span>Scrub</span>
            </button>
          </div>

          {/* Interactive Scrubber (collapsible when active) */}
          {isSliderMode && selectedDayId === 'today' && (
            <div className="scrubber-box">
              <div className="scrubber-meta">
                <span className="scrubber-label">SCRUB TODAY'S TEMP</span>
                <span className="scrubber-val">{scrubbedTemp.toFixed(1)}°C</span>
              </div>
              <input
                type="range"
                min="16.0"
                max="34.0"
                step="0.1"
                value={scrubbedTemp}
                onChange={(e) => setScrubbedTemp(parseFloat(e.target.value))}
                className="temp-slider-input"
              />
              <div className="scrubber-scale">
                <span>16°C (Brisk)</span>
                <span>Yesterday: {yesterdayRef.toFixed(1)}°C</span>
                <span>34°C (Hot)</span>
              </div>
            </div>
          )}

          {/* Main Temperature Display */}
          <div className="mockup-hero-temp">
            <div className="mockup-temp-main">{displayedTemp.toFixed(1)}°</div>
            <div className="mockup-temp-delta">
              <span className={`delta-badge delta-${deltaType}`}>
                {deltaType === 'cool' && <ArrowDownRight size={14} />}
                {deltaType === 'warm' && <ArrowUpRight size={14} />}
                {deltaType === 'mild' && <Minus size={14} />}
                {deltaFormatted}
              </span>
              <span className="delta-sub">
                {selectedDayId === 'yesterday'
                  ? 'Historical baseline'
                  : selectedDayId === 'tomorrow'
                  ? 'vs today at this hour'
                  : isSliderMode
                  ? `vs yesterday's ${yesterdayRef.toFixed(1)}°C`
                  : 'vs yesterday at this hour'}
              </span>
            </div>
          </div>

          {/* 3-Day Horizon Spectrum Strip */}
          <div className="horizon-spectrum-strip">
            <div
              onClick={() => {
                setSelectedDayId('yesterday');
                setIsSliderMode(false);
              }}
              className={`spectrum-card ${selectedDayId === 'yesterday' ? 'active-day' : ''}`}
            >
              <div className="spectrum-head">
                <span className="spectrum-label">Yesterday</span>
                <span className="spectrum-date">{yesterdaySnapshot.dateStr}</span>
              </div>
              <div className="spectrum-temp">{yesterdaySnapshot.temperature.toFixed(1)}°</div>
              <div className="spectrum-sub">Baseline</div>
            </div>

            <div
              onClick={() => {
                setSelectedDayId('today');
                setIsSliderMode(false);
              }}
              className={`spectrum-card ${selectedDayId === 'today' ? 'active-day' : ''}`}
            >
              <div className="spectrum-head">
                <span className="spectrum-label">Today</span>
                <span className="spectrum-date">{todaySnapshot.dateStr}</span>
              </div>
              <div className="spectrum-temp">{todaySnapshot.temperature.toFixed(1)}°</div>
              <div className={`spectrum-sub text-${todaySnapshot.deltaType}`}>
                {todaySnapshot.deltaValue > 0
                  ? `+${todaySnapshot.deltaValue.toFixed(1)}°`
                  : `${todaySnapshot.deltaValue.toFixed(1)}°`}
              </div>
            </div>

            <div
              onClick={() => {
                setSelectedDayId('tomorrow');
                setIsSliderMode(false);
              }}
              className={`spectrum-card ${selectedDayId === 'tomorrow' ? 'active-day' : ''}`}
            >
              <div className="spectrum-head">
                <span className="spectrum-label">Tomorrow</span>
                <span className="spectrum-date">{tomorrowSnapshot.dateStr}</span>
              </div>
              <div className="spectrum-temp">{tomorrowSnapshot.temperature.toFixed(1)}°</div>
              <div className={`spectrum-sub text-${tomorrowSnapshot.deltaType}`}>
                {tomorrowSnapshot.deltaValue > 0
                  ? `+${tomorrowSnapshot.deltaValue.toFixed(1)}°`
                  : `${tomorrowSnapshot.deltaValue.toFixed(1)}°`}
              </div>
            </div>
          </div>

          {/* Human-first Narrative Summary */}
          <p className={`mockup-summary summary-${deltaType}`}>
            {dynamicSummary}
          </p>

          {/* Optimal 2-Hour Window */}
          <div className="mockup-window-box">
            <div className="window-header">
              <Compass size={14} className="text-sage" />
              <span>OPTIMAL 2-HOUR WINDOW</span>
            </div>
            <div className="window-time">
              {activeDaySnapshot.optimalWindow} • {activeDaySnapshot.optimalSub}
            </div>
          </div>

          {/* Recommended Gear Checklist */}
          <div className="mockup-footer">
            <div className="mockup-gear">
              {activeDaySnapshot.gear.map((item, idx) => (
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
