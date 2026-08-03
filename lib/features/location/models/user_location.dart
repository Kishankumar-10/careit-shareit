class UserLocation {
  final double latitude;
  final double longitude;

  final String state;
  final String city;
  final String area;
  final String pincode;

  // New fields
  final String houseNumber;
  final String street;
  final String landmark;
  final String district;
  final String country;

  const UserLocation({
    required this.latitude,
    required this.longitude,
    required this.state,
    required this.city,
    required this.area,
    required this.pincode,

    required this.houseNumber,
    required this.street,
    required this.landmark,
    required this.district,
    required this.country,
  });

  String get fullAddress {
    final parts = [
      if (houseNumber.isNotEmpty) houseNumber,
      if (street.isNotEmpty) street,
      if (area.isNotEmpty) area,
      if (landmark.isNotEmpty) landmark,
      if (city.isNotEmpty) city,
      if (district.isNotEmpty) district,
      if (state.isNotEmpty) state,
      if (pincode.isNotEmpty) pincode,
    ];

    return parts.join(", ");
  }
}
