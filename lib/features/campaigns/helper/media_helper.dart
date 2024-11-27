import 'dart:io';
import 'dart:typed_data';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/widgets.dart';
import 'package:gruene_app/features/campaigns/widgets/app_route.dart';
import 'package:image/image.dart' as IMG;

class MediaHelper {
  static const int maxUploadDimension = 1200;

  static Future<File?> acquirePhoto(BuildContext context) async {
    var image = await Navigator.of(context, rootNavigator: true).push(
      AppRoute(
        builder: (context) {
          return CameraAwesomeBuilder.awesome(
            saveConfig: SaveConfig.photo(),
            onMediaCaptureEvent: (mediaCapture) async {
              if (mediaCapture.status == MediaCaptureStatus.success) {
                final imageFile = File(mediaCapture.captureRequest.path!);
                Navigator.maybePop(context, imageFile);
              }
            },
          );
        },
      ),
    ) as File?;
    return image;
  }

  static Future<Uint8List> resizeAndReduceImage(Uint8List originalImage) async {
    Uint8List? resizedImg;
    // Uint8List? originalImage;

    final compressAction = Future.delayed(Duration.zero, () async {
      // if (newPoster.photo == null) return;
      // bytes = (await NetworkAssetBundle(Uri.parse(imgurl)).load(imgurl)).buffer.asUint8List();

      // originalImage = await newPoster.photo!.readAsBytes();
      IMG.Image? img = IMG.decodeImage(originalImage);
      IMG.Image resized;
      if (img!.height > maxUploadDimension || img.width > maxUploadDimension) {
        int desiredWidth, desiredHeight;
        if (img.width > img.height) {
          desiredWidth = maxUploadDimension;
          desiredHeight = (img.height / img.width * maxUploadDimension).round();
        } else {
          desiredHeight = maxUploadDimension;
          desiredWidth = (img.width / img.height * maxUploadDimension).round();
        }

        resized = IMG.copyResize(
          img,
          width: desiredWidth,
          height: desiredHeight,
          maintainAspect: true,
        );
      } else {
        resized = img;
      }
      // resizedImg = Uint8List.fromList(IMG.encodePng(resized));
      resizedImg = Uint8List.fromList(IMG.encodeJpg(resized, quality: 60));
    });

    await compressAction;
    return resizedImg!;
  }
}
