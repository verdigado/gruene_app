part of '../converters.dart';

extension PoiAddressParsing on PoiAddress {
  AddressModel transformToAddressModel() {
    final address = this;
    return AddressModel(
      street: address.street ?? '',
      houseNumber: address.houseNumber ?? '',
      zipCode: address.zip ?? '',
      city: address.city ?? '',
    );
  }
}
