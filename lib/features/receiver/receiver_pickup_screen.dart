import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/services/donation_service.dart';
import '../../features/location/models/donation_model.dart';

class ReceiverPickupScreen extends StatelessWidget {
  final DonationModel donation;

  final DonationService _donationService = DonationService();

  ReceiverPickupScreen({super.key, required this.donation});

  Future<void> _openGoogleMaps(BuildContext context) async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${donation.latitude},${donation.longitude}',
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pickup Details")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.orange.shade50,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.local_shipping, color: Colors.white),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Pickup Status",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            donation.status.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            _sectionTitle(Icons.fastfood, "Food Details"),

            const SizedBox(height: 20),

            _infoTile("Food Name", donation.foodName),

            _infoTile("Food Type", donation.foodType),

            _infoTile("Quantity", donation.quantity),

            _infoTile("Pickup Address", donation.pickupAddress),

            const SizedBox(height: 30),

            _sectionTitle(Icons.person, "Donor Details"),

            const SizedBox(height: 20),

            _infoTile("Donor Name", donation.donorName),

            _infoTile("Phone", donation.donorPhone),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _openGoogleMaps(context),
                child: const Text("Open Google Maps"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _donationService.completeDonation(donation.id!);

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Donation marked as completed."),
                    ),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Mark Completed"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(title: Text(title), subtitle: Text(value)),
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 24),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
