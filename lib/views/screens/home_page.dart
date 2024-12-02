import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_atp/core/utils/distance_converter.dart';
import 'package:flutter_atp/core/widgets/dialog.dart';
import 'package:get/get.dart';
import 'package:flutter_atp/controllers/location_controller.dart';
import 'package:flutter_atp/controllers/trip_controller.dart';
import 'package:flutter_atp/core/utils/state_enum.dart';
import 'package:flutter_atp/core/widgets/floating_menu_button.dart';
import 'package:flutter_atp/core/widgets/trip_card.dart';

class HomePage extends StatelessWidget {
  final TripController tripController = Get.put(TripController());
  final LocationController locationController = Get.put(LocationController());

  final List<Map<String, dynamic>> sliderImages = [
    {
      "path": 'assets/krl-rute.webp',
      "title": 'KRL Jabodetabek',
    },
    {
      "path": 'assets/lrt-rute.jpg',
      "title": 'LRT Jabodebek',
    },
    {
      "path": 'assets/mrt-rute.webp',
      "title": 'MRT Jakarta',
    },
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Active Trips',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        // Determine if there are any ongoing trips
                        final ongoingTrips = tripController.trips
                            .where((trip) => trip['status'] == 'ongoing')
                            .toList();

                        // If no ongoing trips or loading
                        if (tripController.isLoading.value ==
                            RequestState.loading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (ongoingTrips.isEmpty) {
                          return Card(
                            elevation: 4,
                            child: Container(
                              height:
                                  150, // Adjust this value to control the card's height
                              width: double.infinity,
                              padding: const EdgeInsets.all(16.0),
                              child: const Center(
                                child: Text(
                                  'No Active Trips',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        // If there are ongoing trips, show the list
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ongoingTrips.length,
                          itemBuilder: (context, index) {
                            final destination =
                                ongoingTrips[index]['destination'];
                            final type = destination['type'];
                            return TripCard(
                              type: type,
                              index: index,
                              title: Text(destination['name']),
                              subtitle: Text(type.toString().toUpperCase()),
                              trailing: Obx(() {
                                String cacheKey = '${type}_$index';
                                final cachedDistance = locationController
                                    .cachedDistances[cacheKey];

                                if (cachedDistance != null) {
                                  return Text(
                                    'Jarak: ${meterToKilometer(cachedDistance)} km',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  );
                                } else if (locationController
                                        .currentPosition.value !=
                                    null) {
                                  locationController.calculateDistance(
                                    destination['latitude'],
                                    destination['longitude'],
                                    type,
                                    index,
                                  );
                                }
                                return const SizedBox();
                              }),
                              onTap: () {
                                Get.dialog(
                                  CustomDialog(
                                    title: type.toString().toUpperCase(),
                                    subtitle: destination['name'],
                                    icon: Icons.info,
                                    onPrimaryButtonPressed: () {
                                      Get.back();
                                    },
                                    primaryButtonText: "OK",
                                    onSecondaryButtonPressed: () {
                                      tripController
                                          .deleteTrip(ongoingTrips[index]['id'])
                                          .then(
                                            (value) => Get.back(),
                                          );
                                    },
                                    secondaryButtonText: "Hapus",
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }),

                      const SizedBox(height: 20),
                      const Text(
                        'Peta Rute',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Image Slider
                      CarouselSlider.builder(
                        itemCount: sliderImages.length,
                        itemBuilder: (context, index, realIndex) {
                          final imageData = sliderImages[index];
                          return GestureDetector(
                            onTap: () {
                              // Show full image dialog
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Image.asset(
                                    imageData['path'],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      imageData['path'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                    Container(
                                      color: Colors
                                          .black45, // Slightly transparent black overlay
                                      child: Center(
                                        child: Text(
                                          imageData['title'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 10.0,
                                                color: Colors.black,
                                                offset: Offset(2.0, 2.0),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 200,
                          viewportFraction: 0.8,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: const FloatingMenuButton(),
        ),
      ),
    );
  }
}
