import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/app/models/campaigns/marker_item_model.dart';
import 'package:gruene_app/features/campaigns/helper/marker_item_helper.dart';
import 'package:gruene_app/features/campaigns/helper/util.dart';
import 'package:gruene_app/features/campaigns/widgets/map_controller.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

typedef OnMapCreatedCallback = void Function(MapController controller);
typedef AddPOIClickedCallback = void Function(LatLng location);
typedef LoadVisibleItemsCallBack = void Function(LatLng locationSW, LatLng locationNE);
typedef GetMarkerImagesCallback = Map<String, String> Function();

class MapContainer extends StatefulWidget {
  final OnMapCreatedCallback? onMapCreated;
  final AddPOIClickedCallback? addPOIClicked;
  final LoadVisibleItemsCallBack? loadVisibleItems;
  final GetMarkerImagesCallback getMarkerImages;

  const MapContainer({
    super.key,
    required this.onMapCreated,
    required this.addPOIClicked,
    required this.loadVisibleItems,
    required this.getMarkerImages,
  });

  @override
  State<StatefulWidget> createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> implements MapController {
  MapLibreMapController? _controller;
  final MarkerItemManager _markerItemManager = MarkerItemManager();
  bool _isMapInitialized = false;

  final LatLngBounds _cameraTargetBounds = LatLngBounds(
    southwest: LatLng(46.8, 5.6),
    northeast: LatLng(55.1, 15.5),
  ); //typically Germany

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapLibreMap(
            // minMaxZoomPreference: MinMaxZoomPreference(14, 18),
            styleString: Config.maplibreUrl,
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(target: LatLng(52.528810, 13.379300), zoom: 16),
            onStyleLoadedCallback: _onStyleLoadedCallback,
            cameraTargetBounds: CameraTargetBounds(_cameraTargetBounds),
            trackCameraPosition: true,
            onCameraIdle: _onCameraIdle,
            onMapClick: _onMapClick,

            // rotateGesturesEnabled: false,
          ),
          Center(
            child: Container(
              padding:
                  EdgeInsets.only(bottom: 65 /* height of the add_marker icon to position it exactly on the middle */),
              child: GestureDetector(
                onTap: _onIconTap,
                child: SvgPicture.asset('assets/symbols/add_marker.svg'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(MapLibreMapController controller) async {
    if (!mounted) return;

    setState(() {
      _controller = controller;
      _isMapInitialized = true;
    });

    final onMapCreated = widget.onMapCreated;
    if (onMapCreated != null) {
      onMapCreated(this);
    }
  }

  void _onIconTap() {
    final addPOIClicked = widget.addPOIClicked;

    if (addPOIClicked != null) {
      addPOIClicked(_controller!.cameraPosition!.target);
    }
  }

  void _onMapClick(Point<double> point, LatLng coordinates) {}

  void _onCameraIdle() async {
    if (!_isMapInitialized) return;
    final visRegion = await _controller?.getVisibleRegion();

    widget.loadVisibleItems!(visRegion!.southwest, visRegion.northeast);
  }

  void _onStyleLoadedCallback() async {
    widget.getMarkerImages().forEach((x, y) async {
      await addImageFromAsset(_controller!, x, y);
    });

    _controller!.addGeoJsonSource('markers', MarkerItemHelper.transformListToGeoJson(<MarkerItemModel>[]).toJson());

    await _controller!.addSymbolLayer(
      'markers',
      'symbols',
      const SymbolLayerProperties(
        iconImage: ['get', 'type'],
        iconSize: 2,
        iconAllowOverlap: true,
      ),
      filter: [
        '!',
        ['has', 'point_count'],
      ],
    );
  }

  @override
  void setMarkerSource(List<MarkerItemModel> poiList) {
    _markerItemManager.addMarkers(poiList);
    _controller!
        .setGeoJsonSource('markers', MarkerItemHelper.transformListToGeoJson(_markerItemManager.getMarkers()).toJson());
  }

  @override
  void addMarkerItem(MarkerItemModel markerItem) {
    setMarkerSource([markerItem]);
  }
}

class MarkerItemManager {
  final List<MarkerItemModel> loadedMarkers = [];

  void addMarkers(List<MarkerItemModel> poiList) {
    loadedMarkers.retainWhere((oldMarker) => poiList.any((newMarker) => newMarker.id != oldMarker.id));
    loadedMarkers.addAll(poiList);
  }

  List<MarkerItemModel> getMarkers() {
    return loadedMarkers;
  }
}
