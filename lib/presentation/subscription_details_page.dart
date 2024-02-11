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
                    Text("Personal Plan",),
                    ElevatedButton(onPressed: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(),
                        ),
                      );
                    }, child: Text('₹'+details['price'][1]))
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Split Plan",),
                    ElevatedButton(onPressed: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(),
                        ),
                      );
                      _splitPlan(context);
                    }, child: Text('₹'+details['price'][0]))
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
    final subscriptionName = details['name'];
    final subscriptionPrice=details['price'][0];
    firestore
        .collection('subscriptions')
        .doc(subscriptionName)
        .collection(generateRandomString(20))
        .doc(auth.currentUser!.uid)
        .update({
      'User': auth.currentUser!.uid,

    }).then((value) {
      // Subscription added successfully
    }).catchError((error) {
      print('Error: $error');
    });
  }
  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
  }
}
