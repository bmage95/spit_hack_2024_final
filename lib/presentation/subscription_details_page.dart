import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spit_hack_2024/presentation/payment_status.dart';
import 'package:spit_hack_2024/utils/subscription_details.dart';

import 'home_page.dart';

class SubscriptionDetailsPage extends StatefulWidget {
  const SubscriptionDetailsPage({super.key, required this.name});

  final String name;

  @override
  State<SubscriptionDetailsPage> createState() =>
      _SubscriptionDetailsPageState();
}

class _SubscriptionDetailsPageState extends State<SubscriptionDetailsPage> {
  Map details = {};

  @override
  void initState() {
    setState(() {
      details = SubscriptionDetails.subscriptionData[widget.name.toLowerCase()];
    });
    debugPrint(details.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      details['icon_image'],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                Text(
                  details['title'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                details['description'],
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text(
                            'Split Plan',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '₹${details['price'][0]}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text(
                            'Personal Plan',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '₹${details['price'][1]}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var screenshot in details['screenshots'])
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        screenshot,
                        height: 200,
                        width: 200,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _showSubscriptionDialog();
            },
            child: const Text('Buy plan'),
          ),
        ),
      ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Personal Plan",
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(),
                            ),
                          );
                        },
                        child: Text('₹' + details['price'][1]))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Split Plan",
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(),
                            ),
                          );
                          _splitPlan(context);
                        },
                        child: Text('₹' + details['price'][0]))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  void _splitPlan(BuildContext context) {
    randomVar = generateRandomString(20);
    final subscriptionName = details['title'];
    debugPrint(subscriptionName);
    final subscriptionPrice = details['price'][0];
    // Get the documents from the collection named subscriptionName like Netflix, Prime, etc. where there are less than 4 members in the array
    // If there are less than 4 members, add the user to the subscription
    // Else, create a new subscription
    firestore
        .collection(subscriptionName)
        .where('is_full', isEqualTo: false)
        .get()
        .then((value) {
      debugPrint(value.docs.toString());
      if (value.docs.isNotEmpty) {
        firestore
            .collection(subscriptionName)
            .doc(value.docs.first.id)
            .update({
              'members': FieldValue.arrayUnion([auth.currentUser!.uid]),
            })
            .then((value) => debugPrint('User added to subscription'))
            .catchError((error) => debugPrint('Failed to add user: $error'));
        firestore
            .collection(subscriptionName)
            .doc(value.docs.first.id)
            .get()
            .then(
          (value) {
            if (value['members'].length >= 4) {
              firestore
                  .collection(subscriptionName)
                  .doc(value.id)
                  .update({
                    'is_full': true,
                  })
                  .then((value) => debugPrint('Subscription is full'))
                  .catchError(
                    (error) =>
                        debugPrint('Failed to update subscription: $error'),
                  );
            }
          },
        );
        firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('subscriptions')
            .doc(subscriptionName)
            .set({
              'name': subscriptionName,
              'price': int.parse(subscriptionPrice.toString()),
              'imageName': details['icon_image'],
            })
            .then(
              (value) => debugPrint('Subscription added to user'),
            )
            .catchError(
              (error) =>
                  debugPrint('Failed to add subscription to user: $error'),
            );
      } else {
        firestore
            .collection(subscriptionName)
            .doc(randomVar)
            .set({
              'members': [auth.currentUser!.uid],
              'price': subscriptionPrice,
              'is_full': false,
            })
            .then((value) => debugPrint('Subscription created'))
            .catchError(
                (error) => debugPrint('Failed to create subscription: $error'));
      }
      firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('subscriptions')
          .doc(subscriptionName)
          .set({
            'name': subscriptionName,
            'price': int.parse(subscriptionPrice.toString()),
            'imageName': details['icon_image'],
          })
          .then(
            (value) => debugPrint('Subscription added to user'),
          )
          .catchError(
            (error) => debugPrint('Failed to add subscription to user: $error'),
          );
    });
  }

  String randomVar = '';

  String generateRandomString(int length) {
    const String validChars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    Random random = Random();
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      int randomIndex = random.nextInt(validChars.length);
      buffer.write(validChars[randomIndex]);
    }

    return buffer.toString();
  }
}
