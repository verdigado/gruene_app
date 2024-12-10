import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/campaigns/helper/map_helper.dart';
import 'package:gruene_app/features/campaigns/helper/map_layer_manager.dart';
import 'package:gruene_app/features/campaigns/helper/marker_item_helper.dart';
import 'package:gruene_app/features/campaigns/helper/marker_item_manager.dart';
import 'package:gruene_app/features/campaigns/helper/util.dart';
import 'package:gruene_app/features/campaigns/models/bounding_box.dart';
import 'package:gruene_app/features/campaigns/models/map_layer_model.dart';
import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';
import 'package:gruene_app/features/campaigns/widgets/map_controller.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

typedef OnMapCreatedCallback = void Function(MapController controller);
typedef AddPOIClickedCallback = void Function(LatLng location);
typedef LoadVisibleItemsCallBack = void Function(LatLng locationSW, LatLng locationNE);
typedef LoadDataLayersCallBack = void Function(LatLng locationSW, LatLng locationNE);
typedef GetMarkerImagesCallback = Map<String, String> Function();
typedef OnFeatureClickCallback = void Function(dynamic feature);
typedef OnNoFeatureClickCallback = void Function();
typedef OnEditItemClickedCallback = void Function();
typedef AddMapLayersForContextCallback = void Function(MapLibreMapController mapLibreController);

class MapContainer extends StatefulWidget {
  final OnMapCreatedCallback? onMapCreated;
  final AddPOIClickedCallback? addPOIClicked;
  final LoadVisibleItemsCallBack? loadVisibleItems;
  final LoadDataLayersCallBack? loadDataLayers;
  final GetMarkerImagesCallback? getMarkerImages;
  final OnFeatureClickCallback? onFeatureClick;
  final OnNoFeatureClickCallback? onNoFeatureClick;
  final AddMapLayersForContextCallback? addMapLayersForContext;

  const MapContainer({
    super.key,
    required this.onMapCreated,
    required this.addPOIClicked,
    required this.loadVisibleItems,
    required this.getMarkerImages,
    required this.onFeatureClick,
    required this.onNoFeatureClick,
    this.loadDataLayers,
    this.addMapLayersForContext,
  });

  @override
  State<StatefulWidget> createState() => _MapContainerState();
}

class _MapContainerState extends State<MapContainer> implements MapController {
  MapLibreMapController? _controller;
  final MarkerItemManager _markerItemManager = MarkerItemManager();
  final MapLayerDataManager _mapLayerManager = MapLayerDataManager();
  bool _isMapInitialized = false;

  static const markerSourceName = 'markers';
  static const markerLayerName = 'markerSymbols';
  static const addMarkerAssetName = 'assets/symbols/add_marker.svg';
  static const minZoomMarkerItems = 12.0;

  List<Widget> popups = [];

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
                child: SvgPicture.asset(addMarkerAssetName),
              ),
            ),
          ),
          ...popups,
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

    _loadDataOnMap();
  }

  void _loadDataOnMap() async {
    final visRegion = await _controller?.getVisibleRegion();
    debugPrint('Bounding Box: SW-${visRegion!.southwest} NE-${visRegion.northeast}');
    debugPrint('Zoom level: ${_controller!.cameraPosition!.zoom}');

    final loadVisibleItems = widget.loadVisibleItems;
    if (loadVisibleItems != null) {
      loadVisibleItems(visRegion.southwest, visRegion.northeast);
    }
    final loadDataLayers = widget.loadDataLayers;
    if (loadDataLayers != null) {
      loadDataLayers(visRegion.southwest, visRegion.northeast);
    }
  }

  void _onIconTap() {
    final addPOIClicked = widget.addPOIClicked;

    if (addPOIClicked != null) {
      addPOIClicked(_controller!.cameraPosition!.target);
    }
  }

  void _onMapClick(Point<double> point, LatLng coordinates) async {
    final controller = _controller;
    if (controller == null) {
      return;
    }
    final targetLatLng = await controller.toLatLng(point);
    if (!mounted) return;

    final onFeatureClick = widget.onFeatureClick;
    final onNoFeatureClick = widget.onNoFeatureClick;

    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    final touchTargetSize = pixelRatio * 38.0; // corresponds to 1 cm roughly
    final rect = Rect.fromCenter(center: Offset(point.x, point.y), width: touchTargetSize, height: touchTargetSize);

    final jsonFeatures = await controller.queryRenderedFeaturesInRect(rect, [markerLayerName], null);
    final features = jsonFeatures.map((e) => e as Map<String, dynamic>).where((x) {
      // if (x.containsKey('id')) return true;
      if (x['properties'] == null) return false;
      final properties = x['properties'] as Map<String, dynamic>;
      if (properties['status_type'] == null) return false;
      return true;
    }).toList();

    if (features.isNotEmpty && onFeatureClick != null) {
      final feature = MapHelper.getClosestFeature(features, targetLatLng);
      onFeatureClick(feature);
    } else if (onNoFeatureClick != null) {
      onNoFeatureClick();
    }
  }

  void _onCameraIdle() async {
    if (!_isMapInitialized) return;

    _loadDataOnMap();
  }

  void _onStyleLoadedCallback() async {
    if (widget.getMarkerImages != null) {
      widget.getMarkerImages!().forEach((x, y) async {
        await addImageFromAsset(_controller!, x, y);
      });
    }

    await _controller!.addGeoJsonSource(
      markerSourceName,
      MarkerItemHelper.transformListToGeoJson(<MarkerItemModel>[]).toJson(),
    );

    await _controller!.addSymbolLayer(
      markerSourceName,
      markerLayerName,
      const SymbolLayerProperties(
        iconImage: ['get', 'status_type'],
        iconSize: 2,
        iconAllowOverlap: true,
      ),
      enableInteraction: false,
      minzoom: minZoomMarkerItems,
      filter: [
        '!',
        ['has', 'point_count'],
      ],
    );
    // init context layers re-directed to context screens
    widget.addMapLayersForContext!(_controller!);
  }

  @override
  void setMarkerSource(List<MarkerItemModel> poiList) {
    _markerItemManager.addMarkers(poiList);
    _controller!.setGeoJsonSource(
      markerSourceName,
      MarkerItemHelper.transformListToGeoJson(_markerItemManager.getMarkers()).toJson(),
    );
  }

  @override
  void setLayerSource(String sourceId, List<MapLayerModel> layerData) async {
    _mapLayerManager.addLayerData(sourceId, layerData);
    final sourceIds = await _controller!.getSourceIds();
    Future<void> Function(Map<String, dynamic> data) setLayerData;
    if (sourceIds.contains(sourceId)) {
      setLayerData = (data) async {
        await _controller!.setGeoJsonSource(
          sourceId,
          data,
        );
      };
    } else {
      setLayerData = (data) async {
        await _controller!.addGeoJsonSource(
          sourceId,
          data,
        );
      };
    }
    final data = MarkerItemHelper.transformMapLayerDataToGeoJson(_mapLayerManager.getMapLayerData(sourceId)).toJson();
    await setLayerData(data);
  }

  @override
  void removeLayerSource(String sourceId) async {
    /* 
    * A bug prevents using correct method -> see https://github.com/maplibre/flutter-maplibre-gl/issues/526
    * Therefore we set it as empty datasource. Once the issue has been corrected
    */
    // await _controller!.removeSource(sourceId);
    await _controller!.setGeoJsonSource(sourceId, MarkerItemHelper.transformMapLayerDataToGeoJson([]).toJson());
  }

  @override
  void addMarkerItem(MarkerItemModel markerItem) {
    setMarkerSource([markerItem]);
  }

  @override
  void removeMarkerItem(int markerItemId) {
    _markerItemManager.removeMarker(markerItemId);
    _controller!.setGeoJsonSource(
      markerSourceName,
      MarkerItemHelper.transformListToGeoJson(_markerItemManager.getMarkers()).toJson(),
    );
  }

  @override
  Future<Point<num>> getScreenPointFromLatLng(LatLng coord) async {
    final point = await _controller!.toScreenLocation(coord);
    return point;
  }

  @override
  void showMapPopover(
    LatLng coord,
    Widget widget,
    OnEditItemClickedCallback? onEditItemClicked, {
    Size? desiredSize,
  }) async {
    if (!mounted) return;

    await moveMapIfItemIsOnBorder(coord);
    final point = await getScreenPointFromLatLng(coord);

    _showPopOver(
      point,
      widget,
      onEditItemClicked,
      desiredSize: desiredSize!,
    );
  }

  Future<void> moveMapIfItemIsOnBorder(LatLng itemCoordinate) async {
    const animationInMilliseconds = 300;
    const borderThresholdInPercent = 0.18;
    final centerCoord = _controller!.cameraPosition!.target;
    final visibleRegion = await _controller!.getVisibleRegion();
    final visibleRegionHeight = visibleRegion.northeast.latitude - visibleRegion.southwest.latitude;
    final visibleRegionWidth = visibleRegion.northeast.longitude - visibleRegion.southwest.longitude;

    double? newLatitude;
    double? newLongitude;

    var verticalThresholdDistance = visibleRegionHeight * borderThresholdInPercent;
    var horizontalThresholdDistance = visibleRegionWidth * borderThresholdInPercent;

    // check whether coordinate is in border region (defined as percentage of visible area) of visible area
    if ((visibleRegion.northeast.latitude - verticalThresholdDistance) < itemCoordinate.latitude) {
      final diff = itemCoordinate.latitude - (visibleRegion.northeast.latitude - verticalThresholdDistance);
      newLatitude = centerCoord.latitude + (diff * 1.5);
    } else if ((visibleRegion.southwest.latitude + verticalThresholdDistance) > itemCoordinate.latitude) {
      newLatitude = centerCoord.latitude - (verticalThresholdDistance / 2);
    }
    if ((visibleRegion.northeast.longitude - horizontalThresholdDistance) < itemCoordinate.longitude) {
      newLongitude = centerCoord.longitude + horizontalThresholdDistance;
    } else if ((visibleRegion.southwest.longitude + horizontalThresholdDistance) > itemCoordinate.longitude) {
      newLongitude = centerCoord.longitude - horizontalThresholdDistance;
    }

    if (newLongitude != null || newLatitude != null) {
      // find new target and animate camera
      final newTarget = LatLng(
        newLatitude ?? centerCoord.latitude,
        newLongitude ?? centerCoord.longitude,
      );
      // ignore: unused_local_variable
      await _controller!.animateCamera(
        CameraUpdate.newLatLng(newTarget),
        duration: Duration(milliseconds: animationInMilliseconds),
      );
    }
  }

  void _showPopOver(
    Point<num> pointOnScreen,
    Widget widget,
    OnEditItemClickedCallback? onEditItemClicked, {
    Size desiredSize = const Size(100, 100),
  }) {
    final mediaQuery = MediaQuery.of(context);
    final pixelRatio = mediaQuery.devicePixelRatio;

    setState(() {
      popups.clear();
      num popupHeight = desiredSize.height;
      num popupWidth = desiredSize.width;
      popups.add(
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Container(
            color: ThemeColors.secondary.withAlpha(30),
          ),
          onTap: () {
            setState(() {
              popups.clear();
            });
          },
        ),
      );
      final heightArrowTriangle = 10.0;
      popups.add(
        Positioned(
          top: ((pointOnScreen.y / pixelRatio) - popupHeight).toDouble() - (5 + heightArrowTriangle),
          left: (pointOnScreen.x / pixelRatio) - (popupWidth / 2),
          child: GestureDetector(
            onTap: () => onTapPopup(onEditItemClicked),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.background,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.only(top: 3, left: 5, right: 5),
                  width: popupWidth.toDouble(),
                  height: popupHeight.toDouble(),
                  child: widget,
                ),
                Center(
                  child: ClipPath(
                    clipper: MyTriangle(),
                    child: Container(
                      color: ThemeColors.background,
                      width: 15,
                      height: heightArrowTriangle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void onTapPopup(OnEditItemClickedCallback? onEditItemClicked) {
    if (onEditItemClicked == null) return;
    setState(() {
      popups.clear();
    });
    onEditItemClicked();
  }

  @override
  Future<BoundingBox> getCurrentBoundingBox() async {
    final visRegion = await _controller?.getVisibleRegion();
    return BoundingBox(southwest: visRegion!.southwest, northeast: visRegion.northeast);
  }

  @override
  double getCurrentZoomLevel() {
    return _controller!.cameraPosition!.zoom;
  }

  @override
  double get minimumMarkerZoomLevel => minZoomMarkerItems;
}

class MyTriangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addPolygon(
      [
        Offset(0, 0),
        Offset(size.width / 2, size.height),
        Offset(size.width, 0),
      ],
      true,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
