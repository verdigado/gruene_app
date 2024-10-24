import 'package:flutter/widgets.dart';

import 'i18n/translations.g.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xFFFFFFFF),
      builder: (context, _) => const Center(
        child: Text(
          'Gruene App',
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}
