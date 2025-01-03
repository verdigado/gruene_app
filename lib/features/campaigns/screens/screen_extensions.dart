import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:motion_toast/motion_toast.dart';

mixin AddressExtension {
  abstract TextEditingController streetTextController;
  abstract TextEditingController houseNumberTextController;
  abstract TextEditingController zipCodeTextController;
  abstract TextEditingController cityTextController;

  void disposeAddressTextControllers() {
    streetTextController.dispose();
    houseNumberTextController.dispose();
    zipCodeTextController.dispose();
    cityTextController.dispose();
  }

  AddressModel getAddress() {
    return AddressModel(
      street: streetTextController.text,
      houseNumber: houseNumberTextController.text,
      zipCode: zipCodeTextController.text,
      city: cityTextController.text,
    );
  }

  void setAddress(AddressModel address) {
    streetTextController.text = address.street;
    houseNumberTextController.text = address.houseNumber;
    zipCodeTextController.text = address.zipCode;
    cityTextController.text = address.city;
  }
}

mixin FlyerValidator {
  ({int flyerCount})? validateFlyer(
    String flyerCountRawValue,
    BuildContext context,
  ) {
    final flyerCount = int.tryParse(flyerCountRawValue) ?? 0;
    if (flyerCount < 1) {
      final theme = Theme.of(context);
      MotionToast.error(
        description: Text(
          t.campaigns.flyer.noFlyerWarning,
          style: theme.textTheme.labelMedium!.apply(
            color: ThemeColors.background,
          ),
        ),
      ).show(context);
      return null;
    }
    return (flyerCount: flyerCount);
  }
}

mixin ConfirmDelete {
  void confirmDelete(BuildContext context, void Function() onDeletePressed) async {
    final theme = Theme.of(context);
    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeColors.alertBackground,
          title: Center(
            child: Text(
              '${t.campaigns.deleteEntry.label}?',
              style: theme.textTheme.titleMedium?.apply(color: theme.colorScheme.surface),
            ),
          ),
          content: Text(
            t.campaigns.deleteEntry.confirmation_dialog,
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
      onDeletePressed();
    }
  }
}

mixin DoorValidator {
  ({int closedDoors, int openedDoors})? validateDoors(
    String openedDoorsRawValue,
    String closedDoorsRawValue,
    BuildContext context,
  ) {
    final openedDoors = int.tryParse(openedDoorsRawValue) ?? 0;
    final closedDoors = int.tryParse(closedDoorsRawValue) ?? 0;
    if (openedDoors + closedDoors == 0) {
      final theme = Theme.of(context);
      MotionToast.error(
        description: Text(
          t.campaigns.door.noDoorsWarning,
          style: theme.textTheme.labelMedium!.apply(
            color: ThemeColors.background,
          ),
        ),
      ).show(context);
      return null;
    }
    return (closedDoors: closedDoors, openedDoors: openedDoors);
  }
}

mixin PosterValidator {
  bool validatePoster(
    File? currentPhoto,
    BuildContext context,
  ) {
    if (currentPhoto == null) {
      final theme = Theme.of(context);
      MotionToast.error(
        description: Text(
          t.campaigns.poster.noPhotoWarning,
          style: theme.textTheme.labelMedium!.apply(
            color: ThemeColors.background,
          ),
        ),
      ).show(context);
      return false;
    }
    return true;
  }
}
