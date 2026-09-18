import React, { useState, useEffect } from 'react';
import {
  Download,
  QrCode,
  Copy,
  Check,
  HelpCircle,
  Smartphone,
  Apple,
  Share,
  PlusSquare,
  ChevronDown,
  ChevronUp,
  Info,
  GitBranch,
} from 'lucide-react';
import { APP_METADATA } from '../../core/constants/theme';
import { PlatformType } from '../../core/utils/platform_detector';
import { generateQrDataUrl } from '../../core/utils/qr_generator';
import { fetchLatestRelease, GitHubRelease } from '../../domain/services/github_release_service';
import { GlassCard } from '../ui/GlassCard';
import { Badge } from '../ui/Badge';
import { TabGroup } from '../ui/TabGroup';
import { Modal } from '../ui/Modal';
import { SideloadGuideModal } from './SideloadGuideModal';
import { ApkVerifierDropzone } from './ApkVerifierDropzone';

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
  const [liveRelease, setLiveRelease] = useState<GitHubRelease | null>(null);
  const [isFullChecksum, setIsFullChecksum] = useState(false);
  const [showChecksumExplainer, setShowChecksumExplainer] = useState(false);

  useEffect(() => {
    const downloadUrl =
      typeof window !== 'undefined'
        ? `${window.location.origin}${APP_METADATA.apkDownloadUrl}`
        : APP_METADATA.apkDownloadUrl;

    generateQrDataUrl(downloadUrl).then(setQrDataUrl);

    // Fetch dynamic GitHub release metadata
    fetchLatestRelease().then((release) => {
      if (release) setLiveRelease(release);
    });
  }, []);

  const versionString = liveRelease?.tagName || APP_METADATA.version;
  const apkSizeString = liveRelease?.apkSize || APP_METADATA.apkSize;
  const apkDownloadLink = liveRelease?.apkDownloadUrl || APP_METADATA.apkDownloadUrl;

  const tabs = [
    {
      id: 'android' as PlatformType,
      label: 'Android APK',
      icon: <Smartphone size={18} />,
      badge: versionString,
    },
    {
      id: 'ios' as PlatformType,
      label: 'iOS / iPadOS',
      icon: <Apple size={18} />,
      badge: 'Home Screen PWA',
    },
  ];

  return (
    <section id="download" className="section-container">
      <div className="section-header">
        <Badge variant="muted">DISTRIBUTION</Badge>
        <h2 className="section-title">Install Horizon</h2>
        <p className="section-subtitle">
          Direct, private, zero telemetry. Available as a standalone Android package or an iOS Home Screen app.
        </p>
      </div>

      <div className="download-wrapper">
        {/* Platform Selector Tabs */}
        <TabGroup
          tabs={tabs}
          activeTab={selectedPlatform === 'desktop' ? 'android' : selectedPlatform}
          onChange={onPlatformChange}
        />

        {/* Tab 1: Android APK */}
        {(selectedPlatform === 'android' || selectedPlatform === 'desktop') && (
          <GlassCard className="download-card">
            <div className="download-card-grid">
              {/* Left Column: Actions */}
              <div className="download-main-col">
                <div className="download-badge-group">
                  <span className="platform-tag android-tag">
                    <Smartphone size={14} /> Android Universal APK
                  </span>
                  <span className="meta-tag">ARM64 & x86_64</span>
                  {liveRelease && (
                    <span className="meta-tag flex items-center gap-1 text-sage">
                      <GitBranch size={11} /> GitHub Sync
                    </span>
                  )}
                </div>

                <h3 className="download-heading">Horizon for Android</h3>
                <p className="download-desc">
                  Self-contained standalone package. Features hardware-accelerated 60/120 FPS rendering, tactile haptic feedback, background caching, and localized Open-Meteo queries.
                </p>

                {/* Primary Action Buttons */}
                <div className="download-btn-row">
                  <a
                    href={apkDownloadLink}
                    download="horizon-release.apk"
                    className="btn btn-primary btn-lg"
                  >
                    <Download size={18} />
                    <span>Download APK ({apkSizeString})</span>
                  </a>

                  <button
                    onClick={() => setIsQrModalOpen(true)}
                    className="btn btn-secondary btn-lg"
                    title="Scan QR Code from your phone"
                  >
                    <QrCode size={18} />
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

                {/* Client-Side In-Browser Verifier Dropzone */}
                <ApkVerifierDropzone expectedChecksum={APP_METADATA.apkChecksum} />
              </div>

              {/* Right Column: Checksum & File Info */}
              <div className="download-side-col">
                <div className="info-box">
                  <h4 className="info-box-title">Release Metadata</h4>
                  <div className="info-row">
                    <span className="info-label">Version</span>
                    <span className="info-val">{versionString}</span>
                  </div>
                  <div className="info-row">
                    <span className="info-label">File Size</span>
                    <span className="info-val">{apkSizeString}</span>
                  </div>
                  <div className="info-row">
                    <span className="info-label">Target SDK</span>
                    <span className="info-val">Android 8.0+ (API 26+)</span>
                  </div>
                  <div className="info-row">
                    <span className="info-label">Architecture</span>
                    <span className="info-val">Universal (ARM64, v7a, x86_64)</span>
                  </div>

                  {/* Cryptographic SHA-256 Checksum with Full Inspector */}
                  <div className="checksum-box">
                    <div className="checksum-header">
                      <div className="flex items-center gap-1">
                        <span className="checksum-title">SHA-256 Checksum</span>
                        <button
                          type="button"
                          onClick={() => setShowChecksumExplainer(!showChecksumExplainer)}
                          className="checksum-info-btn"
                          title="What is a checksum?"
                        >
                          <Info size={13} />
                        </button>
                      </div>
                      <button
                        onClick={() => onCopyChecksum(APP_METADATA.apkChecksum)}
                        className="copy-btn"
                        title="Copy checksum to clipboard"
                      >
                        {copiedChecksum ? (
                          <span className="flex items-center gap-1 text-sage">
                            <Check size={12} /> Copied
                          </span>
                        ) : (
                          <span className="flex items-center gap-1">
                            <Copy size={12} /> Copy
                          </span>
                        )}
                      </button>
                    </div>

                    {showChecksumExplainer && (
                      <div className="checksum-explainer">
                        A cryptographic hash proving the file has not been altered or corrupted during download.
                      </div>
                    )}

                    <div
                      className="checksum-code-wrapper"
                      onClick={() => setIsFullChecksum(!isFullChecksum)}
                      title="Click to toggle full hash"
                    >
                      <code className="checksum-code">
                        {isFullChecksum
                          ? APP_METADATA.apkChecksum
                          : `${APP_METADATA.apkChecksum.slice(0, 32)}...`}
                      </code>
                      <button className="checksum-toggle-btn">
                        {isFullChecksum ? <ChevronUp size={13} /> : <ChevronDown size={13} />}
                      </button>
                    </div>
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
              <div className="download-badge-group">
                <span className="platform-tag ios-tag">
                  <Apple size={14} /> Apple iOS / iPadOS
                </span>
                <span className="meta-tag">Safari Progressive Web App</span>
              </div>

              <h3 className="download-heading">Add Horizon to Your iPhone / iPad</h3>
              <p className="download-desc">
                No App Store account or side-loading required. Install Horizon directly as a native standalone PWA on iOS 16.4+ in three simple steps:
              </p>

              <div className="ios-steps-container">
                <div className="ios-step-card">
                  <div className="ios-step-icon">
                    <Apple size={22} className="text-gold" />
                  </div>
                  <div className="ios-step-num">Step 1</div>
                  <h4 className="ios-step-name">Open in Safari</h4>
                  <p className="ios-step-text">Navigate to Horizon on your iPhone or iPad using the default Safari browser.</p>
                </div>

                <div className="ios-step-card">
                  <div className="ios-step-icon">
                    <Share size={22} className="text-cyan" />
                  </div>
                  <div className="ios-step-num">Step 2</div>
                  <h4 className="ios-step-name">Tap Share Button</h4>
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
