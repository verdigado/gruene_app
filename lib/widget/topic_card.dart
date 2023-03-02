import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gruene_app/common/utils/image_provider_delegate.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/gen/fonts.gen.dart';
import 'package:gruene_app/locator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    show BaseCacheManager, DefaultCacheManager;

class TopicCard extends StatefulWidget {
  final String imgageUrl;
  final String id;

  final void Function(bool, String)? onTap;

  final String? topic;

  final bool checked;

  const TopicCard({
    super.key,
    required this.id,
    required this.imgageUrl,
    this.topic,
    this.onTap,
    this.checked = false,
  });

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
  CachedNetworkImage? img;
  var icon = Icons.add;
  bool checkedState = false;
  final double cardBorder = 15.0;

  late ImageProviderDelegate imgProvider;

  @override
  void initState() {
    checkedState = widget.checked;
    imgProvider = locator.get<ImageProviderDelegate>(instanceName: 'TopicCard');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardSize = size.width / 2 - 20;
    return InkWell(
      onTap: () => check(),
      child: Stack(children: [
        Positioned.fill(
          child: Card(
            color: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardBorder),
            ),
            child: Image(
              image: imgProvider.provide(widget.imgageUrl),
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                  FittedBox(
                fit: BoxFit.fill,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(cardBorder),
                    child: child),
              ),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return placeholderCard(context, cardSize);
              },
              errorBuilder: (context, error, stackTrace) {
                return FittedBox(
                    fit: BoxFit.fill,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(cardBorder),
                      child: Container(
                        color: Theme.of(context).colorScheme.primary,
                        width: cardSize,
                        height: cardSize,
                      ),
                    ));
              },
            ),
          ),
        ),
        Positioned(
          top: cardSize / 100 * 4,
          left: size.width / 2 - cardSize / 3,
          child: FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.white,
            mini: true,
            onPressed: () {
              check();
            },
            child: Icon(
              checkedState ? Icons.check : Icons.add,
              color: checkedState
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.black,
              size: cardSize / 6,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              widget.topic ?? '',
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: FontFamily.bereit,
                  fontSize: 26),
            ),
          ),
        ),
      ]),
    );
  }

  void check() {
    setState(() {
      checkedState = !checkedState;
    });
    if (widget.onTap != null) {
      widget.onTap!(checkedState, widget.id);
    }
  }

  Shimmer placeholderCard(BuildContext context, double cardSize) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.primary,
      highlightColor: mcgpalette0[100]!,
      child: FittedBox(
        fit: BoxFit.fill,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(cardBorder),
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            width: cardSize,
            height: cardSize,
          ),
        ),
      ),
    );
  }
}
