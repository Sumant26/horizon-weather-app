# AI Agent & Developer Guidelines: Horizon Weather

This document establishes the project overview, current architectural baseline, engineering standards, feature evolution roadmap, testing discipline, security mandates, and operational protocols for any AI Agent or human engineer contributing to the **Horizon** codebase.

---

## 1. Project Context & Current Baseline

### 1.1 Core Concept
**Horizon** is a minimalist, high-contrast, editorial weather application focused on **human-first glanceability** (temperature relative to yesterday, optimal outdoor activity windows, night-sky clarity, and minimalist gear recommendations).

### 1.2 Current Architecture & Structure
* **Model** (`lib/data/models/weather_model.dart`): Contains `WeatherData` and domain logic getters (`humanSummary`, `optimalActivityWindow`, `recommendedGear`, `nightSkyClarity`).
* **Repository** (`lib/data/repositories/weather_repository.dart`): Mock repository generating localized, randomized simulated weather data.
* **State** (`lib/presentation/state/weather_provider.dart`): `ValueNotifier<WeatherState>` pattern modeling explicit sealed states (`WeatherLoading`, `WeatherError`, `WeatherLoaded`).
* **UI** (`lib/presentation/screens/home_screen.dart`): Single-screen scrollable layout featuring dynamic background gradients matched to environmental conditions and kinetic typography.
* **Dependencies** (`pubspec.yaml`): Standard Flutter SDK only (no external packages yet).

---

## 2. Feature Evolution Roadmap & Planned Capabilities

### A. Real Data & Live Integrations
1. **Live Weather & Historical API Integration**:
   - Integrate **Open-Meteo** (free, open-source, no API key required, high precision) or WeatherAPI / OpenWeatherMap.
   - Query historical archive data for the exact hour yesterday to compute real dynamic `tempDifferenceYesterday` metrics.
2. **Live Geolocation & Multi-Location Support**:
   - Auto-detect GPS coordinates with `geolocator` and reverse-geocode neighborhood names via `geocoding`.
   - Search, bookmark, and swipe across multiple microclimate locations in horizontal paging views.
3. **Air Quality Index (AQI) & UV Index**:
   - Render real-time AQI metrics (PM2.5, PM10, Ozone) with actionable health recommendations (e.g., *"Crisp air: great for running"*, *"Sensitive groups: limit prolonged outdoor exertion"*).

### B. UI/UX & Visual Polish (Elevating Minimalist Aesthetics)
1. **Hourly Timeline & 7-Day Forecast Spectrum**:
   - Scrubbable horizontal 24-hour microclimate strip showing precipitation probabilities and temperature curves.
   - Minimalist 7-day compact forecast with high/low temperature spectrum gradient bars.
2. **Celestial Sun & Moon Astronomical Path**:
   - Dynamic celestial arc depicting the live position of the Sun/Moon, Sunrise/Sunset times, Golden Hour, Blue Hour, and Lunar phases.
3. **Subtle Atmospheric Canvas Effects**:
   - Soft, non-distracting background particles (gentle mist, fine rain drops, clear night star field shimmer) using `CustomPainter` with isolated repainting.
4. **Interactive Weather Radar & Wind Map**:
   - Minimalist monochrome precipitation radar and animated wind vector layers.

### C. Smart & "Human-First" Features
1. **Custom Activity Profiles ("Optimal Windows")**:
   - Allow users to select favorite outdoor activities (*Running, Cycling, Stargazing, Outdoor Dining, Photography*).
   - Dynamically compute and highlight the green 2-hour window in the day tailored to that activity.
2. **Interactive Gear & Packing Checklist**:
   - Checkable items (*Umbrella, Sunglasses, Windbreaker, Hydration pack*) that remember user preferences across sessions.
3. **Smart Push Notifications & Morning Briefings**:
   - Rain onset alerts (*"Rain expected at your location in 20 minutes"*).
   - Morning glanceable briefing summary comparing today's trend against yesterday.

### D. Code Quality & Architectural Enhancements
1. **Modular Widget Decomposition**:
   - Break down `home_screen.dart` into isolated, reusable presentation components (`KineticTemperatureWidget`, `GlanceableInsightCard`, `ActivityWindowSection`, `GearChecklistWrap`).
2. **Offline Caching & Instant Cold Launch**:
   - Persist last-known weather snapshot locally for instantaneous cold launches and zero-network resilience.
3. **Settings & Units System**:
   - Dynamic unit conversions: Metric (°C, km/h, mm) vs. Imperial (°F, mph, in).
   - Visual theme variants: *Deep OLED Black, Slate Minimalist, Frosted Glass*.

---

## 3. Architectural Principles & Clean Layering

Horizon strictly adheres to **Clean Architecture** principles separated into four distinct, isolated layers:

```
lib/
├── core/                  # Cross-cutting concerns: themes, constants, network clients, error models, logger
├── data/
│   ├── datasources/       # Remote (APIs) and local (cache/database) data providers
│   ├── models/            # DTOs, JSON serialization, and raw mapping logic
│   └── repositories/      # Concrete implementations of domain repository interfaces
├── domain/
│   ├── entities/          # Pure business models and immutable state
│   ├── repositories/      # Abstract repository interfaces (contracts)
│   └── usecases/          # Granular business logic / application rules
└── presentation/
    ├── components/        # Isolated, reusable, highly modular atomic widgets
    ├── screens/           # Compositional screen layouts (< 200 lines)
    └── state/             # State holders, notifiers, controllers, or view-models
```

### Key Architectural Rules:
- **Dependency Inversion**: Dependencies only point inwards towards the domain layer. The `domain` layer must have zero Flutter/UI dependencies and zero knowledge of `data` or `presentation`.
- **Interface Segregation**: Repositories in `data/` must implement abstract repository interfaces defined in `domain/`.
- **Single Responsibility Principle (SRP)**: UI widgets must solely focus on layout and presentation. No direct API calls, complex transforms, or I/O within widgets.

---

## 4. Efficient State Management Standards

- **Immutability First**: All state models must be immutable (`@immutable`, sealed classes, or records).
- **Explicit Sealed State Pattern**: Every asynchronous state must exhaustively model initial, loading, loaded/success, and failure states:
  ```dart
  sealed class WeatherState { const WeatherState(); }
  class WeatherInitial extends WeatherState { const WeatherInitial(); }
  class WeatherLoading extends WeatherState { const WeatherLoading(); }
  class WeatherLoaded extends WeatherState { 
    final WeatherEntity data; 
    final bool isFromCache;
    const WeatherLoaded(this.data, {this.isFromCache = false}); 
  }
  class WeatherFailure extends WeatherState { 
    final Failure failure; 
    const WeatherFailure(this.failure); 
  }
  ```
- **Predictable State Containers**: State containers (`ValueNotifier`, `Riverpod`, `Bloc`) must be easily testable and decoupled from UI lifecycles.
- **Granular Rebuild Scopes**: Never trigger full-tree rebuilds for localized state updates. Use selectors, builder widgets (`ValueListenableBuilder`), or dedicated listener components.

---

## 5. Best Practices & Code Quality

- **Strict Static Analysis**: The codebase must continuously pass `flutter analyze` with **0 errors and 0 warnings**.
- **`const` Discipline**: Use `const` constructors aggressively on widgets and models to minimize garbage collection cycles and leverage widget tree caching.
- **Modularity & Atomic Structure**: Screen files must remain concise (< 200 lines). Break down complex visuals into isolated widgets under `presentation/components/`.
- **Deterministic Resource Disposal**: All `StreamSubscription`, `TextEditingController`, `AnimationController`, `Timer`, and `ChangeNotifier` instances must be deterministically cancelled or disposed of in `dispose()`.
- **Zero Magic Values**: Centralize all padding, dimensions, durations, colors, typography styles, and API endpoints into dedicated constants (`core/constants/` or theme tokens).

---

## 6. Comprehensive Error Handling

- **No Silent Failures**: Never write empty `catch` blocks (`catch (e) {}`). All caught exceptions must be logged and mapped to a domain-level `Failure`.
- **Domain Failure Hierarchy**:
  ```dart
  sealed class Failure {
    final String message;
    const Failure(this.message);
  }
  class NetworkFailure extends Failure { const NetworkFailure([super.message = "No internet connection."]); }
  class ServerFailure extends Failure { const ServerFailure([super.message = "Weather service temporarily unavailable."]); }
  class LocationPermissionFailure extends Failure { const LocationPermissionFailure([super.message = "Location permission denied."]); }
  class CacheFailure extends Failure { const CacheFailure([super.message = "No cached weather data found."]); }
  ```
- **User-Centric Feedback**: Provide non-blocking, actionable feedback (e.g., retry buttons, offline cache indicators, snackbars) rather than blank screens or raw exception traces.
- **Defensive Null-Safety**: Eliminate unnecessary force-unwrapping (`!`). Favor pattern matching, early guards, and null-coalescing defaults.

---

## 7. Structured Error Logging & Observability

- **Unified Logger**: Route all application logs through `core/utils/app_logger.dart` instead of unstructured `print()` or `debugPrint()`.
- **Log Levels & Filtering**:
  - `debug` / `verbose`: Microstate transitions and sanitized API payloads.
  - `info`: Key user milestones (e.g., GPS resolved, cache updated).
  - `warning`: Recoverable degradations (e.g., remote fetch failed; falling back to offline cache).
  - `error`: Uncaught exceptions, network pipeline crashes, with full stack traces.
- **Environment Gating**: Debug and verbose logs must be completely muted in production/release builds (`kReleaseMode`).
- **Telemetry Ready**: Log output pipelines must allow plug-and-play forwarding to remote crash reporting services (Sentry, Firebase Crashlytics).

---

## 8. Offline-First & Cache Strategy (Cache-Then-Network)

- **Instant Cold Launch**: On app startup, immediately load and render the most recent cached weather snapshot from local storage (`shared_preferences`, `hive`, or `sqlite`) before initiating network requests.
- **Background Synchronization**: Initiate an asynchronous background refresh to fetch fresh data seamlessly without jarring layout shifts.
- **Time-To-Live (TTL) Validation**:
  - Data younger than TTL (e.g., 30 minutes) is considered **Fresh**.
  - Data older than TTL is marked as **Stale** (UI shows subtle "Updated X min ago" badge).
- **Graceful Network Degradation**: If network requests fail due to connectivity loss or server downtime, preserve the cached data on screen and display a gentle offline indicator.

---

## 9. Performance & Frame Rate Targets (60 / 120 FPS)

- **Steady 60/120 FPS Target**: Horizon animations, transitions, and scroll physics must maintain a steady frame rate with zero jank or dropped frames.
- **Zero Heavy Computations in `build()`**:
  - `build()` methods must be purely declarative.
  - Pre-compute derived values (e.g., optimal activity windows, temperature deltas, sky clarity) in models or notifiers.
- **`RepaintBoundary` for Canvas & Dynamic Graphics**:
  - Wrap custom-painted graphics (e.g., kinetic temperature shaders, rain particle effects, celestial arcs) with `RepaintBoundary` to isolate repaint regions from the rest of the widget tree.
- **List & Scroll Optimization**: Use `ListView.builder` or `CustomScrollView` with slivers for dynamic lists to ensure items are lazily created and recycled.

---

## 10. Security & Configuration Management

- **Zero Secret Commits**: Never commit private API keys, client secrets, or sensitive configuration tokens to version control.
- **Environment Variable Injection**:
  - Inject API keys and endpoints at compile time using `--dart-define` or `--dart-define-from-file=.env`.
  - Maintain an `.env.example` template with dummy placeholders in the repository.
  - Ensure `.env`, `*.local`, and generated credential files are strictly listed in `.gitignore`.
- **Safe Network Transport**: All external HTTP requests must use TLS/HTTPS with timeout guards (e.g., 10-second connection timeout).

---

## 11. UI/UX, Responsiveness & Accessibility

- **Adaptive Layouts**: Ensure fluid responsive rendering across varying screen dimensions (compact smartphones, foldables, tablets) using `LayoutBuilder` and flexible widgets.
- **Safe Area & System UI**: Strictly encapsulate primary layouts in `SafeArea`. Dynamically adjust system navigation bar and status bar contrast (`SystemChrome.setSystemUIOverlayStyle`).
- **Dynamic Text Scaling & Accessibility**:
  - Support user-configured accessibility text scaling without visual overflow or clipping (`TextOverflow.ellipsis`, scalable containers).
  - Provide adequate touch target sizes (minimum 48x48 dp) for all interactive controls.
  - Maintain high color contrast ratios meeting WCAG AA standards for optimal outdoor readability.

---

## 12. Conventional Commits Standard

All git commits, pull requests, and branch names must follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

### Format:
`<type>(<optional scope>): <description>`

### Types:
- `feat:` A new user-facing feature or capability (e.g., `feat(weather): add open-meteo historical comparison`).
- `fix:` A bug fix (e.g., `fix(astronomy): resolve sky clarity calculation at dusk`).
- `perf:` A code change that improves performance (e.g., `perf(render): wrap particle canvas in repaint boundary`).
- `refactor:` A code change that neither fixes a bug nor adds a feature (e.g., `refactor(state): decompose weather notifier into isolated usecases`).
- `test:` Adding missing tests or correcting existing tests (e.g., `test(models): add unit tests for optimal window getter`).
- `docs:` Documentation only changes (e.g., `docs: update agents and architecture roadmap`).
- `chore:` Maintenance tasks, dependency bumps, tooling updates (e.g., `chore(deps): bump flutter lints to 3.0.0`).

---

## 13. Testing Discipline & Coverage

Every feature, utility, and state transition must be accompanied by comprehensive automated tests before integration.

### Test Structure:
1. **Unit Tests (`test/unit/`)**:
   - **Models & Calculations**: 100% coverage for computed getters (`humanSummary`, `optimalActivityWindow`, `recommendedGear`, `nightSkyClarity`).
   - **Repositories**: Mock data sources to verify JSON parsing, network mapping, error translation, and cache fallback.
   - **Use Cases**: Test business logic permutations under both success and failure states.
2. **State & Notifier Tests (`test/presentation/state/`)**:
   - Verify initial state, sequential loading transitions, successful state emissions, and error states.
3. **Widget & Component Tests (`test/presentation/components/`)**:
   - Test UI rendering across states (loading spinner, error banner, loaded content).
   - Test user interactions (pull-to-refresh gestures, retry taps, scroll performance).

### Test Quality Guidelines:
- Adhere strictly to the **Arrange-Act-Assert (AAA)** pattern.
- Mock all external network, device sensors, and filesystem boundaries.
- Tests must execute fast, deterministically, and without dependency on real network connections or device clocks.

---

## 14. Mandatory Pre-Commit & Verification Workflow

**Before committing, pushing, or creating a Pull Request, you MUST run and pass all verification checks locally:**

```bash
# 1. Format code according to official Dart conventions
dart format --set-exit-if-changed .

# 2. Run static analysis (must report zero errors and zero warnings)
flutter analyze

# 3. Run the full test suite with coverage
flutter test --coverage
```

> **Strict Rule for Agents**: If any test fails or `flutter analyze` reports any warning or error, **DO NOT** mark the task as complete or commit code. Diagnose and resolve the root cause immediately.
