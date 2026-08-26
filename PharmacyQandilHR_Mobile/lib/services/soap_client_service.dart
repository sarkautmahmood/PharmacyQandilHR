import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import '../core/config/api_config.dart';

/// Central SOAP 1.1 / 1.2 XML Client for communicating with ASMX Services
class SoapClientService {
  /// Calls an ASMX WebMethod via SOAP HTTP POST
  static Future<Map<String, dynamic>> callSoapMethod({
    required String serviceUrl,
    required String methodName,
    required Map<String, dynamic> parameters,
  }) async {
    final String soapEnvelope = _buildSoapEnvelope(methodName, parameters);

    try {
      final response = await http.post(
        Uri.parse(serviceUrl),
        headers: {
          'Content-Type': 'text/xml; charset=utf-8',
          'SOAPAction': '${ApiConfig.soapNamespace}$methodName',
        },
        body: utf8.encode(soapEnvelope),
      ).timeout(ApiConfig.timeoutDuration);

      if (response.statusCode == 200) {
        return _parseSoapResponse(response.body, methodName);
      } else {
        return {
          'Success': false,
          'Message': 'سێرڤەر وەڵامی نەدایەوە (کۆدی هەڵە: ${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'Success': false,
        'Message': 'کێشەی پەیوەندی بە سێرڤەر: $e',
      };
    }
  }

  /// Builds a standard SOAP 1.1 Envelope with Kurdish/Arabic UTF-8 support
  static String _buildSoapEnvelope(String methodName, Map<String, dynamic> parameters) {
    final StringBuffer paramsXml = StringBuffer();
    parameters.forEach((key, value) {
      paramsXml.write('<$key>${_escapeXml(value.toString())}</$key>');
    });

    return '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
               xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
               xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <$methodName xmlns="${ApiConfig.soapNamespace}">
      $paramsXml
    </$methodName>
  </soap:Body>
</soap:Envelope>''';
  }

  /// Parses XML SOAP Response and extracts the result payload or JSON
  static Map<String, dynamic> _parseSoapResponse(String responseXml, String methodName) {
    try {
      final document = xml.XmlDocument.parse(responseXml);
      final resultElement = document.findAllElements('${methodName}Result').firstOrNull;

      if (resultElement == null) {
        return {'Success': false, 'Message': 'وەڵامی نادیار لە سێرڤەرەوە'};
      }

      // Check if response has child XML nodes or contains a serialized JSON string
      final String textContent = resultElement.innerText;
      if (textContent.startsWith('{') && textContent.endsWith('}')) {
        return jsonDecode(textContent) as Map<String, dynamic>;
      }

      // Extract direct XML child elements
      final Map<String, dynamic> resultMap = {};
      for (var child in resultElement.children) {
        if (child is xml.XmlElement) {
          resultMap[child.name.local] = child.innerText;
        }
      }

      if (resultMap.isNotEmpty) {
        if (resultMap.containsKey('Success')) {
          resultMap['Success'] = resultMap['Success'].toString().toLowerCase() == 'true';
        }
        return resultMap;
      }

      return {'Success': true, 'Data': textContent};
    } catch (e) {
      return {'Success': false, 'Message': 'هەڵە لە خوێندنەوەی وەڵامی سێرڤەر: $e'};
    }
  }

  static String _escapeXml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }
}
