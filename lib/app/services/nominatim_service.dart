import 'package:gruene_app/app/geocode/nominatim.dart';
import 'package:logger/logger.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class NominatimService {
  final Logger _logger = Logger();

  Future<AddressModel> getLocationAddress(LatLng location) async {
    try {
      final place = await Nominatim.reverseSearch(
        lat: location.latitude,
        lon: location.longitude,
      );
      final address = AddressModel.fromPlace(place);
      return address;
    } catch (e) {
      _logger.e(
        'Nominatim reverse search failed on (lat: ${location.latitude}, lon: ${location.longitude}): ${e.toString()}',
      );
      return AddressModel();
    }
  }
}

class AddressModel {
  final String street;
  final String city;
  final String zipCode;
  final String houseNumber;

  const AddressModel({this.street = '', this.houseNumber = '', this.zipCode = '', this.city = ''});

  /*
  * More details on how to find and categorize "places" can be found in the OSM Wiki:
  * https://wiki.openstreetmap.org/wiki/Template:Generic:Map_Features:place
  * If road is absent we take hamlet oder dwelling as Street Information.
  * For City we take in descending order city, town, or village, whatever is first.
  * Hopefully, this will solve most issues with that kind of address composition.
  */
  AddressModel.fromPlace(Place place)
      : street = place.address?['road']?.toString() ??
            place.address?['hamlet']?.toString() ??
            place.address?['isolated_dwelling']?.toString() ??
            '',
        houseNumber = place.address?['house_number']?.toString() ?? '',
        zipCode = place.address?['postcode']?.toString() ?? '',
        city = place.address?['city']?.toString() ??
            place.address?['town']?.toString() ??
            place.address?['village']?.toString() ??
            '';
}
