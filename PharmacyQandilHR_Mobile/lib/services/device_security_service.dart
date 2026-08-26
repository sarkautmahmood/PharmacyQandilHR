import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manages Hardware Device UUID and Binding (Anti-Device-Sharing)
class DeviceSecurityService {
  static const _storage = FlutterSecureStorage();
  static const String _deviceUuidKey = "PHARMACY_QANDIL_DEVICE_UUID";

  /// Gets or generates the unique hardware device UUID stored securely in iOS Keychain / Android KeyStore
  static Future<String> getUniqueDeviceUUID() async {
    // 1. Check if device UUID is already persisted in secure storage
    String? storedUuid = await _storage.read(key: _deviceUuidKey);
    if (storedUuid != null && storedUuid.isNotEmpty) {
      return storedUuid;
    }

    // 2. Generate Hardware-bound UUID
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String generatedId = "";

    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        generatedId = "ANDROID_${androidInfo.id}_${androidInfo.model.replaceAll(' ', '_')}";
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        generatedId = "IOS_${iosInfo.identifierForVendor ?? 'UNKNOWN'}_${iosInfo.utsname.machine}";
      } else {
        generatedId = "DEVICE_${DateTime.now().millisecondsSinceEpoch}";
      }
    } catch (e) {
      generatedId = "DEV_${DateTime.now().millisecondsSinceEpoch}";
    }

    // 3. Save to KeyStore / Keychain
    await _storage.write(key: _deviceUuidKey, value: generatedId);
    return generatedId;
  }
}
