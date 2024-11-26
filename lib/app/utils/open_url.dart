import 'package:url_launcher/url_launcher.dart';

Future<void> openMail(String mail) async {
  await launchUrl(Uri.parse('mailto:$mail'));
}
