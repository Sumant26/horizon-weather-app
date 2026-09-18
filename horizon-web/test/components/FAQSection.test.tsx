import { describe, it, expect } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import { FAQSection } from '../../src/components/sections/FAQSection';

describe('FAQSection Component', () => {
  it('renders FAQ questions and toggles answers', () => {
    render(<FAQSection />);

    expect(screen.getByText('Frequently Asked Questions')).toBeInTheDocument();
    expect(screen.getByText('How do I install Horizon on Android?')).toBeInTheDocument();

    const q2 = screen.getByText('How do I use Horizon on iPhone / iPad (iOS)?');
    fireEvent.click(q2);

    expect(screen.getByText(/On iOS, open Horizon Web in Safari/i)).toBeInTheDocument();
  });
});
