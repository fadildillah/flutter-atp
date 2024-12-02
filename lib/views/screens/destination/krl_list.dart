import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_atp/controllers/destination_controller.dart';
import 'package:flutter_atp/controllers/location_controller.dart';
import 'package:flutter_atp/controllers/trip_controller.dart';
import 'package:flutter_atp/core/utils/distance_converter.dart';
import 'package:flutter_atp/core/utils/state_enum.dart';
import 'package:flutter_atp/core/widgets/dialog.dart';
import 'package:flutter_atp/core/widgets/dropdown.dart';
import 'package:flutter_atp/services/destination_service.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class KrlList extends StatefulWidget {
  const KrlList({super.key});

  @override
  State<KrlList> createState() => _KrlListState();
}

class _KrlListState extends State<KrlList> {
  final destinationController =
      Get.put(DestinationController(DestinationService()));

  final LocationController locationController = Get.put(LocationController());
  final TripController tripController = Get.put(TripController());

  var uuid = Uuid();
  var lineDescription = ''.obs;

  @override
  void initState() {
    super.initState();
    destinationController.fetchKrlCities();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(() {
            if (destinationController.isLoading.value == RequestState.loading) {
              return const CustomDropDown<String>(
                hintText: "Pilih Kota",
                icon: Icons.location_city_rounded,
                items: [],
                onChanged: null,
              );
            } else {
              return CustomDropDown<String>(
                hintText: 'Pilih Kota',
                icon: Icons.location_city_rounded,
                value: destinationController.selectedCity.value.isEmpty
                    ? null
                    : destinationController.selectedCity.value,
                items: destinationController.krlCities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city['name'] as String,
                    child: Text(
                      city['name'] as String,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    destinationController.selectedCity.value = value;
                    destinationController.selectedLine.value = '';
                    lineDescription.value = '';
                    locationController.cachedDistances.clear();
                    destinationController.krlStations.clear();
                    log(destinationController.selectedCity.value);
                    destinationController.fetchKrlLinesByCity(value);
                  }
                },
              );
            }
          }),
          const SizedBox(height: 16),
          Obx(() {
            if (destinationController.isLoading.value == RequestState.loading ||
                destinationController.krlLines.isEmpty) {
              return const SizedBox.shrink();
            } else {
              return Column(
                children: [
                  CustomDropDown<String>(
                    hintText: 'Pilih Jalur',
                    icon: Icons.train,
                    value: destinationController.selectedLine.value.isEmpty
                        ? null
                        : destinationController.selectedLine.value,
                    items: destinationController.krlLines.map((line) {
                      return DropdownMenuItem<String>(
                        value: line['name'] as String,
                        child: Text(
                          line['name'] as String,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        destinationController.selectedLine.value = value;
                        destinationController.krlStations.clear();
                        log(destinationController.selectedLine.value);
                        setState(() {
                          destinationController.fetchKrlStationsByCityAndLine(
                              destinationController.selectedCity.value, value);
                          lineDescription.value = destinationController.krlLines
                              .firstWhere((line) =>
                                  line['name'] ==
                                  destinationController
                                      .selectedLine.value)['description'];
                          locationController.cachedDistances.clear();
                          log(lineDescription.value);
                        });
                      }
                    },
                  ),
                  Obx(() {
                    if (lineDescription.value != '') {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.swap_vert_outlined,
                            color: Colors.blue,
                          ),
                          Text(
                            lineDescription.value,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                ],
              );
            }
          }),
          Obx(() {
            if (destinationController.isStationLoading.value ==
                RequestState.loading) {
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (destinationController.krlStations.isEmpty) {
              return const Expanded(
                child: Center(
                  child:
                      Text('Pilih kota lalu pilih jalur untuk melihat stasiun'),
                ),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: destinationController.krlStations.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      shadowColor: Theme.of(context).primaryColor,
                      elevation: 2.0,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red[300],
                          child: Icon(
                            Icons.train,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        title: Text(
                            destinationController.krlStations[index]['name'],
                            style: Theme.of(context).textTheme.titleSmall),
                        subtitle: Obx(() {
                          String cacheKey = 'krl_$index';
                          final cachedDistance =
                              locationController.cachedDistances[cacheKey];
                          if (cachedDistance != null) {
                            return Text(
                              'Jarak: ${meterToKilometer(cachedDistance)} km',
                              style: Theme.of(context).textTheme.bodyMedium,
                            );
                          } else if (locationController.currentPosition.value !=
                              null) {
                            locationController.calculateDistance(
                              destinationController.krlStations[index]
                                  ['latitude'],
                              destinationController.krlStations[index]
                                  ['longitude'],
                              'krl',
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
                          Get.dialog(
                            CustomDialog(
                                icon: Icons.subway,
                                background:
                                    Theme.of(context).scaffoldBackgroundColor,
                                title: destinationController.krlStations[index]
                                    ['name'],
                                subtitle:
                                    'Alarm akan aktif pada jarak 1 km sebelum stasiun tujuan.',
                                primaryButtonText: 'OK',
                                onPrimaryButtonPressed: () {
                                  tripController.insertKrlTrip(
                                    {
                                      'id': uuid.v4(),
                                      'station_id': destinationController
                                          .krlStations[index]['station_id'],
                                      'start_time':
                                          DateTime.now().toIso8601String(),
                                      'status': 'ongoing',
                                    },
                                  );
                                },
                                secondaryButtonText: 'Batal'),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }
          })
        ],
      ),
    );
  }
}
