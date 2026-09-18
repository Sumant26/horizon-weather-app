import 'package:flutter/material.dart';
import '../../core/audio/procedural_soundscape_player.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/weather_condition.dart';
import '../components/activity_window_selector.dart';
import '../components/air_quality_card.dart';
import '../components/atmospheric_canvas.dart';
import '../components/biophilic_health_card.dart';
import '../components/card_detail_modal.dart';
import '../components/celestial_path_widget.dart';
import '../components/daily_briefing_card.dart';
import '../components/deep_meteorology_card.dart';
import '../components/gear_checklist_sheet.dart';
import '../components/hourly_forecast_strip.dart';
import '../components/journey_simulator_card.dart';
import '../components/kinetic_temperature.dart';
import '../components/location_page_indicator.dart';
import '../components/location_search_modal.dart';
import '../components/minute_precipitation_card.dart';
import '../components/proactive_notifications_modal.dart';
import '../components/saved_locations_drawer.dart';
import '../components/seven_day_forecast_card.dart';
import '../components/share_story_modal.dart';
import '../components/soundscape_player_modal.dart';
import '../components/thermal_comfort_card.dart';
import '../components/weather_alert_banner.dart';
import '../components/weather_header.dart';
import '../components/weather_radar_card.dart';
import '../components/yesterday_comparison_chart.dart';
import '../screens/settings_sheet.dart';
import '../state/location_provider.dart';
import '../state/settings_provider.dart';
import '../state/weather_provider.dart';
import '../utils/card_detail_factory.dart';

class WeatherHomeScreen extends StatefulWidget {
  final WeatherNotifier weatherNotifier;
  final LocationNotifier locationNotifier;
  final SettingsNotifier settingsNotifier;

  const WeatherHomeScreen({
    super.key,
    required this.weatherNotifier,
    required this.locationNotifier,
    required this.settingsNotifier,
  });

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: widget.locationNotifier.value.activeIndex);
    widget.locationNotifier.addListener(_onLocationChanged);
    _loadCurrentWeather();
  }

  @override
  void dispose() {
    _pageController.dispose();
    widget.locationNotifier.removeListener(_onLocationChanged);
    super.dispose();
  }

  void _onLocationChanged() {
    final activeIndex = widget.locationNotifier.value.activeIndex;
    if (_pageController.hasClients &&
        _pageController.page?.round() != activeIndex) {
      _pageController.animateToPage(
        activeIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
    final activeLoc = widget.locationNotifier.value.activeLocation;
    widget.weatherNotifier.fetchWeatherForLocation(activeLoc);
  }

  void _loadCurrentWeather({bool forceRefresh = false}) {
    final activeLoc = widget.locationNotifier.value.activeLocation;
    widget.weatherNotifier
        .fetchWeatherForLocation(activeLoc, forceRefresh: forceRefresh);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.weatherNotifier,
        widget.settingsNotifier,
        widget.locationNotifier
      ]),
      builder: (context, _) {
        final weatherState = widget.weatherNotifier.value;
        final settings = widget.settingsNotifier.value;
        final locationState = widget.locationNotifier.value;

        final WeatherCondition? activeCondition = switch (weatherState) {
          WeatherLoaded(:final data) => data.condition,
          WeatherLoading(:final previousData) => previousData?.condition,
          _ => null,
        };

        if (weatherState is WeatherLoaded) {
          final isNightTime = weatherState.data.condition ==
                  WeatherCondition.clearNight ||
              weatherState.data.condition == WeatherCondition.partlyCloudyNight;
          ProceduralSoundscapePlayer.instance.syncWithCondition(
            weatherState.data.condition.displayName,
            isNightTime,
          );
        }

        return HorizonTheme(
          mode: settings.themeMode,
          child: Scaffold(
            body: AtmosphericCanvasBackground(
              condition: activeCondition,
              themeMode: settings.themeMode,
              child: SafeArea(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: switch (weatherState) {
                    WeatherInitial() ||
                    WeatherLoading(previousData: null) =>
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.softAmber,
                          strokeWidth: 2,
                        ),
                      ),
                    WeatherLoading(:final previousData?) => _buildLoadedContent(
                        context,
                        WeatherLoaded(
                          data: previousData,
                          isFromCache: true,
                          activityWindow: const ActivityWindowResult(
                            activity: OutdoorActivity.walking,
                            timeRange: 'Evaluating...',
                            reasoning: 'Refreshing microclimate node...',
                            comfortScore: 85,
                          ),
                        ),
                        settings.temperatureUnit,
                        locationState,
                      ),
                    WeatherErrorState(:final failure, :final cachedData) =>
                      cachedData != null
                          ? _buildLoadedContent(
                              context,
                              WeatherLoaded(
                                data: cachedData,
                                isFromCache: true,
                                activityWindow: const ActivityWindowResult(
                                  activity: OutdoorActivity.walking,
                                  timeRange: 'Cached Window',
                                  reasoning: 'Displaying offline snapshot.',
                                  comfortScore: 80,
                                ),
                              ),
                              settings.temperatureUnit,
                              locationState,
                            )
                          : _buildErrorView(context, failure.message),
                    WeatherLoaded() => _buildLoadedContent(context,
                        weatherState, settings.temperatureUnit, locationState),
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadedContent(
    BuildContext context,
    WeatherLoaded state,
    dynamic tempUnit,
    LocationState locationState,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580),
        child: PageView.builder(
          controller: _pageController,
          itemCount: locationState.savedLocations.length,
          onPageChanged: (idx) {
            if (locationState.activeIndex != idx) {
              widget.locationNotifier.setActiveLocation(idx);
            }
          },
          itemBuilder: (context, index) {
            return _buildLocationView(context, state, tempUnit, locationState);
          },
        ),
      ),
    );
  }

  Widget _buildLocationView(
    BuildContext context,
    WeatherLoaded state,
    dynamic tempUnit,
    LocationState locationState,
  ) {
    final data = state.data;

    return RefreshIndicator(
      onRefresh: () =>
          Future.sync(() => _loadCurrentWeather(forceRefresh: true)),
      color: AppColors.softAmber,
      backgroundColor: Colors.black54,
      elevation: 0,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        children: [
          // 1. Severe Weather Alert Banner (if active)
          WeatherAlertBanner(alerts: data.weatherAlerts),

          // 2. Header: Node Locality, Cache Indicator, Search, Settings & Share
          WeatherHeader(
            location: data.location,
            isFromCache: state.isFromCache,
            timestamp: data.timestamp,
            activeTriggerCount: data.smartTriggers.activeTriggerCount,
            onOpenLocationSearch: () =>
                LocationSearchModal.show(context, widget.locationNotifier),
            onOpenSavedLocations: () => SavedLocationsDrawer.show(context,
                locationNotifier: widget.locationNotifier),
            onOpenSoundscape: () => SoundscapePlayerModal.show(context),
            onOpenSettings: () => SettingsSheet.show(context,
                notifier: widget.settingsNotifier, weather: data),
            onOpenShareStory: () =>
                ShareStoryModal.show(context, data, tempUnit),
            onOpenSmartTriggers: () =>
                ProactiveNotificationsModal.show(context, data),
            onRefresh: () => _loadCurrentWeather(forceRefresh: true),
          ),
          const SizedBox(height: 10),

          // 3. Multi-Location Carousel Page Dots Indicator
          LocationPageIndicator(
            count: locationState.savedLocations.length,
            activeIndex: locationState.activeIndex,
            onPageSelected: (idx) =>
                widget.locationNotifier.setActiveLocation(idx),
          ),
          const SizedBox(height: 28),

          // 4. Kinetic Big Typography Display & Yesterday Delta
          KineticTemperatureDisplay(data: data, unit: tempUnit),
          const SizedBox(height: 24),

          // 5. Cozy Glanceable Human Summary
          Text(
            data.humanSummary,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              height: 1.45,
              color: Colors.white70,
            ),
          ),
          if (data.nightSkyClarity != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.twilightCyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.twilightCyan.withValues(alpha: 0.25)),
              ),
              child: Text(
                data.nightSkyClarity!,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.twilightCyan),
              ),
            ),
          ],
          const SizedBox(height: 24),

          // 6. Horizon Daily Ambient Briefing & Procedural Soundscape
          DailyBriefingCard(
            briefing: data.dailyBriefing,
            onTap: () => CardDetailModal.show(
              context: context,
              content: CardDetailFactory.createDailyBriefing(data, tempUnit),
              weather: data,
              unit: tempUnit,
            ),
          ),
          const SizedBox(height: 28),

          // 7. Minute-by-Minute Next-Hour Rain Matrix
          MinutePrecipitationCard(
            minutePrecipitation: data.minutePrecipitation,
            onTap: () => CardDetailModal.show(
              context: context,
              content:
                  CardDetailFactory.createMinutePrecipitation(data, tempUnit),
              weather: data,
              unit: tempUnit,
            ),
          ),
          if (data.minutePrecipitation.hasPrecipitation)
            const SizedBox(height: 28),

          // 8. 24-Hour Scrubbable Timeline Strip
          HourlyForecastStrip(
            hourly: data.hourlyForecast,
            unit: tempUnit,
            onTap: () => CardDetailModal.show(
              context: context,
              content: CardDetailFactory.createHourlyForecast(data, tempUnit),
              weather: data,
              unit: tempUnit,
            ),
          ),
          const SizedBox(height: 32),

          // 9. Yesterday vs. Today 24-Hour Overlay Comparison Chart
          YesterdayComparisonChart(
            comparison: data.yesterdayComparison,
            unit: tempUnit,
            onTap: () => CardDetailModal.show(
              context: context,
              content:
                  CardDetailFactory.createYesterdayComparison(data, tempUnit),
              weather: data,
              unit: tempUnit,
            ),
          ),
          const SizedBox(height: 32),

          // 10. Dynamic Optimal Activity Window Finder
          ActivityWindowSelector(
            selectedActivity: state.selectedActivity,
            windowResult: state.activityWindow,
            onActivitySelected: (act) =>
                widget.weatherNotifier.selectActivity(act),
            onTap: () => CardDetailModal.show(
              context: context,
              content: CardDetailFactory.createActivityWindow(
                  data, state.activityWindow, tempUnit),
              weather: data,
              unit: tempUnit,
            ),
          ),
          const SizedBox(height: 32),

          // 11. Interactive Weather Radar & Animated Wind Streamlines
          WeatherRadarCard(
            condition: data.condition,
            windStream: data.windStream,
            speedUnit: widget.settingsNotifier.value.speedUnit,
            onTap: () => CardDetailModal.show(
              context: context,
              content: CardDetailFactory.createWeatherRadar(
                  data, widget.settingsNotifier.value.speedUnit),
              weather: data,
              unit: tempUnit,
            ),
          ),
          const SizedBox(height: 32),

          // 12. 7-Day Spectrum Outlook
          SevenDayForecastCard(
            dailyForecast: data.dailyForecast,
            unit: tempUnit,
            onTap: () => CardDetailModal.show(
              context: context,
              content: CardDetailFactory.createSevenDayForecast(data, tempUnit),
              weather: data,
              unit: tempUnit,
            ),
          ),
          const SizedBox(height: 32),

          // 13. Celestial Sun & Moon Arc
          CelestialPathWidget(
            astronomy: data.astronomy,
            onTap: () => CardDetailModal.show(
              context: context,
              content: CardDetailFactory.createCelestialPath(data, tempUnit),
              weather: data,
              unit: tempUnit,
            ),
          ),
          const SizedBox(height: 32),

          // 14. Biophilic Health & Circadian Wellness
          BiophilicHealthCard(
            biophilicHealth: data.biophilicHealth,
            onTap: () => CardDetailModal.show(
              context: context,
              content: CardDetailFactory.createBiophilicHealth(data, tempUnit),
              weather: data,
              unit: tempUnit,
            ),
          ),
          const SizedBox(height: 32),

          // 15. Deep Precision Meteorology Matrix
          DeepMeteorologyCard(
            deepMeteorology: data.deepMeteorology,
            onTap: () => CardDetailModal.show(
              context: context,
              content:
                  CardDetailFactory.createPrecisionMeteorology(data, tempUnit),
              weather: data,
              unit: tempUnit,
            ),
          ),
          const SizedBox(height: 32),

          // 16. Bioclimatic Thermal Comfort Breakdown ("Why it feels like X°")
          ThermalComfortCard(
            thermalComfort: data.thermalComfort,
            unit: tempUnit,
            onTap: () => CardDetailModal.show(
              context: context,
              content: CardDetailFactory.createThermalComfort(data, tempUnit),
              weather: data,
              unit: tempUnit,
            ),
          ),
          const SizedBox(height: 32),

          // 17. Commute & Route Weather Simulator ("Horizon Journey")
          JourneySimulatorCard(
            journey: data.journey,
            tempUnit: tempUnit,
            speedUnit: widget.settingsNotifier.value.speedUnit,
            onTap: () => CardDetailModal.show(
              context: context,
              content: CardDetailFactory.createJourneySimulator(
                  data, tempUnit, widget.settingsNotifier.value.speedUnit),
              weather: data,
              unit: tempUnit,
            ),
          ),
          const SizedBox(height: 32),

          // 18. Air Quality & UV Index
          AirQualityCard(
            airQuality: data.airQuality,
            uvIndex: data.uvIndex,
            onTap: () => CardDetailModal.show(
              context: context,
              content: CardDetailFactory.createAirQuality(data, tempUnit),
              weather: data,
              unit: tempUnit,
            ),
          ),
          const SizedBox(height: 32),

          // 19. Comfort & Wardrobe Packing Checklist
          GearChecklistWrap(
            recommendedGear: data.recommendedGear,
            packedGear: state.packedGear,
            onToggleItem: (item) => widget.weatherNotifier.toggleGearItem(item),
            onTapHeader: () => CardDetailModal.show(
              context: context,
              content: CardDetailFactory.createGearChecklist(
                  data, state.packedGear.toList(), tempUnit),
              weather: data,
              unit: tempUnit,
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded,
                size: 48, color: Colors.white38),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => _loadCurrentWeather(forceRefresh: true),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.softAmber),
            ),
          ],
        ),
      ),
    );
  }
}
