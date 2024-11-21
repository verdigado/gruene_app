import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gruene_app/features/campaigns/screens/helper/map_mock_data.dart';
import 'package:gruene_app/features/campaigns/widgets/filter_chip_widget.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class GoogleMapDemo extends StatelessWidget {
  GoogleMapDemo({super.key});

  final List<FilterChipModel> flyerFilter = [
    FilterChipModel(t.campaigns.filters.visited_areas, false),
    FilterChipModel(t.campaigns.filters.routes, false),
    FilterChipModel(t.campaigns.filters.experience_areas, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterChipCampaign(flyerFilter, <String, List<String>>{}),
        Center(
          child: Text(
            'Google Map Demo',
            style: TextStyle(color: Colors.green),
          ),
        ),
        Expanded(
          child: MapSample(),
        ),
        // Center(child: Text(t.campaigns.flyer.label)),
      ],
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  GoogleMapController? controller;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(52.528810, 13.379300),
    zoom: 16,
  );

  AssetMapBitmap? _assetMapBitmap;

  @override
  Widget build(BuildContext context) {
    loadImage();
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: _onMapCreated,
        markers: MapMockData.getPosterPOIs('poster').map(_toMarker).toSet(),
        polygons: [MapMockData.focus_area.map((p) => LatLng(p.latitude, p.longitude)).toList()].map(toPolygon).toSet(),
      ),
    );
  }

  // Future<Marker> _toMarker(PosterPOI poster) async {
  Marker _toMarker(PosterPOI poster) {
    // final ImageConfiguration imageConfiguration = createLocalImageConfiguration(
    //   context,
    // );
    // AssetMapBitmap assetMapBitmap = AssetMapBitmap.create(
    //   imageConfiguration,
    //   'assets/symbols/custom-marker.png',
    //   width: 40,
    //   height: 40,
    //   bitmapScaling: MapBitmapScaling.auto,
    // );
    final MarkerId markerId = MarkerId(poster.name);
    return Marker(
      markerId: markerId,
      position: LatLng(poster.coordinate.latitude, poster.coordinate.longitude),
      infoWindow: InfoWindow(title: poster.name, snippet: '*'),
      // width: 40,
      // height: 40,
      onTap: () => _markerTap(poster.name),
      icon: _assetMapBitmap == null ? BitmapDescriptor.defaultMarker : _assetMapBitmap!,
      // child: Image(
      //   image: AssetImage('assets/symbols/custom-marker.png'),),
    );
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    _controller.complete(controllerParam);

    setState(() {
      controller = controllerParam;
    });
  }

  Future<void> _markerTap(String id) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(id),
      ),
    );
  }

  Polygon toPolygon(List<LatLng> area) {
    final String polygonIdVal = 'polygon_id_1';
    final PolygonId polygonId = PolygonId(polygonIdVal);

    final Polygon polygon = Polygon(
      polygonId: polygonId,
      // consumeTapEvents: true,
      strokeWidth: 5,
      fillColor: const Color.fromARGB(90, 44, 151, 44),
      points: area,
      // onTap: () {
      //   _onPolygonTapped(polygonId);
      // },
    );
    return polygon;
  }

  void loadImage() async {
    final ImageConfiguration imageConfiguration = createLocalImageConfiguration(
      context,
    );
    _assetMapBitmap = await AssetMapBitmap.create(
      imageConfiguration,
      'assets/symbols/custom-marker.png',
      width: 40,
      height: 40,
      bitmapScaling: MapBitmapScaling.auto,
    );
  }
}
