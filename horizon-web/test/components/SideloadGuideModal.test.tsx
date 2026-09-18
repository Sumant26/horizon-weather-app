import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import { SideloadGuideModal } from '../../src/components/sections/SideloadGuideModal';

describe('SideloadGuideModal Component', () => {
  it('renders modal steps when open', () => {
    const onClose = vi.fn();
    render(<SideloadGuideModal isOpen={true} onClose={onClose} />);

    expect(screen.getByText('Android Sideloading Guide')).toBeInTheDocument();
    expect(screen.getByText('Download the Official APK')).toBeInTheDocument();
    expect(screen.getByText('Allow Unknown Sources (One-Time Prompt)')).toBeInTheDocument();
  });

  it('triggers onClose when clicking Got It button', () => {
    const onClose = vi.fn();
    render(<SideloadGuideModal isOpen={true} onClose={onClose} />);

    fireEvent.click(screen.getByText('Got It, Thanks!'));
    expect(onClose).toHaveBeenCalledTimes(1);
  });
});
