import 'package:cloud_firestore/cloud_firestore.dart';

class DonationModel {
  final String? id;
  final String foodName;
  final String quantity;
  final String foodType;
  final DateTime cookedTime;
  final DateTime bestBefore;
  final String pickupAddress;
  final String notes;
  final String status;
  final String donorName;
  final String donorPhone;
  final String donorId;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final String acceptedByName;
  final String acceptedByPhone;
  final DateTime? acceptedAt;

  DonationModel({
    this.id,
    required this.foodName,
    required this.quantity,
    required this.foodType,
    required this.cookedTime,
    required this.bestBefore,
    required this.pickupAddress,
    required this.notes,
    required this.status,
    required this.donorName,
    required this.donorPhone,
    required this.donorId,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.acceptedByName = '',
    this.acceptedByPhone = '',
    this.acceptedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'quantity': quantity,
      'foodType': foodType,
      'cookedTime': Timestamp.fromDate(cookedTime),
      'bestBefore': Timestamp.fromDate(bestBefore),
      'pickupAddress': pickupAddress,
      'notes': notes,
      'status': status,
      'donorName': donorName,
      'donorPhone': donorPhone,
      'donorId': donorId,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': Timestamp.fromDate(createdAt),
      'acceptedByName': acceptedByName,
      'acceptedByPhone': acceptedByPhone,
      'acceptedAt': acceptedAt != null ? Timestamp.fromDate(acceptedAt!) : null,
    };
  }

  factory DonationModel.fromMap(Map<String, dynamic> map, String documentId) {
    return DonationModel(
      id: documentId,
      foodName: map['foodName'] ?? '',
      quantity: map['quantity'] ?? '',
      foodType: map['foodType'] ?? '',
      cookedTime: (map['cookedTime'] as Timestamp).toDate(),
      bestBefore: (map['bestBefore'] as Timestamp).toDate(),
      pickupAddress: map['pickupAddress'] ?? '',
      notes: map['notes'] ?? '',
      status: map['status'] ?? 'available',
      donorName: map['donorName'] ?? '',
      donorPhone: map['donorPhone'] ?? '',
      donorId: map['donorId'] ?? '',

      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),

      createdAt: (map['createdAt'] as Timestamp).toDate(),
      acceptedByName: map['acceptedByName'] ?? '',

      acceptedByPhone: map['acceptedByPhone'] ?? '',

      acceptedAt:
          map['acceptedAt'] != null
              ? (map['acceptedAt'] as Timestamp).toDate()
              : null,
    );
  }
}
