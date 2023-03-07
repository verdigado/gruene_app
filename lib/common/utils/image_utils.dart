import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gruene_app/common/exception/file_cropper_exception.dart';
import 'package:gruene_app/common/exception/permisson_exception.dart';
import 'package:gruene_app/common/logger.dart';
import 'package:gruene_app/common/utils/snackbars.dart';
import 'package:gruene_app/routing/router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File> cropImage(File img) async {
  final cropped = await ImageCropper().cropImage(
    sourcePath: img.path,
    compressFormat: ImageCompressFormat.jpg,
    cropStyle: CropStyle.circle,
  );
  if (cropped == null) {
    throw FileCropperException('The Cropped Editor has been Aborted');
  }
  return File(cropped.path);
}

Future<File?> getImageFromCameraOrGallery(ImageSource src) async {
  File? profilImg;
  try {
    Permission pem = Permission.storage;
    // Shift if ImageSource is Camera
    if (src == ImageSource.camera) {
      pem = Permission.camera;
    }
    var status = await pem.status;
    if (!status.isGranted) {
      await pem.request();
    }
    if (await pem.status.isGranted) {
      final img = await ImagePicker().pickImage(source: src);
      if (img == null) {
        // Interupt by the User no Image was Picked
        return null;
      }
      profilImg = File(img.path);
      return await cropImage(profilImg);
    } else {
      rootNavigatorKey.currentState?.pop();
      throw PermissionException('Fail on Permisson Request');
    }
  } on PlatformException catch (ex) {
    logger.i('Fail to getImage for Profile', [ex]);
  } on FileCropperException catch (ex) {
    logger.i('Fail to Crop img', [ex]);
  } finally {
    profilImg?.delete();
  }
}
