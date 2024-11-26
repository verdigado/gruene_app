import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/widgets.dart';
import 'package:gruene_app/features/campaigns/widgets/app_route.dart';

class MediaHelper {
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
}
