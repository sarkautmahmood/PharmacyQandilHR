import 'dart:math' as math;

/// Math utility for client-side Geofencing and Distance Calculation
class GeofenceCalculator {
  static const double earthRadiusMeters = 6371000.0;

  /// Calculate distance between two GPS coordinates in meters using Haversine formula
  static double getDistanceMeters({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    final double dLat = _toRadians(endLatitude - startLatitude);
    final double dLon = _toRadians(endLongitude - startLongitude);

    final double rLat1 = _toRadians(startLatitude);
    final double rLat2 = _toRadians(endLatitude);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLon / 2) * math.sin(dLon / 2) * math.cos(rLat1) * math.cos(rLat2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusMeters * c;
  }

  static double _toRadians(double degree) {
    return degree * (math.pi / 180.0);
  }

  /// Formats distance in Kurdish (e.g. "١٢.٥ مەتر" or "١.٢ کم")
  static String formatDistanceKurdish(double meters) {
    if (meters < 1000) {
      return "${meters.toStringAsFixed(1)} مەتر";
    } else {
      final km = meters / 1000.0;
      return "${km.toStringAsFixed(2)} کم";
    }
  }
}
