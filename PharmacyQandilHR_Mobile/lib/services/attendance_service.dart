import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import '../core/config/api_config.dart';
import 'device_security_service.dart';
import 'location_service.dart';
import 'soap_client_service.dart';

class AttendanceService {
  /// Submits an Attendance Check-In (1) or Check-Out (2) with GPS and Live Selfie
  static Future<Map<String, dynamic>> submitAttendance({
    required int empId,
    required int placeId,
    required int checkType, // 1: In, 2: Out
    required File selfieImageFile,
  }) async {
    // 1. Get Live GPS Location with Anti-Mock
    final PositionResult posResult = await LocationService.getCurrentPosition();
    if (!posResult.success) {
      return {
        'Success': false,
        'Message': posResult.errorMessage ?? 'نەتوانرا لۆکەیشن دیاری بکرێت.',
      };
    }

    // 2. Compress & Convert Selfie image to Base64
    String selfieBase64 = "";
    try {
      final bytes = await selfieImageFile.readAsBytes();
      final decodedImage = img.decodeImage(bytes);
      if (decodedImage != null) {
        // Resize to 480px width for fast upload and low bandwidth consumption
        final resized = img.copyResize(decodedImage, width: 480);
        final compressedJpg = img.encodeJpg(resized, quality: 75);
        selfieBase64 = base64Encode(compressedJpg);
      } else {
        selfieBase64 = base64Encode(bytes);
      }
    } catch (e) {
      selfieBase64 = "";
    }

    // 3. Get Hardware-bound Device UUID
    final String deviceUuid = await DeviceSecurityService.getUniqueDeviceUUID();

    // 4. Call ASMX SOAP WebService
    final Map<String, dynamic> params = {
      'empID': empId,
      'placeID': placeId,
      'checkType': checkType,
      'latitude': posResult.latitude!,
      'longitude': posResult.longitude!,
      'selfieBase64': selfieBase64,
      'deviceUUID': deviceUuid,
    };

    return await SoapClientService.callSoapMethod(
      serviceUrl: ApiConfig.attendanceServiceUrl,
      methodName: 'Check_Attendance',
      parameters: params,
    );
  }
}
