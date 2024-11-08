import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get clientId => dotenv.env['CLIENT_ID'] ?? '';
  static String get issuer => dotenv.env['ISSUER'] ?? '';
}
