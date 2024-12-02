import 'package:gruene_app/app/geocode/nominatim.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class NominatimService {
  Future<AddressModel> getLocationAddress(LatLng location) async {
    final place = await Nominatim.reverseSearch(
      lat: location.latitude,
      lon: location.longitude,
    );
    final address = AddressModel.convertFromPlace(place);
    return address;
  }
}

class AddressModel {
  final String? street;
  final String? city;
  final String? zipCode;
  final String? houseNumber;

  const AddressModel({this.street, this.houseNumber, this.zipCode, this.city});

  static AddressModel convertFromPlace(Place place) {
    return AddressModel(
      street: place.address?['road']?.toString(),
      houseNumber: place.address?['house_number']?.toString(),
      zipCode: place.address?['postcode']?.toString(),
      city: place.address?['city']?.toString(),
    );
  }
}
