import 'package:flutter/material.dart';

class NewsCard extends StatefulWidget {
  final bool bookmarked;

  final double imageHeight;

  final double imageWidth;

  final String imageUrl;

  final String typ;
  final String titel;

  final String subtitel;

  final String chipLabel;

  final void Function() onTap;

  const NewsCard({
    super.key,
    this.imageHeight = 190.00,
    this.imageWidth = 1000.0,
    this.bookmarked = false,
    required this.imageUrl,
    required this.typ,
    required this.titel,
    required this.subtitel,
    required this.chipLabel,
    required this.onTap,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  double padding = 16.0;
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      child: Padding(
        padding: EdgeInsets.fromLTRB(padding, 16, padding, 16),
        child: GestureDetector(
          onTap: () {
            setState(() {
              padding = 6.0;
            });
            widget.onTap();
          },
          child: Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.4),
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ]),
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Image(
                            alignment: Alignment.topCenter,
                            width: widget.imageWidth,
                            height: widget.imageHeight,
                            image: NetworkImage(widget.imageUrl),
                            frameBuilder: (context, child, frame,
                                wasSynchronouslyLoaded) {
                              return child;
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return SizedBox(
                                width: widget.imageWidth,
                                height: widget.imageHeight,
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return SizedBox(
                                width: widget.imageWidth,
                                height: widget.imageHeight,
                              );
                            },
                          ),
                          Positioned(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        widget.typ,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                      )),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        splashRadius: 0.001,
                                        onPressed: () {
                                          print('bookmarked');
                                        },
                                        color: widget.bookmarked
                                            ? Theme.of(context).primaryColor
                                            : Colors.white,
                                        icon: const Icon(
                                          Icons.bookmark_add_outlined,
                                          size: 32,
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                      child: Text(
                        widget.titel,
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                                color: Colors.black, fontSize: 26, height: 1.2),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 100),
                        child: Text(
                          widget.subtitel,
                          textAlign: TextAlign.left,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: AbsorbPointer(
                        absorbing: true,
                        child: FilterChip(
                          onSelected: (value) {},
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.all(1),
                          shape: StadiumBorder(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          label: Text(
                            widget.chipLabel,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
