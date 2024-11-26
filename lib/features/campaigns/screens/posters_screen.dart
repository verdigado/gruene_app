import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/models/campaigns/posters/poster_create_model.dart';
import 'package:gruene_app/app/services/gruene_api_service.dart';
import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/campaigns/helper/media_helper.dart';
import 'package:gruene_app/features/campaigns/screens/poster_add.dart';
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
  final GrueneApiService _grueneApiService = GrueneApiService(poiType: PoiServiceType.poster);
  final NominatimService _nominatimService = NominatimService();

  @override
  Widget build(BuildContext) {
    MapContainer mapContainer = MapContainer(
      onMapCreated: onMapCreated,
      addPOIClicked: addPOIClicked,
      loadVisibleItems: loadVisibleItems,
      getMarkerImages: getMarkerImages,
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

  void onMapCreated(MapController controller) {
    _mapController = controller;
  }

  void addPOIClicked(LatLng location) async {
    final currentRoute = GoRouterState.of(context);

    var locationAddress = _nominatimService.getLocationAddress(location);

    final photo = await MediaHelper.acquirePhoto(context);

    final result = await Navigator.of(context, rootNavigator: true).push(
      AppRoute(
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
    ) as PosterCreateModel?;

    if (result != null) {
      final newPoster = result;

      final markerItem = await _grueneApiService.createNewPoster(newPoster);
      _mapController.addMarkerItem(markerItem);
    }
  }

  void loadVisibleItems(LatLng locationSW, LatLng locationNE) async {
    // final resultHealth = await _grueneApiService.getHealth();
    // print(resultHealth.error);

    final markerItems = await _grueneApiService.loadPoisInRegion(locationSW, locationNE);
    _mapController.setMarkerSource(markerItems);
  }

  Map<String, String> getMarkerImages() {
    return {
      'poster': 'assets/symbols/posters/poster.png',
      'poster_damaged': 'assets/symbols/posters/poster_damaged.png',
      'poster_taken_down': 'assets/symbols/posters/poster_taken_down.png',
    };
  }
}
