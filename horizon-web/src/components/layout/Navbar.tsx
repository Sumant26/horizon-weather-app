import React from 'react';
import { Download, Github, MapPin } from 'lucide-react';
import { APP_METADATA } from '../../core/constants/theme';

interface NavbarProps {
  onScrollToDownload: () => void;
  onScrollToFeatures: () => void;
  locationName?: string;
  currentTemp?: number;
}

export const Navbar: React.FC<NavbarProps> = ({
  onScrollToDownload,
  onScrollToFeatures,
  locationName,
  currentTemp,
}) => {
  return (
    <header className="navbar-container">
      <div className="navbar-inner">
        {/* Brand */}
        <div className="navbar-brand">
          <img
            src="/assets/app_logo.jpg?v=2"
            alt="Horizon Logo"
            className="navbar-logo"
            width={32}
            height={32}
          />
          <div className="navbar-title-group">
            <span className="navbar-title">HORIZON</span>
            <span className="navbar-version">{APP_METADATA.version}</span>
          </div>

          {locationName && (
            <div className="navbar-location-pill" title={`Live weather in ${locationName}`}>
              <MapPin size={11} className="text-sage" />
              <span className="navbar-city-name">{locationName.split(',')[0]}</span>
              {currentTemp !== undefined && (
                <>
                  <span className="navbar-dot-sep">•</span>
                  <span className="navbar-temp-tag">{currentTemp.toFixed(1)}°</span>
                </>
              )}
            </div>
          )}
        </div>

        {/* Navigation Links */}
        <nav className="navbar-nav">
          <button onClick={onScrollToFeatures} className="nav-link">
            Philosophy
          </button>
          <button onClick={onScrollToDownload} className="nav-link">
            Download
          </button>
          <a
            href={APP_METADATA.githubUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="nav-link"
          >
            GitHub
          </a>
        </nav>

        {/* Primary Action Buttons */}
        <div className="navbar-actions">
          <a
            href={APP_METADATA.githubUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="btn btn-ghost navbar-source-btn"
            title="GitHub Repository"
          >
            <Github size={16} />
            <span className="navbar-btn-text">Source</span>
          </a>
          <button onClick={onScrollToDownload} className="btn btn-primary navbar-get-btn">
            <Download size={15} />
            <span>Get App</span>
          </button>
        </div>
      </div>
    </header>
  );
};
