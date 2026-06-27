enum WeatherCondition { clearDay, clearNight, overcast, rainy, extremeHeat }

class WeatherData {
  final double temperature;
  final double tempDifferenceYesterday; 
  final double humidity;
  final double uvIndex;
  final double cloudCover; 
  final WeatherCondition condition;
  final DateTime timestamp;
  final String neighborhoodName;

  const WeatherData({
    required this.temperature,
    required this.tempDifferenceYesterday,
    required this.humidity,
    required this.uvIndex,
    required this.cloudCover,
    required this.condition,
    required this.timestamp,
    required this.neighborhoodName,
  });

  // Feature 1: "Human-First" Glanceability / Relative Weather Context
  String get humanSummary {
    final diff = tempDifferenceYesterday.abs().toStringAsFixed(1);
    final comparison = tempDifferenceYesterday < 0 ? "cooler" : "warmer";
    
    switch (condition) {
      case WeatherCondition.rainy:
        return "Expect a brief shower soon. It's about $diff°C $comparison than yesterday at this time.";
      case WeatherCondition.extremeHeat:
        return "Intense sun out there. It feels significantly $comparison than yesterday afternoon.";
      case WeatherCondition.clearNight:
        return "The air is crisp and clear tonight—perfect time to look up.";
      case WeatherCondition.overcast:
        return "The sky is blanketed in clouds. Lighter and $diff°C $comparison than yesterday.";
      case WeatherCondition.clearDay:
      default:
        return "It's a comfortable, bright day. About $diff°C $comparison than yesterday at this exact hour.";
    }
  }

  // Feature 2: The "Perfect Window" Activity Planning Locator
  String get optimalActivityWindow {
    if (condition == WeatherCondition.rainy) return "Next ideal outdoor window: Tomorrow morning";
    if (temperature > 33) return "Best outdoor window: 6:30 PM – 8:00 PM (Cooler breeze)";
    if (humidity > 80) return "Best outdoor window: 4:00 PM – 5:30 PM (When humidity dips)";
    return "Best outdoor window: Right now (Perfect equilibrium)";
  }

  // Feature 3: Minimalist Wardrobe & Gear Recommendation Checklist
  List<String> get recommendedGear {
    final List<String> gear = [];
    if (uvIndex > 5) gear.add("Sunglasses");
    if (temperature > 30) gear.add("Water Bottle");
    if (temperature < 20) gear.add("Light Jacket");
    if (condition == WeatherCondition.rainy) gear.add("Umbrella");
    if (gear.isEmpty) gear.add("Just yourself");
    return gear;
  }

  // Feature 4: Night Sky Clarity Index (Stargazing Window Utility)
  String? get nightSkyClarity {
    final hour = timestamp.hour;
    if (hour > 5 && hour < 18) return null; // Only show contextually during night hours
    if (cloudCover > 0.4) return "Sky Clarity: Poor (Heavy cloud cover)";
    if (humidity > 75) return "Sky Clarity: Fair (Atmospheric haze)";
    return "Sky Clarity: Excellent (High atmospheric transparency)";
  }
}
