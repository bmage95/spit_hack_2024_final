import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:spit_hack_2024/utils/subscription_details.dart';
import 'components/bottomNavBar.dart';

class YourSubs extends StatefulWidget {
  const YourSubs({Key? key}) : super(key: key);

  @override
  State<YourSubs> createState() => _YourSubsState();
}

class _YourSubsState extends State<YourSubs> {
  List<Map<String, dynamic>> subscriptions = [];
  final TextEditingController name1 = TextEditingController();
  String selectedType = 'Type 1'; // Default value for Type
  int selectedPrice = 149; // Default value for Price
  final prices = [149, 999];
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  final data = SubscriptionDetails.subscriptionData;
  final types = ["Type 1", "Type 2"];
  List<String> titles = SubscriptionDetails.subscriptionData.values
      .map<String>((value) => value['title'])
      .toList();
  int typeIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Subscriptions'),
      ),
      body: subscriptions.isEmpty
          ? const Center(
              child: Text(
                'Oops! To add new, press the button ->',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: subscriptions.length,
              itemBuilder: (context, index) {
                final subscription = subscriptions[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      subscription['name'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    trailing: Text(
                      "₹${subscription['price']}" ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                      ),
                    ),
                    onTap: () {
                      // Implement onTap action if needed
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSubscriptionDialog();
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavBar(
        initialTabIndex: 2,
      ),
    );
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';

        return AlertDialog(
          title: const Text('Add Subscription'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AutoCompleteTextField<String>(
                  key: key,
                  controller: name1,
                  clearOnSubmit: false,
                  suggestions: titles,
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
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: types.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                      typeIndex = types.indexOf(selectedType);
                      selectedPrice =
                          prices[typeIndex]; // Update typeIndex here
                    });
                  },
                ),
                DropdownButtonFormField<int>(
                  value: selectedPrice,
                  decoration: const InputDecoration(labelText: 'Price'),
                  items: prices.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value ?? 0,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPrice = value!;
                    });
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
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _submitSignUpForm(context);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _submitSignUpForm(BuildContext context) {}
}
