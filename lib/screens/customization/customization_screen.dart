import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/screens/customization/bloc/customization_bloc.dart';
import 'package:gruene_app/screens/customization/pages/interests_page.dart';
import 'package:gruene_app/screens/customization/pages/intro_page.dart';
import 'package:gruene_app/screens/customization/pages/subject_page.dart';
import 'package:gruene_app/screens/customization/repository/customization_repository.dart';

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
    final pages = [
      IntroPage(controller),
      InterestsPage(controller),
      SubjectPage(controller)
    ];
    return RepositoryProvider(
      create: (context) => CustomizationRepositoryImpl(),
      child: BlocProvider(
        create: (context) =>
            CustomizationBloc(context.read<CustomizationRepositoryImpl>())
              ..add(CustomizationLoad()),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: widget.currentPage != 0
              ? PreferredSize(
                  preferredSize: const Size(double.infinity, 80),
                  child: AppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    leading: const CupertinoNavigationBarBackButton(
                      color: Colors.grey,
                      previousPageTitle: 'Zurück',
                    ),
                    elevation: 0,
                    leadingWidth: 100,
                    bottom: progressIndicator(pages),
                  ),
                )
              : PreferredSize(
                  preferredSize: const Size(0, 0), child: Container()),
          body: SafeArea(
            child: PageView(
              controller: controller,
              onPageChanged: (value) => setState(() {
                widget.currentPage = value;
              }),
              physics: const NeverScrollableScrollPhysics(),
              children: pages,
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize progressIndicator(List<StatefulWidget> pages) {
    return PreferredSize(
        preferredSize: const Size(double.infinity, 80),
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                    backgroundColor: Colors.red.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation(Colors.red),
                    value: getProgressOfCurrentPage(pages.length - 1)),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Schritt ${widget.currentPage} von ${pages.length - 1}',
                  textAlign: TextAlign.left,
                ),
              )
            ],
          ),
        ));
  }

  double getProgressOfCurrentPage(int pages) {
    var cu = widget.currentPage;
    return cu / pages;
  }
}
