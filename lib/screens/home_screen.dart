import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../features/auth/repository/profile_repository.dart';
import '../../features/location/models/user_profile.dart';
import '../../features/location/models/user_location.dart';
import '../../features/donation/presentation/donate_food_screen.dart';
import 'package:geolocator/geolocator.dart';
import '../../features/receiver/receiver_home_screen.dart';
import '../../features/location/models/donation_model.dart';
import '../../core/services/donation_service.dart';
import '../core/services/location_service.dart';
import '../screens/my_donations_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/donation_card.dart';

class HomeScreen extends StatefulWidget {
  final UserLocation? currentLocation;
  final int initialIndex;

  const HomeScreen({super.key, this.currentLocation, this.initialIndex = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int currentIndex;
  final ProfileRepository _profileRepository = ProfileRepository();

  UserProfile? _profile;
  UserLocation? _currentLocation;
  Position? _receiverPosition;

  bool isLoading = true;
  final DonationService _donationService = DonationService();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _currentLocation = widget.currentLocation;

    _loadProfile();
    _getReceiverLocation();
    _loadCurrentLocation();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _profileRepository.getUserProfile();

      if (!mounted) return;

      setState(() {
        _profile = profile;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      debugPrint("Error loading profile: $e");
    }
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

  Future<void> _loadCurrentLocation() async {
    try {
      final location = await LocationService.instance.getUserLocation();

      if (!mounted) return;

      setState(() {
        _currentLocation = location;
      });

      debugPrint("Current Address: ${location.fullAddress}");
    } catch (e) {
      debugPrint("Error loading current location: $e");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      bottomNavigationBar: _buildBottomNavigation(),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              //--------------------------------------------------
              // Top App Bar
              //--------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        "assets/careitshareit_logo02.png",
                        height: 48,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.green, size: 22),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              //--------------------------------------------------
              // Location Chip
              //--------------------------------------------------
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(30),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Icon(Icons.location_on, size: 18, color: Colors.grey),

                    SizedBox(width: 6),

                    Expanded(
                      child: Text(
                        _currentLocation == null
                            ? "Fetching location..."
                            : _currentLocation!.fullAddress,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              //--------------------------------------------------
              // Greeting
              //--------------------------------------------------
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Hello, ", style: AppTextStyles.heading),

                    TextSpan(
                      text: "${_profile?.name ?? 'User'} ",
                      style: AppTextStyles.heading,
                    ),

                    const TextSpan(text: "👋", style: TextStyle(fontSize: 30)),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Every meal deserves a purpose.",
                style: AppTextStyles.subtitle,
              ),

              const SizedBox(height: 34),

              //--------------------------------------------------
              // Quick Actions
              //--------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      emoji: "🍱",

                      title: "Donate\nFood",

                      subtitle:
                          "Share your leftover food with nearby volunteers.",

                      buttonText: "Continue",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DonateFoodScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: _buildActionCard(
                      emoji: "🐾",

                      title: "Receive\nFood",

                      subtitle:
                          "Find nearby food donations and help feed stray animals.",

                      buttonText: "Explore",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReceiverHomeScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 34),

              Text("Current Activity", style: AppTextStyles.sectionTitle),

              const SizedBox(height: 18),

              StreamBuilder<List<DonationModel>>(
                stream: _donationService.getDonations(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }

                  final donations = List<DonationModel>.from(
                    snapshot.data ?? [],
                  );
                  const statusPriority = {
                    'available': 0,
                    'accepted': 1,
                    'completed': 2,
                  };

                  donations.sort((a, b) {
                    final priorityA =
                        statusPriority[a.status.toLowerCase()] ?? 99;
                    final priorityB =
                        statusPriority[b.status.toLowerCase()] ?? 99;

                    // Sort by status first
                    if (priorityA != priorityB) {
                      return priorityA.compareTo(priorityB);
                    }

                    // Within the same status, show newest first
                    return b.createdAt.compareTo(a.createdAt);
                  });

                  if (donations.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Center(
                        child: Text("No donations available."),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 380,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: donations.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final donation = donations[index];

                        return DonationCard(
                          donation: donation,
                          distance: _calculateDistance(donation),
                          width: 300,
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 34),

              //--------------------------------------------------
              // Nearby Community
              //--------------------------------------------------
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.04),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Nearby Community",
                            style: AppTextStyles.cardTitle,
                          ),
                        ),

                        TextButton(
                          onPressed: () {},

                          child: const Text("View Nearby"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("12", style: AppTextStyles.heading),

                              Text(
                                "Donations Nearby",
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("8", style: AppTextStyles.heading),

                              Text(
                                "Volunteers Nearby",
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        const Text("Within 5 km"),

                        const Spacer(),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),

                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(30),
                          ),

                          child: const Text(
                            "New Today",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //--------------------------------------------------
  // Action Card
  //--------------------------------------------------

  Widget _buildActionCard({
    required String emoji,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),

      onTap: onTap,

      child: Container(
        height: 250,

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade100,
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),

            const SizedBox(height: 22),

            Text(title, style: AppTextStyles.title),

            const SizedBox(height: 10),

            Expanded(child: Text(subtitle, style: AppTextStyles.bodySmall)),

            Row(
              children: [
                Text(
                  buttonText,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(width: 6),

                const Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //--------------------------------------------------
  // Bottom Navigation
  //--------------------------------------------------

  Widget _buildBottomNavigation() {
    return NavigationBar(
      selectedIndex: currentIndex,

      onDestinationSelected: (index) {
        if (index == currentIndex) return;

        setState(() {
          currentIndex = index;
        });

        switch (index) {
          case 0:
            // Already on Home
            break;

          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyDonationsScreen()),
            );
            break;

          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
            break;
        }
      },

      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: "Home",
        ),

        NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2),
          label: "My Donations",
        ),

        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}
