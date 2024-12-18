import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/app/services/gruene_api_campaigns_service.dart';
import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/campaigns/helper/enums.dart';
import 'package:gruene_app/features/campaigns/helper/map_helper.dart';
import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';
import 'package:gruene_app/features/campaigns/widgets/app_route.dart';
import 'package:gruene_app/features/campaigns/widgets/content_page.dart';
import 'package:gruene_app/features/campaigns/widgets/map_controller.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

typedef GetAdditionalDataBeforeCallback<T> = Future<T?> Function(BuildContext);
typedef GetAddScreenCallback<T, U> = T Function(LatLng, AddressModel?, U?);
typedef SaveNewAndGetMarkerCallback<T> = Future<MarkerItemModel> Function(T);
typedef GetPoiCallback<T> = Future<T> Function(String);
typedef GetPoiDetailWidgetCallback<T> = Widget Function(T);
typedef GetPoiEditWidgetCallback<T> = Widget Function(T);
typedef OnDeletePoiCallback = void Function(String posterId);

abstract class MapConsumer<T extends StatefulWidget> extends State<T> {
  late MapController mapController;
  final NominatimService _nominatimService;

  bool focusAreasVisible = false;
  final String _focusAreadId = 'focusArea';
  final _minZoomFocusAreaLayer = 11.5;

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
    var locationAddress = _nominatimService.getLocationAddress(location);
    U? additionalData;
    if (acquireAdditionalDataBefore != null) {
      additionalData = await acquireAdditionalDataBefore(context);
    }
    var navState = getNavState();
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
                title: getCurrentRoute().name ?? '',
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

  NavigatorState getNavState() => Navigator.of(context, rootNavigator: true);
  GoRouterState getCurrentRoute() => GoRouterState.of(context);

  Future<void> loadVisibleItems(LatLng locationSW, LatLng locationNE) async {
    if (mapController.getCurrentZoomLevel() > mapController.minimumMarkerZoomLevel) {
      final markerItems = await campaignService.loadPoisInRegion(locationSW, locationNE);
      mapController.setMarkerSource(markerItems);
    }
  }

  void onFeatureClick<U>(
    dynamic rawFeature,
    GetPoiCallback<U> getPoi,
    GetPoiDetailWidgetCallback<U> getPoiDetail,
    GetPoiEditWidgetCallback<U> getPoiEdit, {
    Size desiredSize = const Size(100, 100),
  }) async {
    final feature = rawFeature as Map<String, dynamic>;
    final poiId = MapHelper.extractPoiIdFromFeature(feature);
    U poi = await getPoi(poiId);
    final poiDetailWidget = getPoiDetail(poi);
    var popupWidget = SizedBox(
      height: desiredSize.height,
      width: desiredSize.width,
      child: poiDetailWidget,
    );
    final coord = MapHelper.extractLatLngFromFeature(feature);
    mapController.showMapPopover(
      coord,
      popupWidget,
      () => _editPoi(() => getPoiEdit(poi)),
      desiredSize: desiredSize,
    );
  }

  void _editPoi(Widget Function() getEditWidget) async {
    await showModalEditForm(context, getEditWidget);
  }

  static Future<ModalEditResult?> showModalEditForm(BuildContext context, Widget Function() getEditWidget) async {
    final theme = Theme.of(context);
    return await showModalBottomSheet<ModalEditResult>(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      backgroundColor: theme.colorScheme.surface,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: getEditWidget(),
        ),
      ),
    );
  }

  void deletePoi(String poiId) async {
    final id = int.parse(poiId);
    await campaignService.deletePoi(poiId);
    mapController.removeMarkerItem(id);
  }

  void addMapLayersForContext(MapLibreMapController mapLibreController) async {
    final focusAreaBorderLayerId = '${_focusAreadId}_border';

    await mapLibreController.addFillLayer(
      _focusAreadId,
      focusAreaFillLayerId,
      FillLayerProperties(
        fillColor: [
          Expressions.interpolate,
          ['exponential', 0.5],
          [Expressions.zoom],
          18,
          ['get', 'score_color'],
        ],
        fillOpacity: ['get', 'score_opacity'],
      ),
      enableInteraction: false,
      minzoom: _minZoomFocusAreaLayer,
    );

    await mapLibreController.addLineLayer(
      _focusAreadId,
      focusAreaBorderLayerId,
      LineLayerProperties(lineColor: ThemeColors.background.toHexStringRGB(), lineWidth: 1),
      minzoom: _minZoomFocusAreaLayer,
      enableInteraction: false,
    );
  }

  void onFocusAreaStateChanged(bool state) async {
    focusAreasVisible = state;
    if (focusAreasVisible) {
      loadFocusAreaLayer();
    } else {
      mapController.removeLayerSource(_focusAreadId);
    }
  }

  String get focusAreaFillLayerId => '${_focusAreadId}_layer';
  void loadDataLayers(LatLng locationSW, LatLng locationNE) async {
    if (focusAreasVisible) {
      loadFocusAreaLayer();
    }
  }

  void loadFocusAreaLayer() async {
    if (mapController.getCurrentZoomLevel() > _minZoomFocusAreaLayer) {
      final bbox = await mapController.getCurrentBoundingBox();

      final focusAreas = await campaignService.loadFocusAreasInRegion(bbox.southwest, bbox.northeast);
      mapController.setLayerSource(_focusAreadId, focusAreas);
    }
  }

  void showFocusAreaInfoAtPoint(Point<double> point) async {
    if (!focusAreasVisible) return;
    var features = await mapController.getFeaturesInScreen(
      point,
      [focusAreaFillLayerId],
    );
    if (features.isNotEmpty) {
      final feature = features.first;
      if (feature['properties'] == null) return;
      final properties = feature['properties'] as Map<String, dynamic>;
      var infoText = <String>[];
      if (properties['info'] != null) infoText.add(properties['info'] as String);
      if (properties['score_info'] != null) infoText.add(properties['score_info'] as String);

      if (infoText.isNotEmpty) _showInfo(infoText.join('\n'));
    }
  }

  void _showInfo(String infoText) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          infoText,
        ),
        duration: Duration(milliseconds: 800),
      ),
    );
  }
}
