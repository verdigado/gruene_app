import 'dart:io';
import 'package:http/http.dart' as http;

class IpService {
  Future<bool> isOwnIP(String ip) async {
    final isInputIPv6 = isIPv6(ip);
    final publicIp = await getPublicIp(useIPv6: isInputIPv6);
    return ip == publicIp;
  }

  Future<String?> getPublicIp({bool useIPv6 = false}) async {
    try {
      final url = 'https://api${useIPv6 ? '6' : '4'}.ipify.org';
      final response = await http.get(Uri.parse(url));
      return response.body;
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
