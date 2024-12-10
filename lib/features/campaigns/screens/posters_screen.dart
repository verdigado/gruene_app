import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gruene_app/app/services/enums.dart';
import 'package:gruene_app/app/services/gruene_api_campaigns_service.dart';
import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:gruene_app/features/campaigns/helper/media_helper.dart';
import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_create_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_update_model.dart';
import 'package:gruene_app/features/campaigns/screens/map_consumer.dart';
import 'package:gruene_app/features/campaigns/screens/poster_add_screen.dart';
import 'package:gruene_app/features/campaigns/screens/poster_detail.dart';
import 'package:gruene_app/features/campaigns/screens/poster_edit.dart';
import 'package:gruene_app/features/campaigns/widgets/filter_chip_widget.dart';
import 'package:gruene_app/features/campaigns/widgets/map.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class PostersScreen extends StatefulWidget {
  const PostersScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PostersScreenState();
}

class _PostersScreenState extends MapConsumer<PostersScreen> {
  final GrueneApiCampaignsService _grueneApiService = GrueneApiCampaignsService(poiType: PoiServiceType.poster);

  final List<FilterChipModel> postersFilter = [
    FilterChipModel(
      text: t.campaigns.filters.routes,
      isEnabled: false,
    ),
    FilterChipModel(
      text: t.campaigns.filters.polling_stations,
      isEnabled: false,
    ),
    FilterChipModel(
      text: t.campaigns.filters.experience_areas,
      isEnabled: false,
    ),
  ];

  _PostersScreenState() : super(NominatimService());

  @override
  GrueneApiCampaignsService get campaignService => _grueneApiService;

  @override
  Widget build(localContext) {
    MapContainer mapContainer = MapContainer(
      onMapCreated: onMapCreated,
      addPOIClicked: _addPOIClicked,
      loadVisibleItems: loadVisibleItems,
      getMarkerImages: _getMarkerImages,
      onFeatureClick: _onFeatureClick,
      onNoFeatureClick: _onNoFeatureClick,
    );

    return Column(
      children: [
        FilterChipCampaign(postersFilter, <String, List<String>>{}),
        Expanded(
          child: mapContainer,
        ),
      ],
    );
  }

  Future<File?> _acquireAdditionalDataBeforeShowingAddScreen(BuildContext context) async {
    return await MediaHelper.acquirePhoto(context);
  }

  PosterAddScreen _getAddScreen(LatLng location, AddressModel? address, File? photo) {
    return PosterAddScreen(
      location: location,
      address: address!,
      photo: photo,
    );
  }

  Future<MarkerItemModel> saveNewAndGetMarkerItem(PosterCreateModel newPoster) async =>
      await campaignService.createNewPoster(newPoster);

  void _addPOIClicked(LatLng location) async {
    super.addPOIClicked<File, PosterAddScreen, PosterCreateModel>(
      location,
      _acquireAdditionalDataBeforeShowingAddScreen,
      _getAddScreen,
      saveNewAndGetMarkerItem,
    );
  }

  Map<String, String> _getMarkerImages() {
    return {
      'poster_ok': 'assets/symbols/posters/poster.png',
      'poster_damaged': 'assets/symbols/posters/poster_damaged.png',
      'poster_missing': 'assets/symbols/posters/poster_damaged.png',
      'poster_removed': 'assets/symbols/posters/poster_removed.png',
    };
  }

  void _onFeatureClick(dynamic rawFeature) async {
    getPoi(String poiId) async {
      final poster = await campaignService.getPoiAsPosterDetail(poiId);
      return poster;
    }

    getPoiDetail(PosterDetailModel poster) {
      return PosterDetail(
        poi: poster,
      );
    }

    getEditPosterWidget(PosterDetailModel poster) {
      return PosterEdit(poster: poster, onSave: _savePoster, onDelete: deletePoi);
    }

    super.onFeatureClick<PosterDetailModel>(rawFeature, getPoi, getPoiDetail, getEditPosterWidget);
  }

  void _onNoFeatureClick() {}

  void _savePoster(PosterUpdateModel posterUpdate) async {
    final updatedMarker = await campaignService.updatePoster(posterUpdate);
    mapController.setMarkerSource([updatedMarker]);
  }
}
