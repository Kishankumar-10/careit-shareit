import 'package:flutter/material.dart';

import '../core/services/donation_service.dart';
import '../features/location/models/donation_model.dart';
import '../widgets/donation_card.dart';
import 'package:geolocator/geolocator.dart';
import '../screens/home_screen.dart';

class MyDonationsScreen extends StatefulWidget {
  const MyDonationsScreen({super.key});

  @override
  State<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen> {
  final DonationService donationService = DonationService();

  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  String _calculateDistance(DonationModel donation) {
    if (_currentPosition == null) {
      return "Calculating...";
    }

    final distanceInMeters = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      donation.latitude,
      donation.longitude,
    );

    if (distanceInMeters < 1000) {
      return "${distanceInMeters.toStringAsFixed(0)} m away";
    }

    return "${(distanceInMeters / 1000).toStringAsFixed(1)} km away";
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen(initialIndex: 0)),
        );
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("My Donations"), centerTitle: true),

        body: StreamBuilder<List<DonationModel>>(
          stream: donationService.getMyDonations(),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final donations = List<DonationModel>.from(snapshot.data ?? []);

            const statusOrder = {"accepted": 0, "available": 1, "completed": 2};

            donations.sort((a, b) {
              final orderA = statusOrder[a.status] ?? 999;
              final orderB = statusOrder[b.status] ?? 999;

              if (orderA != orderB) {
                return orderA.compareTo(orderB);
              }

              // If two donations have the same status,
              // show the newest one first.
              return b.createdAt.compareTo(a.createdAt);
            });

            if (donations.isEmpty) {
              return const Center(
                child: Text(
                  "No donations found.",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: donations.length,
              itemBuilder: (context, index) {
                final donation = donations[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: DonationCard(
                    donation: donation,
                    distance: _calculateDistance(donation),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
