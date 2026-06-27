import 'package:flutter/material.dart';
import '../../data/models/weather_model.dart';
import '../../data/repositories/weather_repository.dart';
import '../state/weather_provider.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  late final WeatherNotifier _weatherNotifier;

  @override
  void initState() {
    super.initState();
    _weatherNotifier = WeatherNotifier(WeatherRepository());
    _weatherNotifier.refreshForecast();
  }

  @override
  void dispose() {
    _weatherNotifier.dispose();
    super.dispose();
  }

  // Pure procedural visual mapping: Translates context to elegant fluid background gradients
  List<Color> _computeDynamicGradient(WeatherCondition? condition) {
    switch (condition) {
      case WeatherCondition.clearNight:
        return [const Color(0xFF090D14), const Color(0xFF141A24)];
      case WeatherCondition.rainy:
        return [const Color(0xFF2C353F), const Color(0xFF181F25)];
      case WeatherCondition.extremeHeat:
        return [const Color(0xFFC85A32), const Color(0xFF7A2A1E)];
      case WeatherCondition.overcast:
        return [const Color(0xFF2E3138), const Color(0xFF1C1E22)];
      case WeatherCondition.clearDay:
      default:
        return [const Color(0xFF16161D), const Color(0xFF0D0D11)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<WeatherState>(
        valueListenable: _weatherNotifier,
        builder: (context, state, child) {
          final WeatherCondition? activeCondition =
              state is WeatherLoaded ? state.data.condition : null;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _computeDynamicGradient(activeCondition),
              ),
            ),
            child: SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: switch (state) {
                  WeatherLoading() => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white30,
                        strokeWidth: 2,
                      ),
                    ),
                  WeatherError(:final message) => Center(
                      child: Text(
                        message,
                        style: const TextStyle(
                            color: Colors.white54, fontWeight: FontWeight.w300),
                      ),
                    ),
                  WeatherLoaded(:final data) => RefreshIndicator(
                      onRefresh: () => _weatherNotifier.refreshForecast(),
                      color: Colors.white,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 32.0),
                        children: [
                          // Structural Context Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "HORIZON NODE",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white38,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    data.neighborhoodName,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh,
                                    color: Colors.white38, size: 20),
                                onPressed: () =>
                                    _weatherNotifier.refreshForecast(),
                              )
                            ],
                          ),
                          const SizedBox(height: 80),

                          // Kinetic Typography Display Matrix
                          Text(
                            "${data.temperature.toStringAsFixed(0)}°",
                            style: TextStyle(
                              fontSize: 120,
                              // Font thickness inherently maps directly to absolute environment temperature
                              fontWeight: data.temperature > 28
                                  ? FontWeight.w400
                                  : FontWeight.w200,
                              height: 0.85,
                              letterSpacing: -6,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Human Glanceable Logic Phrase
                          Text(
                            data.humanSummary,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              height: 1.45,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 48),
                          const Divider(color: Colors.white12, height: 1),
                          const SizedBox(height: 40),

                          // Planning Segment (Optimal Activity Windows)
                          const Text(
                            "OPTIMIZED WINDOWS",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white38,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            data.optimalActivityWindow,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.white70,
                            ),
                          ),

                          // Conditional Night Sky Clarity Context for Astronomy
                          if (data.nightSkyClarity != null) ...[
                            const SizedBox(height: 14),
                            Text(
                              data.nightSkyClarity!,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF81E6D9),
                              ),
                            ),
                          ],
                          const SizedBox(height: 48),

                          // Gear Configuration Checklist
                          const Text(
                            "MINIMAL CHECKLIST",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white38,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: data.recommendedGear
                                .map((item) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.04),
                                        borderRadius: BorderRadius.circular(24),
                                        border:
                                            Border.all(color: Colors.white10),
                                      ),
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
