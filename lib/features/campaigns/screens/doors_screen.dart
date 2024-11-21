import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gruene_app/app/constants/config.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/app/widgets/icon.dart';
import 'package:gruene_app/features/campaigns/screens/fleaflet_helper/util.dart';
import 'package:gruene_app/features/campaigns/screens/helper/map_mock_data.dart';
import 'package:gruene_app/features/campaigns/widgets/filter_chip_widget.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:popover/popover.dart';

class DoorsScreen extends MapPage {
  DoorsScreen({super.key}) : super(const Icon(Icons.map), 'Full screen map');

  final List<FilterChipModel> doorsFilter = [
    FilterChipModel(t.campaigns.filters.visited_areas, false),
    FilterChipModel(t.campaigns.filters.routes, false),
    FilterChipModel(t.campaigns.filters.focusAreas, true),
    FilterChipModel(t.campaigns.filters.experience_areas, false),
  ];
  final Map<String, List<String>> doorsExclusions = <String, List<String>>{
    t.campaigns.filters.focusAreas: [t.campaigns.filters.visited_areas],
    t.campaigns.filters.visited_areas: [t.campaigns.filters.focusAreas],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterChipCampaign(doorsFilter, doorsExclusions),
        Center(
          child: Text(
            'MapLibre (Vector)',
            style: TextStyle(color: Colors.green),
          ),
        ),
        Expanded(child: FullMap()),
        //Center(child: Text(t.campaigns.door.label)),
      ],
    );
  }
}

class FullMap extends StatefulWidget {
  const FullMap({super.key});

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapLibreMapController? mapController;
  var isLight = true;
  static const double pointSize = 40;

  _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
    controller.onFeatureTapped.add(onFeatureTap);
  }

  Future<void> _onStyleLoadedCallback() async {
    bool withCluster = true;
    // _onStyleLoadedCallback() {
    await addImageFromAsset(mapController!, 'door', 'assets/symbols/doors/door.png');

    var points = MapMockData.getPosterPOIsAsGeoJson('door').toJson();
    if (withCluster) {
      await mapController!.addSource(
        'points',
        GeojsonSourceProperties(
          data: points,
          cluster: true,
          clusterMaxZoom: 14, // Max zoom to cluster points on
          clusterRadius: 50, // Radius of each cluster when clustering points (defaults to 50)
        ),
      );
    } else {
      await mapController!.addGeoJsonSource('points', points);
    }

    await mapController!.addSource('fills', GeojsonSourceProperties(data: MapMockData.focus_area_fill));

    await mapController!.addFillLayer(
      'fills',
      'fills',
      const FillLayerProperties(
        fillColor: [
          Expressions.interpolate,
          ['exponential', 0.5],
          [Expressions.zoom],
          11,
          'red',
          18,
          'green',
        ],
        fillOpacity: 0.4,
      ),
      // filter: ['==', 'id', filteredId],
    );

// await mapController!.addLayer('points', 'symbolLayer', SymbolLayerProperties())

    await mapController!.addSymbolLayer(
      'points',
      'symbols',
      const SymbolLayerProperties(
        iconImage: ['get', 'type'], //  "{type}-15",

        iconSize: 2,
        iconAllowOverlap: true,
      ),
      filter: [
        '!',
        ['has', 'point_count'],
      ],
    );

    if (withCluster) {
      await mapController!.addLayer(
        'points',
        'points-circles',
        filter: ['has', 'point_count'],
        const CircleLayerProperties(
          circleColor: [
            Expressions.step,
            [Expressions.get, 'point_count'],
            '#51bbd6',
            100,
            '#f1f075',
            750,
            '#f28cb1',
          ],
          circleRadius: [
            Expressions.step,
            [Expressions.get, 'point_count'],
            20,
            100,
            30,
            750,
            40,
          ],
        ),
      );
      await mapController!.addLayer(
        'points',
        'points-count',
        filter: ['has', 'point_count'],
        const SymbolLayerProperties(
          textField: [Expressions.get, 'point_count_abbreviated'],
          textFont: ['Open Sans Semibold'],
          textSize: 12,
        ),
      );
    }

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: const Text('Style loaded :)'),
    //     backgroundColor: Theme.of(context).primaryColor,
    //     duration: const Duration(seconds: 1),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: commented out when cherry-picking https://github.com/flutter-mapbox-gl/maps/pull/775
      // needs different dark and light styles in this repo
      // floatingActionButton: Padding(
      // padding: const EdgeInsets.all(32.0),
      // child: FloatingActionButton(
      // child: Icon(Icons.swap_horiz),
      // onPressed: () => setState(
      // () => isLight = !isLight,
      // ),
      // ),
      // ),
      body: Stack(
        children: [
          MapLibreMap(
            // minMaxZoomPreference: MinMaxZoomPreference(14, 18),
            styleString: Config.maplibreUrl,
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(target: LatLng(52.528810, 13.379300), zoom: 16),
            onStyleLoadedCallback: _onStyleLoadedCallback,
            onMapClick: _onMapClicked,
            // rotateGesturesEnabled: false,
          ),
          Center(
            // Positioned(
            // top: _getPointY(context) - pointSize / 2,
            // left: _getPointX(context) - pointSize / 2,
            //child: const IgnorePointer(

            child: GestureDetector(
              onTap: _onIconTap,
              child: SvgPicture.asset('assets/symbols/add_marker.svg'),
            ),

            // child: GestureDetector(
            //   onTap: _onIconTap,
            //   child: Icon(
            //     Icons.add_location_alt,
            //     // Icons.pin_drop,

            //     size: pointSize,
            //     color: ThemeColors.tertiary,
            //   ),
            // ),
          ),
        ],
      ),
    );
  }

  double _getPointX(BuildContext context) => MediaQuery.sizeOf(context).width / 2;

  double _getPointY(BuildContext context) => MediaQuery.sizeOf(context).height / 2;

  Future<void> _onMapClicked(Point<double> point, LatLng coordinates) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(coordinates.toString()),
      ),
    );
  }

  void onFeatureTap(dynamic featureId, Point<double> point, LatLng coordinates) async {
    // final test = await mapController!.toScreenLocation(coordinates);
    // Finder.
    showPopover(
      context: context,
      direction: PopoverDirection.top,
      arrowDxOffset: 200,
      arrowDyOffset: 100,
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
    );

    // print(point);
    // print(MediaQuery.sizeOf(context).center(Offset.zero));
    // showPopover(
    //   context: context,
    //   direction: PopoverDirection.bottom,
    //   // arrowDxOffset: 30,
    //   arrowDyOffset: 900,
    //   // arrowHeight: 15,
    //   // arrowWidth: 30,
    //   bodyBuilder: (context) => Column(
    //     children: [
    //       Placeholder(
    //         fallbackHeight: 150,
    //         fallbackWidth: 150,
    //       ),
    //       Icon(Icons.add_a_photo),
    //     ],
    //   ),
    // );

    final snackBar = SnackBar(
      content: Text(
        'Tapped feature with id $featureId and $point',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onIconTap() {
    final snackBar = SnackBar(
      content: Text(
        'Add clicked',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

abstract class MapPage extends StatelessWidget {
  const MapPage(
    this.leading,
    this.title, {
    this.needsLocationPermission = true,
    super.key,
  });

  final Widget leading;
  final String title;
  final bool needsLocationPermission;
}
