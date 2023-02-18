import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TopicCard extends StatefulWidget {
  const TopicCard({super.key});

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
  Image? img;

  @override
  void initState() {
    super.initState();
    img = Image.network(
      'https://cdn.shopify.com/s/files/1/0955/4450/products/peredovik-sunflower-seeds-29935185035421_compact.jpg?v=1628023632',
      width: 160,
      height: 160,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      child: Stack(children: [
        Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: img,
            )),
        Positioned(
            top: 10,
            left: 110,
            child: FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.white,
                mini: true,
                onPressed: () {
                  print('add');
                },
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).primaryColor,
                  size: 30,
                ))),
      ]),
    );
  }
}
