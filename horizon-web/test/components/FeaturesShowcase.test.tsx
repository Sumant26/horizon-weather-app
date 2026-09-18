import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import { FeaturesShowcase } from '../../src/components/sections/FeaturesShowcase';

describe('FeaturesShowcase Component', () => {
  it('renders all 4 essential design pillars', () => {
    render(<FeaturesShowcase />);

    expect(screen.getByText('Temperature Relative to Yesterday')).toBeInTheDocument();
    expect(screen.getByText('2-Hour Activity Comfort Windows')).toBeInTheDocument();
    expect(screen.getByText('Contextual Gear Checklist')).toBeInTheDocument();
    expect(screen.getByText('Night Sky Clarity Index')).toBeInTheDocument();
  });
});
