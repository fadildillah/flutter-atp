import 'dart:developer';

import 'package:flutter_atp/core/utils/state_enum.dart';
import 'package:flutter_atp/models/destination_model.dart';
import 'package:flutter_atp/services/destination_service.dart';
import 'package:get/get.dart';

class DestinationController extends GetxController {
  final DestinationService _destinationService;

  var destinations = <Destination>[].obs;

  var krlCities = <Map<String, dynamic>>[].obs;
  RxString selectedCity = ''.obs;
  var krlLines = <Map<String, dynamic>>[].obs;
  RxString selectedLine = ''.obs;
  var krlStations = <Map<String, dynamic>>[].obs;

  var isLoading = RequestState.initial.obs;
  var isStationLoading = RequestState.initial.obs;

  DestinationController(this._destinationService);

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchAllDestinations() async {
    try {
      isLoading.value = RequestState.loading;
      List<Destination> _destinations =
          await _destinationService.getAllDestination();
      destinations.assignAll(_destinations);
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = RequestState.loaded;
    }
  }

  Future<void> fetchDestinationByType(String type) async {
    try {
      isLoading.value = RequestState.loading;
      List<Destination> _destinations =
          await _destinationService.getDestinationByType(type);
      destinations.assignAll(_destinations);
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = RequestState.loaded;
    }
  }

  Future<void> fetchDestinationById(String id) async {
    try {
      isLoading.value = RequestState.loading;
      List<Destination> _destinations =
          await _destinationService.getDestinationById(id);
      destinations.assignAll(_destinations);
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = RequestState.loaded;
    }
  }

  Future<void> fetchKrlCities() async {
    try {
      isLoading.value = RequestState.loading;

      List<Map<String, dynamic>> _cities =
          await _destinationService.getKrlCities();
      krlCities.assignAll(_cities);
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = RequestState.loaded;
    }
  }

  Future<void> fetchKrlLines() async {
    try {
      isLoading.value = RequestState.loading;
      List<Map<String, dynamic>> _lines =
          await _destinationService.getKrlLines();
      krlLines.assignAll(_lines);
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = RequestState.loaded;
    }
  }

  Future<void> fetchKrlLinesByCity(String city) async {
    try {
      isLoading.value = RequestState.loading;
      List<Map<String, dynamic>> _lines =
          await _destinationService.getKrlLinesByCity(city);
      krlLines.assignAll(_lines);
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = RequestState.loaded;
    }
  }

  Future<void> fetchKrlStationsByCityAndLine(String city, String line) async {
    try {
      // Update loading state
      isStationLoading.value = RequestState.loading;
      log("Fetching stations for city: ${selectedCity.value}, line: ${selectedLine.value}");

      // Call the service function
      List<Map<String, dynamic>> _stations =
          await _destinationService.getKrlStationsByCityAndLine(city, line);
      krlStations.assignAll(_stations);

      // Update the loading state after fetching data
      isStationLoading.value = RequestState.loaded;
    } catch (e) {
      // Handle error and set the state to loaded
      isStationLoading.value = RequestState.error;
      print("Error fetching stations: $e");
    }
  }
}
