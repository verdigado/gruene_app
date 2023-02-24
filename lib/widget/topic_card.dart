import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
  final cardSize = 160.00;

  @override
  void initState() {
    checkedState = widget.checked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(children: [
      Positioned.fill(
        child: InkWell(
          onTap: () {
            check();
          },
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.imgageUrl,
                errorWidget: (context, url, error) {
                  return FittedBox(
                      fit: BoxFit.fill,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: Theme.of(context).colorScheme.primary,
                          width: 206,
                          height: 206,
                        ),
                      ));
                },
                placeholder: (context, url) => placeholderCard(),
                imageBuilder: (context, imageProvider) => ClipRRect(
                  borderRadius: BorderRadius.circular(15),
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
        top: 8,
        left: size.width / 2 - 55,
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.white,
          mini: true,
          onPressed: () {
            check();
          },
          child: Icon(
            checkedState ? Icons.check : Icons.add,
            color: checkedState ? const Color(0xFFFF495D) : Colors.black,
            size: 30,
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

  Shimmer placeholderCard() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF145F32),
      highlightColor: const Color(0xFF5B8F70),
      child: FittedBox(
        fit: BoxFit.fill,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            width: 206,
            height: 206,
          ),
        ),
      ),
    );
  }
}
