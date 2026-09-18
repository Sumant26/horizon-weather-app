import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import { ApkVerifierDropzone } from '../../src/components/sections/ApkVerifierDropzone';

describe('ApkVerifierDropzone Component', () => {
  const dummyExpected = 'a8f9c1e4d3b2e7f8092348571029384756102938475610293847561029384756';

  it('renders dropzone with client-side zero-upload label', () => {
    render(<ApkVerifierDropzone expectedChecksum={dummyExpected} />);

    expect(screen.getByText(/In-Browser APK Integrity Verifier/i)).toBeInTheDocument();
    expect(screen.getByText(/Client-side only • Zero upload/i)).toBeInTheDocument();
    expect(screen.getByText(/app-release.apk/i)).toBeInTheDocument();
  });
});
