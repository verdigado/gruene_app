import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void openInAppBrowser(String url, BuildContext context) async {
  final browser = ChromeSafariBrowser();
  await browser.open(
    url: WebUri(url),
    settings: ChromeSafariBrowserSettings(toolbarBackgroundColor: Theme.of(context).primaryColor),
  );
}
