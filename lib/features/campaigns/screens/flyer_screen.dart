import 'package:flutter/widgets.dart';
import 'package:gruene_app/app/services/gruene_api_campaigns_service.dart';
import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:gruene_app/features/campaigns/models/flyer/flyer_create_model.dart';
import 'package:gruene_app/features/campaigns/models/flyer/flyer_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/flyer/flyer_update_model.dart';
import 'package:gruene_app/features/campaigns/models/marker_item_model.dart';
import 'package:gruene_app/features/campaigns/screens/flyer_add_screen.dart';
import 'package:gruene_app/features/campaigns/screens/flyer_detail.dart';
import 'package:gruene_app/features/campaigns/screens/flyer_edit.dart';
import 'package:gruene_app/features/campaigns/screens/map_consumer.dart';
import 'package:gruene_app/features/campaigns/widgets/filter_chip_widget.dart';
import 'package:gruene_app/features/campaigns/widgets/map.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:maplibre_gl_platform_interface/maplibre_gl_platform_interface.dart';

class FlyerScreen extends StatefulWidget {
  FlyerScreen({super.key});

  final List<FilterChipModel> flyerFilter = [
    FilterChipModel(t.campaigns.filters.visited_areas, false),
    FilterChipModel(t.campaigns.filters.routes, false),
    FilterChipModel(t.campaigns.filters.experience_areas, false),
  ];

  @override
  State<FlyerScreen> createState() => _FlyerScreenState();
}

class _FlyerScreenState extends MapConsumer<FlyerScreen> {
  final GrueneApiCampaignsService _grueneApiService = GrueneApiCampaignsService(poiType: PoiServiceType.flyer);

  _FlyerScreenState() : super(NominatimService());

  @override
  Widget build(BuildContext context) {
    final mapContainer = MapContainer(
      onMapCreated: onMapCreated,
      addPOIClicked: _addPOIClicked,
      loadVisibleItems: loadVisibleItems,
      getMarkerImages: _getMarkerImages,
      onFeatureClick: _onFeatureClick,
      onNoFeatureClick: _onNoFeatureClick,
    );

    return Column(
      children: [
        FilterChipCampaign(widget.flyerFilter, <String, List<String>>{}),
        Expanded(
          child: mapContainer,
        ),
      ],
    );
  }

  void _addPOIClicked(LatLng location) {
    super.addPOIClicked<Object, FlyerAddScreen, FlyerCreateModel>(
      location,
      null,
      _getAddScreen,
      _saveNewAndGetMarkerItem,
    );
  }

  Map<String, String> _getMarkerImages() {
    return {
      'flyer': 'assets/symbols/flyer/flyer.png',
    };
  }

  void _onFeatureClick(dynamic rawFeature) async {
    getPoi(String poiId) async {
      final flyer = await campaignService.getPoiAsFlyerDetail(poiId);
      return flyer;
    }

    getPoiDetail(FlyerDetailModel flyer) {
      return FlyerDetail(
        poi: flyer,
      );
    }

    getEditPoiWidget(FlyerDetailModel flyer) {
      return FlyerEdit(flyer: flyer, onSave: _saveFlyer, onDelete: deletePoi);
    }

    super.onFeatureClick<FlyerDetailModel>(
      rawFeature,
      getPoi,
      getPoiDetail,
      getEditPoiWidget,
      desiredSize: Size(145, 70),
    );
  }

  void _onNoFeatureClick() {}

  @override
  GrueneApiCampaignsService get campaignService => _grueneApiService;

  FlyerAddScreen _getAddScreen(LatLng location, AddressModel? address, Object? additionalData) {
    return FlyerAddScreen(
      location: location,
      address: address!,
    );
  }

  Future<MarkerItemModel> _saveNewAndGetMarkerItem(FlyerCreateModel newFlyer) async {
    return await campaignService.createNewFlyer(newFlyer);
  }

  void _saveFlyer(FlyerUpdateModel flyerUpdate) async {
    final updatedMarker = await campaignService.updateFlyer(flyerUpdate);
    mapController.setMarkerSource([updatedMarker]);
  }
}
