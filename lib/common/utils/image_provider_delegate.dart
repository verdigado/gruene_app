// Helper Class to make NetworkImages Testable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class ImageProviderDelegate {
  ImageProviderTyp typ;

  ImageProviderDelegate({required this.typ});

  ImageProvider provide(String url) {
    switch (typ) {
      case ImageProviderTyp.cached:
        return CachedNetworkImageProvider(url);

      case ImageProviderTyp.asset:
        return AssetImage(url);
    }
  }
}

enum ImageProviderTyp { asset, cached }
