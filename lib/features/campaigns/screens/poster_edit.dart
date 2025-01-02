import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/campaigns/helper/campaign_constants.dart';
import 'package:gruene_app/features/campaigns/helper/enums.dart';
import 'package:gruene_app/features/campaigns/helper/media_helper.dart';
import 'package:gruene_app/features/campaigns/helper/poster_status.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_update_model.dart';
import 'package:gruene_app/features/campaigns/screens/map_consumer.dart';
import 'package:gruene_app/features/campaigns/screens/screen_extensions.dart';
import 'package:gruene_app/features/campaigns/widgets/close_save_widget.dart';
import 'package:gruene_app/features/campaigns/widgets/create_address_widget.dart';
import 'package:gruene_app/features/campaigns/widgets/delete_and_save_widget.dart';
import 'package:gruene_app/features/campaigns/widgets/multiline_text_input_field.dart';
import 'package:gruene_app/i18n/translations.g.dart';

typedef OnSavePosterCallback = Future<void> Function(PosterUpdateModel posterUpdate);

class PosterEdit extends StatefulWidget {
  final PosterDetailModel poster;
  final OnSavePosterCallback onSave;
  final OnDeletePoiCallback onDelete;

  const PosterEdit({
    super.key,
    required this.poster,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<PosterEdit> createState() => _PosterEditState();
}

class _PosterEditState extends State<PosterEdit> with AddressExtension, ConfirmDelete, PosterValidator {
  Set<PosterStatus> _segmentedButtonSelection = <PosterStatus>{};

  @override
  TextEditingController streetTextController = TextEditingController();
  @override
  TextEditingController houseNumberTextController = TextEditingController();
  @override
  TextEditingController zipCodeTextController = TextEditingController();
  @override
  TextEditingController cityTextController = TextEditingController();
  TextEditingController commentTextController = TextEditingController();

  File? _currentPhoto;
  bool _isPhotoDeleted = false;

  bool _isWorking = false;

  @override
  void dispose() {
    disposeAddressTextControllers();
    commentTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setAddress(widget.poster.address);
    commentTextController.text = widget.poster.comment;
    if (widget.poster.status != PosterStatus.ok) _segmentedButtonSelection = {widget.poster.status};

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = _getSegmentedButtonStyle(theme);
    final currentSize = MediaQuery.of(context).size;
    final lightBorderColor = ThemeColors.textLight;
    var imageRowHeight = 130.0;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: CloseSaveWidget(onClose: () => _closeDialog(ModalEditResult.cancel)),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: imageRowHeight,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.zero),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: currentSize.width,
                              height: imageRowHeight,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(10), bottom: Radius.zero),
                              ),
                              child: _getPosterPreview(),
                            ),
                            Positioned.fill(
                              right: 10,
                              top: 5,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: _pickImageFromDevice,
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ThemeColors.secondary.withAlpha(100),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.add_photo_alternate,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              left: 10,
                              bottom: 5,
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: GestureDetector(
                                  onTap: _deleteAndAcquireNewPhoto,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 15, right: 20),
                                    decoration: BoxDecoration(color: ThemeColors.background.withAlpha(0)),
                                    child: Text(
                                      t.campaigns.poster.delete_photo,
                                      style: theme.textTheme.labelMedium!.apply(
                                        color: theme.colorScheme.surface,
                                        fontSizeDelta: 2,
                                        letterSpacingDelta: 2,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(-1.5, -1.5),
                                            color: theme.colorScheme.secondary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              right: 10,
                              bottom: 5,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: _acquireNewPhoto,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 15, left: 20),
                                    decoration: BoxDecoration(color: ThemeColors.background.withAlpha(0)),
                                    child: Text(
                                      t.campaigns.poster.replace_photo,
                                      style: theme.textTheme.labelMedium!.apply(
                                        color: theme.colorScheme.surface,
                                        fontSizeDelta: 2,
                                        fontWeightDelta: 2,
                                        letterSpacingDelta: 2,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(-1.5, -1.5),
                                            color: theme.colorScheme.secondary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [Text(t.campaigns.poster.editPoster, style: theme.textTheme.titleLarge)],
                ),
              ),
              CreateAddressWidget(
                streetTextController: streetTextController,
                houseNumberTextController: houseNumberTextController,
                zipCodeTextController: zipCodeTextController,
                cityTextController: cityTextController,
                inputBorderColor: lightBorderColor,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: SegmentedButton<PosterStatus>(
                              multiSelectionEnabled: false,
                              emptySelectionAllowed: true,
                              showSelectedIcon: false,
                              selected: _segmentedButtonSelection,
                              onSelectionChanged: (Set<PosterStatus> newSelection) {
                                setState(() {
                                  _segmentedButtonSelection = newSelection;
                                });
                              },
                              segments: PosterStatusHelper.getPosterStatusOptions.map<ButtonSegment<PosterStatus>>(
                                  ((PosterStatus, String, String) posterStatusContext) {
                                return ButtonSegment<PosterStatus>(
                                  value: posterStatusContext.$1,
                                  label: Text(posterStatusContext.$2),
                                );
                              }).toList(),
                              style: buttonStyle,
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            child: Text(
                              _getCurrentPosterStatusHint(),
                              style: theme.textTheme.labelMedium!.apply(
                                color: ThemeColors.textDisabled,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                height: 140,
                child: Row(
                  children: [
                    Expanded(
                      child: MultiLineTextInputField(
                        labelText: t.campaigns.poster.comment.label,
                        hint: t.campaigns.poster.comment.hint,
                        textController: commentTextController,
                        borderColor: lightBorderColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        t.campaigns.poster.deletePoster.hint,
                        style: theme.textTheme.labelMedium?.apply(color: ThemeColors.textDisabled),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 6, bottom: 24),
                child: DeleteAndSaveWidget(
                  onDelete: () => confirmDelete(context, _onDeletePressed),
                  onSave: _savePoster,
                ),
              ),
            ],
          ),
        ),
        _getLoadingScreen(),
      ],
    );
  }

  Widget _getPosterPreview() {
    Widget getDummyAsset() => Image.asset(CampaignConstants.dummyImageAssetName);

    if (_currentPhoto != null) {
      return GestureDetector(
        onTap: _showPictureFullView,
        child: Image.file(
          _currentPhoto!,
          fit: BoxFit.cover,
        ),
      );
    }
    if (_isPhotoDeleted) return getDummyAsset();
    return FutureBuilder(
      future: Future.delayed(Duration.zero, () => widget.poster.imageUrl),
      builder: (context, snapshot) {
        if (!snapshot.hasData && !snapshot.hasError) {
          return getDummyAsset();
        }

        return GestureDetector(
          onTap: _showPictureFullView,
          child: FadeInImage.assetNetwork(
            placeholder: CampaignConstants.dummyImageAssetName,
            image: snapshot.data!,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  void _onDeletePressed() async {
    widget.onDelete(widget.poster.id);
    _closeDialog(ModalEditResult.delete);
  }

  void _closeDialog(ModalEditResult editResult) {
    Navigator.maybePop(context, editResult);
  }

  void _savePoster() async {
    if (!context.mounted) return;
    if (!validatePoster(_currentPhoto, context)) return;

    setState(() {
      _isWorking = true;
    });

    final reducedImage = await Future.delayed(
      Duration(milliseconds: 250),
      () => MediaHelper.resizeAndReduceImageFile(_currentPhoto),
    );

    final updateModel = PosterUpdateModel(
      id: widget.poster.id,
      address: getAddress(),
      status: _segmentedButtonSelection.isEmpty ? PosterStatus.ok : _segmentedButtonSelection.single,
      comment: commentTextController.text,
      removePreviousPhotos: _isPhotoDeleted,
      newPhoto: reducedImage,
    );
    await widget.onSave(updateModel);

    _closeDialog(ModalEditResult.save);
  }

  ButtonStyle _getSegmentedButtonStyle(ThemeData theme) {
    final WidgetStateProperty<Color?> segmentedButtonBackgroundColor = WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return ThemeColors.secondary;
        }
        return ThemeColors.background;
      },
    );
    final WidgetStateProperty<Color?> segmentedButtonForegroundColor = WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return ThemeColors.background;
        }
        return ThemeColors.text;
      },
    );

    final WidgetStateProperty<TextStyle?> segmentedButtonTextStyle = WidgetStateProperty.resolveWith<TextStyle?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return theme.textTheme.labelMedium!.apply(
            color: Colors.red,
          );
        }
        return theme.textTheme.labelMedium;
      },
    );

    return ButtonStyle(
      textStyle: segmentedButtonTextStyle, //WidgetStatePropertyAll(theme.textTheme.labelMedium),
      backgroundColor: segmentedButtonBackgroundColor,
      foregroundColor: segmentedButtonForegroundColor,
      side: WidgetStatePropertyAll(BorderSide(color: ThemeColors.secondary)),
    );
  }

  String _getCurrentPosterStatusHint() {
    if (_segmentedButtonSelection.isEmpty) return '';
    return _segmentedButtonSelection.map(
      (selected) {
        return PosterStatusHelper.getPosterStatusOptions
            .firstWhere(((PosterStatus, String, String) posterStatusContext) => posterStatusContext.$1 == selected)
            .$3;
      },
    ).join('; ');
  }

  void _acquireNewPhoto() async {
    final photo = await MediaHelper.acquirePhoto(context);

    if (photo != null) {
      setState(() {
        _currentPhoto = photo;
      });
    }
  }

  void _deleteAndAcquireNewPhoto() {
    if (_currentPhoto != null || widget.poster.imageUrl != null) {
      setState(() {
        _isPhotoDeleted = true;
        _currentPhoto = null;
      });
    }
  }

  void _showPictureFullView() async {
    ImageProvider imageProvider;
    if (_currentPhoto != null) {
      imageProvider = FileImage(_currentPhoto!);
    } else {
      imageProvider = NetworkImage(widget.poster.imageUrl!);
    }
    MediaHelper.showPictureInFullView(context, imageProvider);
  }

  Widget _getLoadingScreen() {
    if (!_isWorking) return SizedBox(height: 0, width: 0);
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(color: ThemeColors.text.withAlpha(120)),
        child: Center(
          child: CircularProgressIndicator(
            color: ThemeColors.primary,
          ),
        ),
      ),
    );
  }

  void _pickImageFromDevice() async {
    final photo = await MediaHelper.pickImageFromDevice(context);

    if (photo != null) {
      setState(() {
        _currentPhoto = photo;
      });
    }
  }
}
