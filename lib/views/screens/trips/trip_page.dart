import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atp/controllers/location_controller.dart';
import 'package:flutter_atp/controllers/trip_controller.dart';
import 'package:flutter_atp/controllers/user_controller.dart';
import 'package:flutter_atp/core/utils/distance_converter.dart';
import 'package:flutter_atp/core/utils/state_enum.dart';
import 'package:flutter_atp/core/widgets/dialog.dart';
import 'package:flutter_atp/core/widgets/trip_card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TripPage extends StatefulWidget {
  TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  final UserController userController = Get.put(UserController());

  final TripController tripController = Get.put(TripController());

  final LocationController locationController = Get.put(LocationController());

  final Set<String> _activeAlarms = {};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      log('Updating distances');
      // First update current location
      await locationController.fetchCurrentLocation();
      // Then update distances
      _updateDistance();
      locationController.cachedDistances.refresh();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _activeAlarms.clear();
    super.dispose();
  }

  void _setupAlarmForNearbyStation(String stationType, int index,
      double distance, String stationName, String tripId) {
    // Create a unique identifier for this station alarm
    final String alarmKey = '${stationType}_${tripId}';

    // Only set up alarm if:
    // 1. We're within range
    // 2. This station doesn't already have an active alarm
    // 3. There isn't already a dialog showing for this station
    if (distance < 1000 &&
        !_activeAlarms.contains(alarmKey) &&
        !Get.isDialogOpen!) {
      _activeAlarms.add(alarmKey);

      final DateTime now = DateTime.now();
      final alarmId = index + 1;

      final alarmSettings = AlarmSettings(
        id: alarmId,
        dateTime: now.add(const Duration(seconds: 1)),
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: true,
        vibrate: true,
        volume: 0.8,
        fadeDuration: 3.0,
        warningNotificationOnKill: Platform.isIOS,
        androidFullScreenIntent: true,
        notificationSettings: NotificationSettings(
          title: 'Approaching ${stationType.toUpperCase()} Station',
          body: 'You are within 1km of $stationName',
          stopButton: 'Stop the alarm',
          icon: 'notification_icon',
        ),
      );

      Alarm.set(alarmSettings: alarmSettings).then((_) {
        _showAlarmDialog(stationType, alarmId, stationName, tripId, alarmKey);
      });
    }
  }

  void _updateDistance() async {
    if (locationController.currentPosition.value != null) {
      // Update MRT distances
      final mrtTrips = tripController.trips
          .where((trip) =>
              trip['destination']['type'] == 'mrt' &&
              trip['status'] == 'ongoing')
          .toList();

      for (var trip in mrtTrips) {
        final destination = trip['destination'];
        // Use the original index from the full trips list
        final originalIndex = tripController.trips.indexOf(trip);

        final distance = await locationController.updateDistance(
          destination['latitude'],
          destination['longitude'],
          'mrt',
          originalIndex,
        );
        _setupAlarmForNearbyStation(
            'mrt', originalIndex, distance, destination['name'], trip['id']);
      }

      // Update LRT distances
      final lrtTrips = tripController.trips
          .where((trip) =>
              trip['destination']['type'] == 'lrt' &&
              trip['status'] == 'ongoing')
          .toList();
      for (var trip in lrtTrips) {
        final destination = trip['destination'];
        final originalIndex = tripController.trips.indexOf(trip);
        final distance = await locationController.updateDistance(
          destination['latitude'],
          destination['longitude'],
          'lrt',
          originalIndex, // Use the original index
        );
        _setupAlarmForNearbyStation(
            'lrt', originalIndex, distance, destination['name'], trip['id']);
      }

      // Update KRL distances
      final krlTrips = tripController.tripStations
          .where((trip) => trip['status'] == 'ongoing')
          .toList();
      for (var trip in krlTrips) {
        final station = trip['station'];
        final originalIndex = tripController.tripStations.indexOf(trip);
        final distance = await locationController.updateDistance(
          station['latitude'],
          station['longitude'],
          'krl',
          originalIndex,
        );
        _setupAlarmForNearbyStation(
            'krl', originalIndex, distance, station['name'], trip['id']);
      }

      // Update BRT distances
      final brtTrips = tripController.trips
          .where((trip) =>
              trip['destination']['type'] == 'brt' &&
              trip['status'] == 'ongoing')
          .toList();
      for (var trip in brtTrips) {
        final destination = trip['destination'];
        final originalIndex = tripController.trips.indexOf(trip);
        final distance = await locationController.updateDistance(
          destination['latitude'],
          destination['longitude'],
          'brt',
          originalIndex,
        );
        _setupAlarmForNearbyStation(
            'brt', originalIndex, distance, destination['name'], trip['id']);
      }
    }
  }

  void _showAlarmDialog(String stationType, int alarmId, String stationName,
      String tripId, String alarmKey) {
    Get.dialog(
      CustomDialog(
          title: "Approaching ${stationType.toUpperCase()} Station",
          subtitle: "You are within 1km from $stationName",
          icon: Icons.alarm,
          onPrimaryButtonPressed: () async {
            Alarm.stop(alarmId);
            if (stationType != 'krl') {
              await tripController.updateTrip(tripId, {
                'status': 'success',
              });
            } else {
              await tripController.updateKrlTrip(tripId, {
                'status': 'success',
              });
            }
            _activeAlarms.remove(alarmKey); // Remove from active alarms
            Get.back();
          }),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trips'),
          centerTitle: true,
          bottom: TabBar(
            automaticIndicatorColorAdjustment: true,
            tabs: [
              buildTabBar(context, 'MRT'),
              buildTabBar(context, 'LRT'),
              buildTabBar(context, 'KRL'),
              buildTabBar(context, 'BRT'),
            ],
          ),
        ),
        body: SafeArea(
          child: Obx(() {
            if (tripController.isLoading.value == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (tripController.isLoading.value == RequestState.loaded &&
                    tripController.trips.isNotEmpty ||
                tripController.tripStations.isNotEmpty) {
              final mrtTrips = tripController.trips
                  .where((trip) => trip['destination']['type'] == 'mrt')
                  .toList();
              final lrtTrips = tripController.trips
                  .where((trip) => trip['destination']['type'] == 'lrt')
                  .toList();
              final krlTrips = tripController.tripStations.toList();
              final brtTrips = tripController.trips
                  .where((trip) => trip['destination']['type'] == 'brt')
                  .toList();

              return TabBarView(
                children: [
                  buildTripList(context, mrtTrips, 'mrt'),
                  buildTripList(context, lrtTrips, 'lrt'),
                  buildKrlTripList(context, krlTrips),
                  buildTripList(context, brtTrips, 'brt'),
                ],
              );
            } else {
              return const Center(child: Text('No data'));
            }
          }),
        ),
      ),
    );
  }

  Widget buildTripList(BuildContext context, List trips, String type) {
    if (trips.isEmpty) {
      return const Center(child: Text('No trips available'));
    }

    // Separate trips based on status with indices preserved
    final ongoingTrips = trips.asMap().entries.where((entry) {
      tripController.trips.indexOf(entry.value);
      return entry.value['status'] == 'ongoing';
    }).map((entry) {
      final originalIndex = tripController.trips.indexOf(entry.value);
      return MapEntry(originalIndex, entry.value);
    }).toList();

    final completedTrips = trips
        .asMap()
        .entries
        .where((entry) => entry.value['status'] == 'success')
        .map((entry) => MapEntry(entry.key, entry.value))
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (ongoingTrips.isNotEmpty) ...[
          const Text(
            'Active Trips',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...ongoingTrips.map((entry) => TripCard(
                index: entry.key, // Use original index from trips list
                title: Text(entry.value['destination']['name']),
                subtitle: Text(type.toUpperCase()),
                trailing: Obx(() {
                  String cacheKey = '${type}_${entry.key}';
                  final cachedDistance =
                      locationController.cachedDistances[cacheKey];
                  log('Cache key: $cacheKey, Distance: $cachedDistance');
                  log('Current position: ${locationController.currentPosition.value}');

                  if (cachedDistance != null) {
                    return Text(
                      'Jarak: ${meterToKilometer(cachedDistance)} km',
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  }

                  if (locationController.currentPosition.value != null) {
                    // Trigger calculation only if not already running for this key
                    if (!locationController.cachedDistances
                        .containsKey(cacheKey)) {
                      locationController.calculateDistance(
                        entry.value['destination']['latitude'],
                        entry.value['destination']['longitude'],
                        type,
                        entry.key,
                      );
                    }
                  }

                  return const CircularProgressIndicator(); // Show loading if calculating
                }),

                onTap: () {
                  tripController.deleteTrip(entry.value['id']);
                },
                type: type,
              )),
          const SizedBox(height: 16),
        ],
        if (completedTrips.isNotEmpty) ...[
          const Text(
            'Recent Trips',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...completedTrips.map((entry) => TripCardDisabled(
                index: entry.key, // Use original index from trips list
                title: Text(entry.value['destination']['name']),
                subtitle: Text(DateFormat('hh:mm a')
                    .format(DateTime.parse(entry.value['start_time']))),
                trailing: Text(
                  DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(entry.value['start_time'])),
                ),
                type: type,
              )),
        ],
        if (ongoingTrips.isEmpty && completedTrips.isEmpty)
          const Center(child: Text('No trips available')),
      ],
    );
  }

  Widget buildKrlTripList(BuildContext context, List trips) {
    if (trips.isEmpty) {
      return const Center(child: Text('No trips available'));
    }

    final ongoingTrips = trips.asMap().entries.where((entry) {
      tripController.tripStations.indexOf(entry.value);
      return entry.value['status'] == 'ongoing';
    }).map((entry) {
      final originalIndex = tripController.tripStations.indexOf(entry.value);
      return MapEntry(originalIndex, entry.value);
    }).toList();

    final completedTrips = trips
        .asMap()
        .entries
        .where((entry) => entry.value['status'] == 'success')
        .map((entry) => MapEntry(entry.key, entry.value))
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (ongoingTrips.isNotEmpty) ...[
          const Text(
            'Active Trips',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...ongoingTrips.map((entry) => TripCard(
                index: entry.key,
                title: Text(entry.value['station']['name']),
                subtitle: Text('KRL'),
                trailing: Obx(() {
                  String cacheKey = 'krl_${entry.key}';
                  final cachedDistance =
                      locationController.cachedDistances[cacheKey];

                  if (cachedDistance != null) {
                    return Text(
                      'Jarak: ${meterToKilometer(cachedDistance)} km',
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  } else if (locationController.currentPosition.value != null) {
                    locationController.calculateDistance(
                      entry.value['station']['latitude'],
                      entry.value['station']['longitude'],
                      'krl',
                      entry.key,
                    );
                  }
                  return const SizedBox();
                }),
                onTap: () {
                  tripController.deleteKrlTrip(entry.value['id']);
                },
                type: 'krl',
              )),
          const SizedBox(height: 16),
        ],
        if (completedTrips.isNotEmpty) ...[
          const Text(
            'Recent Trips',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...completedTrips.map((entry) => TripCardDisabled(
                index: entry.key,
                title: Text(entry.value['station']['name']),
                subtitle: Text(DateFormat('hh:mm a')
                    .format(DateTime.parse(entry.value['start_time']))),
                trailing: Text(
                  DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(entry.value['start_time'])),
                ),
                type: 'krl',
              )),
        ],
        if (ongoingTrips.isEmpty && completedTrips.isEmpty)
          const Center(child: Text('No trips available')),
      ],
    );
  }

  Widget buildTabBar(BuildContext context, String label) {
    return Tab(
      child: Text(label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              )),
    );
  }
}
