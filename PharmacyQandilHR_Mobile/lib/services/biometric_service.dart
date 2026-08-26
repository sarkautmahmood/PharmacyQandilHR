import 'package:local_auth/local_auth.dart';

/// Biometric Authentication (Fingerprint & FaceID)
class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Authenticates the employee using their phone's Biometrics
  static Future<bool> authenticateEmployee({String reason = 'تکایە پەنجەمۆر یان دەموچاوت دابنێ بۆ سەلماندنی کەسایەتی'}) async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) {
        // If device has no hardware biometric, allow fallback
        return true;
      }

      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      // Fallback
      return true;
    }
  }
}
