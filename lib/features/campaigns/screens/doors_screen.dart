import 'package:flutter/material.dart';
import 'package:gruene_app/app/services/enums.dart';
import 'package:gruene_app/app/services/gruene_api_campaigns_service.dart';
import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_create_model.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_update_model.dart';
import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';
import 'package:gruene_app/features/campaigns/screens/door_edit.dart';
import 'package:gruene_app/features/campaigns/screens/doors_add_screen.dart';
import 'package:gruene_app/features/campaigns/screens/doors_detail.dart';
import 'package:gruene_app/features/campaigns/screens/map_consumer.dart';
import 'package:gruene_app/features/campaigns/widgets/filter_chip_widget.dart';
import 'package:gruene_app/features/campaigns/widgets/map.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class DoorsScreen extends StatefulWidget {
  const DoorsScreen({super.key});

  @override
  State<DoorsScreen> createState() => _DoorsScreenState();
}

class _DoorsScreenState extends MapConsumer<DoorsScreen> {
  final Map<String, List<String>> doorsExclusions = <String, List<String>>{
    t.campaigns.filters.focusAreas: [t.campaigns.filters.visited_areas],
    t.campaigns.filters.visited_areas: [t.campaigns.filters.focusAreas],
  };

  late List<FilterChipModel> doorsFilter;

  final GrueneApiCampaignsService _grueneApiService = GrueneApiCampaignsService(poiType: PoiServiceType.door);

  bool focusAreasVisible = false;
  final String focusAreadId = 'focusArea';
  final minZoomFocusAreaLayer = 11.5;

  _DoorsScreenState() : super(NominatimService());

  @override
  GrueneApiCampaignsService get campaignService => _grueneApiService;

  @override
  void initState() {
    doorsFilter = [
      FilterChipModel(
        text: t.campaigns.filters.visited_areas,
        isEnabled: false,
      ),
      FilterChipModel(
        text: t.campaigns.filters.routes,
        isEnabled: false,
      ),
      FilterChipModel(
        text: t.campaigns.filters.focusAreas,
        isEnabled: true,
        stateChanged: onFocusAreaStateChanged,
      ),
      FilterChipModel(
        text: t.campaigns.filters.experience_areas,
        isEnabled: false,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MapContainer mapContainer = MapContainer(
      onMapCreated: onMapCreated,
      addPOIClicked: _addPOIClicked,
      loadVisibleItems: loadVisibleItems,
      getMarkerImages: _getMarkerImages,
      onFeatureClick: _onFeatureClick,
      onNoFeatureClick: _onNoFeatureClick,
      addMapLayersForContext: addMapLayersForContext,
      loadDataLayers: _loadDataLayers,
    );

    return Column(
      children: [
        FilterChipCampaign(doorsFilter, doorsExclusions),
        Expanded(
          child: mapContainer,
        ),
      ],
    );
  }

  void _addPOIClicked(LatLng location) {
    super.addPOIClicked<Object, DoorsAddScreen, DoorCreateModel>(
      location,
      null,
      _getAddScreen,
      _saveNewAndGetMarkerItem,
    );
  }

  Map<String, String> _getMarkerImages() {
    return {
      'door': 'assets/symbols/doors/door.png',
    };
  }

  void _onFeatureClick(dynamic rawFeature) async {
    getPoi(String poiId) async {
      final door = await campaignService.getPoiAsDoorDetail(poiId);
      return door;
    }

    getPoiDetail(DoorDetailModel door) {
      return DoorsDetail(
        poi: door,
      );
    }

    getEditPoiWidget(DoorDetailModel door) {
      return DoorEdit(door: door, onSave: _saveDoor, onDelete: deletePoi);
    }

    super.onFeatureClick<DoorDetailModel>(
      rawFeature,
      getPoi,
      getPoiDetail,
      getEditPoiWidget,
      desiredSize: Size(145, 95),
    );
  }

  void _onNoFeatureClick() {}

  Future<void> _saveDoor(DoorUpdateModel doorUpdate) async {
    final updatedMarker = await campaignService.updateDoor(doorUpdate);
    mapController.setMarkerSource([updatedMarker]);
  }

  DoorsAddScreen _getAddScreen(LatLng location, AddressModel? address, Object? additionalData) {
    return DoorsAddScreen(
      location: location,
      address: address!,
    );
  }

  Future<MarkerItemModel> _saveNewAndGetMarkerItem(DoorCreateModel newDoor) async =>
      await _grueneApiService.createNewDoor(newDoor);

  void onFocusAreaStateChanged(bool state) async {
    focusAreasVisible = state;
    if (focusAreasVisible) {
      _loadFocusAreaLayer();
    } else {
      mapController.removeLayerSource(focusAreadId);
    }
  }

  void addMapLayersForContext(MapLibreMapController mapLibreController) async {
    final focusAreaFillLayerId = '${focusAreadId}_layer';
    final focusAreaBorderLayerId = '${focusAreadId}_border';

    await mapLibreController.addFillLayer(
      focusAreadId,
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
      minzoom: minZoomFocusAreaLayer,
    );

    await mapLibreController.addLineLayer(
      focusAreadId,
      focusAreaBorderLayerId,
      LineLayerProperties(lineColor: 'rgba(0, 0, 0, 1)', lineWidth: 1),
      minzoom: minZoomFocusAreaLayer,
    );
  }

  void _loadFocusAreaLayer() async {
    if (mapController.getCurrentZoomLevel() > minZoomFocusAreaLayer) {
      final bbox = await mapController.getCurrentBoundingBox();

      final focusAreas = await campaignService.loadFocusAreasInRegion(bbox.southwest, bbox.northeast);
      mapController.setLayerSource(focusAreadId, focusAreas);
    }
  }

  void _loadDataLayers(LatLng locationSW, LatLng locationNE) async {
    if (focusAreasVisible) {
      _loadFocusAreaLayer();
    }
  }
}
