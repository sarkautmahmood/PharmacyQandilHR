import 'package:geolocator/geolocator.dart';

/// GPS Location & Anti-Fake GPS Service for Pharmacy Geofencing
class LocationService {
  /// Retrieves high accuracy GPS position with mock location detection
  static Future<PositionResult> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return PositionResult(
        success: false,
        errorMessage: 'تکایە GPSی مۆبایلەکەت پێبکە (Location Service ناچالاکە).',
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return PositionResult(
          success: false,
          errorMessage: 'ڕێگەپێدانی لۆکەیشن ڕەتکرایەوە.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return PositionResult(
        success: false,
        errorMessage: 'ڕێگەپێدانی لۆکەیشن بۆ هەمیشە داخراوە. تکایە لە ڕێکخستنی مۆبایلەکە ڕێگەی پێبدە.',
      );
    }

    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: const Duration(seconds: 15),
      );

      // Anti-Mock GPS Check (Prevent Fake GPS apps)
      if (position.isMocked) {
        return PositionResult(
          success: false,
          errorMessage: 'بەرنامەی شوێنی ساختە (Fake GPS) دۆزرایەوە! تکایە لایبە بۆ دەوام لێدان.',
        );
      }

      return PositionResult(
        success: true,
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      );
    } catch (e) {
      return PositionResult(
        success: false,
        errorMessage: 'نەتوانرا شوێنی ئێستات دیاری بکرێت: $e',
      );
    }
  }
}

class PositionResult {
  final bool success;
  final double? latitude;
  final double? longitude;
  final double? accuracy;
  final String? errorMessage;

  PositionResult({
    required this.success,
    this.latitude,
    this.longitude,
    this.accuracy,
    this.errorMessage,
  });
}
