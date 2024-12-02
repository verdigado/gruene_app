import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/services/gruene_api_campaigns_service.dart';
import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/campaigns/helper/map_helper.dart';
import 'package:gruene_app/features/campaigns/helper/media_helper.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_create_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/posters/poster_update_model.dart';
import 'package:gruene_app/features/campaigns/screens/poster_add.dart';
import 'package:gruene_app/features/campaigns/screens/poster_detail.dart';
import 'package:gruene_app/features/campaigns/screens/poster_edit.dart';
import 'package:gruene_app/features/campaigns/widgets/app_route.dart';
import 'package:gruene_app/features/campaigns/widgets/content_page.dart';
import 'package:gruene_app/features/campaigns/widgets/filter_chip_widget.dart';
import 'package:gruene_app/features/campaigns/widgets/map.dart';
import 'package:gruene_app/features/campaigns/widgets/map_controller.dart';
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

class _PostersScreenState extends State<PostersScreen> {
  late MapController _mapController;
  final GrueneApiCampaignsService _grueneApiService = GrueneApiCampaignsService(poiType: PoiServiceType.poster);
  final NominatimService _nominatimService = NominatimService();

  @override
  Widget build(localContext) {
    MapContainer mapContainer = MapContainer(
      onMapCreated: _onMapCreated,
      addPOIClicked: _addPOIClicked,
      loadVisibleItems: _loadVisibleItems,
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

  void _onMapCreated(MapController controller) {
    _mapController = controller;
  }

  void _addPOIClicked(LatLng location) async {
    final currentRoute = GoRouterState.of(context);

    var locationAddress = _nominatimService.getLocationAddress(location);

    final photo = await MediaHelper.acquirePhoto(context);

    var navState = getNavState();
    final result = await navState.push(
      AppRoute<PosterCreateModel?>(
        builder: (context) {
          return FutureBuilder(
            future: locationAddress.timeout(const Duration(milliseconds: 800), onTimeout: () => AddressModel()),
            builder: (context, AsyncSnapshot<AddressModel> snapshot) {
              if (!snapshot.hasData && !snapshot.hasError) {
                return Container(
                  color: ThemeColors.secondary,
                );
              }

              final address = snapshot.data;
              return ContentPage(
                title: currentRoute.name ?? '',
                child: PosterAddScreen(
                  location: location,
                  address: address!,
                  photo: photo,
                ),
              );
            },
          );
        },
      ),
    );

    if (result != null) {
      final newPoster = result;

      final markerItem = await _grueneApiService.createNewPoster(newPoster);
      _mapController.addMarkerItem(markerItem);
    }
  }

  NavigatorState getNavState() => Navigator.of(context, rootNavigator: true);

  void _loadVisibleItems(LatLng locationSW, LatLng locationNE) async {
    final markerItems = await _grueneApiService.loadPoisInRegion(locationSW, locationNE);
    _mapController.setMarkerSource(markerItems);
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
    final poster = await _grueneApiService.getPoiAsPosterDetail(poiId);

    final coord = MapHelper.extractLatLngFromFeature(feature);
    var popupWidget = SizedBox(
      height: 100,
      width: 100,
      child: PosterDetail(
        poi: poster,
      ),
    );
    _mapController.showMapPopover(
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
    final updatedMarker = await _grueneApiService.updatePoi(posterUpdate);
    _mapController.setMarkerSource([updatedMarker]);
  }

  void _deletePoster(String posterId) async {
    final id = int.parse(posterId);
    await _grueneApiService.deletePoi(posterId);
    _mapController.removeMarkerItem(id);
  }
}
