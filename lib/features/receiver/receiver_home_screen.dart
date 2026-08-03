import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../features/receiver/receiver_pickup_screen.dart';
import '../../core/services/donation_service.dart';
import '../../features/location/models/donation_model.dart';

class ReceiverHomeScreen extends StatefulWidget {
  const ReceiverHomeScreen({super.key});

  @override
  State<ReceiverHomeScreen> createState() => _ReceiverHomeScreenState();
}

class _ReceiverHomeScreenState extends State<ReceiverHomeScreen> {
  final DonationService _donationService = DonationService();

  Position? _receiverPosition;

  @override
  void initState() {
    super.initState();
    _getReceiverLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Receive Food")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Nearby Food Donations",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: StreamBuilder<List<DonationModel>>(
                  stream: _donationService.getDonations(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text("Something went wrong"));
                    }

                    final donations =
                        (snapshot.data ?? [])
                            .where((d) => d.status == "available")
                            .toList();

                    if (donations.isEmpty) {
                      return const Center(
                        child: Text("No donations available"),
                      );
                    }

                    return ListView.builder(
                      itemCount: donations.length,
                      itemBuilder: (context, index) {
                        final donation = donations[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  donation.foodName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text("Quantity : ${donation.quantity}"),

                                Text("Type : ${donation.foodType}"),

                                Text(
                                  "Best Before : ${DateFormat('dd MMM • hh:mm a').format(donation.bestBefore)}",
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  _calculateDistance(donation),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (!context.mounted) return;

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => ReceiverPickupScreen(
                                                donation: donation,
                                              ),
                                        ),
                                      );

                                      await _donationService.acceptDonation(
                                        donation.id!,
                                      );
                                    },
                                    child: const Text("Accept"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getReceiverLocation() async {
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
        _receiverPosition = position;
      });

      debugPrint(
        "Receiver Location: ${position.latitude}, ${position.longitude}",
      );
    } catch (e) {
      debugPrint("Error getting receiver location: $e");
    }
  }

  String _calculateDistance(DonationModel donation) {
    if (_receiverPosition == null) {
      return "Calculating...";
    }

    final distanceInMeters = Geolocator.distanceBetween(
      _receiverPosition!.latitude,
      _receiverPosition!.longitude,
      donation.latitude,
      donation.longitude,
    );

    if (distanceInMeters < 1000) {
      return "${distanceInMeters.toStringAsFixed(0)} m away";
    }

    return "${(distanceInMeters / 1000).toStringAsFixed(1)} km away";
  }
}
