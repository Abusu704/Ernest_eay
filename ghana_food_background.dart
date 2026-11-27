import 'dart:async';
import 'package:flutter/material.dart';

class GhanaFoodBackground extends StatefulWidget {
  final Widget child;
  final int initialIndex;

  const GhanaFoodBackground({
    super.key,
    required this.child,
    this.initialIndex = 0,
  });

  @override
  State<GhanaFoodBackground> createState() => _GhanaFoodBackgroundState();
}

class _GhanaFoodBackgroundState extends State<GhanaFoodBackground> {
  static const List<String> _foodImages = [
    'lib/assets/images/jollof.jpeg',
    'lib/assets/images/banku.jpg',
    'lib/assets/images/waakye.jpg',
    'lib/assets/images/kelewele.jpg',
  ];

  late int _currentIndex;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex % _foodImages.length;
    _timer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _foodImages.length;
      });
    });
  }

  @override
  void didUpdateWidget(covariant GhanaFoodBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _currentIndex = widget.initialIndex % _foodImages.length;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _fallbackGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3E1F14), Color(0xFF8B3A2B), Color(0xFFD9822B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentImage = _foodImages[_currentIndex];

    return Stack(
      fit: StackFit.expand,
      children: [
        _fallbackGradient(),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          child: Image.asset(
            currentImage,
            key: ValueKey(currentImage),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) => _fallbackGradient(),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1A0E09).withValues(alpha: 0.72),
                const Color(0xFF2B160E).withValues(alpha: 0.62),
                const Color(0xFF1A0E09).withValues(alpha: 0.78),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}