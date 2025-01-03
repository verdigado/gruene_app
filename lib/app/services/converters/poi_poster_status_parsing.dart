part of '../converters.dart';

extension PoiPosterStatusParsing on PoiPosterStatus {
  PosterStatus transformToModelPosterStatus() {
    return switch (this) {
      PoiPosterStatus.ok => PosterStatus.ok,
      PoiPosterStatus.damaged => PosterStatus.damaged,
      PoiPosterStatus.missing => PosterStatus.missing,
      PoiPosterStatus.removed => PosterStatus.removed,
      PoiPosterStatus.swaggerGeneratedUnknown => throw UnimplementedError(),
    };
  }

  String translatePosterStatus() {
    return switch (this) {
      PoiPosterStatus.ok => '',
      PoiPosterStatus.damaged => t.campaigns.poster.status.damaged.label,
      PoiPosterStatus.removed => t.campaigns.poster.status.removed.label,
      PoiPosterStatus.missing => t.campaigns.poster.status.missing.label,
      PoiPosterStatus.swaggerGeneratedUnknown => throw UnimplementedError(),
    };
  }
}
