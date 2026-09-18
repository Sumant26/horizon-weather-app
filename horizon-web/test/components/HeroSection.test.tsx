import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, act } from '@testing-library/react';
import { HeroSection } from '../../src/components/sections/HeroSection';

describe('HeroSection Component', () => {
  beforeEach(() => {
    vi.restoreAllMocks();
  });

  it('renders headline, user location, and 3-day perspective tabs', async () => {
    const onDownload = vi.fn();
    const onExplore = vi.fn();

    await act(async () => {
      render(
        <HeroSection
          onDownloadClick={onDownload}
          onExploreFeatures={onExplore}
        />,
      );
    });

    expect(screen.getByText(/way to feel the weather/i)).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /yesterday/i })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /today \(live\)/i })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /tomorrow/i })).toBeInTheDocument();
    expect(screen.getByText(/OPTIMAL 2-HOUR WINDOW/i)).toBeInTheDocument();
  });

  it('switches across Yesterday, Today, and Tomorrow tabs seamlessly', async () => {
    const onDownload = vi.fn();
    const onExplore = vi.fn();

    await act(async () => {
      render(
        <HeroSection
          onDownloadClick={onDownload}
          onExploreFeatures={onExplore}
        />,
      );
    });

    // Click Yesterday tab
    act(() => {
      fireEvent.click(screen.getByRole('button', { name: /yesterday/i }));
    });
    expect(screen.getByText(/Historical baseline/i)).toBeInTheDocument();

    // Click Tomorrow tab
    act(() => {
      fireEvent.click(screen.getByRole('button', { name: /tomorrow/i }));
    });
    expect(screen.getByText(/vs today at this hour/i)).toBeInTheDocument();
  });

  it('triggers download button click', async () => {
    const onDownload = vi.fn();
    const onExplore = vi.fn();

    await act(async () => {
      render(
        <HeroSection
          onDownloadClick={onDownload}
          onExploreFeatures={onExplore}
        />,
      );
    });

    fireEvent.click(screen.getByText('Get Horizon App'));
    expect(onDownload).toHaveBeenCalledTimes(1);
  });
});
