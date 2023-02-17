import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gruene_app/screens/customization/pages/interests_page.dart';
import 'package:gruene_app/screens/customization/pages/intro_page.dart';

class CustomizationScreen extends StatefulWidget {
  const CustomizationScreen({super.key});

  @override
  State<CustomizationScreen> createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackButton(color: Colors.grey),
            Flexible(fit: FlexFit.tight, child: SizedBox()),
            Text(
              'Zurück',
            )
          ],
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [IntroPage(controller), InterestsPage(controller)],
        ),
      ),
    );
  }
}
