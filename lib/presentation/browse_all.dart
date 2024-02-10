import 'package:flutter/material.dart';

class BrowseAll extends StatefulWidget {
  const BrowseAll({Key? key}) : super(key: key);

  @override
  State<BrowseAll> createState() => _BrowseAllState();
}

class _BrowseAllState extends State<BrowseAll> {
  // List of icons (just for demonstration)
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
                return IconButton(
                  icon: Icon(_icons[index]),
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
