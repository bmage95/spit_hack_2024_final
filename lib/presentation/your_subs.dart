import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:spit_hack_2024/presentation/splash_page.dart';

import 'components/bottomNavBar.dart';

class YourSubs extends StatefulWidget {
  const YourSubs({Key? key}) : super(key: key);

  @override
  State<YourSubs> createState() => _YourSubsState();
}

class _YourSubsState extends State<YourSubs> {
  List<Map<String, String>> subscriptions = [];
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  final TextEditingController name1 = new TextEditingController();
  final TextEditingController type1 = new TextEditingController();
  final TextEditingController price1 = new TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Subscriptions'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('subscriptions')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var subscriptions = snapshot.data!.docs;

          if (subscriptions.isEmpty) {
            return Center(
              child: Text(
                'Oops! To add new, press the button ->',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: subscriptions.length,
            itemBuilder: (context, index) {
              var subscription = subscriptions[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: CircleAvatar(
                  child: Placeholder(),
                ),
                title: Text(subscription['name'] ?? ''),
                subtitle: Text(subscription['address'] ?? ''),
                trailing: Text(subscription['dob'] ?? ''),
                onTap: () {
                  // Implement onTap action if needed
                },
              );
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
      bottomNavigationBar: BottomNavBar(),
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
                  controller: name1,
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
                  controller: type1,
                  decoration: InputDecoration(labelText: 'Type'),
                  onChanged: (value) {
                    type = value;
                  },
                ),
                TextFormField(
                  controller: price1,
                  decoration: InputDecoration(labelText: 'Price'),
                  onChanged: (value) {
                    price = value;
                  },
                  keyboardType: TextInputType.number,
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
    final subscription_name = name1.text;
    final subscription_type = type1.text;
    final subscription_price = price1.text;

    firestore.collection('users').doc(auth.currentUser!.uid).collection('subscriptions').doc(subscription_name).set({
      'name': subscription_name,
      'address': subscription_type,
      'dob': subscription_price,
    }).then((value) {

    }).catchError((error) {
      print('Error: $error');
    });
  }



}
