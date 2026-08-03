import '../../location/models/user_location.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/services/location_service.dart';

class LocationRepository {
  final LocationService _locationService = LocationService.instance;

  Future<bool> isLocationServiceEnabled() async {
    return await _locationService.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return await _locationService.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return await _locationService.requestPermission();
  }

  Future<Position> getCurrentPosition() async {
  return await _locationService.getCurrentPosition();
}
  Future<UserLocation> getUserLocation() async {
  return await _locationService.getUserLocation();
}
}