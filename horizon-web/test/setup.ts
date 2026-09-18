import '@testing-library/jest-dom';

// Mock matchMedia for jsdom tests
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: (query: string) => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: () => {},
    removeListener: () => {},
    addEventListener: () => {},
    removeEventListener: () => {},
    dispatchEvent: () => false,
  }),
});

// Mock HTMLCanvasElement.prototype.getContext for jsdom
HTMLCanvasElement.prototype.getContext = ((_contextId: string) => ({
  clearRect: () => {},
  beginPath: () => {},
  arc: () => {},
  fill: () => {},
  fillStyle: '',
  shadowBlur: 0,
  shadowColor: '',
} as unknown as CanvasRenderingContext2D)) as unknown as typeof HTMLCanvasElement.prototype.getContext;
