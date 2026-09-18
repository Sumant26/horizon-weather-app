import React from 'react';
import { Download, Sparkles } from 'lucide-react';
import { APP_METADATA } from '../../core/constants/theme';

interface NavbarProps {
  onScrollToDownload: () => void;
  onScrollToFeatures: () => void;
  onScrollToSpecs: () => void;
}

export const Navbar: React.FC<NavbarProps> = ({
  onScrollToDownload,
  onScrollToFeatures,
  onScrollToSpecs,
}) => {
  return (
    <header className="navbar-container">
      <div className="navbar-inner">
        {/* Brand */}
        <div className="navbar-brand">
          <img
            src="/assets/app_logo.jpg"
            alt="Horizon Logo"
            className="navbar-logo"
            width={36}
            height={36}
          />
          <div className="navbar-title-group">
            <span className="navbar-title">HORIZON</span>
            <span className="navbar-version">{APP_METADATA.version}</span>
          </div>
        </div>

        {/* Links */}
        <nav className="navbar-nav">
          <button onClick={onScrollToFeatures} className="nav-link">
            Features
          </button>
          <button onClick={onScrollToSpecs} className="nav-link">
            Architecture
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

        {/* Actions */}
        <div className="navbar-actions">
          <a
            href={APP_METADATA.pwaUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="btn btn-ghost"
          >
            <Sparkles size={16} />
            <span>Launch Web App</span>
          </a>
          <button onClick={onScrollToDownload} className="btn btn-primary">
            <Download size={16} />
            <span>Get App</span>
          </button>
        </div>
      </div>
    </header>
  );
};
