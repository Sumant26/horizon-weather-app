export interface TechSpecItem {
  category: string;
  items: { label: string; value: string; detail?: string }[];
}

export const TECH_SPECS: TechSpecItem[] = [
  {
    category: 'Architecture & Engine',
    items: [
      { label: 'Framework', value: 'Flutter SDK 3.x (Dart)' },
      { label: 'Layering', value: 'Clean Architecture (Domain, Data, Presentation, Core)' },
      { label: 'Frame Rate', value: 'Deterministic 60 / 120 FPS Target' },
      { label: 'State Model', value: 'Immutable ValueNotifier & Sealed State Containers' },
    ],
  },
  {
    category: 'Data & Privacy',
    items: [
      { label: 'Weather Provider', value: 'Open-Meteo High-Resolution API (No API Key Required)' },
      { label: 'Historical Archive', value: 'Hourly ERA5 Reanalysis comparisons' },
      { label: 'Telemetry & Tracking', value: '0% Telemetry • No Accounts • No Advertising' },
      { label: 'Offline Resilience', value: 'Instant Cold Launch with TTL-validated Local Cache' },
    ],
  },
  {
    category: 'Distribution & Formats',
    items: [
      { label: 'Android Build', value: 'Universal Release APK (ARM64 & x86_64)' },
      { label: 'iOS / Desktop', value: 'Progressive Web App (PWA) with Offline Worker' },
      { label: 'File Size', value: '~18.4 MB Self-Contained' },
      { label: 'Permissions', value: 'Precise/Approximate GPS (Optional for Auto-Node)' },
    ],
  },
];
