import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/common/exception/file_cropper_exception.dart';
import 'package:gruene_app/common/exception/permisson_exception.dart';
import 'package:gruene_app/common/logger.dart';
import 'package:gruene_app/common/utils/avatar_utils.dart';
import 'package:gruene_app/common/utils/image_utils.dart';
import 'package:gruene_app/common/utils/snackbars.dart';
import 'package:gruene_app/constants/layout.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:gruene_app/main.dart';
import 'package:gruene_app/net/profile/data/profile.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';
import 'package:gruene_app/routing/router.dart';
import 'package:gruene_app/widget/modal_top_line.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(left: medium1, bottom: small, top: small),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profil',
                  style: Theme.of(context).primaryTextTheme.displaySmall,
                ),
                if (state is ProfileReady) ...[
                  InkWell(
                    onTap: () => openImagePickerModal(context),
                    child: state.profile.profileImageUrl != null &&
                            state.profile.profileImageUrl!.isNotEmpty
                        ? circleAvatarImage(state.profile)
                        : circleAvatarInitials(state.profile, editable: true),
                  ),
                  SizedBox(
                    height: medium1,
                  ),
                  Text(state.profile.description),
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  openImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (ctx, con) {
            return SizedBox(
              height: con.maxHeight / 100 * 45,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const ModalTopLine(color: Colors.grey),
                    InkWell(
                      onTap: () =>
                          uploadProfileImage(context, ImageSource.camera)
                              .then(sendImage)
                              .then((value) => value
                                  ? context.pop()
                                  : logger.i('Image not Send')),
                      child: Row(
                        children: [
                          const Icon(Icons.camera_alt_outlined),
                          SizedBox(
                            width: small,
                          ),
                          const Text('Foto Aufnehmen')
                        ],
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () =>
                          uploadProfileImage(context, ImageSource.gallery)
                              .then(sendImage)
                              .then((value) => value
                                  ? context.pop()
                                  : logger.i('Image not Send')),
                      child: Row(
                        children: [
                          const Icon(Icons.image_outlined),
                          SizedBox(
                            width: small,
                          ),
                          const Text('Aus der Bibliothek auswählen')
                        ],
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        removeProfileImage();
                        context.pop();
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline),
                          SizedBox(
                            width: small,
                          ),
                          const Text('Profilbild löschen')
                        ],
                      ),
                    ),
                    SizedBox(
                      height: small,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<Uint8List> uploadProfileImage(
      BuildContext context, ImageSource src) async {
    try {
      final res = await getImageFromCameraOrGallery(src);
      if (res != null) {
        return await res.readAsBytes();
      }
    } on PermissionException catch (ex) {
      logger.i([ex]);
      permissonDeniedSnackbar(src.name);
    }
    return Uint8List(0);
  }

  bool sendImage(Uint8List img) {
    if (img.isNotEmpty) {
      context.read<ProfileBloc>().add(UploadProfileImage(img));
      return true;
    }
    return false;
  }

  void removeProfileImage() {
    context.read<ProfileBloc>().add(const RemoveProfileImage());
  }
}
