part of '../converters.dart';

extension PoiServiceTypeParsing on PoiServiceType {
  V1CampaignsPoisGetType transformToApiGetType() {
    switch (this) {
      case PoiServiceType.poster:
        return V1CampaignsPoisGetType.poster;
      case PoiServiceType.door:
        return V1CampaignsPoisGetType.house;
      case PoiServiceType.flyer:
        return V1CampaignsPoisGetType.flyerSpot;
    }
  }

  V1CampaignsPoisSelfGetType transformToApiSelfGetType() {
    switch (this) {
      case PoiServiceType.poster:
        return V1CampaignsPoisSelfGetType.poster;
      case PoiServiceType.door:
        return V1CampaignsPoisSelfGetType.house;
      case PoiServiceType.flyer:
        return V1CampaignsPoisSelfGetType.flyerSpot;
    }
  }

  CreatePoiType transformToApiCreateType() {
    switch (this) {
      case PoiServiceType.poster:
        return CreatePoiType.poster;
      case PoiServiceType.door:
        return CreatePoiType.house;
      case PoiServiceType.flyer:
        return CreatePoiType.flyerSpot;
    }
  }
}
