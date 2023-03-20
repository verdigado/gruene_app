import 'dart:typed_data';

import 'package:flutter/material.dart';

class CircleAvatarImage extends StatelessWidget {
  final bool editable;
  final double radius;
  final Uint8List? imageUrl;

  const CircleAvatarImage(
      {super.key,
      required this.imageUrl,
      this.editable = true,
      this.radius = 40.0});

  @override
  Widget build(BuildContext context) {
    if (editable) {
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        radius: 40,
        // TODO: Replace with NetworkImage
        backgroundImage: MemoryImage(imageUrl!),
        child: const Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.edit),
            )),
      );
    } else {
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        radius: radius,
        // TODO: Replace with NetworkImage
        backgroundImage: MemoryImage(imageUrl!),
      );
    }
  }
}

class CircleAvatarInitials extends StatelessWidget {
  final String initals;

  final double radius;

  final bool editable;

  const CircleAvatarInitials({
    super.key,
    required this.initals,
    this.radius = 40.0,
    this.editable = false,
  });

  @override
  Widget build(BuildContext context) {
    if (editable) {
      return CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          radius: radius,
          child: Stack(
            children: [
              Align(alignment: Alignment.center, child: Text(initals)),
              const Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.edit),
                  ))
            ],
          ));
    } else {
      return CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          radius: radius,
          child: Text(initals));
    }
  }
}
