class UserProfile {
  final String name;
  final String phoneNumber;
  final String state;
  final String city;
  final String area;
  final String pinCode;
  

  const UserProfile({
    required this.name,
    required this.phoneNumber,
    required this.state,
    required this.city,
    required this.area,
    required this.pinCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'state': state,
      'city': city,
      'area': area,
      'pinCode': pinCode,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      area: map['area'] ?? '',
      pinCode: map['pinCode'] ?? '',
    );
  }
}