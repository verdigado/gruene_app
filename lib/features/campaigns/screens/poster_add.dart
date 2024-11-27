import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gruene_app/app/models/campaigns/posters/poster_create_model.dart';
import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/campaigns/helper/media_helper.dart';
import 'package:gruene_app/features/campaigns/widgets/textinputfield.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class PosterAddScreen extends StatefulWidget {
  final LatLng location;
  final AddressModel address;
  final File? photo;

  const PosterAddScreen({super.key, this.photo, required this.address, required this.location});

  @override
  State<StatefulWidget> createState() => _PostersAddState();
}

class _PostersAddState extends State<PosterAddScreen> {
  TextEditingController streetTextController = TextEditingController();
  TextEditingController houseNumberTextController = TextEditingController();
  TextEditingController zipCodeTextController = TextEditingController();
  TextEditingController cityTextController = TextEditingController();
  File? _currentPhoto;

  @override
  void initState() {
    streetTextController.text = widget.address.street ?? '';
    houseNumberTextController.text = widget.address.houseNumber ?? '';
    zipCodeTextController.text = widget.address.zipCode ?? '';
    cityTextController.text = widget.address.city ?? '';
    _currentPhoto = widget.photo;
    super.initState();
  }

  @override
  void dispose() {
    streetTextController.dispose();
    houseNumberTextController.dispose();
    zipCodeTextController.dispose();
    cityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  t.campaigns.posters.addPoster,
                  style: theme.textTheme.displayMedium,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ThemeColors.background, width: 1),
                  gradient: LinearGradient(
                    colors: [Color(0xFF03BD4E), Color(0xFF875CFF)],
                  ),
                ),
                child: getPhotoPreviewOrIcon(),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextInputField(
                    textController: streetTextController,
                    labelText: t.campaigns.address.street,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 6),
                  child: TextInputField(
                    width: 75,
                    labelText: t.campaigns.address.housenumber,
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
                    width: 75,
                    labelText: t.campaigns.address.zipcode,
                    textController: zipCodeTextController,
                  ),
                ),
                Expanded(
                  child: TextInputField(
                    labelText: t.campaigns.address.city_or_place,
                    textController: cityTextController,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: EdgeInsets.only(right: 6),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.background,
                        foregroundColor: ThemeColors.primary,
                      ),
                      child: Text(
                        t.campaigns.actions.cancel,
                        style: theme.textTheme.titleMedium?.apply(
                          color: ThemeColors.primary,
                        ),
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 48,
                    padding: EdgeInsets.only(left: 6),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.primary,
                        foregroundColor: ThemeColors.background,
                      ),
                      child: Text(
                        t.campaigns.actions.save,
                        style: theme.textTheme.titleMedium?.apply(
                          color: ThemeColors.background,
                        ),
                      ),
                      onPressed: () => onSavePressed(context),
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

  Widget getPhotoPreviewOrIcon() {
    if (_currentPhoto != null) {
      return Container(
        width: 150,
        height: 120,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: GestureDetector(
          onTap: acquireNewPhoto,
          child: Image.file(
            _currentPhoto!,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Center(
        child: GestureDetector(
          onTap: acquireNewPhoto,
          child: Icon(
            Icons.photo_camera,
            color: Colors.white,
            size: 30.0,
          ),
        ),
      );
    }
  }

  void acquireNewPhoto() async {
    final photo = await MediaHelper.acquirePhoto(context);
    // final photoBytes = await reduceAndResize(photo);

    if (photo != null) {
      setState(() {
        _currentPhoto = photo;
      });
    }
  }

  Future<Uint8List?> reduceAndResize(File? photo) async {
    if (photo == null) return null;
    final fileContent = await photo.readAsBytes();
    return await MediaHelper.resizeAndReduceImage(fileContent);
  }

  void onSavePressed(BuildContext localContext) async {
    final reducedImage = await reduceAndResize(_currentPhoto);
    if (!localContext.mounted) return;
    Navigator.maybePop(
      localContext,
      PosterCreateModel(
        location: widget.location,
        street: streetTextController.text,
        houseNumber: houseNumberTextController.text,
        zipCode: zipCodeTextController.text,
        city: cityTextController.text,
        photo: reducedImage,
      ),
    );
  }
}
