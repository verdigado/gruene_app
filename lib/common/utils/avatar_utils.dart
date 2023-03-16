import 'dart:typed_data';

import 'package:flutter/material.dart';

Widget circleAvatarImage(Uint8List? imageUrl,
    {editable = true, double radius = 40}) {
  if (editable) {
    return CircleAvatar(
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
      radius: radius,
      // TODO: Replace with NetworkImage
      backgroundImage: MemoryImage(imageUrl!),
    );
  }
}

Widget circleAvatarInitials(
  String initals, {
  double radius = 40,
  editable = false,
}) {
  if (editable) {
    return CircleAvatar(
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
    return CircleAvatar(radius: radius, child: Text(initals));
  }
}
