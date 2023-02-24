import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/gen/fonts.gen.dart';
import 'package:shimmer/shimmer.dart';

class TopicCard extends StatefulWidget {
  String imgageUrl;
  String id;

  void Function(bool, String)? onTap;

  String? topic;

  bool checked;

  TopicCard({
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

  @override
  void initState() {
    checkedState = widget.checked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardSize = size.width / 2 - 20;
    return Stack(children: [
      Positioned.fill(
        child: InkWell(
          onTap: () {
            check();
          },
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cardBorder),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.imgageUrl,
                errorWidget: (context, url, error) {
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
                placeholder: (context, url) =>
                    placeholderCard(context, cardSize),
                imageBuilder: (context, imageProvider) => ClipRRect(
                  borderRadius: BorderRadius.circular(cardBorder),
                  child: Image(
                    image: imageProvider,
                    width: cardSize,
                    height: cardSize,
                    fit: BoxFit.fill,
                  ),
                ),
              )),
        ),
      ),
      Positioned(
        top: cardSize / 100 * 4,
        left: size.width / 2 - cardSize / 3.5,
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
    ]);
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
