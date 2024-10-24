import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
