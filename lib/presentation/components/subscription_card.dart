import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final String searchedString;
  final VoidCallback onChanged; // Callback function to handle onChanged

  const SubscriptionCard({Key? key, required this.searchedString, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String assetPath = 'assets/$searchedString.png';

    return GestureDetector(
      onTap: () {
        // Trigger the callback function to navigate to the dedicated page
        onChanged();
      },
      child: Container(
        height: 100,
        width: 200,
        color: Colors.purpleAccent,
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