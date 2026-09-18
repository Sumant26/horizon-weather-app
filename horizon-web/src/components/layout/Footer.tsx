import React from 'react';
import { Heart, Github, ShieldCheck, Zap } from 'lucide-react';
import { APP_METADATA } from '../../core/constants/theme';

export const Footer: React.FC = () => {
  return (
    <footer className="footer-container">
      <div className="footer-inner">
        <div className="footer-grid">
          {/* Col 1 */}
          <div className="footer-col-main">
            <div className="footer-brand">
              <img
                src="/assets/app_logo.jpg"
                alt="Horizon Logo"
                className="footer-logo"
                width={32}
                height={32}
              />
              <span className="footer-title">HORIZON WEATHER</span>
            </div>
            <p className="footer-desc">
              Human-first glanceability weather application. Minimalist, high-contrast, offline-resilient, and built for instant everyday clarity.
            </p>
            <div className="footer-badges">
              <span className="footer-pill">
                <ShieldCheck size={14} className="text-sage" />
                <span>Zero Tracking</span>
              </span>
              <span className="footer-pill">
                <Zap size={14} className="text-gold" />
                <span>Open-Meteo Powered</span>
              </span>
            </div>
          </div>

          {/* Col 2 */}
          <div className="footer-col">
            <h4 className="footer-heading">Product</h4>
            <ul className="footer-links">
              <li><a href="#features">Feature Pillars</a></li>
              <li><a href="#download">Android APK</a></li>
              <li><a href="#download">iOS PWA Guide</a></li>
              <li><a href={APP_METADATA.pwaUrl} target="_blank" rel="noopener noreferrer">Live Web Edition</a></li>
            </ul>
          </div>

          {/* Col 3 */}
          <div className="footer-col">
            <h4 className="footer-heading">Architecture</h4>
            <ul className="footer-links">
              <li><a href="#specs">Clean Layering</a></li>
              <li><a href="#specs">ValueNotifier State</a></li>
              <li><a href="#specs">ERA5 Historical Reanalysis</a></li>
              <li><a href="#faq">Frequently Asked Questions</a></li>
            </ul>
          </div>

          {/* Col 4 */}
          <div className="footer-col">
            <h4 className="footer-heading">Open Source</h4>
            <ul className="footer-links">
              <li>
                <a
                  href={APP_METADATA.githubUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center gap-1"
                >
                  <Github size={14} />
                  <span>GitHub Repository</span>
                </a>
              </li>
              <li><span className="text-muted">MIT License</span></li>
              <li><span className="text-muted">Flutter 3.x Engine</span></li>
            </ul>
          </div>
        </div>

        {/* Bottom bar */}
        <div className="footer-bottom">
          <p className="footer-copy">
            © {new Date().getFullYear()} Horizon Weather Suite. Crafted with{' '}
            <Heart size={14} className="inline text-peach" fill="#E68A6C" /> for atmospheric clarity.
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
