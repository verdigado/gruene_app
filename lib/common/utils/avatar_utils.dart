import 'package:flutter/material.dart';
import 'package:gruene_app/net/profile/bloc/data/profile.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';

Widget circleAvatarImage(Profile profile,
    {editable = true, double radius = 40}) {
  if (editable) {
    return CircleAvatar(
      radius: 40,
      // TODO: Replace with NetworkImage
      backgroundImage: MemoryImage(profile.profileImageUrl!),
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
      backgroundImage: MemoryImage(profile.profileImageUrl!),
    );
  }
}

Widget circleAvatarInitials(Profile profile, {double radius = 40}) {
  return CircleAvatar(radius: radius, child: Text(profile.initals));
}
