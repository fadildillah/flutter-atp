import 'package:flutter/material.dart';

class TripCard extends StatelessWidget {
  final String type;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final int index;
  final void Function() onTap;

  const TripCard(
      {super.key,
      required this.index,
      required this.onTap,
      required this.title,
      required this.subtitle,
      required this.trailing,
      required this.type});

  Color _getColorByType(String type) {
    switch (type.toLowerCase()) {
      case 'mrt':
        return Colors.blue.shade100;
      case 'lrt':
        return Colors.red.shade100;
      case 'krl':
        return Colors.red.shade200;
      // Add more cases for other types if needed
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getColorByType(type),
      child: ListTile(
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
        // You can add more details like coordinates if needed
        // leading: Icon(_getIconByType(type)), // Optional: Add icons for different types
      ),
    );
  }
}

class TripCardDisabled extends StatelessWidget {
  final String type;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final int index;

  const TripCardDisabled({
    super.key,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.type,
  });

  Color _getColorByType(String type) {
    switch (type.toLowerCase()) {
      case 'mrt':
        return Colors.blue.shade50;
      case 'lrt':
        return Colors.red.shade50;
      case 'krl':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getColorByType(type),
      child: ListTile(
        enabled: false,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
      ),
    );
  }
}
