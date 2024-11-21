import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/features/campaigns/screens/helper/map_mock_data.dart';
import 'package:gruene_app/features/campaigns/widgets/filter_chip_widget.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/src/logger.dart';

class FlyerScreen extends StatelessWidget {
  FlyerScreen({super.key});

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
            'fleaflet (Vector)',
            style: TextStyle(color: Colors.green),
          ),
        ),
        Expanded(
          child: FleafletMap2(title: 'Titel'),
        ),
        // Center(child: Text(t.campaigns.flyer.label)),
      ],
    );
  }
}

class FleafletMap2 extends StatefulWidget {
  const FleafletMap2({super.key, required this.title});

  final String title;
  static const String route = '/';

  @override
  State<FleafletMap2> createState() => _FleafletMapState2();
}

class _FleafletMapState2 extends State<FleafletMap2> {
  final MapController _controller = MapController();
  Style? _style;
  Object? _error;

  @override
  void initState() {
    super.initState();
    // showIntroDialogIfNeeded();
    _initStyle();
  }

  void _initStyle() async {
    try {
      _style = await _readStyle();
    } catch (e, stack) {
      // ignore: avoid_print
      print(e);
      // ignore: avoid_print
      print(stack);
      _error = e;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (_error != null) {
      children.add(Expanded(child: Text(_error!.toString())));
    } else if (_style == null) {
      children.add(const Center(child: CircularProgressIndicator()));
    } else {
      children.add(
        Flexible(
          child: Expanded(
            child: Stack(
              children: [
                _map(_style!),
                Center(
                  child: GestureDetector(
                    // onTap: _onIconTap,
                    child: SvgPicture.asset('assets/symbols/add_marker.svg'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      children.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [_statusText()]));
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
    // return Scaffold(
    //   body: Stack(
    //     children: [
    //       FlutterMap(
    //         options: MapOptions(
    //           initialCenter: const LatLng(51.5, -0.09),
    //           initialZoom: 5,
    //           cameraConstraint: CameraConstraint.contain(
    //             bounds: LatLngBounds(
    //               const LatLng(-90, -180),
    //               const LatLng(90, 180),
    //             ),
    //           ),
    //         ),
    //         children: [
    //           openStreetMapTileLayer,
    //           RichAttributionWidget(
    //             popupInitialDisplayDuration: const Duration(seconds: 5),
    //             animationConfig: const ScaleRAWA(),
    //             showFlutterMapAttribution: false,
    //             attributions: [
    //               TextSourceAttribution(
    //                 'OpenStreetMap contributors',
    //                 onTap: () async => launchUrl(
    //                   Uri.parse('https://openstreetmap.org/copyright'),
    //                 ),
    //               ),
    //               const TextSourceAttribution(
    //                 'This attribution is the same throughout this app, except '
    //                 'where otherwise specified',
    //                 prependCopyright: false,
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //       const FloatingMenuButton(),
    //     ],
    //   ),
    // );
  }

  Widget _statusText() => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: StreamBuilder(
          stream: _controller.mapEventStream,
          builder: (context, snapshot) {
            return Text(
              'Zoom: ${_controller.camera.zoom.toStringAsFixed(2)} Center: ${_controller.camera.center.latitude.toStringAsFixed(4)},${_controller.camera.center.longitude.toStringAsFixed(4)}',
            );
          },
        ),
      );

  Widget _map(Style style) => FlutterMap(
        mapController: _controller,
        options: MapOptions(
          onTap: _onTap,
          initialCenter: style.center ?? const LatLng(52.528810, 13.379300),
          initialZoom: style.zoom ?? 16,
          maxZoom: 22,
          // backgroundColor: material.Theme.of(context).canvasColor,
        ),
        children: [
          VectorTileLayer(
            tileProviders: style.providers,
            theme: style.theme,
            sprites: style.sprites,
            maximumZoom: 22,
            tileOffset: TileOffset.mapbox,
            layerMode: VectorTileLayerMode.vector,
          ),
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
            markers: MapMockData.getPosterPOIs('flyer').map(_toMarker).toList(),
          ),
        ],
      );

  Future<void> _onTap(TapPosition tapPosition, LatLng point) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(point.toString()),
      ),
    );
  }

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
      child: GestureDetector(
        onTap: () => _markerTap(poster.name),
        child: Image(
          image: AssetImage('assets/symbols/flyer/${poster.status}.png'),
        ),
      ),
    );
  }
}

Future<Style> _readStyle() => StyleReader(
      uri: Config.fluttermapVectorUrl,
      logger: Logger.console(),
    ).read();

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
