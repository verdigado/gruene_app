import 'dart:convert';
import 'dart:io';
import 'package:gruene_app/app/constants/config.dart';
import 'package:http/http.dart' as http;

class IpService {
  Future<bool> isOwnIP(String ip) async {
    final isInputIPv6 = isIPv6(ip);
    final publicIp = await getPublicIp(useIPv6: isInputIPv6);
    return ip == publicIp;
  }

  Future<String?> getPublicIp({bool useIPv6 = false}) async {
    try {
      final url = useIPv6 ? Config.ipServiceV6Url : Config.ipServiceV4Url;

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        return jsonResponse['clientIp'] as String?;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  bool isIPv6(String ip) {
    try {
      final address = InternetAddress(ip);
      return address.type == InternetAddressType.IPv6;
    } catch (e) {
      return false;
    }
  }
}
