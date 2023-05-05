import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class NewsPage extends StatelessWidget {
  final String heroTag;

  final String url;
  const NewsPage({
    super.key,
    required this.heroTag,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        color: Colors.transparent,
        child: DismissiblePage(
          direction: DismissiblePageDismissDirection.multi,
          isFullScreen: true,
          onDismissed: () => context.pop(),
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Hero(
              tag: heroTag,
              child: Scaffold(
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, top: 16),
                              child: IconButton(
                                  onPressed: () => context.pop(),
                                  icon: const Icon(
                                    Icons.close_outlined,
                                    size: 30,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: InAppWebView(
                        gestureRecognizers: {}..add(
                            Factory<VerticalDragGestureRecognizer>(
                                () => VerticalDragGestureRecognizer())),
                        initialUrlRequest: URLRequest(url: Uri.tryParse(url)),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
