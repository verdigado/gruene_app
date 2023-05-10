import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/common/exception/permisson_exception.dart';
import 'package:gruene_app/common/logger.dart';
import 'package:gruene_app/common/utils/avatar_utils.dart';
import 'package:gruene_app/common/utils/image_utils.dart';
import 'package:gruene_app/constants/layout.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';
import 'package:gruene_app/widget/modals/modal_top_line.dart';
import 'package:gruene_app/widget/modals/multi_modal_select.dart';
import 'package:gruene_app/widget/profil_value_card.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          return BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state.status == ProfileStatus.profileImageRemoveError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Center(
                  child: Text(AppLocalizations.of(context)!
                      .profileImageRemoveErrorMessage),
                )));
                context.read<ProfileBloc>().add(const GetProfile());
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  left: medium1, bottom: small, top: small, right: medium1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.profileShow,
                    style: Theme.of(context).primaryTextTheme.displaySmall,
                  ),
                  const SizedBox(
                    height: medium1,
                  ),
                  if (state.status == ProfileStatus.ready) ...[
                    InkWell(
                      onTap: () => openImagePickerModal(context),
                      child: state.profile.profileImageUrl != null &&
                              state.profile.profileImageUrl!.isNotEmpty
                          ? CircleAvatarImage(
                              imageUrl: state.profile.profileImageUrl,
                            )
                          : CircleAvatarInitials(
                              initals: state.profile.initals,
                              editable: true,
                            ),
                    ),
                    const SizedBox(
                      height: medium1,
                    ),
                    Text(state.profile.displayName,
                        style:
                            Theme.of(context).primaryTextTheme.headlineSmall),
                    ProfilValueCard(
                      label: 'E-Mail-Adresse',
                      value: state.profile.memberProfil.email.value.first.value,
                      visibility: state.profile.memberProfil.email.visible,
                      ontoggleVisibility: (v) => context
                          .read<ProfileBloc>()
                          .add(UpdateProfileValueVisibility('email', v)),
                      onEdit: () => openEmailEditModal(),
                    ),
                    ProfilValueCard(
                      label: 'Telefon',
                      value:
                          state.profile.memberProfil.telefon.value.first.value,
                      visibility: state.profile.memberProfil.telefon.visible,
                      ontoggleVisibility: (v) => context
                          .read<ProfileBloc>()
                          .add(UpdateProfileValueVisibility('telefon', v)),
                      onEdit: () => openTelefonlEditModal(),
                    )
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> openTelefonlEditModal() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return MultiModalSelect(
              inputHint: AppLocalizations.of(context)!.telefonnumber,
              inputLabel: AppLocalizations.of(context)!.telefonnumber,
              inputHeadline:
                  AppLocalizations.of(context)!.telefonnumberAsFavTitle,
              onAddValue: (String value) => context
                  .read<ProfileBloc>()
                  .add(MemberProfileAddValue('telefon', value)),
              onAddFavouriteValue: (favItemIndex) {
                context.read<ProfileBloc>().add(
                    SetFavoritProfile(favTelfonnumberItemIndex: favItemIndex));
              },
              values: [
                ...state.profile.memberProfil.telefon.value.map((e) => e.value)
              ],
              initalTextinputValue: '+49',
              textInputType: TextInputType.phone,
              validate: (value) {
                return value != null &&
                    value.isNotEmpty &&
                    !state.profile.memberProfil.telefon.value
                        .map((e) => e.value)
                        .contains(value) &&
                    value.startsWith('+') &&
                    value.length <= 16;
              },
            );
          },
        );
      },
    );
  }

  Future<void> openEmailEditModal() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return MultiModalSelect(
              inputHeadline: AppLocalizations.of(context)!.emailAsFavTitle,
              inputHint: AppLocalizations.of(context)!.emailAdress,
              inputLabel: AppLocalizations.of(context)!.emailAdress,
              onAddValue: (String value) => context
                  .read<ProfileBloc>()
                  .add(MemberProfileAddValue('email', value)),
              onAddFavouriteValue: (favItemIndex) {
                context
                    .read<ProfileBloc>()
                    .add(SetFavoritProfile(favEmailItemIndex: favItemIndex));
              },
              values: [
                ...state.profile.memberProfil.email.value.map((e) => e.value)
              ],
              textInputType: TextInputType.emailAddress,
              validate: (value) {
                return value != null &&
                    value.isNotEmpty &&
                    !state.profile.memberProfil.email.value
                        .map((e) => e.value)
                        .contains(value) &&
                    value.contains('@');
              },
            );
          },
        );
      },
    );
  }

  void openImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (ctx, con) {
            return SizedBox(
              height: con.maxHeight / 100 * 40,
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
                          const Icon(
                            Icons.camera_alt_outlined,
                            size: medium3,
                          ),
                          const SizedBox(
                            width: small,
                          ),
                          Text(
                            AppLocalizations.of(context)!.takePhoto,
                            style: const TextStyle(fontSize: medium1),
                          )
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
                          const Icon(
                            Icons.image_outlined,
                            size: medium3,
                          ),
                          const SizedBox(
                            width: small,
                          ),
                          Text(AppLocalizations.of(context)!.selectFromLibary,
                              style: const TextStyle(fontSize: medium1))
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
                          const Icon(
                            Icons.delete_outline,
                            size: medium3,
                          ),
                          const SizedBox(
                            width: small,
                          ),
                          Text(AppLocalizations.of(context)!.profilPhotoDelete,
                              style: const TextStyle(fontSize: medium1))
                        ],
                      ),
                    ),
                    const SizedBox(
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
        final data = await res.readAsBytes();
        if (await res.exists()) {
          res.delete();
        }
        return data;
      }
    } on PermissionException catch (ex) {
      logger.i([ex]);
      var res = await showOkCancelAlertDialog(
        context: context,
        okLabel: AppLocalizations.of(context)!.openSettings,
        message:
            '${AppLocalizations.of(context)!.permissonDeniedOpenSettings} ${src.name}',
      );
      if (res.name == OkCancelResult.ok.name) {
        openAppSettings();
      }
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
