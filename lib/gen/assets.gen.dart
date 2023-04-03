/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Sonnenblume_rgb_aufTransparent.png
  AssetGenImage get sonnenblumeRgbAufTransparent =>
      const AssetGenImage('assets/images/Sonnenblume_rgb_aufTransparent.png');

  /// File path: assets/images/bicycle_man.svg
  String get bicycleMan => 'assets/images/bicycle_man.svg';

  /// File path: assets/images/gruene_topic_economy.svg
  String get grueneTopicEconomy => 'assets/images/gruene_topic_economy.svg';

  /// File path: assets/images/gruene_topic_economy.svg.vec
  String get grueneTopicEconomySvg =>
      'assets/images/gruene_topic_economy.svg.vec';

  /// File path: assets/images/gruene_topic_europa1.svg
  String get grueneTopicEuropa1 => 'assets/images/gruene_topic_europa1.svg';

  /// File path: assets/images/gruene_topic_europa1.svg.vec
  String get grueneTopicEuropa1Svg =>
      'assets/images/gruene_topic_europa1.svg.vec';

  /// File path: assets/images/gruenen_topic_oekologie.svg
  String get gruenenTopicOekologie =>
      'assets/images/gruenen_topic_oekologie.svg';

  /// File path: assets/images/gruenen_topic_oekologie.svg.vec
  String get gruenenTopicOekologieSvg =>
      'assets/images/gruenen_topic_oekologie.svg.vec';

  /// List of all assets
  List<dynamic> get values => [
        sonnenblumeRgbAufTransparent,
        bicycleMan,
        grueneTopicEconomy,
        grueneTopicEconomySvg,
        grueneTopicEuropa1,
        grueneTopicEuropa1Svg,
        gruenenTopicOekologie,
        gruenenTopicOekologieSvg
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider() => AssetImage(_assetName);

  String get path => _assetName;

  String get keyName => _assetName;
}
