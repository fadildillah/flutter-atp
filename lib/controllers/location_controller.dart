import 'package:flutter_atp/core/utils/state_enum.dart';
import 'package:get/get.dart';
import 'package:flutter_atp/services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  final LocationService locationService = LocationService();
  Rxn<Position> currentPosition = Rxn<Position>();
  RxMap<String, double> cachedDistances = <String, double>{}.obs;
  var locationLoadingState = RequestState.initial.obs;
  var distanceLoadingState = RequestState.initial.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentLocation();
  }

  Future<void> fetchCurrentLocation() async {
    try {
      locationLoadingState.value = RequestState.loading;

      bool permissionGranted = await locationService.requestPermission();
      if (!permissionGranted) {
        locationLoadingState.value = RequestState.error;
        Get.snackbar('Permission Denied', 'Location permission is required');
        return;
      }

      currentPosition.value = await locationService.getCurrentLocation();
      locationLoadingState.value = RequestState.loaded;
    } catch (e) {
      locationLoadingState.value = RequestState.error;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> calculateDistance(
      double destLat, double destLng, String transportType, int index) async {
    String cacheKey = '${transportType}_$index';

    if (cachedDistances.containsKey(cacheKey)) return;

    if (currentPosition.value != null) {
      double distance = await locationService.calculateDistance(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
        destLat,
        destLng,
      );

      cachedDistances[cacheKey] = distance;
      cachedDistances.refresh();
    } else {
      Get.snackbar('Error', 'Current location is not available');
    }
  }

  Future<double> updateDistance(
      double destLat, double destLng, String transportType, int index) async {
    double distance = await locationService.calculateDistance(
      currentPosition.value!.latitude,
      currentPosition.value!.longitude,
      destLat,
      destLng,
    );
    if (currentPosition.value != null) {
      String cacheKey = '${transportType}_$index';
      cachedDistances[cacheKey] = distance;
      cachedDistances.refresh();
      return distance;
    } else {
      Get.snackbar('Error', 'Current location is not available');
      return double.infinity;
    }
  }
}
