part of '../converters.dart';

extension AddressModelParsing on AddressModel {
  PoiAddress transformToPoiAddress() {
    final address = this;
    return PoiAddress(
      city: address.city.isEmpty ? null : address.city,
      zip: address.zipCode.isEmpty ? null : address.zipCode,
      street: address.street.isEmpty ? null : address.street,
      houseNumber: address.houseNumber.isEmpty ? null : address.houseNumber,
    );
  }
}
