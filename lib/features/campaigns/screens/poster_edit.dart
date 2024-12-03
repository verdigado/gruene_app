import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/campaigns/helper/media_helper.dart';
import 'package:gruene_app/features/campaigns/helper/poster_status.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_update_model.dart';
import 'package:gruene_app/features/campaigns/widgets/multiline_text_input_field.dart';
import 'package:gruene_app/features/campaigns/widgets/textinputfield.dart';
import 'package:gruene_app/i18n/translations.g.dart';

typedef OnSavePosterCallback = void Function(PosterUpdateModel posterUpdate);
typedef OnDeletePosterCallback = void Function(String posterId);

class PosterEdit extends StatefulWidget {
  static const dummyAsset = 'assets/splash/logo_android12.png';
  final PosterDetailModel poster;
  final OnSavePosterCallback onSave;
  final OnDeletePosterCallback onDelete;

  const PosterEdit({
    super.key,
    required this.poster,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<PosterEdit> createState() => _PosterEditState();
}

class _PosterEditState extends State<PosterEdit> {
  Set<PosterStatus> _segmentedButtonSelection = <PosterStatus>{};

  TextEditingController streetTextController = TextEditingController();
  TextEditingController houseNumberTextController = TextEditingController();
  TextEditingController zipCodeTextController = TextEditingController();
  TextEditingController cityTextController = TextEditingController();
  TextEditingController commentTextController = TextEditingController();

  File? _currentPhoto;
  bool _isPhotoDeleted = false;

  @override
  void initState() {
    streetTextController.text = widget.poster.street;
    houseNumberTextController.text = widget.poster.houseNumber;
    zipCodeTextController.text = widget.poster.zipCode;
    cityTextController.text = widget.poster.city;
    commentTextController.text = widget.poster.comment;
    if (widget.poster.status != PosterStatus.ok) _segmentedButtonSelection = {widget.poster.status};

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = _getSegmentedButtonStyle(theme);
    final currentSize = MediaQuery.of(context).size;
    var imageRowHeight = 130.0;
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _closeDialog,
                  child: Icon(Icons.close),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _savePoster,
                    child: Text(
                      t.common.actions.save,
                      textAlign: TextAlign.right,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ),
              ],
            ),
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
                          left: 10,
                          bottom: 5,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: GestureDetector(
                              onTap: _deleteAndAcquireNewPhoto,
                              child: Text(
                                t.campaigns.posters.delete_photo,
                                style: theme.textTheme.labelMedium!.apply(
                                  color: theme.colorScheme.surface,
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
                        Positioned.fill(
                          right: 10,
                          bottom: 5,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: _acquireNewPhoto,
                              child: Text(
                                t.campaigns.posters.replace_photo,
                                style: theme.textTheme.labelMedium!.apply(
                                  color: theme.colorScheme.surface,
                                  fontWeightDelta: 2,
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
              children: [Text(t.campaigns.posters.editPoster, style: theme.textTheme.titleLarge)],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextInputField(
                    labelText: t.campaigns.address.street,
                    borderColor: theme.colorScheme.tertiary,
                    textController: streetTextController,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 6),
                  child: TextInputField(
                    labelText: t.campaigns.address.housenumber,
                    width: 75,
                    borderColor: theme.colorScheme.tertiary,
                    textController: houseNumberTextController,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 6),
                  child: TextInputField(
                    labelText: t.campaigns.address.zipcode,
                    width: 75,
                    borderColor: theme.colorScheme.tertiary,
                    textController: zipCodeTextController,
                  ),
                ),
                Expanded(
                  child: TextInputField(
                    labelText: t.campaigns.address.city_or_place,
                    borderColor: theme.colorScheme.tertiary,
                    textController: cityTextController,
                  ),
                ),
              ],
            ),
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
                          segments: PosterStatusHelper.getPosterStatusOptions
                              .map<ButtonSegment<PosterStatus>>(((PosterStatus, String, String) posterStatusContext) {
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
                    labelText: t.campaigns.posters.comment.label,
                    hint: t.campaigns.posters.comment.hint,
                    textController: commentTextController,
                    borderColor: theme.colorScheme.tertiary,
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
                    t.campaigns.posters.deletePoster.hint,
                    style: theme.textTheme.labelMedium?.apply(color: ThemeColors.textDisabled),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 6, bottom: 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onDeletePressed,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: ThemeColors.textWarning,
                      backgroundColor: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        side: BorderSide(
                          color: ThemeColors.textWarning,
                        ),
                      ),
                    ),
                    child: Text(
                      t.campaigns.posters.deletePoster.label,
                      style: theme.textTheme.titleMedium?.apply(color: ThemeColors.textWarning),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPosterPreview() {
    Widget getDummyAsset() => Image.asset(
          PosterEdit.dummyAsset,
        );
    if (_currentPhoto != null) {
      return Image.file(
        _currentPhoto!,
        fit: BoxFit.cover,
      );
    }
    if (_isPhotoDeleted) return getDummyAsset();
    return FutureBuilder(
      future: Future.delayed(Duration.zero, () => widget.poster.imageUrl),
      builder: (context, snapshot) {
        if (!snapshot.hasData && !snapshot.hasError) {
          return getDummyAsset();
        }

        return FadeInImage.assetNetwork(
          placeholder: PosterEdit.dummyAsset,
          image: snapshot.data!,
          fit: BoxFit.cover,
        );
      },
    );
  }

  void _onDeletePressed() async {
    final theme = Theme.of(context);
    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeColors.alertBackground,
          title: Center(
            child: Text(
              '${t.campaigns.posters.deletePoster.label}?',
              style: theme.textTheme.titleMedium?.apply(color: theme.colorScheme.surface),
            ),
          ),
          content: Text(
            t.campaigns.posters.deletePoster.confirmation_dialog,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.apply(
              color: theme.colorScheme.surface,
              fontSizeDelta: 1,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.maybePop(context, false),
              child: Text(
                t.common.actions.cancel,
                style: theme.textTheme.labelLarge?.apply(color: ThemeColors.textCancel),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.maybePop(context, true),
              child: Text(
                t.common.actions.delete,
                style: theme.textTheme.labelLarge?.apply(
                  color: ThemeColors.textWarning,
                  fontWeightDelta: 2,
                ),
              ),
            ),
          ],
        );
      },
    );
    if (shouldDelete ?? false) {
      _deleteAndReturn();
    }
  }

  void _deleteAndReturn() {
    widget.onDelete(widget.poster.id);
    _closeDialog();
  }

  void _closeDialog() {
    Navigator.maybePop(context);
  }

  void _savePoster() async {
    final reducedImage = await MediaHelper.resizeAndReduceImageFile(_currentPhoto);

    final updateModel = PosterUpdateModel(
      id: widget.poster.id,
      street: streetTextController.text,
      housenumber: houseNumberTextController.text,
      zipCode: zipCodeTextController.text,
      city: cityTextController.text,
      status: _segmentedButtonSelection.isEmpty ? PosterStatus.ok : _segmentedButtonSelection.single,
      comment: commentTextController.text,
      removePreviousPhotos: _isPhotoDeleted,
      newPhoto: reducedImage,
    );
    widget.onSave(updateModel);
    _closeDialog();
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
}
