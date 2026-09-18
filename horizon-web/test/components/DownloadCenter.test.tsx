import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import { DownloadCenter } from '../../src/components/sections/DownloadCenter';

describe('DownloadCenter Component', () => {
  it('renders Android tab details by default', () => {
    const onPlatformChange = vi.fn();
    const onOpenGuide = vi.fn();
    const onCloseGuide = vi.fn();
    const onCopy = vi.fn();

    render(
      <DownloadCenter
        selectedPlatform="android"
        onPlatformChange={onPlatformChange}
        isSideloadGuideOpen={false}
        onOpenSideloadGuide={onOpenGuide}
        onCloseSideloadGuide={onCloseGuide}
        copiedChecksum={false}
        onCopyChecksum={onCopy}
      />,
    );

    expect(screen.getByText('Horizon for Android')).toBeInTheDocument();
    expect(screen.getByText(/Download APK/i)).toBeInTheDocument();
    expect(screen.getByText('Scan QR')).toBeInTheDocument();
  });

  it('triggers platform change when tab clicked', () => {
    const onPlatformChange = vi.fn();
    const onOpenGuide = vi.fn();
    const onCloseGuide = vi.fn();
    const onCopy = vi.fn();

    render(
      <DownloadCenter
        selectedPlatform="android"
        onPlatformChange={onPlatformChange}
        isSideloadGuideOpen={false}
        onOpenSideloadGuide={onOpenGuide}
        onCloseSideloadGuide={onCloseGuide}
        copiedChecksum={false}
        onCopyChecksum={onCopy}
      />,
    );

    fireEvent.click(screen.getByText('iOS / iPadOS'));
    expect(onPlatformChange).toHaveBeenCalledWith('ios');
  });

  it('renders iOS PWA instructions when iOS tab is active', () => {
    const onPlatformChange = vi.fn();
    const onOpenGuide = vi.fn();
    const onCloseGuide = vi.fn();
    const onCopy = vi.fn();

    render(
      <DownloadCenter
        selectedPlatform="ios"
        onPlatformChange={onPlatformChange}
        isSideloadGuideOpen={false}
        onOpenSideloadGuide={onOpenGuide}
        onCloseSideloadGuide={onCloseGuide}
        copiedChecksum={false}
        onCopyChecksum={onCopy}
      />,
    );

    expect(screen.getByText(/Install Horizon on iPhone in 1 Tap/i)).toBeInTheDocument();
    expect(screen.getByText('Open in Safari')).toBeInTheDocument();
    expect(screen.getByText('Add to Home Screen')).toBeInTheDocument();
  });
});
