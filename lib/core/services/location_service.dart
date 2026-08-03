import 'package:geocoding/geocoding.dart';
import '../../features/location/models/user_location.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();

  static final LocationService instance = LocationService._();

  /// Checks whether the device's location service (GPS) is enabled.
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Returns the current location permission status.
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Requests location permission from the user.
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Returns the user's current GPS position.
  Future<Position> getCurrentPosition() async {
  return await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ),
  );
}
  Future<UserLocation> getUserLocation() async {
  final position = await getCurrentPosition();

  final placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  final place = placemarks.first;

 return UserLocation(
  latitude: position.latitude,
  longitude: position.longitude,

  state: place.administrativeArea ?? "",
  city: place.locality ?? "",
  area: place.subLocality ?? "",
  pincode: place.postalCode ?? "",

  houseNumber: place.subThoroughfare ?? "",
  street: place.thoroughfare ?? "",
  landmark: place.name ?? "",
  district: place.subAdministrativeArea ?? "",
  country: place.country ?? "",
);
}
}