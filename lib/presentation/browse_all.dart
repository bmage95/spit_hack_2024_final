import 'package:flutter/material.dart';

import 'components/bottomNavBar.dart';
import 'subscription_details_page.dart';

class BrowseAll extends StatefulWidget {
  const BrowseAll({Key? key}) : super(key: key);

  @override
  State<BrowseAll> createState() => _BrowseAllState();
}

class _BrowseAllState extends State<BrowseAll> {
  // List of image paths for the first five items
  final List<String> _imagePaths = [
    'assets/netflix.png',
    'assets/spotify.png',
    'assets/office.png',
    'assets/prime.png',
    'assets/elbato.png',
  ];

  // List of icons
  final List<IconData> _icons = [
    Icons.ac_unit,
    Icons.access_alarm,
    Icons.access_time,
    Icons.accessibility,
    Icons.account_balance,
    Icons.account_balance_wallet,
    Icons.account_box,
    Icons.account_circle,
    Icons.adb,
    Icons.add,
    Icons.add_alarm,
    Icons.add_alert,
    Icons.add_box,
    Icons.add_circle,
    Icons.add_circle_outline,
    Icons.add_location,
    Icons.add_shopping_cart,
    Icons.add_to_photos,
    Icons.adjust,
    Icons.airport_shuttle,
    Icons.alarm,
  ];

  // Corresponding labels for the first five icons
  List<String> _labels = ['Netflix', 'Spotify', 'Office', 'Prime', 'Elbato'];

  // Method to get the corresponding image path for each index
  String _getImagePath(int index) {
    if (index < _imagePaths.length) {
      return _imagePaths[index];
    }
    return '';
  }

  // Method to get the corresponding label text for each index
  String _getLabelText(int index) {
    if (index < _labels.length) {
      return _labels[index];
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse All'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: _icons.length,
              itemBuilder: (context, index) {
                return (index < _imagePaths.length)
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubscriptionDetailsPage(
                                name: _getLabelText(index),
                              ),
                            ),
                          );
                        },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                            _getImagePath(
                                index), // Get the corresponding image path
                            height: 60,
                            width: 60,
                          ),
                      ),
                    )
                    : Icon(
                        _icons[index - _imagePaths.length],
                        // Adjust index for icons list
                        size: 40,
                      );
              },
            ),
          ),
        ],
      ),
        bottomNavigationBar: BottomNavBar()
    );
  }
}
