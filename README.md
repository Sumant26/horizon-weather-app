# Horizon — Weather for Humans, Not Meteorologists

> A minimalist, high-contrast, editorial weather intelligence ecosystem crafted for instant glanceability — featuring a native Flutter mobile client and a bespoke, matte dark React web companion.

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
├── horizon-web/                     # React + TypeScript Web Companion (Matte Dark Theme)
│   ├── public/                      # Static assets, release APKs, manifest.json
│   ├── src/
│   │   ├── components/
│   │   │   ├── layout/              # Navbar, Footer
│   │   │   ├── sections/            # HeroSection, FeaturesShowcase, DownloadCenter
│   │   │   └── ui/                  # SideloadGuideModal, QR Generator, Badges
│   │   ├── core/constants/          # Metadata, Matte Dark tokens, typography
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

---

## 2. Horizon Web (`horizon-web`)

**Horizon Web** is crafted with an authentic, matte dark editorial aesthetic:

### Web Color System (Matte Dark Editorial)
- **Deep Matte Ground**: `#060608` with subtle vignette depth.
- **Tactile Matte Ivory Button**: Solid bone-ivory `#FAF8F5` with dark text `#060608`.
- **Understated Natural Accents**: Warm ember delta `#D97757`, muted sage comfort `#7E9F8E`, and muted slate clarity `#8898AA`.
- **Typography**: Crisp pure white headings (`#FFFFFF`) with soft neutral grey secondary text (`#9E9EA7`).

### Direct Multi-Platform Distribution
- **Android APK Direct Sideload**: Download APK directly or scan the dynamic QR code from your phone; includes SHA-256 verification and step-by-step sideload guide.
- **iOS PWA Walkthrough**: 3-step visual instruction for installing Horizon to the iOS Home Screen without App Store accounts.

---

## 3. Quality Gate & CI/CD

### Husky Git Hooks
The repository includes a pre-commit quality gate (`.husky/pre-commit`) that automatically verifies:
- `dart format --set-exit-if-changed lib test`
- `flutter analyze`
- `flutter test`
- `npm run typecheck` & `npm test` in `horizon-web/`

### GitHub Actions Pipeline
Continuous Integration is configured via `.github/workflows/ci.yml`:
- **Flutter Job**: Validates formatting, static analysis, unit tests with coverage, and builds verification APK.
- **Web Job**: Performs type checking, ESLint inspection, Vitest test execution, and production bundling.

---

## License

This project is open-source and available under the [MIT License](LICENSE).
