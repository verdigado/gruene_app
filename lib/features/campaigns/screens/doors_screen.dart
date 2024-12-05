import 'package:flutter/material.dart';
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
import 'package:maplibre_gl_platform_interface/maplibre_gl_platform_interface.dart';

class DoorsScreen extends StatefulWidget {
  DoorsScreen({super.key});

  final List<FilterChipModel> doorsFilter = [
    FilterChipModel(t.campaigns.filters.visited_areas, false),
    FilterChipModel(t.campaigns.filters.routes, false),
    FilterChipModel(t.campaigns.filters.focusAreas, true),
    FilterChipModel(t.campaigns.filters.experience_areas, false),
  ];

  @override
  State<DoorsScreen> createState() => _DoorsScreenState();
}

class _DoorsScreenState extends MapConsumer<DoorsScreen> {
  final Map<String, List<String>> doorsExclusions = <String, List<String>>{
    t.campaigns.filters.focusAreas: [t.campaigns.filters.visited_areas],
    t.campaigns.filters.visited_areas: [t.campaigns.filters.focusAreas],
  };

  final GrueneApiCampaignsService _grueneApiService = GrueneApiCampaignsService(poiType: PoiServiceType.door);

  _DoorsScreenState() : super(NominatimService());

  @override
  GrueneApiCampaignsService get campaignService => _grueneApiService;

  @override
  Widget build(BuildContext context) {
    MapContainer mapContainer = MapContainer(
      onMapCreated: onMapCreated,
      addPOIClicked: _addPOIClicked,
      loadVisibleItems: loadVisibleItems,
      getMarkerImages: _getMarkerImages,
      onFeatureClick: _onFeatureClick,
      onNoFeatureClick: _onNoFeatureClick,
    );

    return Column(
      children: [
        FilterChipCampaign(widget.doorsFilter, doorsExclusions),
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

  void _saveDoor(DoorUpdateModel doorUpdate) async {
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
}
