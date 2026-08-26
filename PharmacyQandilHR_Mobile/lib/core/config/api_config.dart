/// API & SOAP Configuration for Pharmacy Qandil HR ASMX Backend
class ApiConfig {
  /// Base URL to the ASP.NET Web Forms & ASMX Server
  /// Replace with your actual LAN IP / Domain (e.g. http://192.168.1.50/PharmacyQandilHR or https://hr.pharmacyqandil.com)
  static const String serverBaseUrl = "http://10.0.2.2:5000"; // 10.0.2.2 for Android Emulator, localhost for iOS Sim

  /// ASMX Service Endpoints
  static const String attendanceServiceUrl = "$serverBaseUrl/Services/HR_AttendanceService.asmx";
  static const String portalServiceUrl = "$serverBaseUrl/Services/HR_PortalService.asmx";

  /// SOAP XML Namespace (Must match ASMX Namespace)
  static const String soapNamespace = "http://pharmacyqandil.com/hr/";

  /// Network Timeout
  static const Duration timeoutDuration = Duration(seconds: 25);
}
