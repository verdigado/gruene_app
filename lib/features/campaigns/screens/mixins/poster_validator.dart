part of '../mixins.dart';

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
