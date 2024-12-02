import 'package:flutter/material.dart';

class CustomDarkModeSwitch extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;
  final bool initialMode;

  const CustomDarkModeSwitch({
    Key? key,
    required this.onThemeChanged,
    this.initialMode = false,
  }) : super(key: key);

  @override
  _CustomDarkModeSwitchState createState() => _CustomDarkModeSwitchState();
}

class _CustomDarkModeSwitchState extends State<CustomDarkModeSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _moonOffset;
  late Animation<Offset> _sunOffset;
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialMode;

    // Animation controller setup
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Offset animations for moon and sun icons
    _moonOffset = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _sunOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;

      if (_isDarkMode) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }

      // Notify parent about theme change
      widget.onThemeChanged(_isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleTheme,
      child: Container(
        width: 70,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _isDarkMode ? Colors.blueGrey[800] : Colors.blueGrey[200],
        ),
        child: Stack(
          children: [
            // Background elements
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Moon icon (for dark mode)
                  SlideTransition(
                    position: _moonOffset,
                    child: const Icon(
                      Icons.dark_mode,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),

                  // Sun icon (for light mode)
                  SlideTransition(
                    position: _sunOffset,
                    child: const Icon(
                      Icons.light_mode,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Sliding toggle
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              alignment:
                  _isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 35,
                height: 35,
                margin: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isDarkMode ? Colors.white : Colors.white70,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
