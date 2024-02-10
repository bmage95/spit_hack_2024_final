import 'package:flutter/material.dart';

class YourSubs extends StatefulWidget {
  const YourSubs({Key? key}) : super(key: key);

  @override
  State<YourSubs> createState() => _YourSubsState();
}

class _YourSubsState extends State<YourSubs> {
  List<Map<String, String>> subscriptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Subscriptions'),
      ),
      body: subscriptions.isEmpty
          ? Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.grey[300],
          ),
          child: Text(
            'Oops! to add new press the button ->',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )
          : ListView.builder(
        itemCount: subscriptions.length,
        itemBuilder: (context, index) {
          final subscription = subscriptions[index];
          return ListTile(
            title: Text(subscription['name'] ?? ''),
            subtitle: Text(subscription['type'] ?? ''),
            trailing: Text(subscription['price'] ?? ''),
            onTap: () {
              // Implement onTap action if needed
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSubscriptionDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String type = '';
        String price = '';

        return AlertDialog(
          title: Text('Add Subscription'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Type'),
                  onChanged: (value) {
                    type = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Price'),
                  onChanged: (value) {
                    price = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  subscriptions.add({
                    'name': name,
                    'type': type,
                    'price': price,
                  });
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
