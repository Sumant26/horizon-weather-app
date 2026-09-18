import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import { FeaturesShowcase } from '../../src/components/sections/FeaturesShowcase';

describe('FeaturesShowcase Component', () => {
  it('renders all 6 feature pillars', () => {
    render(<FeaturesShowcase />);

    expect(screen.getByText('Temperature Relative to Yesterday')).toBeInTheDocument();
    expect(screen.getByText('2-Hour Activity Comfort Windows')).toBeInTheDocument();
    expect(screen.getByText('Biophilic Health & Migraine Alerts')).toBeInTheDocument();
    expect(screen.getByText('Night-Sky Clarity & Celestial Arc')).toBeInTheDocument();
    expect(screen.getByText('Procedural Ambient Soundscapes')).toBeInTheDocument();
    expect(screen.getByText('High-Contrast OLED Visual Themes')).toBeInTheDocument();
  });
});
