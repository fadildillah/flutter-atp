import 'package:flutter/material.dart';
import 'package:flutter_atp/controllers/destination_controller.dart';
import 'package:flutter_atp/core/utils/state_enum.dart';
import 'package:flutter_atp/services/destination_service.dart';
import 'package:get/get.dart';

class BrtList extends StatefulWidget {
  const BrtList({super.key});

  @override
  State<BrtList> createState() => _BrtListState();
}

class _BrtListState extends State<BrtList> {
  final destinationController =
      Get.put(DestinationController(DestinationService()));
  List<dynamic> filteredDestinations = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    destinationController.fetchDestinationByType('brt').then((_) {
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
              child: TextField(
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
                decoration: const InputDecoration(
                  hintText: 'Search by station',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDestinations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredDestinations[index].name),
                    subtitle: Text(filteredDestinations[index].type),
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
