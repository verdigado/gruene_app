import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/features/campaigns/screens/helper/map_mock_data.dart';
import 'package:gruene_app/features/campaigns/widgets/filter_chip_widget.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:latlong2/latlong.dart';
import 'package:popover/popover.dart';

const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

class PostersScreen extends StatelessWidget {
  PostersScreen({super.key});

  final List<FilterChipModel> postersFilter = [
    FilterChipModel(t.campaigns.filters.routes, false),
    FilterChipModel(t.campaigns.filters.polling_stations, false),
    FilterChipModel(t.campaigns.filters.experience_areas, false),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterChipCampaign(postersFilter, <String, List<String>>{}),
        Center(
          child: Text(
            'fleaflet (Raster)',
            style: TextStyle(color: Colors.green),
          ),
        ),
        Expanded(
          child: FleafletMap(),
        ),
        // Center(child: Text(t.campaigns.posters.label)),
      ],
    );
  }
}

class FleafletMap extends StatefulWidget {
  static const String route = '/';

  const FleafletMap({super.key});

  @override
  State<FleafletMap> createState() => _FleafletMapState();
}

class _FleafletMapState extends State<FleafletMap> {
  final mapController = MapController();

  @override
  void initState() {
    super.initState();

    // showIntroDialogIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              onTap: _onTap,
              initialCenter: const LatLng(52.528810, 13.379300),
              initialZoom: 16,
              maxZoom: 20,
              // initialCenter: const LatLng(51.5, -0.09),
              // initialZoom: 5,

              cameraConstraint: CameraConstraint.contain(
                bounds: LatLngBounds(
                  const LatLng(46.8, 5.6),
                  const LatLng(55.1, 15.5),
                ),
                // bounds: LatLngBounds(
                //   const LatLng(-90, -180),
                //   const LatLng(90, 180),
                // ),
              ),
            ),
            children: [
              openStreetMapTileLayer,

              PolygonLayer(
                polygons: [
                  Polygon(
                    points: MapMockData.focus_area,
                    // color: Colors.blue,
                    color: const Color.fromARGB(90, 44, 151, 44),
                  ),
                ],
              ),
              MarkerLayer(
                markers: MapMockData.getPosterPOIs('poster').map(_toMarker).toList(),
              ),
              // RichAttributionWidget(
              //   popupInitialDisplayDuration: const Duration(seconds: 5),
              //   animationConfig: const ScaleRAWA(),
              //   showFlutterMapAttribution: false,
              //   attributions: [
              //     TextSourceAttribution(
              //       'OpenStreetMap contributors',
              //       onTap: () async => launchUrl(
              //         Uri.parse('https://openstreetmap.org/copyright'),
              //       ),
              //     ),
              //     const TextSourceAttribution(
              //       'This attribution is the same throughout this app, except '
              //       'where otherwise specified',
              //       prependCopyright: false,
              //     ),
              //   ],
              // ),
            ],
          ),
          Center(
            child: GestureDetector(
              child: SvgPicture.asset('assets/symbols/add_marker.svg'),
            ),
          ),
          // const FloatingMenuButton(),
        ],
      ),
    );
  }

  Future<void> _onTap(TapPosition tapPosition, LatLng point) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(point.toString()),
      ),
    );
  }
  // void showIntroDialogIfNeeded() {
  //   const seenIntroBoxKey = 'seenIntroBox(a)';
  //   if (kIsWeb && Uri.base.host.trim() == 'demo.fleaflet.dev') {
  //     SchedulerBinding.instance.addPostFrameCallback(
  //       (_) async {
  //         final prefs = await SharedPreferences.getInstance();
  //         if (prefs.getBool(seenIntroBoxKey) ?? false) return;

  //         if (!mounted) return;

  //         await showDialog<void>(
  //           context: context,
  //           builder: (context) => const FirstStartDialog(),
  //         );
  //         await prefs.setBool(seenIntroBoxKey, true);
  //       },
  //     );
  //   }
  // }

  Future<void> _markerTap(String id) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(id),
      ),
    );
  }

  Marker _toMarker(PosterPOI poster) {
    return Marker(
      point: poster.coordinate,
      width: 40,
      height: 40,
      child: PosterMarkerItem(poster),
    );
    // return Marker(
    //   point: poster.coordinate,
    //   width: 40,
    //   height: 40,
    //   child: GestureDetector(
    //     onTap: () => _markerTap(poster.name),
    //     child: Image(
    //       image: AssetImage('assets/symbols/posters/${poster.status}.png'),
    //     ),
    //   ),
    // );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: Config.fluttermapTileUrl,
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
      // Use the recommended flutter_map_cancellable_tile_provider package to
      // support the cancellation of loading tiles.
      tileProvider: CancellableNetworkTileProvider(),
    );

class PosterMarkerItem extends StatefulWidget {
  final PosterPOI posterItem;

  const PosterMarkerItem(
    this.posterItem, {
    super.key,
  });

  @override
  State createState() => PosterMarkerState();
}

class PosterMarkerState extends State<PosterMarkerItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPopover(
        context: context,
        direction: PopoverDirection.top,
        bodyBuilder: (context) => SizedBox(
          height: 150,
          width: 100,
          child: Column(
            children: [
              Expanded(child: Placeholder()),
              Text('test', style: TextStyle(color: Colors.black)),
            ],
          ),
          // child: Column(children: [Text('test')]),
        ),
      ),
      child: Image(
        image: AssetImage('assets/symbols/posters/${widget.posterItem.status}.png'),
      ),
    );
  }
}
