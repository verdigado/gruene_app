import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/services/gruene_api_campaigns_service.dart';
import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';
import 'package:gruene_app/features/campaigns/widgets/app_route.dart';
import 'package:gruene_app/features/campaigns/widgets/content_page.dart';
import 'package:gruene_app/features/campaigns/widgets/map_controller.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

typedef GetAdditionalDataBeforeCallback<T> = Future<T?> Function(BuildContext);
typedef GetAddScreenCallback<T, U> = T Function(LatLng, AddressModel?, U?);
typedef SaveNewAndGetMarkerCallback<T> = Future<MarkerItemModel> Function(T);

abstract class MapConsumer<T extends StatefulWidget> extends State<T> {
  late MapController mapController;
  final NominatimService _nominatimService;

  MapConsumer(this._nominatimService);

  GrueneApiCampaignsService get campaignService;

  void onMapCreated(MapController controller) {
    mapController = controller;
  }

  void addPOIClicked<U, V extends Widget, W>(
    LatLng location,
    GetAdditionalDataBeforeCallback<U>? acquireAdditionalDataBefore,
    GetAddScreenCallback<V, U> getAddScreen,
    SaveNewAndGetMarkerCallback<W> saveAndGetMarker,
  ) async {
    final currentRoute = GoRouterState.of(context);

    var locationAddress = _nominatimService.getLocationAddress(location);
    U? additionalData;
    if (acquireAdditionalDataBefore != null) {
      additionalData = await acquireAdditionalDataBefore(context);
    }
    var navState = _getNavState();
    final result = await navState.push(
      AppRoute<W?>(
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
                child: getAddScreen(location, address, additionalData),
              );
            },
          );
        },
      ),
    );

    if (result != null) {
      final markerItem = await saveAndGetMarker(result);
      mapController.addMarkerItem(markerItem);
    }
  }

  NavigatorState _getNavState() => Navigator.of(context, rootNavigator: true);

  void loadVisibleItems(LatLng locationSW, LatLng locationNE) async {
    final markerItems = await campaignService.loadPoisInRegion(locationSW, locationNE);
    mapController.setMarkerSource(markerItems);
  }
}
