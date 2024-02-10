import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final String searchedString;
  final VoidCallback onChanged; // Callback function to handle onChanged
  final double aspectRatio;
  final double borderRadius;

  const SubscriptionCard({
    Key? key,
    required this.searchedString,
    required this.onChanged,
    this.aspectRatio = 3 / 4, // Default aspect ratio
    this.borderRadius = 10, // Default border radius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String assetPath = 'assets/$searchedString.png';

    return GestureDetector(
      onTap: () {
        // Trigger the callback function to navigate to the dedicated page
        onChanged();
      },
      child: Container(
        height: 130, // Adjust the height here as needed
        width: 200, // Adjust the width here as needed
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
