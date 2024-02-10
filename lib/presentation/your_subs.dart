import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class YourSubs extends StatefulWidget {
  const YourSubs({Key? key}) : super(key: key);

  @override
  State<YourSubs> createState() => _YourSubsState();
}

class _YourSubsState extends State<YourSubs> {
  List<Map<String, String>> subscriptions = [];
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

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
                AutoCompleteTextField<String>(
                  key: key,
                  clearOnSubmit: false,
                  suggestions: ["Netflix", "Amazon Prime", "Hulu", "Disney+"],
                  itemBuilder: (BuildContext context, String suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  itemFilter: (String suggestion, input) =>
                      suggestion.toLowerCase().startsWith(input.toLowerCase()),
                  itemSorter: (a, b) => a.compareTo(b),
                  itemSubmitted: (String data) {
                    setState(() {
                      name = data;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Name'),
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
