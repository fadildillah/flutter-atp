import 'package:flutter/material.dart';
import 'package:flutter_atp/core/utils/transport_type.dart';
import 'package:get/get.dart';

class FloatingMenuButton extends StatefulWidget {
  const FloatingMenuButton({super.key});

  @override
  _FloatingMenuButtonState createState() => _FloatingMenuButtonState();
}

class _FloatingMenuButtonState extends State<FloatingMenuButton>
    with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Option 1 Button
        AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          bottom: _isMenuOpen ? 220 : 0,
          right: 0,
          child: _buildOptionButton(
            icon: Icons.directions_subway,
            label: 'MRT',
            onPressed: () {
              // Handle Option 1 tap
              Get.toNamed('/destination', arguments: TransportType.mrt);
            },
          ),
        ),

        // Option 2 Button
        AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          bottom: _isMenuOpen ? 170 : 0,
          right: 0,
          child: _buildOptionButton(
            icon: Icons.directions_railway,
            label: 'LRT',
            onPressed: () {
              // Handle Option 2 tap
              Get.toNamed('/destination', arguments: TransportType.lrt);
            },
          ),
        ),

        // Option 3 Button
        AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          bottom: _isMenuOpen ? 120 : 0,
          right: 0,
          child: _buildOptionButton(
            icon: Icons.train,
            label: 'KRL',
            onPressed: () {
              // Handle Option 3 tap
              Get.toNamed('/destination', arguments: TransportType.krl);
            },
          ),
        ),

        // Option 4 Button
        AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          bottom: _isMenuOpen ? 70 : 0,
          right: 0,
          child: _buildOptionButton(
            icon: Icons.directions_bus,
            label: 'BRT',
            onPressed: () {
              // Handle Option 4 tap
              Get.toNamed('/destination', arguments: TransportType.brt);
            },
          ),
        ),

        // Main FAB Button
        Positioned(
          bottom: 10,
          right: 0,
          child: FloatingActionButton.extended(
            onPressed: _toggleMenu,
            label: Text(
              "Moda\nTransportasi",
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            icon: Icon(_isMenuOpen ? Icons.close : Icons.add_circle,
                color: Theme.of(context).colorScheme.onSurface),
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton(
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return AnimatedOpacity(
      opacity: _isMenuOpen ? 1.0 : 0.0,
      duration: Duration(milliseconds: 200),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: Colors.white),
        label: Text(label, style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
