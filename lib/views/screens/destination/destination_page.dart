import 'package:flutter/material.dart';
import 'package:flutter_atp/core/utils/transport_type.dart';
import 'package:flutter_atp/views/screens/destination/brt_list.dart';
import 'package:flutter_atp/views/screens/destination/krl_list.dart';
import 'package:flutter_atp/views/screens/destination/lrt_list.dart';
import 'package:flutter_atp/views/screens/destination/mrt_list.dart';
import 'package:get/get.dart';

class DestinationPage extends StatelessWidget {
  DestinationPage({super.key});

  final TransportType type = Get.arguments;

  @override
  Widget build(BuildContext context) {
    Widget listWidget;

    switch (type) {
      case TransportType.mrt:
        listWidget = MrtList();
        break;
      case TransportType.lrt:
        listWidget = LrtList();
        break;
      case TransportType.krl:
        listWidget = KrlList();
        break;
      case TransportType.brt:
        listWidget = BrtList();
        break;
      default:
        listWidget = Center(child: Text("No list available"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(type.toString().split('.').last.toUpperCase()),
        centerTitle: true,
      ),
      body: listWidget,
    );
  }
}
