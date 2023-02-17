import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/screens/customization/pages/interests_page.dart';
import 'package:gruene_app/screens/customization/pages/intro_page.dart';

class CustomizationScreen extends StatefulWidget {
  CustomizationScreen({super.key});
  int currentPage = 0;

  @override
  State<CustomizationScreen> createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: widget.currentPage != 0
          ? PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: AppBar(
                backgroundColor: Colors.white,
                leading: const CupertinoNavigationBarBackButton(
                  color: Colors.grey,
                  previousPageTitle: 'Zurück',
                ),
                elevation: 0,
                leadingWidth: 100,
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(6.0),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 18, top: 10),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.red.withOpacity(0.3),
                              valueColor:
                                  const AlwaysStoppedAnimation(Colors.red),
                              value: 0.5,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Schritt ${widget.currentPage} von 2',
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            )
          : null,
      body: SafeArea(
        child: PageView(
          controller: controller,
          onPageChanged: (value) => setState(() {
            widget.currentPage = value;
          }),
          physics: const NeverScrollableScrollPhysics(),
          children: [IntroPage(controller), InterestsPage(controller)],
        ),
      ),
    );
  }
}
