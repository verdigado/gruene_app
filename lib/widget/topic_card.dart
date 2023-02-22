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

  @override
  void initState() {
    checkedState = widget.checked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(children: [
        Positioned.fill(
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CachedNetworkImage(
                  imageUrl: widget.imgageUrl,
                  errorWidget: (context, url, error) {
                    return SizedBox(
                      width: 160,
                      height: 160,
                      child: Card(
                        semanticContainer: true,
                        color: const Color(0xFF145F32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    );
                  },
                  placeholder: (context, url) => placeholderCard(),
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                    width: 160,
                    height: 160,
                    fit: BoxFit.fill,
                  ),
                  width: 160,
                  height: 160,
                  fit: BoxFit.fill,
                ),
              )),
        ),
        Positioned(
          top: 15,
          left: 130,
          child: FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.white,
            mini: true,
            onPressed: () {
              setState(() {
                checkedState = !checkedState;
              });
              if (widget.onTap != null) {
                widget.onTap!(checkedState, widget.id);
              }
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
      ]),
    );
  }

  Shimmer placeholderCard() {
    return Shimmer.fromColors(
        baseColor: const Color(0xFF145F32),
        highlightColor: const Color(0xFF5B8F70),
        child: SizedBox(
          width: 160,
          height: 160,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: const FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: 160,
                height: 160,
              ),
            ),
          ),
        ));
  }
}
