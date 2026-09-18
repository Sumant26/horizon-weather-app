import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import { HeroSection } from '../../src/components/sections/HeroSection';

describe('HeroSection Component', () => {
  it('renders headline and yesterday delta mockup', () => {
    const onDownload = vi.fn();
    const onExplore = vi.fn();

    render(
      <HeroSection
        onDownloadClick={onDownload}
        onExploreFeatures={onExplore}
      />,
    );

    expect(screen.getByText(/way to feel the weather/i)).toBeInTheDocument();
    expect(screen.getByText('-2.8° Cooler')).toBeInTheDocument();
    expect(screen.getByText(/07:00 – 09:00 AM/i)).toBeInTheDocument();
  });

  it('triggers download button click', () => {
    const onDownload = vi.fn();
    const onExplore = vi.fn();

    render(
      <HeroSection
        onDownloadClick={onDownload}
        onExploreFeatures={onExplore}
      />,
    );

    fireEvent.click(screen.getByText('Get Horizon App'));
    expect(onDownload).toHaveBeenCalledTimes(1);
  });
});
