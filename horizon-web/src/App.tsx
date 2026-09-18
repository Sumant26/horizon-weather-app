import React from 'react';
import { Navbar } from './components/layout/Navbar';
import { Footer } from './components/layout/Footer';
import { HeroSection } from './components/sections/HeroSection';
import { FeaturesShowcase } from './components/sections/FeaturesShowcase';
import { DownloadCenter } from './components/sections/DownloadCenter';
import { TechSpecsSection } from './components/sections/TechSpecsSection';
import { FAQSection } from './components/sections/FAQSection';
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
      {/* Top Navigation */}
      <Navbar
        onScrollToDownload={() => scrollTo('download')}
        onScrollToFeatures={() => scrollTo('features')}
        onScrollToSpecs={() => scrollTo('specs')}
      />

      {/* Main Showcase & Storytelling */}
      <main>
        {/* 1. Hero */}
        <HeroSection
          onDownloadClick={() => scrollTo('download')}
          onExploreFeatures={() => scrollTo('features')}
        />

        {/* 2. Core 6 Feature Pillars */}
        <FeaturesShowcase />

        {/* 3. Distribution & Download Center */}
        <DownloadCenter
          selectedPlatform={selectedPlatform}
          onPlatformChange={setSelectedPlatform}
          isSideloadGuideOpen={isSideloadGuideOpen}
          onOpenSideloadGuide={() => setIsSideloadGuideOpen(true)}
          onCloseSideloadGuide={() => setIsSideloadGuideOpen(false)}
          copiedChecksum={copiedChecksum}
          onCopyChecksum={handleCopyChecksum}
        />

        {/* 4. Tech Specs & Architecture */}
        <TechSpecsSection />

        {/* 5. Frequently Asked Questions */}
        <FAQSection />
      </main>

      {/* Footer */}
      <Footer />
    </div>
  );
};
