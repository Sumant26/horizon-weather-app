import React from 'react';
import { Modal } from '../ui/Modal';
import { ShieldCheck, CheckCircle2 } from 'lucide-react';

interface SideloadGuideModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const SideloadGuideModal: React.FC<SideloadGuideModalProps> = ({
  isOpen,
  onClose,
}) => {
  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="Android Sideloading Guide"
      subtitle="How to install Horizon APK cleanly in 3 simple steps"
      maxWidth="540px"
    >
      <div className="guide-steps-list">
        {/* Step 1 */}
        <div className="guide-step">
          <div className="guide-step-number">1</div>
          <div className="guide-step-content">
            <h4 className="guide-step-title">Download the Official APK</h4>
            <p className="guide-step-desc">
              Tap the <strong>"Download APK"</strong> button or scan the QR code from your Android device. The file will save to your Downloads folder.
            </p>
          </div>
        </div>

        {/* Step 2 */}
        <div className="guide-step">
          <div className="guide-step-number">2</div>
          <div className="guide-step-content">
            <h4 className="guide-step-title">Allow Unknown Sources (One-Time Prompt)</h4>
            <p className="guide-step-desc">
              When opening the APK, Android will ask: <em>"For your security, your phone is not allowed to install unknown apps from this source"</em>.
              Tap <strong>Settings</strong> and toggle on <strong>"Allow from this source"</strong>.
            </p>
          </div>
        </div>

        {/* Step 3 */}
        <div className="guide-step">
          <div className="guide-step-number">3</div>
          <div className="guide-step-content">
            <h4 className="guide-step-title">Tap Install & Launch</h4>
            <p className="guide-step-desc">
              Tap <strong>Install</strong>. Horizon will install instantaneously with zero tracking, zero background drain, and instant cold launch.
            </p>
          </div>
        </div>
      </div>

      <div className="guide-security-banner">
        <ShieldCheck size={20} className="text-sage" />
        <div className="guide-security-text">
          <strong>100% Safe & Verifiable</strong>
          <p>Horizon is open source and built with zero analytics SDKs or advertising trackers. You can verify the SHA-256 checksum anytime.</p>
        </div>
      </div>

      <div className="guide-footer-btn">
        <button onClick={onClose} className="btn btn-primary w-full">
          <CheckCircle2 size={18} />
          <span>Got It, Thanks!</span>
        </button>
      </div>
    </Modal>
  );
};
