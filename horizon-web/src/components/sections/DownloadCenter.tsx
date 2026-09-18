import React, { useState, useEffect } from 'react';
import {
  Download,
  QrCode,
  Copy,
  Check,
  HelpCircle,
  Smartphone,
  Apple,
  Globe,
  Share,
  PlusSquare,
  ExternalLink,
} from 'lucide-react';
import { APP_METADATA } from '../../core/constants/theme';
import { PlatformType } from '../../core/utils/platform_detector';
import { generateQrDataUrl } from '../../core/utils/qr_generator';
import { GlassCard } from '../ui/GlassCard';
import { Badge } from '../ui/Badge';
import { TabGroup } from '../ui/TabGroup';
import { Modal } from '../ui/Modal';
import { SideloadGuideModal } from './SideloadGuideModal';

interface DownloadCenterProps {
  selectedPlatform: PlatformType;
  onPlatformChange: (platform: PlatformType) => void;
  isSideloadGuideOpen: boolean;
  onOpenSideloadGuide: () => void;
  onCloseSideloadGuide: () => void;
  copiedChecksum: boolean;
  onCopyChecksum: (checksum: string) => void;
}

export const DownloadCenter: React.FC<DownloadCenterProps> = ({
  selectedPlatform,
  onPlatformChange,
  isSideloadGuideOpen,
  onOpenSideloadGuide,
  onCloseSideloadGuide,
  copiedChecksum,
  onCopyChecksum,
}) => {
  const [isQrModalOpen, setIsQrModalOpen] = useState(false);
  const [qrDataUrl, setQrDataUrl] = useState<string>('');

  useEffect(() => {
    const downloadUrl =
      typeof window !== 'undefined'
        ? `${window.location.origin}${APP_METADATA.apkDownloadUrl}`
        : APP_METADATA.pwaUrl;

    generateQrDataUrl(downloadUrl).then(setQrDataUrl);
  }, []);

  const tabs = [
    {
      id: 'android' as PlatformType,
      label: 'Android APK',
      icon: <Smartphone size={18} />,
      badge: 'v1.0.0',
    },
    {
      id: 'ios' as PlatformType,
      label: 'iOS / iPadOS',
      icon: <Apple size={18} />,
      badge: '1-Tap PWA',
    },
    {
      id: 'desktop' as PlatformType,
      label: 'Web Edition',
      icon: <Globe size={18} />,
    },
  ];

  return (
    <section id="download" className="section-container">
      <div className="section-header">
        <Badge variant="gold">DIRECT DISTRIBUTION</Badge>
        <h2 className="section-title">Get Horizon for Your Device</h2>
        <p className="section-subtitle">
          Zero app store intermediaries, zero telemetry, and instantaneous updates. Choose your platform below.
        </p>
      </div>

      <div className="download-wrapper">
        {/* Platform Selector Tabs */}
        <TabGroup
          tabs={tabs}
          activeTab={selectedPlatform}
          onChange={onPlatformChange}
        />

        {/* Tab 1: Android APK */}
        {selectedPlatform === 'android' && (
          <GlassCard className="download-card">
            <div className="download-card-grid">
              {/* Left Column: Actions */}
              <div className="download-main-col">
                <div className="download-badge-group">
                  <span className="platform-tag android-tag">
                    <Smartphone size={14} /> Android Universal APK
                  </span>
                  <span className="meta-tag">ARM64 & x86_64</span>
                </div>

                <h3 className="download-heading">Horizon for Android</h3>
                <p className="download-desc">
                  Self-contained standalone package. Features hardware-accelerated 60/120 FPS rendering, tactile haptic feedback, background caching, and localized Open-Meteo queries.
                </p>

                {/* Primary Action Buttons */}
                <div className="download-btn-row">
                  <a
                    href={APP_METADATA.apkDownloadUrl}
                    download="horizon-release.apk"
                    className="btn btn-primary btn-lg"
                  >
                    <Download size={20} />
                    <span>Download APK ({APP_METADATA.apkSize})</span>
                  </a>

                  <button
                    onClick={() => setIsQrModalOpen(true)}
                    className="btn btn-secondary btn-lg"
                    title="Scan QR Code from your phone"
                  >
                    <QrCode size={20} />
                    <span>Scan QR</span>
                  </button>
                </div>

                {/* Help button */}
                <div className="download-help-row">
                  <button
                    onClick={onOpenSideloadGuide}
                    className="link-btn"
                  >
                    <HelpCircle size={15} />
                    <span>How to install APK on Android (3 simple steps)</span>
                  </button>
                </div>
              </div>

              {/* Right Column: Checksum & File Info */}
              <div className="download-side-col">
                <div className="info-box">
                  <h4 className="info-box-title">Release Metadata</h4>
                  <div className="info-row">
                    <span className="info-label">Version</span>
                    <span className="info-val">{APP_METADATA.version}</span>
                  </div>
                  <div className="info-row">
                    <span className="info-label">File Size</span>
                    <span className="info-val">{APP_METADATA.apkSize}</span>
                  </div>
                  <div className="info-row">
                    <span className="info-label">Target SDK</span>
                    <span className="info-val">Android 8.0+ (API 26+)</span>
                  </div>
                  <div className="info-row">
                    <span className="info-label">Release Date</span>
                    <span className="info-val">{APP_METADATA.releaseDate}</span>
                  </div>

                  {/* SHA-256 Checksum with Copy */}
                  <div className="checksum-box">
                    <div className="checksum-header">
                      <span className="checksum-title">SHA-256 CHECKSUM</span>
                      <button
                        onClick={() => onCopyChecksum(APP_METADATA.apkChecksum)}
                        className="copy-btn"
                        title="Copy SHA-256 Checksum"
                      >
                        {copiedChecksum ? (
                          <span className="inline-flex items-center text-sage">
                            <Check size={13} /> Copied
                          </span>
                        ) : (
                          <span className="inline-flex items-center">
                            <Copy size={13} /> Copy
                          </span>
                        )}
                      </button>
                    </div>
                    <code className="checksum-code">{APP_METADATA.apkChecksum}</code>
                  </div>
                </div>
              </div>
            </div>
          </GlassCard>
        )}

        {/* Tab 2: iOS / iPadOS PWA */}
        {selectedPlatform === 'ios' && (
          <GlassCard className="download-card">
            <div className="ios-pwa-grid">
              <div className="ios-header-col">
                <div className="download-badge-group">
                  <span className="platform-tag ios-tag">
                    <Apple size={14} /> Apple iOS / iPadOS
                  </span>
                  <span className="meta-tag">Instant PWA • No Sideloading</span>
                </div>

                <h3 className="download-heading">Install Horizon on iPhone in 1 Tap</h3>
                <p className="download-desc">
                  Thanks to modern Progressive Web App (PWA) standards, you can install Horizon directly to your iOS Home Screen without developer certificates, AltStore, or TestFlight restrictions.
                </p>

                <div className="download-btn-row">
                  <a
                    href={APP_METADATA.pwaUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="btn btn-primary btn-lg"
                  >
                    <ExternalLink size={18} />
                    <span>Open in Safari & Install</span>
                  </a>
                </div>
              </div>

              {/* iOS Step-by-Step Visual Cards */}
              <div className="ios-steps-container">
                <div className="ios-step-card">
                  <div className="ios-step-icon">
                    <Globe size={22} className="text-gold" />
                  </div>
                  <div className="ios-step-num">Step 1</div>
                  <h4 className="ios-step-name">Open in Safari</h4>
                  <p className="ios-step-text">Navigate to Horizon Web in Safari on your iPhone or iPad.</p>
                </div>

                <div className="ios-step-card">
                  <div className="ios-step-icon">
                    <Share size={22} className="text-cyan" />
                  </div>
                  <div className="ios-step-num">Step 2</div>
                  <h4 className="ios-step-name">Tap Share Icon</h4>
                  <p className="ios-step-text">Tap the standard iOS Share square icon at the bottom of the screen.</p>
                </div>

                <div className="ios-step-card">
                  <div className="ios-step-icon">
                    <PlusSquare size={22} className="text-sage" />
                  </div>
                  <div className="ios-step-num">Step 3</div>
                  <h4 className="ios-step-name">Add to Home Screen</h4>
                  <p className="ios-step-text">Select "Add to Home Screen". Horizon will launch full-screen with offline support.</p>
                </div>
              </div>
            </div>
          </GlassCard>
        )}

        {/* Tab 3: Web Edition */}
        {selectedPlatform === 'desktop' && (
          <GlassCard className="download-card">
            <div className="web-edition-box">
              <div className="download-badge-group">
                <span className="platform-tag web-tag">
                  <Globe size={14} /> Full Web Companion
                </span>
                <span className="meta-tag">Chrome • Safari • Firefox • Edge</span>
              </div>

              <h3 className="download-heading">Horizon Web Edition</h3>
              <p className="download-desc max-w-xl">
                Run Horizon directly in your browser with zero downloads. Full support for keyboard shortcuts, offline caching, and responsive high-contrast layouts.
              </p>

              <div className="download-btn-row justify-center">
                <a
                  href={APP_METADATA.pwaUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="btn btn-primary btn-lg"
                >
                  <ExternalLink size={20} />
                  <span>Launch Web App (Port 8080)</span>
                </a>
              </div>
            </div>
          </GlassCard>
        )}
      </div>

      {/* QR Code Modal for Android / Mobile Scanning */}
      <Modal
        isOpen={isQrModalOpen}
        onClose={() => setIsQrModalOpen(false)}
        title="Scan to Download Horizon"
        subtitle="Point your phone camera at this QR code to download the APK directly."
        maxWidth="380px"
      >
        <div className="qr-modal-content">
          <div className="qr-code-frame">
            {qrDataUrl ? (
              <img
                src={qrDataUrl}
                alt="Horizon APK Download QR Code"
                className="qr-image"
                width={240}
                height={240}
              />
            ) : (
              <div className="qr-loading">Generating QR Code...</div>
            )}
          </div>
          <p className="qr-instructions">
            Supports Android Camera, Google Lens, and built-in QR scanners.
          </p>
          <button
            onClick={() => setIsQrModalOpen(false)}
            className="btn btn-secondary w-full"
          >
            Close
          </button>
        </div>
      </Modal>

      {/* Sideload Guide Modal */}
      <SideloadGuideModal
        isOpen={isSideloadGuideOpen}
        onClose={onCloseSideloadGuide}
      />
    </section>
  );
};
