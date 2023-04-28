import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:gruene_app/screens/start/tabs/news_card_pagination_list_view.dart';
import 'package:gruene_app/widget/news_page.dart';

class NewsCard extends StatefulWidget {
  final bool bookmarked;

  final double imageHeight;

  final double imageWidth;

  final void Function()? onTap;

  final String heroTag;

  final News news;

  final void Function(News news) onBookmarked;

  const NewsCard(
      {super.key,
      this.imageHeight = 190.00,
      this.imageWidth = 1000.0,
      this.bookmarked = false,
      required this.news,
      this.onTap,
      required this.heroTag,
      required this.onBookmarked});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  late bool bookmarked;
  @override
  void initState() {
    bookmarked = widget.bookmarked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Bounce(
        duration: const Duration(milliseconds: 110),
        onPressed: () {
          context.pushTransparentRoute(
            NewsPage(
              heroTag: widget.heroTag,
              url: widget.news.newsUrl,
            ),
            rootNavigator: true,
          );
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
            child: Hero(
              tag: widget.heroTag,
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                              image: NetworkImage(widget.news.imageUrl),
                              frameBuilder: (context, child, frame,
                                  wasSynchronouslyLoaded) {
                                return child;
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
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
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          widget.news.typ,
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
                                            setState(() {
                                              bookmarked = !bookmarked;
                                            });
                                            widget.onBookmarked(widget.news);
                                          },
                                          color: bookmarked
                                              ? const Color.fromARGB(
                                                  255, 255, 255, 0)
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
                          widget.news.titel,
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  color: Colors.black,
                                  fontSize: 26,
                                  height: 1.2),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 100),
                          child: Text(
                            widget.news.subtitel,
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
                              widget.news.chipLabel,
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
      ),
    );
  }
}
