import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import { Navbar } from '../../src/components/layout/Navbar';

describe('Navbar Component', () => {
  it('renders branding title and action buttons', () => {
    const onDownload = vi.fn();
    const onFeatures = vi.fn();
    const onSpecs = vi.fn();

    render(
      <Navbar
        onScrollToDownload={onDownload}
        onScrollToFeatures={onFeatures}
        onScrollToSpecs={onSpecs}
      />,
    );

    expect(screen.getByText('HORIZON')).toBeInTheDocument();
    expect(screen.getByText('Get App')).toBeInTheDocument();
    expect(screen.getByText('Launch Web App')).toBeInTheDocument();
  });

  it('triggers callback when clicking Get App button', () => {
    const onDownload = vi.fn();
    const onFeatures = vi.fn();
    const onSpecs = vi.fn();

    render(
      <Navbar
        onScrollToDownload={onDownload}
        onScrollToFeatures={onFeatures}
        onScrollToSpecs={onSpecs}
      />,
    );

    fireEvent.click(screen.getByText('Get App'));
    expect(onDownload).toHaveBeenCalledTimes(1);
  });
});
