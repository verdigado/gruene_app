import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(52.520008, 13.404954),
    zoom: 13.5
  );

  @override
  State<StatefulWidget> createState() => MapState();
}

class MapState extends State<MapScreen> {
  MaplibreMapController? mapController;
  
  _onMapCreated(MaplibreMapController controller) {
    mapController = controller;
    // TODO backend
    controller.addSymbol(const SymbolOptions(
      iconSize: 1.5,
      geometry: LatLng(52.520008, 13.404954),
      iconImage: "door_front"
    ));
  }
  
  _onStyleLoadedCallback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Style loaded :)"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: const Duration(seconds: 1),
      )
    );
  }

  _toggle(String category) {

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaplibreMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: MapScreen.initialCameraPosition,
        onStyleLoadedCallback: _onStyleLoadedCallback,
        myLocationEnabled: true,
        styleString: '''{
          "version": 8,
          "sources": {
            "OSM": {
              "type": "raster",
              "tiles": [
                "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
              ],
              "tileSize": 256,
              "attribution": "© OpenStreetMap contributors",
              "maxzoom": 18
            }
          },
          "layers": [
            {
              "id": "OSM-layer",
              "source": "OSM",
              "type": "raster"
            }
          ]
        }''',
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => _toggle("doors"),
              icon: const Icon(Icons.door_front_door_outlined)
          ),
          IconButton(
              onPressed: () => _toggle("posters"),
              icon: const Icon(Icons.outlined_flag)
          )
        ],
      ),
    );
  }
  
}