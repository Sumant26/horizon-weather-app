# Horizon — Weather for Humans, Not Meteorologists

> A minimalist, high-contrast editorial weather experience crafted for instant glanceability — available as a native Flutter mobile application and a modern React web companion portal.

---

## Overview

**Horizon** is a design-forward weather application that prioritizes clarity, meaning, and human-first glanceability over raw information overload. Rather than flooding the user with cluttered radar maps and dense numerical tables, Horizon translates meteorological metrics into actionable insights:
- Telling you what the weather *means* for your day.
- Explaining how the current temperature compares directly to **yesterday at this exact hour**.
- Highlighting optimal 2-hour comfort windows for outdoor activities.
- Recommending only the gear you actually need (sunglasses, jacket, umbrella).
- Calculating atmospheric clarity for night-sky stargazing.

---

## Monorepo & Directory Structure

The repository contains both the native Flutter mobile client and the React web companion:

```
horizon_weather_app/
├── lib/                             # Flutter Mobile Application
│   ├── core/                        # Themes, constants, utilities, loggers
│   ├── data/
│   │   ├── models/                  # WeatherData entity + computed property getters
│   │   └── repositories/            # Mock & simulated microclimate data layer
│   └── presentation/
│       ├── screens/                 # HomeScreen & compositional layouts
│       └── state/                   # Sealed WeatherState & WeatherNotifier
│
├── horizon-web/                     # React + TypeScript Web Companion & Showcase
│   ├── public/                      # Static assets & manifest
│   ├── src/
│   │   ├── components/              # Layout, UI elements, and showcase sections
│   │   │   ├── layout/              # Navbar, Footer
│   │   │   ├── sections/            # Hero, DownloadCenter, Features, Specs, FAQ
│   │   │   └── ui/                  # Modals (Sideload Guide), Badges, Cards
│   │   ├── core/constants/          # Theme tokens, metadata, color schemes
│   │   ├── domain/                  # Types and data contracts
│   │   └── state/                   # State holders and hooks
│   ├── package.json                 # Web scripts & dependencies
│   └── vite.config.ts               # Vite configuration
│
├── test/                            # Flutter automated test suite
├── pubspec.yaml                     # Flutter package metadata
├── AGENTS.md                        # Architecture guidelines, standards & roadmap
└── README.md                        # Documentation & setup instructions
```

---

## 1. Horizon Mobile App (Flutter)

### Core Features
- **Human-First Summaries**: Natural language briefings comparing today's trend against yesterday (e.g., *"About 2.3°C warmer than yesterday at this exact hour"*).
- **Dynamic Condition Gradients**: Procedural, smooth background transitions reflecting ambient conditions (Clear Day, Clear Night, Rainy, Overcast, Extreme Heat).
- **Kinetic Typography**: Temperature typography dynamically shifts weight and styling based on heat intensity.
- **Perfect Activity Windows**: Intelligent computation of the best 2-hour window for outdoor activities (Running, Cycling, Stargazing).
- **Minimalist Gear Checklist**: Context-aware essentials (UV sunglasses, hydration pack, light jacket, umbrella).
- **Night Sky Clarity Index**: Real-time atmospheric transparency metrics shown during night hours.
- **Zero Third-Party Dependencies**: Pure Flutter SDK implementation for ultra-fast startup and small bundle footprint.

### Mobile Tech Stack
| Component | Technology | Purpose |
|---|---|---|
| Framework | **Flutter (SDK >= 3.0.0)** | Cross-platform native mobile UI |
| Language | **Dart 3.x** | Strongly-typed client logic |
| Design System | **Material 3** | Modern typography and layout primitives |
| State Management | **ValueNotifier / Sealed Classes** | Predictable, lightweight reactive state |
| Animations | **AnimatedContainer / AnimatedSwitcher** | Fluid 60/120 FPS ambient transitions |

### Getting Started (Mobile)

#### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / Xcode (for simulators and device deployment)

#### Run Locally
```bash
# Clone the repository
git clone https://github.com/Sumant26/horizon-weather-app.git
cd horizon-weather-app

# Install Flutter dependencies
flutter pub get

# Run static analysis
flutter analyze

# Execute tests
flutter test

# Launch the app on a connected device/emulator
flutter run
```

#### Build Release Artifacts
```bash
# Android APK
flutter build apk --release

# Android App Bundle (AAB)
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release
```

---

## 2. Horizon Web (`horizon-web`)

**Horizon Web** is the official web companion and distribution portal for Horizon. Built with React 18, TypeScript, and Vite, it delivers an editorial showcase, live interactive weather preview, and an integrated multi-platform distribution center.

### Web Features
- **Editorial Showcase & Live Preview**: Interactive showcase demonstrating Horizon's glanceability and dynamic ambient color system.
- **Multi-Channel Download Center**:
  - **Android APK Sideload**: Direct APK download with dynamically generated QR codes for instant mobile scanning and SHA-256 integrity verification.
  - **iOS PWA Installation Walkthrough**: Step-by-step visual guide for adding Horizon to the iOS Home Screen as a standalone web app.
  - **Instant Web Edition**: One-click launcher for the browser-based client.
- **Interactive Sideloading Guide Modal**: Step-by-step security and installation walkthrough for Android users.
- **Technical Specifications & FAQ**: Clear breakdown of supported architectures, runtime requirements, privacy guarantees, and permissions.
- **Glassmorphism Dark-Mode Aesthetics**: High-contrast OLED black palette with subtle glassmorphic surfaces and responsive layouts.

### Web Tech Stack
| Package | Version | Purpose |
|---|---|---|
| **React** | `^18.2.0` | Declarative UI components |
| **TypeScript** | `^5.3.3` | Type safety and domain contracts |
| **Vite** | `^5.1.4` | Ultra-fast development and optimized bundling |
| **Lucide React** | `^0.344.0` | Minimalist iconography |
| **QRCode** | `^1.5.3` | Dynamic QR code generation for APK mobile downloads |
| **Vitest & Testing Library** | `^1.3.1` | Unit testing and component verification |

### Getting Started (Web)

```bash
# Navigate to the web workspace
cd horizon-web

# Install npm dependencies
npm install

# Start development server
npm run dev

# Run unit tests
npm test

# Typecheck and build for production
npm run build

# Preview production build locally
npm run preview
```

---

## Planned Capabilities & Feature Roadmap

For detailed architectural guidelines, engineering standards, and future milestones, refer to [AGENTS.md](AGENTS.md).

Upcoming roadmap capabilities include:
1. **Live Open-Meteo Integration**: Real-time forecasts and historical archive queries for dynamic yesterday vs. today deltas.
2. **Live GPS & Multi-Location**: Geolocation auto-detection, reverse geocoding, and multi-city horizontal paging.
3. **Air Quality Index (AQI)**: Real-time PM2.5, PM10, and Ozone readings with actionable health recommendations.
4. **Hourly Timeline & 7-Day Spectrum**: Scrubbable 24-hour horizontal forecast strip and high/low temperature spectrum bars.
5. **Celestial Astronomical Arc**: Dynamic Sun and Moon position tracker with golden hour and lunar phase indicators.
6. **Subtle Atmospheric Canvas Effects**: Isolated `CustomPainter` layers for ambient mist, rain streaks, and star fields.

---

## Design Philosophy

Horizon is built around three core principles:
1. **Minimalism** — Zero bloat, zero clutter. Every element on screen serves an immediate purpose.
2. **Glanceability** — All critical environmental context is visible within two seconds of opening the app.
3. **Context Over Data** — Weather translated into human meaning rather than raw numbers.

---

## License

This project is open-source and available under the MIT License for personal and educational use.
