import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_atp/core/utils/state_enum.dart';
import 'package:get/get.dart';
import 'package:flutter_atp/services/trip_service.dart';

class TripController extends GetxController {
  final TripService tripService = TripService();
  final isLoading = RequestState.loading.obs;

  RxList<Map<String, dynamic>> trips = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> tripStations = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    getTrips();
  }

  Future<void> insertTrip(Map<String, dynamic> trip) async {
    try {
      // Set loading state after build completes to avoid interference
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.loading;
      });

      await tripService.insertTrip(trip);

      // Set loaded state after insertion is successful
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.loaded;
      });

      // Navigate to trip page while preserving bottom navigation
      Get.offAllNamed('/',
          predicate: (route) => route.settings.name == '/trip');
    } catch (e) {
      log('Error inserting trip: ${e.toString()}');
      // Delay setting the error state to prevent interference
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.error;
      });
    }
  }

  Future<void> insertKrlTrip(Map<String, dynamic> trip) async {
    try {
      // Set loading state after build completes to avoid interference
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.loading;
      });

      await tripService.insertKrlTrip(trip);

      // Set loaded state after insertion is successful
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.loaded;
      });

      // Navigate to trip page while preserving bottom navigation
      Get.offAllNamed('/',
          predicate: (route) => route.settings.name == '/trip');
    } catch (e) {
      log('Error inserting trip: ${e.toString()}');
      // Delay setting the error state to prevent interference
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.error;
      });
    }
  }

  // for trips mrt, lrt and krl
  Future<void> getTrips() async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.loading;
      });

      final _trips = await tripService.getTripsWithDestinations();
      final _tripsStations = await tripService.getKrlTrips();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        trips.assignAll(_trips);
        tripStations.assignAll(_tripsStations);
        isLoading.value = RequestState.loaded;
        log('Trips: $trips');
      });
    } catch (e) {
      log('Error fetching trips: ${e.toString()}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.error;
      });
    }
  }

  Future<void> updateTrip(String id, Map<String, Object?> data) async {
    try {
      // Set loading state after build completes to avoid interference
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.loading;
      });

      // Update trip in database
      await tripService.updateTrip(id, data);

      // Fetch updated trips after update
      await getTrips();
    } catch (e) {
      log('Error updating trip: ${e.toString()}');
      // Delay setting the error state to prevent interference
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.error;
      });
    }
  }

  Future<void> updateKrlTrip(String id, Map<String, Object?> data) async {
    try {
      // Set loading state after build completes to avoid interference
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.loading;
      });

      // Update trip in database
      await tripService.updateKrlTrip(id, data);

      // Fetch updated trips after update
      await getTrips();
    } catch (e) {
      log('Error updating trip: ${e.toString()}');
      // Delay setting the error state to prevent interference
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.error;
      });
    }
  }

  Future<void> deleteTrip(String id) async {
    try {
      // Set loading state after build completes to avoid interference
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.loading;
      });

      // Delete trip from database
      await tripService.deleteTrip(id);

      // Fetch updated trips after deletion
      await getTrips();
    } catch (e) {
      log('Error deleting trip: ${e.toString()}');
      // Delay setting the error state to prevent interference
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.error;
      });
    }
  }

  Future<void> deleteKrlTrip(String id) async {
    try {
      // Set loading state after build completes to avoid interference
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.loading;
      });

      // Delete trip from database
      await tripService.deleteKrlTrip(id);

      // Fetch updated trips after deletion
      await getTrips();
    } catch (e) {
      log('Error deleting trip: ${e.toString()}');
      // Delay setting the error state to prevent interference
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoading.value = RequestState.error;
      });
    }
  }
}
