# Horizon — Weather for Humans, Not Meteorologists

> A minimalist, high-contrast, editorial weather intelligence ecosystem crafted for instant glanceability — featuring a native Flutter mobile client and a dark, modern React web companion.

[![Horizon CI Pipeline](https://github.com/Sumant26/horizon-weather-app/actions/workflows/ci.yml/badge.svg)](https://github.com/Sumant26/horizon-weather-app/actions/workflows/ci.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![React](https://img.shields.io/badge/React-18.x-61DAFB?logo=react)](https://react.dev)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-3178C6?logo=typescript)](https://www.typescriptlang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## Overview

**Horizon** is a design-forward weather application that prioritizes clarity, meaning, and human-first glanceability over raw information overload. Rather than flooding the user with cluttered radar maps and dense numerical tables, Horizon translates meteorological metrics into actionable insights:
- Telling you what the weather *means* for your day.
- Explaining how the current temperature compares directly to **yesterday at this exact hour**.
- Highlighting optimal 2-hour comfort windows for outdoor activities (running, cycling, stargazing, dining).
- Recommending only the gear you actually need (sunglasses, jacket, umbrella).
- Calculating atmospheric clarity for night-sky stargazing.

---

## Monorepo & Directory Structure

```
horizon_weather_app/
├── .github/
│   └── workflows/
│       ├── ci.yml                   # Unified GitHub Actions CI Pipeline
│       └── deploy-web.yml           # Web Build & Packaging Workflow
├── .husky/
│   └── pre-commit                   # Monorepo pre-commit quality gate (Dart & Web)
│
├── lib/                             # Native Flutter Application
│   ├── core/                        # Cross-cutting concerns: themes, constants, utilities, loggers
│   │   ├── constants/               # AppColors, typography scales, layout dimensions
│   │   └── utils/                   # AppLogger, date formatters, unit converters
│   ├── data/                        # Data Layer
│   │   ├── datasources/             # Remote API clients and local cache adapters
│   │   ├── models/                  # WeatherData entity + computed property getters
│   │   └── repositories/            # Repository implementations (Mock / Open-Meteo)
│   ├── domain/                      # Domain Layer (Pure Dart business logic)
│   │   ├── entities/                # WeatherEntity, ActivityProfile, AstronomyInfo
│   │   └── repositories/            # Abstract repository interfaces
│   └── presentation/                # Presentation Layer
│       ├── components/              # Modular atomic UI widgets
│       ├── screens/                 # HomeScreen & layout compositions
│       └── state/                   # Sealed WeatherState & WeatherNotifier
│
├── horizon-web/                     # React + TypeScript Web Companion
│   ├── public/                      # Static assets, release APKs, manifest.json
│   ├── src/
│   │   ├── components/
│   │   │   ├── layout/              # Navbar, Footer
│   │   │   ├── sections/            # HeroSection, FeaturesShowcase, DownloadCenter
│   │   │   └── ui/                  # SideloadGuideModal, QR Generator, Badges
│   │   ├── core/constants/          # Metadata, deep dark color tokens, typography
│   │   ├── domain/                  # TypeScript interfaces and feature contracts
│   │   └── state/                   # UI state hooks and download tracking
│   ├── package.json                 # Web build scripts & dependencies
│   ├── tsconfig.json                # TypeScript compiler configuration
│   └── vite.config.ts               # Vite build & bundle optimizations
│
├── test/                            # Flutter automated test suite
├── pubspec.yaml                     # Flutter package specifications
├── AGENTS.md                        # Architectural guidelines & engineering standards
├── README.md                        # Documentation & setup guide
└── spec.md                          # Technical specification document
```

---

## 1. Horizon Mobile App (Flutter)

### Core Features
- **Human-First Summaries**: Natural language briefings comparing today's trend against yesterday (e.g., *"About 2.8°C cooler than yesterday at this exact hour"*).
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

```bash
# Clone the repository
git clone https://github.com/Sumant26/horizon-weather-app.git
cd horizon-weather-app

# Install Flutter dependencies
flutter pub get

# Run static analysis (0 error / 0 warning standard)
flutter analyze

# Execute automated tests
flutter test

# Launch the app on a connected device or emulator
flutter run
```

---

## 2. Horizon Web (`horizon-web`)

**Horizon Web** is the official dark companion showcase and direct distribution portal for Horizon. Built with React 18, TypeScript, and Vite, it delivers an editorial showcase and an integrated multi-platform distribution center.

### Web Features
- **Deep Dark Velvet Obsidian Aesthetic**: High-contrast OLED dark palette (`#080B11`), warm honey-gold accents (`#F6AD55`), and soft ivory linen typography (`#FAF6F0`).
- **Editorial Showcase & Live Preview**: Interactive glanceable preview demonstrating Horizon's temperature delta and comfort window computations.
- **Direct Multi-Platform Distribution**:
  - **Android APK Direct Sideload**: Direct APK download with dynamically generated QR codes for instant mobile scanning and SHA-256 integrity verification.
  - **iOS PWA Installation Walkthrough**: Visual 3-step guide for adding Horizon to the iOS Home Screen as a standalone web app.
- **Interactive Sideloading Guide Modal**: Step-by-step security and installation walkthrough for Android users.

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

# Run unit and component tests
npm test

# Typecheck and build for production
npm run build
```

---

## 3. Quality Gate & CI/CD

### Husky Git Hooks
The repository includes a pre-commit quality gate (`.husky/pre-commit`) that automatically verifies:
- `dart format --set-exit-if-changed .` (Dart formatting)
- `flutter analyze` (Strict static analysis)
- `flutter test` (Flutter unit and widget tests)
- `npm run typecheck` & `npm test` in `horizon-web/` (TypeScript & Vitest tests)

### GitHub Actions Pipeline
Continuous Integration is configured via `.github/workflows/ci.yml`:
- **Flutter Job**: Validates formatting, static analysis, unit tests with coverage, and builds release APKs.
- **Web Job**: Performs type checking, ESLint inspection, Vitest test execution, and production bundling.

---

## Design Philosophy

Horizon is built around three core principles:
1. **Minimalism** — Zero bloat, zero clutter. Every element on screen serves an immediate purpose.
2. **Glanceability** — All critical environmental context is visible within two seconds of opening the app.
3. **Context Over Data** — Weather translated into human meaning rather than raw numbers.

---

## License

This project is open-source and available under the [MIT License](LICENSE).
