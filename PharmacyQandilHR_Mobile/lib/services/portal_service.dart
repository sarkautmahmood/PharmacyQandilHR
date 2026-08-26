import '../core/config/api_config.dart';
import 'soap_client_service.dart';

class PortalService {
  /// Request a leave
  static Future<Map<String, dynamic>> submitLeaveRequest({
    required int empId,
    required int leaveTypeId,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    final Map<String, dynamic> params = {
      'empID': empId,
      'leaveTypeID': leaveTypeId,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
    };

    return await SoapClientService.callSoapMethod(
      serviceUrl: ApiConfig.portalServiceUrl,
      methodName: 'Request_Leave',
      parameters: params,
    );
  }
}
