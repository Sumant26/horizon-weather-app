import React from 'react';
import { Heart, Github, ShieldCheck, Zap } from 'lucide-react';
import { APP_METADATA } from '../../core/constants/theme';

export const Footer: React.FC = () => {
  return (
    <footer className="footer-container">
      <div className="footer-inner">
        <div className="footer-grid">
          {/* Col 1: Brand & Bio */}
          <div className="footer-brand-col">
            <div className="footer-logo-row">
              <img
                src="/assets/app_logo.jpg?v=2"
                alt="Horizon Logo"
                className="footer-logo"
                width={30}
                height={30}
                style={{ borderRadius: 8 }}
              />
              <span className="footer-title">HORIZON WEATHER</span>
            </div>
            <p className="footer-tagline">
              Weather for humans, not meteorologists. Minimalist, comfortable, high-contrast, and focused on everyday clarity.
            </p>
            <div className="footer-pills">
              <span className="footer-pill">
                <ShieldCheck size={13} className="text-sage" />
                <span>Zero Tracking</span>
              </span>
              <span className="footer-pill">
                <Zap size={13} className="text-gold" />
                <span>Open-Meteo Engine</span>
              </span>
            </div>
          </div>

          {/* Col 2: Navigation & Links */}
          <div className="footer-links-col">
            <h4 className="footer-heading">Ecosystem</h4>
            <ul className="footer-links">
              <li><a href="#features">Core Philosophy</a></li>
              <li><a href="#download">Download Android APK</a></li>
              <li><a href="#download">iOS PWA Guide</a></li>
              <li>
                <a
                  href={APP_METADATA.githubUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  style={{ display: 'inline-flex', alignItems: 'center', gap: 6 }}
                >
                  <Github size={14} />
                  <span>GitHub Repository</span>
                </a>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom bar */}
        <div className="footer-bottom">
          <p className="footer-copy">
            © {new Date().getFullYear()} Horizon Weather. Crafted with{' '}
            <Heart size={13} className="inline text-peach" fill="#ED8936" /> for comfortable everyday clarity.
          </p>
          <div className="footer-meta">
            <span>Version {APP_METADATA.version}</span>
            <span>•</span>
            <span>Build {APP_METADATA.buildNumber}</span>
          </div>
        </div>
      </div>
    </footer>
  );
};
