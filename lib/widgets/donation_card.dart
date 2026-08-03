import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../features/location/models/donation_model.dart';
import '../screens/auth/donation_details_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class DonationCard extends StatelessWidget {
  final DonationModel donation;
  final String distance;
  final double? width;

  const DonationCard({
    super.key,
    required this.donation,
    required this.distance,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade100,
                child: Text(
                  donation.foodType.toLowerCase().contains("veg") ? "🥗" : "🍱",
                  style: const TextStyle(fontSize: 22),
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color:
                      donation.status == "accepted"
                          ? Colors.orange.shade100
                          : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  donation.status.toUpperCase(),
                  style: TextStyle(
                    color:
                        donation.status == "accepted"
                            ? Colors.orange
                            : Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            donation.foodName,
            style: AppTextStyles.cardTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.restaurant, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                "Quantity: ${donation.quantity}",
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  DateFormat('dd MMM • hh:mm a').format(donation.bestBefore),
                  style: AppTextStyles.bodySmall,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(distance, style: AppTextStyles.bodySmall)),
            ],
          ),

          if (donation.status == "accepted") ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            const Text(
              "Accepted By",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.person, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    donation.acceptedByName.isEmpty
                        ? "Unknown"
                        : donation.acceptedByName,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(Icons.phone, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    donation.acceptedByPhone.isEmpty
                        ? "Not Available"
                        : donation.acceptedByPhone,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          InkWell(
            onTap:
                donation.status == "available"
                    ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DonationDetailsScreen(donation: donation),
                        ),
                      );
                    }
                    : null,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_forward,
                    color:
                        donation.status == "available"
                            ? AppColors.primary
                            : Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "View Details",
                    style: TextStyle(
                      color:
                          donation.status == "available"
                              ? AppColors.primary
                              : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
