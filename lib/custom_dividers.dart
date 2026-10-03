import 'package:flutter/material.dart';

/// Custom Divider
class CustomDivider extends StatelessWidget {
  final double widthFactor;
  final Color? color;
  final double? height;

  /// Custom Divider With Fading left and right Dividers and a circular dot in the middle
  const CustomDivider({
    super.key,
    this.widthFactor = 0.4, // Default to 40% of screen width
    this.color,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final dividerColor = color ?? colorScheme.inversePrimary;

    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildGradientLine(screenSize, dividerColor, isStart: true),
          Container(
            width: 3,
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: dividerColor,
              shape: BoxShape.circle,
            ),
          ),
          _buildGradientLine(screenSize, dividerColor, isStart: false),
        ],
      ),
    );
  }

  Widget _buildGradientLine(Size screenSize, Color color,
      {required bool isStart}) {
    return Container(
      height: 1,
      width: screenSize.width * widthFactor,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isStart
              ? [Colors.transparent, color]
              : [color, Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
