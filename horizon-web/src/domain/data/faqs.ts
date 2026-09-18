export interface FAQItem {
  question: string;
  answer: string;
}

export const FAQS: FAQItem[] = [
  {
    question: 'How do I install Horizon on Android?',
    answer:
      'Download the APK from the Download Center. When opening the downloaded file, your phone may ask for permission to "Install unknown apps" from your browser. Toggle this setting on and tap Install. The app will install cleanly without any background tracking or bloat.',
  },
  {
    question: 'How do I use Horizon on iPhone / iPad (iOS)?',
    answer:
      'On iOS, open Horizon Web in Safari, tap the Share icon at the bottom bar, and select "Add to Home Screen". Horizon will launch as a full-screen, standalone application with high performance, smooth animations, and offline caching.',
  },
  {
    question: 'Why does Horizon show temperature relative to yesterday?',
    answer:
      'Human thermal perception is comparative: saying it is 19°C means very different things depending on whether yesterday was 14°C (a pleasant warm jump) or 26°C (a brisk cold front). Horizon computes the exact 24-hour delta at this specific hour so you instantly know how to dress and plan your day.',
  },
  {
    question: 'Does Horizon collect my location or personal data?',
    answer:
      'Never. Horizon has zero user accounts, zero analytics trackers, and zero third-party ads. Your GPS coordinates are processed directly against Open-Meteo for local forecasts and cached solely on your device.',
  },
  {
    question: 'Is an API key required to fetch weather data?',
    answer:
      'No API key is required. Horizon integrates Open-Meteo, an open-source weather service providing high-precision atmospheric and historical data without subscription paywalls or key expirations.',
  },
];
