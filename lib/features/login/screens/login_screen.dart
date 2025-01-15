import 'package:flutter/material.dart';
import 'package:gruene_app/app/widgets/clean_layout.dart';
import 'package:gruene_app/features/login/widgets/support_button.dart';
import 'package:gruene_app/features/login/widgets/welcome_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CleanLayout(
      showAppBar: false,
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              // #457: disable intro slides for now
              // return Container(
              //   padding: EdgeInsets.only(bottom: defaultBottomSheetSize * constraints.maxHeight),
              //   child: WelcomeView(),
              // );
              return WelcomeView();
            },
          ),
          SupportButton(),
          // #457: disable intro slides for now
          // PersistentBottomSheet(
          //   child: IntroSlides(),
          // ),
        ],
      ),
    );
  }
}
