import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/common/utils/avatar_utils.dart';
import 'package:gruene_app/constants/layout.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';
import 'package:gruene_app/net/profile/data/profile.dart';

class ProfileListViewHeader extends StatelessWidget {
  final void Function() onTap;
  final Profile profile;

  const ProfileListViewHeader({
    super.key,
    required this.onTap,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8, top: 8),
          child: Text(
            'Profil',
            style: Theme.of(context).primaryTextTheme.displaySmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: InkWell(
            onTap: () => onTap(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profile.profileImageUrl != null &&
                        profile.profileImageUrl!.isNotEmpty
                    ? circleAvatarImage(profile.profileImageUrl,
                        editable: false, radius: 24)
                    : circleAvatarInitials(profile.initals, radius: 24),
                SizedBox(
                  width: small,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.displayName,
                        style: Theme.of(context).primaryTextTheme.displaySmall),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => onTap(),
                      child: Column(
                        children: const [Text('Profil anzeigen')],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
