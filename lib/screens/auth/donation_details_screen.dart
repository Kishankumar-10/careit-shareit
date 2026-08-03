import 'package:flutter/material.dart';
import '../../features/location/models/donation_model.dart';
import 'package:intl/intl.dart';
import '../../core/services/donation_service.dart';

class DonationDetailsScreen extends StatefulWidget {
  final DonationModel donation;

  const DonationDetailsScreen({super.key, required this.donation});

@override
State<DonationDetailsScreen> createState() =>
    _DonationDetailsScreenState();
} 

class _DonationDetailsScreenState
    extends State<DonationDetailsScreen> {

  final DonationService _donationService = DonationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Donation Details"), centerTitle: true),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox( 
            height: 52,
            child: ElevatedButton(
  onPressed: () async {
    try {
      await _donationService.acceptDonation(widget.donation.id!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Donation accepted successfully 🎉"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to accept donation: $e"),
        ),
      );
    }
  },
  child: const Text("Accept Donation"),
),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Food Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      child: Text("🍱", style: TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.donation.foodName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Chip(
                            label: Text(
                              widget.donation.status.substring(0, 1).toUpperCase() +
                                  widget.donation.status.substring(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Food Details
            const Text(
              "Food Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.restaurant),
                    title: const Text("Food Type"),
                    subtitle: Text(widget.donation.foodType),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.scale),
                    title: const Text("Quantity"),
                    subtitle: Text(widget.donation.quantity),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text("Cooked Time"),
                    subtitle: Text(
                      DateFormat(
                        'dd MMM • hh:mm a',
                      ).format(widget.donation.cookedTime),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.timer),
                    title: const Text("Best Before"),
                    subtitle: Text(
                      DateFormat(
                        'dd MMM • hh:mm a',
                      ).format(widget.donation.bestBefore),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notes),
                    title: const Text("Notes"),
                    subtitle: Text(
                      widget.donation.notes.isEmpty
                          ? "No notes provided"
                          : widget.donation.notes,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Pickup Details
            const Text(
              "Pickup Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(width: 8),
                        Expanded(child: Text(widget.donation.pickupAddress)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text("Open in Maps"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Donor Details
            const Text(
              "Donor Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const Card(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text("Kishan Kumar"),
                    subtitle: Text("Donor"),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text("Phone"),
                    subtitle: Text("+91 9876543210"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
