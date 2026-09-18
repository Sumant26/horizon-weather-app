import React from 'react';
import { Download, Github } from 'lucide-react';
import { APP_METADATA } from '../../core/constants/theme';

interface NavbarProps {
  onScrollToDownload: () => void;
  onScrollToFeatures: () => void;
}

export const Navbar: React.FC<NavbarProps> = ({
  onScrollToDownload,
  onScrollToFeatures,
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
            width={34}
            height={34}
          />
          <div className="navbar-title-group">
            <span className="navbar-title">HORIZON</span>
            <span className="navbar-version">{APP_METADATA.version}</span>
          </div>
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

        {/* Primary Action Button */}
        <div className="navbar-actions">
          <a
            href={APP_METADATA.githubUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="btn btn-ghost"
            title="GitHub Repository"
          >
            <Github size={16} />
            <span>Source</span>
          </a>
          <button onClick={onScrollToDownload} className="btn btn-primary">
            <Download size={15} />
            <span>Get App</span>
          </button>
        </div>
      </div>
    </header>
  );
};
