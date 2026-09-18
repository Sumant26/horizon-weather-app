import { describe, it, expect } from 'vitest';
import { generateQrDataUrl } from '../../src/core/utils/qr_generator';

describe('QR Generator Utility', () => {
  it('generates a valid data:image/png base64 URL', async () => {
    const dataUrl = await generateQrDataUrl('https://example.com/horizon.apk');
    expect(dataUrl).toMatch(/^data:image\/png;base64,/);
  });
});
