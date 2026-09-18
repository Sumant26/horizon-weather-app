import React from 'react';
import { Navbar } from './components/layout/Navbar';
import { Footer } from './components/layout/Footer';
import { HeroSection } from './components/sections/HeroSection';
import { FeaturesShowcase } from './components/sections/FeaturesShowcase';
import { DownloadCenter } from './components/sections/DownloadCenter';
import { useDownloadState } from './state/useDownloadStore';
import { useWeatherStore } from './state/useWeatherStore';

export const App: React.FC = () => {
  const {
    selectedPlatform,
    setSelectedPlatform,
    isSideloadGuideOpen,
    setIsSideloadGuideOpen,
    copiedChecksum,
    handleCopyChecksum,
  } = useDownloadState();

  const {
    liveData,
    locationName,
    microclimate,
    yesterday,
    today,
    tomorrow,
    isLocating,
    locationError,
    refreshWeather,
  } = useWeatherStore();

  const scrollTo = (id: string) => {
    const el = document.getElementById(id);
    if (el) {
      el.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <div className="app-container">
      {/* Top Cozy Navigation with Location Badge */}
      <Navbar
        onScrollToDownload={() => scrollTo('download')}
        onScrollToFeatures={() => scrollTo('features')}
        locationName={locationName}
        currentTemp={today.temperature}
      />

      {/* Main Showcase & Storytelling */}
      <main>
        {/* 1. Cozy Hero Section with User Location & 3-Day Perspective */}
        <HeroSection
          onDownloadClick={() => scrollTo('download')}
          onExploreFeatures={() => scrollTo('features')}
          locationName={locationName}
          microclimate={microclimate}
          yesterday={yesterday}
          today={today}
          tomorrow={tomorrow}
          liveData={liveData}
          isLocating={isLocating}
          locationError={locationError}
          onRefreshWeather={refreshWeather}
        />

        {/* 2. Core 4 Design Pillars tuned to User's City Data */}
        <FeaturesShowcase
          locationName={locationName}
          today={today}
          liveData={liveData}
        />

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
