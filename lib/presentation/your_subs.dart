import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:spit_hack_2024/presentation/splash_page.dart';
import 'package:spit_hack_2024/utils/subscription_details.dart';
import 'components/bottomNavBar.dart';

class YourSubs extends StatefulWidget {
  const YourSubs({Key? key}) : super(key: key);

  @override
  State<YourSubs> createState() => _YourSubsState();
}

class _YourSubsState extends State<YourSubs> {
  List<Map<String, String>> subscriptions = [];
  final TextEditingController name1 = TextEditingController();
  String selectedType = 'Type 1'; // Default value for Type
  String selectedPrice = 'Price 1'; // Default value for Price
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final prices=["Price 1","Price 2"];
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  final data = SubscriptionDetails.subscriptionData;
  final types=["Type 1","Type 2"];
  List<String> titles = SubscriptionDetails.subscriptionData.values.map<
      String>((value) => value['title']).toList();
  int typeIndex = 0;








  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Subscriptions'),
      ),
      body: subscriptions.isEmpty
          ? Center(
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
      bottomNavigationBar: BottomNavBar(initialTabIndex: 2,),
    );
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';

        return AlertDialog(
          title: Text('Add Subscription'),
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
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: InputDecoration(labelText: 'Type'),
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
                      selectedPrice=prices[typeIndex];// Update typeIndex here
                    });
                  },
                ),

                DropdownButtonFormField<String>(
                  value: selectedPrice,
                  decoration: InputDecoration(labelText: 'Price'),
                  items: prices // Example options for Price
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
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
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _submitSignUpForm(context);
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

  void _submitSignUpForm(BuildContext context) {
    final subscriptionName = name1.text;

    firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('subscriptions')
        .doc(subscriptionName)
        .set({
      'name': subscriptionName,
      'type': selectedType,
      'price': selectedPrice,
    }).then((value) {
      // Subscription added successfully
    }).catchError((error) {
      print('Error: $error');
    });
  }
}
