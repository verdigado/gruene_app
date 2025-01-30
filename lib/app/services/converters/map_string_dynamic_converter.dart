part of '../converters.dart';

extension MapStringDynamicConverter on Map<String, dynamic> {
  Map<String, dynamic> convertLatLongField({String fieldName = 'location'}) {
    this[fieldName] = (this[fieldName] as List<dynamic>).cast<double>();
    return this;
  }

  Map<String, dynamic> updateIdField(int id) {
    this['id'] = id.toString();
    return this;
  }
}
