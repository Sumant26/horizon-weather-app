import React from 'react';
import { Navbar } from './components/layout/Navbar';
import { Footer } from './components/layout/Footer';
import { HeroSection } from './components/sections/HeroSection';
import { FeaturesShowcase } from './components/sections/FeaturesShowcase';
import { DownloadCenter } from './components/sections/DownloadCenter';
import { useDownloadState } from './state/useDownloadStore';

export const App: React.FC = () => {
  const {
    selectedPlatform,
    setSelectedPlatform,
    isSideloadGuideOpen,
    setIsSideloadGuideOpen,
    copiedChecksum,
    handleCopyChecksum,
  } = useDownloadState();

  const scrollTo = (id: string) => {
    const el = document.getElementById(id);
    if (el) {
      el.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <div className="app-container">
      {/* Top Cozy Navigation */}
      <Navbar
        onScrollToDownload={() => scrollTo('download')}
        onScrollToFeatures={() => scrollTo('features')}
      />

      {/* Main Showcase & Storytelling */}
      <main>
        {/* 1. Cozy Hero Section */}
        <HeroSection
          onDownloadClick={() => scrollTo('download')}
          onExploreFeatures={() => scrollTo('features')}
        />

        {/* 2. Core 4 Design Pillars */}
        <FeaturesShowcase />

        {/* 3. Streamlined Download Center */}
        <DownloadCenter
          selectedPlatform={selectedPlatform}
          onPlatformChange={setSelectedPlatform}
          isSideloadGuideOpen={isSideloadGuideOpen}
          onOpenSideloadGuide={() => setIsSideloadGuideOpen(true)}
          onCloseSideloadGuide={() => setIsSideloadGuideOpen(false)}
          copiedChecksum={copiedChecksum}
          onCopyChecksum={handleCopyChecksum}
        />
      </main>

      {/* Footer */}
      <Footer />
    </div>
  );
};
