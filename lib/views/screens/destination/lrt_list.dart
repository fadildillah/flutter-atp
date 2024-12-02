import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_atp/controllers/destination_controller.dart';
import 'package:flutter_atp/controllers/location_controller.dart';
import 'package:flutter_atp/controllers/trip_controller.dart';
import 'package:flutter_atp/controllers/user_controller.dart';
import 'package:flutter_atp/core/utils/distance_converter.dart';
import 'package:flutter_atp/core/utils/state_enum.dart';
import 'package:flutter_atp/core/widgets/dialog.dart';
import 'package:flutter_atp/core/widgets/search_field.dart';
import 'package:flutter_atp/services/destination_service.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class LrtList extends StatefulWidget {
  const LrtList({super.key});

  @override
  State<LrtList> createState() => _LrtListState();
}

class _LrtListState extends State<LrtList> {
  final destinationController =
      Get.put(DestinationController(DestinationService()));
  final LocationController locationController = Get.put(LocationController());
  final UserController userController = Get.put(UserController());
  final TripController tripController = Get.put(TripController());
  List<dynamic> filteredDestinations = [];
  TextEditingController searchController = TextEditingController();

  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    destinationController.fetchDestinationByType('lrt').then((_) {
      setState(() {
        filteredDestinations = destinationController.destinations;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (destinationController.isLoading.value == RequestState.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (destinationController.isLoading.value == RequestState.loaded) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomSearchField(
                hintText: 'Cari Stasiun',
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    filteredDestinations = destinationController.destinations
                        .where((destination) => destination.name
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDestinations.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    shadowColor: Theme.of(context).primaryColor,
                    elevation: 2.0,
                    child: ListTile(
                        leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/lrt.jpg')),
                        title: Text(filteredDestinations[index].name,
                            style: Theme.of(context).textTheme.titleSmall),
                        subtitle: Obx(() {
                          // Create the unique key based on the type and index
                          String cacheKey = 'lrt_$index';
                          final cachedDistance =
                              locationController.cachedDistances[cacheKey];

                          if (cachedDistance != null) {
                            // Display the cached distance if available
                            return Text(
                              'Jarak: ${meterToKilometer(cachedDistance)} km',
                              style: Theme.of(context).textTheme.bodyMedium,
                            );
                          } else if (locationController.currentPosition.value !=
                              null) {
                            // Calculate and cache the distance once using the unique key
                            locationController.calculateDistance(
                              filteredDestinations[index].latitude,
                              filteredDestinations[index].longitude,
                              'lrt', // Pass the transport type here
                              index,
                            );
                            return const Text('Calculating distance...');
                          } else {
                            return const Text('Loading distance...');
                          }
                        }),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        onTap: () {
                          log(filteredDestinations[index].toMap().toString());
                          Get.dialog(
                            CustomDialog(
                                icon: Icons.directions_railway,
                                background:
                                    Theme.of(context).scaffoldBackgroundColor,
                                title: filteredDestinations[index].name,
                                subtitle:
                                    'Alarm akan aktif pada jarak 1 km sebelum stasiun tujuan.',
                                primaryButtonText: 'OK',
                                onPrimaryButtonPressed: () {
                                  tripController.insertTrip(
                                    {
                                      'id': uuid.v4(),
                                      'destination_id':
                                          filteredDestinations[index].id,
                                      'start_time':
                                          DateTime.now().toIso8601String(),
                                      'status': 'ongoing',
                                    },
                                  );
                                },
                                secondaryButtonText: 'Batal'),
                          );
                        }),
                  );
                },
              ),
            ),
          ],
        );
      } else {
        return const Center(child: Text('Failed to load data'));
      }
    });
  }
}
