import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../features/location/models/donation_model.dart';
import '../../../core/services/donation_service.dart';
import '../../../features/auth/repository/profile_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonateFoodScreen extends StatefulWidget {
  const DonateFoodScreen({super.key});
  @override
  State<DonateFoodScreen> createState() => _DonateFoodScreenState();
}

class _DonateFoodScreenState extends State<DonateFoodScreen> {
  final TextEditingController cookedTimeController = TextEditingController();
  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController foodTypeController = TextEditingController();
  final TextEditingController bestBeforeController = TextEditingController();
  final TextEditingController pickupAddressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  DateTime? selectedCookedTime;
  DateTime? selectedBestBefore;

  final _formKey = GlobalKey<FormState>();

  final DonationService _donationService = DonationService();
  final ProfileRepository _profileRepository = ProfileRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text("Donate Food", style: AppTextStyles.heading),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Share Your Food", style: AppTextStyles.heading),

              const SizedBox(height: 8),

              Text(
                "Fill in the details below to help nearby volunteers collect your food.",
                style: AppTextStyles.subtitle,
              ),

              const SizedBox(height: 30),

              // Food Name
              TextFormField(
                controller: foodNameController,

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter the food name";
                  }
                  return null;
                },

                decoration: InputDecoration(
                  labelText: "Food Name",
                  hintText: "e.g. Veg Biryani",
                  prefixIcon: const Icon(Icons.fastfood),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Quantity
              TextFormField(
                controller: quantityController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter the quantity";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Quantity",
                  hintText: "e.g. Serves 5 people",
                  prefixIcon: const Icon(Icons.people),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Food Type
              TextFormField(
                controller: foodTypeController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter the food type";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Food Type",
                  hintText: "Veg / Non-Veg",
                  prefixIcon: const Icon(Icons.restaurant_menu),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Cooked Time
              TextFormField(
                controller: cookedTimeController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please select the cooked time";
                  }
                  return null;
                },
                readOnly: true,
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    final now = DateTime.now();

                    selectedCookedTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );

                    cookedTimeController.text = pickedTime.format(context);
                  }
                },
                decoration: InputDecoration(
                  labelText: "Cooked Time",
                  hintText: "Select Time",

                  prefixIcon: const Icon(Icons.schedule),
                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Best Before
              TextFormField(
                controller: bestBeforeController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please select the best before date & time";
                  }
                  return null;
                },
                readOnly: true,
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate == null) return;

                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime == null) return;

                  selectedBestBefore = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );

                  bestBeforeController.text =
                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year} ${pickedTime.format(context)}";
                },
                decoration: InputDecoration(
                  hintText: "Best Before",
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 104, 101, 101),
                    fontSize: 16,
                  ),

                  prefixIcon: const Icon(
                    Icons.event_outlined,
                    color: Colors.black54,
                  ),

                  suffixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.black87,
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Pickup Address
              TextFormField(
                controller: pickupAddressController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter the pickup address";
                  }
                  return null;
                },
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Pickup Address",
                  hintText: "Enter pickup location",
                  prefixIcon: const Icon(Icons.location_on),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Additional Notes
              TextField(
                controller: notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Additional Notes",
                  hintText: "Any instructions for the volunteer...",
                  prefixIcon: const Icon(Icons.note_alt_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();

                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    if (selectedCookedTime == null ||
                        selectedBestBefore == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please select both Cooked Time and Best Before.",
                          ),
                        ),
                      );
                      return;
                    }

                    await _saveDonation();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Donation added successfully 🎉"),
                      ),
                    );
                  },
                  child: const Text("Continue"),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception("Location permission denied.");
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        "Location permission permanently denied. Please enable it from Settings.",
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _saveDonation() async {
    final profile = await _profileRepository.getUserProfile();

    if (profile == null) {
      throw Exception("User profile not found.");
    }
    final position = await _getCurrentLocation();

    final donation = DonationModel(
      foodName: foodNameController.text.trim(),
      quantity: quantityController.text.trim(),
      foodType: foodTypeController.text.trim(),
      cookedTime: selectedCookedTime!,
      bestBefore: selectedBestBefore!,
      pickupAddress: pickupAddressController.text.trim(),
      notes: notesController.text.trim(),
      status: "available",
      donorName: profile.name,
      donorPhone: profile.phoneNumber,
      donorId: FirebaseAuth.instance.currentUser!.uid,
      latitude: position.latitude,
      longitude: position.longitude,
      createdAt: DateTime.now(),
    );

    await _donationService.addDonation(donation);
  }

  @override
  void dispose() {
    foodNameController.dispose();
    quantityController.dispose();
    foodTypeController.dispose();
    cookedTimeController.dispose();
    bestBeforeController.dispose();
    pickupAddressController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
