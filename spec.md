# Technical Specification: Horizon Weather App & Horizon Web

**Document Version:** 2.0.0  
**Status:** Approved / Active  
**Author:** Horizon Engineering & Design Team  
**Date:** September 2026  
**Repository:** `Sumant26/horizon-weather-app`  

---

## 1. Executive Summary & Design Vision

**Horizon** is a minimalist, high-contrast editorial weather intelligence ecosystem crafted for **human-first glanceability** over raw meteorological noise.

### Authentic Editorial Aesthetic
- **Zero AI Cliches**: No neon purple glows, rainbow gradient texts, or generic SaaS widgets.
- **Deep Matte Dark Palette**: Pure deep matte charcoal (`#060608`), elevated dark surfaces (`#0B0B0F`), and subtle hairline borders (`rgba(255, 255, 255, 0.07)`).
- **Tactile Ivory & Warm Ember**: High-contrast solid bone-ivory controls (`#FAF8F5`) and quiet natural temperature delta indicators (`#D97757`).
- **Quiet Typography**: Clean, confident typography with pure white headings and neutral slate secondary text.

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

## 3. Web Design System: Matte Dark Editorial Tokens

| Token | Hex / Value | Purpose |
|---|---|---|
| `--bg-dark` | `#060608` | Pure deep matte charcoal ground |
| `--bg-surface` | `#0B0B0F` | Elevated dark container surface |
| `--bg-card` | `#0E0E13` | Matte frosted glass card base |
| `--border-hairline` | `rgba(255, 255, 255, 0.07)` | Ultra-subtle hairline border |
| `--accent-ivory` | `#FAF8F5` | Solid bone-ivory tactile primary button & focal highlights |
| `--accent-ember` | `#D97757` | Quiet natural warm delta / heat indicator |
| `--accent-sage` | `#7E9F8E` | Quiet activity comfort window accent |
| `--accent-slate` | `#8898AA` | Quiet celestial night sky accent |
| `--text-primary` | `#FFFFFF` | Pure crisp white typography |
| `--text-secondary` | `#9E9EA7` | Editorial neutral grey |
| `--text-muted` | `#5C5C66` | Low-emphasis caption text |

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

---

## 5. Advanced Feature Specifications

### 5.1 In-Browser APK Integrity Verifier (Web Crypto API)
- **Zero Server Upload**: Direct client-side `crypto.subtle.digest('SHA-256', arrayBuffer)` execution inside the browser sandbox.
- **Interactive Dropzone**: Drag-and-drop or file selector accepting `.apk` packages.
- **Instant Match & Verification**: Computes 64-character hexadecimal hash in under 500ms and verifies character-for-character against official build metadata.

### 5.2 Dynamic GitHub Releases Sync
- **Live Endpoint**: Asynchronously queries `api.github.com/repos/Sumant26/horizon-weather-app/releases/latest`.
- **Dynamic Assets**: Automatically updates version badges, APK file sizes, published timestamps, and direct asset download URLs with graceful offline fallback.

### 5.3 Circadian Solar Theme Engine (Flutter)
- **Solar Phase Calculation**: Evaluates local solar time across 7 distinct circadian phases (`Misty Dawn`, `Solar Sunrise`, `Golden Morning`, `Solar Noon`, `Golden Hour`, `Twilight Dusk`, `Deep OLED Night`).
- **Dynamic Ambient Interpolation**: Blends smooth atmospheric background gradients according to real solar altitude while preserving high-contrast accessibility.

### 5.4 Quick Glance Widgets (Android & iOS)
- **Compact 2x2 Glance**: Immediate temperature reading, location title, and comparative delta indicator (`-2.8° Cooler`).
- **Wide 4x2 Dashboard**: Bioclimatic comfort corridor (`07:00 – 09:00 AM`), night sky clarity score, and minimal gear checklist.

