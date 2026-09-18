import { useState, useEffect } from 'react';
import { detectPlatform, PlatformType } from '../core/utils/platform_detector';

export function useDownloadState() {
  const [selectedPlatform, setSelectedPlatform] = useState<PlatformType>('android');
  const [isQrModalOpen, setIsQrModalOpen] = useState(false);
  const [isSideloadGuideOpen, setIsSideloadGuideOpen] = useState(false);
  const [copiedChecksum, setCopiedChecksum] = useState(false);

  useEffect(() => {
    const detected = detectPlatform();
    setSelectedPlatform(detected);
  }, []);

  const handleCopyChecksum = async (checksum: string) => {
    if (typeof navigator !== 'undefined' && navigator.clipboard) {
      await navigator.clipboard.writeText(checksum);
      setCopiedChecksum(true);
      setTimeout(() => setCopiedChecksum(false), 2500);
    }
  };

  return {
    selectedPlatform,
    setSelectedPlatform,
    isQrModalOpen,
    setIsQrModalOpen,
    isSideloadGuideOpen,
    setIsSideloadGuideOpen,
    copiedChecksum,
    handleCopyChecksum,
  };
}
