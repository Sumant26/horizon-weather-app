# Technical Specification: Horizon Weather App & Horizon Web

**Document Version:** 1.0.0  
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
- **Horizon Web (`horizon-web`)**: A high-performance React + TypeScript + Vite companion showcase, live preview client, and multi-channel distribution center.

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
|  - State: ValueNotifier + Sealed States  |                     |  - Multi-Platform Download Center        |
|  - Presentation: Procedural Gradient UI  |                     |  - Dynamic QR Code APK Sideload & SHA-256|
|  - Engine: Kinetic Typography System     |                     |  - iOS PWA Home Screen Installation      |
+------------------------------------------+                     +------------------------------------------+
```

### Directory Organization
```
horizon_weather_app/
├── lib/                             # Native Flutter Application
│   ├── core/                        # Cross-cutting concerns: themes, constants, utilities, loggers
│   │   ├── constants/               # Color tokens, typography scales, layout dimensions
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
│   │   │   ├── sections/            # HeroSection, FeaturesShowcase, DownloadCenter, Specs, FAQ
│   │   │   └── ui/                  # SideloadGuideModal, QR Generator, Badges
│   │   ├── core/constants/          # Metadata, color tokens, typography
│   │   ├── domain/                  # TypeScript interfaces and weather contracts
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

#### State Lifecycle Rules:
- **Zero Full-Tree Rebuilds**: Rebuild scopes are localized to `ValueListenableBuilder` nodes.
- **Predictable Transitions**: `Initial` $\to$ `Loading` $\to$ `Loaded` (or `Error`).
- **Resource Cleanup**: All controllers, timers, and notifiers are deterministically disposed of in the State widget lifecycle.

---

### 3.3 Dynamic Visual Engine & Kinetic Typography

#### Procedural Background Gradient Matrix
The screen background transitions smoothly over 700ms using `AnimatedContainer` mapped to `WeatherCondition`:

| Condition | Top Color | Bottom Color | Aesthetic Rationale |
|---|---|---|---|
| **Clear Day** | `#16161D` | `#0D0D11` | Deep warm charcoal with high-contrast amber glyphs |
| **Clear Night** | `#090D14` | `#141A24` | Midnight navy gradient evoking astronomical depth |
| **Rainy** | `#2C353F` | `#181F25` | Atmospheric storm grey with cool cyan accents |
| **Overcast** | `#2E3138` | `#1C1E22` | Muted flat slate minimizing visual glare |
| **Extreme Heat** | `#C85A32` | `#7A2A1E` | Ember red gradient highlighting thermal stress |

#### Kinetic Typography Rules
- The primary temperature number dynamically scales its `FontWeight` according to heat intensity:
  - $T \le 10^\circ\text{C} \implies \text{FontWeight.w300}$ (Light / Crisp)
  - $11^\circ\text{C} \le T \le 25^\circ\text{C} \implies \text{FontWeight.w500}$ (Regular / Balanced)
  - $26^\circ\text{C} \le T \le 34^\circ\text{C} \implies \text{FontWeight.w700}$ (Bold / Warm)
  - $T \ge 35^\circ\text{C} \implies \text{FontWeight.w900}$ (Ultra-heavy / Extreme Heat)

---

## 4. Detailed Specification: Horizon Web (`horizon-web`)

### 4.1 Purpose & Role
`horizon-web` is the web companion and multi-channel distribution portal for the Horizon ecosystem. It serves two distinct purposes:
1. **Interactive Editorial Showcase**: Demonstrates Horizon's design philosophy, dynamic gradients, and live simulated weather transitions directly in the browser.
2. **Unified Distribution Center**: Facilitates frictionless app distribution across Android, iOS, and Web without app store friction.

---

### 4.2 Web Architecture & Technology Stack

| Layer | Technology | Purpose |
|---|---|---|
| **Core Framework** | React 18 (`react`, `react-dom`) | Declarative component hierarchy |
| **Language** | TypeScript (`^5.3.3`) | Strict compile-time typing and contracts |
| **Build Tooling** | Vite (`^5.1.4`) | Lightning-fast HMR and optimized production chunks |
| **Iconography** | Lucide React (`^0.344.0`) | Clean, modern line icons matching mobile aesthetics |
| **QR Code Engine** | `qrcode` (`^1.5.3`) | Client-side dynamic QR generation for direct APK download |
| **Testing** | Vitest (`^1.3.1`) + JSDOM | Fast unit and component testing |
| **Styling** | Vanilla CSS Design System | Custom CSS variables, glassmorphism tokens, zero bloat |

---

### 4.3 Web Component Hierarchy & Layout

```
App
├── Navbar (Branding, Navigation Links, Release Badge, GitHub Link)
├── HeroSection (Editorial Headline, Dynamic Ambient Background, Feature Pills)
├── FeaturesShowcase (Glanceability, Window Planner, Gear Checklist, Night Sky Clarity)
├── DownloadCenter (Multi-Channel Distribution Hub)
│   ├── AndroidSideloadCard (APK Direct Download, Dynamic QR Code, Sideload Modal Trigger)
│   ├── IosPwaCard (Add to Home Screen 3-step walkthrough)
│   └── WebEditionCard (Browser Launcher & PWA link)
├── SideloadGuideModal (Step-by-Step Android Security & Installation Guide)
├── TechSpecsSection (Architecture specs, package sizes, cryptographic checksums)
├── FAQSection (Common inquiries regarding permissions, privacy, offline capabilities)
└── Footer (Release metadata, build number, copyright, repository links)
```

---

### 4.4 Multi-Channel Distribution Hub

#### 1. Android Direct APK Sideload
- Direct HTTPS download link pointing to `/downloads/horizon-release.apk`.
- **Dynamic QR Generator**: Renders a crisp SVG/Canvas QR code allowing mobile users to scan the screen and initiate download on Android devices.
- **SHA-256 Checksum Badge**: Displays cryptographic integrity hash (`a8f9c1e4d3b2...`) with one-click clipboard copying.
- **Sideload Guide Modal**: Comprehensive 4-step modal explaining *"Install unknown apps"*, package verification, and permissions.

#### 2. iOS Progressive Web App (PWA) Walkthrough
- Step-by-step visual instruction card:
  1. Open Safari on iOS.
  2. Tap the **Share** button in the toolbar.
  3. Select **"Add to Home Screen"** for full-screen standalone execution.

#### 3. Web Edition
- Instant launcher accessing the compiled web client (`http://127.0.0.1:8080/` or production domain).

---

## 5. Non-Functional Requirements (NFRs)

### 5.1 Performance & Framerate Targets
- **60 / 120 FPS Framerate**: All UI animations (color gradient transitions, state switches, modal slides) must maintain 60 or 120 FPS with zero dropped frames.
- **Cold Start Latency**: Flutter application cold launch to interactive display $\le 500\text{ms}$.
- **Web First Contentful Paint (FCP)**: $\le 0.8\text{s}$ on 4G networks; bundle size $\le 150\text{KB}$ gzipped.
- **Isolated Repainting**: All custom-painted elements must be enclosed in `RepaintBoundary` widgets.

### 5.2 Offline-First Strategy (Cache-Then-Network)
1. **Instant Snapshot Render**: On application boot, render the last-known cached `WeatherData` immediately from local storage.
2. **Background Refresh**: Dispatch an asynchronous remote query to update state without UI locking.
3. **Time-To-Live (TTL)**:
   - Data $< 30\text{ minutes}$ is treated as **Fresh**.
   - Data $\ge 30\text{ minutes}$ is treated as **Stale** (UI shows a subtle status indicator).
4. **Graceful Network Degradation**: If network requests fail, cached data remains active with a non-blocking error badge.

### 5.3 Security & Privacy Mandates
- **Zero API Key Leakage**: API tokens or client credentials must never be committed to Git. All configuration is injected via compile-time variables (`--dart-define`).
- **Cryptographic Checksums**: Web release downloads must publish verified SHA-256 integrity hashes.
- **Zero Tracker Policy**: Horizon does not collect user telemetry, advertising identifiers, or location histories.

### 5.4 Accessibility (a11y) & Responsiveness
- **WCAG AA Compliance**: High-contrast typography with minimum contrast ratio $\ge 4.5:1$ across all gradient states.
- **Dynamic Text Scaling**: Responsive layout containers that gracefully accommodate enlarged system accessibility fonts without clipping or overflow.
- **Touch Target Sizing**: Minimum interactive touch target area of $48 \times 48\text{ dp}$.

---

## 6. Verification & Quality Assurance Standards

### 6.1 Automated Testing Matrix

| Layer | Test Type | Tooling | Target Coverage |
|---|---|---|---|
| **Flutter Models** | Unit Tests | `flutter test` | 100% of computed domain getters |
| **Flutter State** | State Notifier Tests | `flutter test` | All sealed state transition sequences |
| **Flutter UI** | Widget Tests | `flutter test` | Gradients, layout responsiveness, error banners |
| **Horizon Web** | Unit & Component Tests | `vitest`, `@testing-library/react` | QR generator, Modal dialogs, theme constants |
| **Web Typing & Linting** | Static Analysis | `tsc --noEmit`, `eslint` | 0 errors, 0 warnings |

### 6.2 Pre-Commit Verification Workflow

Every commit and pull request must execute and pass the following automated verification suite:

```bash
# 1. Flutter Code Format Check
dart format --set-exit-if-changed .

# 2. Flutter Static Analysis (Strict 0 warning mandate)
flutter analyze

# 3. Flutter Test Suite
flutter test --coverage

# 4. Horizon Web Lint & Typecheck
cd horizon-web
npm run typecheck
npm run lint
npm test
```

---

## 7. Future Capability Roadmap

Refer to [AGENTS.md](AGENTS.md) Section 2 for complete expansion details:
1. **Live Open-Meteo REST API & Historical Delta Mapping**: Replacing mock repositories with live Open-Meteo queries and yesterday-delta archive calculations.
2. **Live GPS Geolocation & Multi-Location Paging**: Auto coordinate detection (`geolocator`), reverse geocoding (`geocoding`), and horizontal swiping across saved microclimates.
3. **Air Quality Index (AQI) Integration**: Real-time PM2.5, PM10, and Ozone metrics with actionable health insights.
4. **Celestial Sun/Moon Astronomical Path**: Interactive celestial arc depicting golden hour, blue hour, and lunar cycles.
5. **Atmospheric Canvas Particle Shaders**: Isolated `CustomPainter` layers for ambient rain streaks, mist, and night-sky star fields.
