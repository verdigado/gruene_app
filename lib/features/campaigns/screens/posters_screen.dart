import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gruene_app/app/services/gruene_api_campaigns_service.dart';
import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:gruene_app/features/campaigns/helper/map_helper.dart';
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
  PostersScreen({super.key});

  final List<FilterChipModel> postersFilter = [
    FilterChipModel(t.campaigns.filters.routes, false),
    FilterChipModel(t.campaigns.filters.polling_stations, false),
    FilterChipModel(t.campaigns.filters.experience_areas, false),
  ];

  @override
  State<StatefulWidget> createState() => _PostersScreenState();
}

class _PostersScreenState extends MapConsumer<PostersScreen> {
  final GrueneApiCampaignsService _grueneApiService = GrueneApiCampaignsService(poiType: PoiServiceType.poster);

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
        FilterChipCampaign(widget.postersFilter, <String, List<String>>{}),
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
    final feature = rawFeature as Map<String, dynamic>;
    final poiId = MapHelper.extractPoiIdFromFeature(feature);
    final poster = await campaignService.getPoiAsPosterDetail(poiId);

    final coord = MapHelper.extractLatLngFromFeature(feature);
    var popupWidget = SizedBox(
      height: 100,
      width: 100,
      child: PosterDetail(
        poi: poster,
      ),
    );
    mapController.showMapPopover(
      coord,
      popupWidget,
      () => _editPosterItem(poster),
    );
  }

  void _onNoFeatureClick() {}

  void _editPosterItem(PosterDetailModel poster) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      backgroundColor: theme.colorScheme.surface,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: PosterEdit(poster: poster, onSave: _savePoster, onDelete: _deletePoster),
        ),
      ),
    );
  }

  void _savePoster(PosterUpdateModel posterUpdate) async {
    final updatedMarker = await campaignService.updatePoi(posterUpdate);
    mapController.setMarkerSource([updatedMarker]);
  }

  void _deletePoster(String posterId) async {
    final id = int.parse(posterId);
    await campaignService.deletePoi(posterId);
    mapController.removeMarkerItem(id);
  }
}
