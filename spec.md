# Technical Specification: Horizon Weather App & Horizon Web

**Document Version:** 1.2.0  
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
- **Horizon Web (`horizon-web`)**: A high-performance React + TypeScript + Vite companion showcase and distribution center styled with a cozy, calming **Twilight Heather** aesthetic.

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

---

## 3. Web Design System: Twilight Heather Aesthetic

| Token | Hex / Value | Description |
|---|---|---|
| `--bg-dark` | `#080A12` | Deep midnight celestial obsidian background |
| `--bg-surface` | `#0F1322` | Twilight dark container surface |
| `--bg-card` | `#14182C` | Deep celestial glass card base |
| `--bg-glass` | `rgba(20, 24, 44, 0.78)` | Translucent twilight glass backdrop |
| `--border-glass` | `rgba(167, 139, 250, 0.16)` | Subtle heather lavender border |
| `--accent-lavender` | `#A78BFA` | Primary calming heather lavender accent |
| `--accent-lavender-light` | `#C4B5FD` | Luminous twilight highlight |
| `--accent-violet` | `#8B5CF6` | Deep twilight violet |
| `--accent-cyan` | `#81E6D9` | Starry twilight cyan for celestial clarity |
| `--text-primary` | `#FAF6F0` | Warm ivory soft linen typography |
| `--text-secondary` | `#B4BED2` | Twilight muted slate secondary text |
| `--text-muted` | `#74819B` | Celestial muted tone |

---

## 4. Quality Gate & CI/CD Pipelines

### 4.1 Husky Pre-Commit Hook (`.husky/pre-commit`)
Every local commit verifies:
1. `dart format --set-exit-if-changed lib test`
2. `flutter analyze`
3. `flutter test`
4. `npm run typecheck` in `horizon-web/`
5. `npm test` in `horizon-web/`

### 4.2 GitHub Actions CI Pipeline (`.github/workflows/ci.yml`)
Automated verification on every pull request and push to `main`:
- **Flutter Verification Job**: Runs `dart format` on `lib/` and `test/`, static analysis, unit test coverage, and builds verification APK.
- **Web Verification Job**: Runs `npm ci`, typecheck, lint, Vitest tests, and Vite production bundle compilation.
