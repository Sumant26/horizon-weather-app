# Technical Specification: Horizon Weather App & Horizon Web

**Document Version:** 1.1.0  
**Status:** Approved / Active  
**Author:** Horizon Engineering & Design Team  
**Date:** September 2026  
**Repository:** `Sumant26/horizon-weather-app`  

---

## 1. Executive Summary & System Overview

**Horizon** is a minimalist, high-contrast, editorial weather intelligence ecosystem designed to prioritize **human-first glanceability** over raw meteorological data overload. 

Rather than overwhelming the user with dense numerical tables and cluttered satellite radar layers, Horizon translates environmental conditions into actionable insights:
1. **Contextual Meaning**: Explaining what the weather *means* for the user's day.
2. **Relative Environmental Delta**: Comparing the current temperature directly against **yesterday at this exact hour**.
3. **Optimal Outdoor Windows**: Dynamically identifying the best 2-hour window for outdoor activities (running, cycling, stargazing, outdoor dining).
4. **Minimalist Gear Checklist**: Context-aware recommendations for essential items (sunglasses, jacket, umbrella).
5. **Night Sky Clarity Index**: Real-time atmospheric transparency metrics for stargazing.

The ecosystem comprises two primary deliverables:
- **Horizon Mobile App**: A native, zero-dependency Flutter application built for Android and iOS.
- **Horizon Web (`horizon-web`)**: A high-performance React + TypeScript + Vite companion showcase and distribution center for Android APK sideloading and iOS PWA installation.

---

## 2. Monorepo Topology & High-Level Architecture

```
                                  +---------------------------------------+
                                  |            External APIs              |
                                  |  - Open-Meteo (Forecast & Archive)    |
                                  |  - GPS / Reverse Geocoding            |
                                  +-------------------+-------------------+
                                                      |
                                    HTTPS JSON Data   |
                                                      v
                     +--------------------------------+--------------------------------+
                     |                                                                 |
                     v                                                                 v
+------------------------------------------+                     +------------------------------------------+
|       Horizon Mobile Client (Flutter)    |                     |        Horizon Web Companion (React)     |
|                                          |                     |                                          |
|  - Domain: Business Models & Rules       |                     |  - Showcase & Live Interactive Preview   |
|  - State: ValueNotifier + Sealed States  |                     |  - Direct Distribution Center            |
|  - Presentation: Procedural Gradient UI  |                     |  - Dynamic QR Code APK Sideload & SHA-256|
|  - Engine: Kinetic Typography System     |                     |  - iOS PWA Home Screen Installation Guide|
+------------------------------------------+                     +------------------------------------------+
                                    \                                                 /
                                     \                                               /
                                      +----------------------+----------------------+
                                                             |
                                                             v
                                              +------------------------------+
                                              |       CI/CD & Git Hooks      |
                                              |  - Husky Pre-Commit Gates    |
                                              |  - GitHub Actions Workflows  |
                                              +------------------------------+
```

### Directory Organization
```
horizon_weather_app/
├── .github/
│   └── workflows/
│       ├── ci.yml                   # Unified GitHub Actions CI Pipeline
│       └── deploy-web.yml           # Web Build & Package Pipeline
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

## 3. Detailed Specification: Horizon Mobile App (Flutter)

### 3.1 Domain Model & Computed Attributes

The core business model (`WeatherData`) encapsulates raw atmospheric inputs and exposes computed getters that encapsulate presentation logic.

```dart
enum WeatherCondition {
  clearDay,
  clearNight,
  rainy,
  overcast,
  extremeHeat,
}

class WeatherData {
  final double temperature;               // Current temp in °C
  final double tempDifferenceYesterday;   // Delta vs. yesterday (+2.3°C, -1.1°C)
  final int humidity;                     // Relative humidity percentage (0-100)
  final double windSpeed;                 // Wind speed in km/h
  final int uvIndex;                      // UV Index (0-12+)
  final int cloudCover;                   // Cloud cover percentage (0-100)
  final String location;                  // Formatted location string (e.g., "Kyoto, Japan")
  final WeatherCondition condition;       // Primary environmental condition
  final DateTime timestamp;               // Timestamp of the observation
}
```

#### Computed Domain Algorithms:

1. **Human-First Summary (`humanSummary`)**:
   - Synthesizes temperature, conditions, and yesterday's delta into an editorial, conversational paragraph.
   - Example output: *"It's a comfortable, bright day. About 2.3°C warmer than yesterday at this exact hour."*

2. **Optimal Outdoor Window Planner (`optimalActivityWindow`)**:
   - Evaluates temperature thresholds ($18^\circ\text{C} \le T \le 25^\circ\text{C}$), humidity ($H < 65\%$), and rain probability.
   - Computes the green 2-hour window in the diurnal cycle:
     - Morning window (07:00 – 09:00) during hot summer cycles.
     - Afternoon/Evening window (17:30 – 19:30) during mild cycles.
     - Night window (21:00 – 23:00) for stargazing.

3. **Contextual Gear Checklist (`recommendedGear`)**:
   - Generates minimal packing recommendations based on boolean trigger rules:
     - $\text{UV} \ge 6 \implies \text{"Sunglasses (High UV Index)"}$
     - $T \ge 30^\circ\text{C} \implies \text{"Hydration Pack / Water Bottle"}$
     - $T \le 18^\circ\text{C} \implies \text{"Light Layer / Windbreaker"}$
     - $\text{Condition} == \text{Rainy} \implies \text{"Compact Umbrella"}$

4. **Night Sky Clarity Index (`nightSkyClarity`)**:
   - Activated only between 20:00 and 05:00.
   - Clarity Score $S = 100 - (0.7 \times \text{cloudCover} + 0.3 \times \text{humidity})$.
   - Score $\ge 80 \implies \text{"Excellent (High atmospheric transparency)"}$
   - Score $\ge 50 \implies \text{"Moderate (Partial haze / scattered clouds)"}$
   - Score $< 50 \implies \text{"Poor (Overcast or high humidity haze)"}$

---

### 3.2 State Management Architecture

Horizon uses an explicit **Sealed Class State Pattern** managed via `ValueNotifier<WeatherState>`:

```dart
sealed class WeatherState {
  const WeatherState();
}

final class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

final class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

final class WeatherLoaded extends WeatherState {
  final WeatherData data;
  final bool isFromCache;
  const WeatherLoaded(this.data, {this.isFromCache = false});
}

final class WeatherError extends WeatherState {
  final String message;
  const WeatherError(this.message);
}
```

---

### 3.3 Dynamic Visual Engine & Kinetic Typography

#### Procedural Background Gradient Matrix
The screen background transitions smoothly over 700ms using `AnimatedContainer` mapped to `WeatherCondition`:

| Condition | Top Color | Bottom Color | Aesthetic Rationale |
|---|---|---|---|
| **Clear Day** | `#382315` | `#140D09` | Warm honey-amber dusk fading to deep roasted espresso |
| **Clear Night** | `#0F1B2E` | `#060910` | Midnight celestial indigo fading to velvet obsidian |
| **Rainy** | `#1B2B38` | `#0B1015` | Atmospheric slate teal fading to flannel charcoal |
| **Overcast** | `#282E37` | `#101317` | Muted heather mist fading to flannel grey |
| **Extreme Heat** | `#4D2012` | `#180A06` | Terracotta hearth fading to rich amber obsidian |

#### Kinetic Typography Rules
- The primary temperature number dynamically scales its `FontWeight` according to heat intensity:
  - $T \le 10^\circ\text{C} \implies \text{FontWeight.w300}$ (Light / Crisp)
  - $11^\circ\text{C} \le T \le 25^\circ\text{C} \implies \text{FontWeight.w500}$ (Regular / Balanced)
  - $26^\circ\text{C} \le T \le 34^\circ\text{C} \implies \text{FontWeight.w700}$ (Bold / Warm)
  - $T \ge 35^\circ\text{C} \implies \text{FontWeight.w900}$ (Ultra-heavy / Extreme Heat)

---

## 4. Detailed Specification: Horizon Web (`horizon-web`)

### 4.1 Purpose & Role
`horizon-web` is the dark, editorial web companion and multi-platform distribution center for the Horizon ecosystem:
1. **Interactive Editorial Showcase**: Demonstrates Horizon's design philosophy, high-contrast dark theme, and live glanceable preview.
2. **Direct App Distribution**: Frictionless installation pathways for Android APK sideloading (with dynamic QR code generator & SHA-256 verification) and iOS PWA Home Screen installation.

---

### 4.2 Deep Dark Theme & Color System

| Token | Hex / Value | Description |
|---|---|---|
| `--bg-dark` | `#080B11` | Deep midnight velvet obsidian background |
| `--bg-surface` | `#0E131E` | High-contrast dark container surface |
| `--bg-card` | `#131A28` | Translucent glassmorphic card base |
| `--bg-glass` | `rgba(19, 26, 40, 0.78)` | Backdrop-filtered blurred glass |
| `--border-glass` | `rgba(246, 173, 85, 0.15)` | Honey-gold ambient border |
| `--accent-gold` | `#F6AD55` | Warm honey-gold accent (`AppColors.honeyGold`) |
| `--accent-peach` | `#ED8936` | Warm terracotta accent (`AppColors.warmTerracotta`) |
| `--accent-sage` | `#9AE6B4` | Ambient sage comfort accent (`AppColors.warmSage`) |
| `--accent-cyan` | `#81E6D9` | Twilight cyan celestial accent (`AppColors.twilightCyan`) |
| `--text-primary` | `#FAF6F0` | Warm ivory soft linen typography (`AppColors.softLinen`) |
| `--text-secondary` | `#C4B5A5` | Warm muted stone secondary text |
| `--text-muted` | `#8C7A6B` | Warm soft slate text |

---

### 4.3 Web Component Hierarchy

```
App
├── Navbar (Branding, Philosophy Link, Download Link, GitHub Source Link)
├── HeroSection (Editorial Headline, Ambient Atmosphere, 3 Glanceable Metric Cards, Live Mockup)
├── FeaturesShowcase (4 Essential Design Pillars: Delta, Window, Gear, Night Sky)
├── DownloadCenter (Direct Distribution Hub)
│   ├── AndroidSideloadCard (Direct APK Download, Dynamic QR Code, Sideload Guide Modal, SHA-256)
│   └── IosPwaCard (3-step Add to Home Screen visual walkthrough)
├── SideloadGuideModal (Step-by-Step Android Unknown App Installation Guide)
└── Footer (Branding, Zero Tracking & Engine badges, Ecosystem Links, Copyright)
```

---

## 5. Quality Gate: Git Hooks & CI/CD Pipelines

### 5.1 Husky Pre-Commit Hook (`.husky/pre-commit`)
Every local commit triggers an automated pre-commit hook that verifies:
1. `dart format --set-exit-if-changed .` (Dart formatting)
2. `flutter analyze` (Zero error & zero warning static analysis)
3. `flutter test` (Full Flutter automated test suite)
4. `npm run typecheck` in `horizon-web/` (TypeScript static analysis)
5. `npm test` in `horizon-web/` (Vitest test suite)

### 5.2 GitHub Actions CI Pipeline (`.github/workflows/ci.yml`)
Automated verification on every pull request and push to `main`:
- **Flutter Verification Job**:
  - Sets up Java 17 and Flutter stable.
  - Verifies formatting, runs `flutter analyze` and `flutter test --coverage`.
  - Builds release APK to guarantee release compilability.
- **Web Verification Job**:
  - Sets up Node.js 20 with cached npm dependencies.
  - Runs `npm ci`, `npm run typecheck`, `npm run lint`, `npm test`, and `npm run build`.
  - Archives and uploads production distribution bundle.

---

## 6. Non-Functional Requirements (NFRs)

### 6.1 Performance & Framerate Targets
- **60 / 120 FPS Framerate**: All UI animations and background color transitions maintain a steady 60/120 FPS.
- **Cold Start Latency**: Mobile launch to interactive display $\le 500\text{ms}$.
- **Web First Contentful Paint (FCP)**: $\le 0.8\text{s}$ on standard connections; gzipped bundle size $\le 150\text{KB}$.

### 6.2 Offline-First Strategy (Cache-Then-Network)
1. **Instant Cold Launch**: Immediate rendering of the last-known cached `WeatherData` from local storage.
2. **Background Refresh**: Asynchronous remote query to update state without UI blocking.
3. **Time-To-Live (TTL)**:
   - Data $< 30\text{ minutes}$ is treated as **Fresh**.
   - Data $\ge 30\text{ minutes}$ is treated as **Stale** (UI shows a subtle status indicator).

### 6.3 Security & Privacy Mandates
- **Zero API Secret Commits**: Sensitive credentials are never committed to version control.
- **Cryptographic Verification**: Published APK releases include verified SHA-256 integrity hashes.
- **Zero Tracker Policy**: No telemetry, analytics trackers, or location history logging.
