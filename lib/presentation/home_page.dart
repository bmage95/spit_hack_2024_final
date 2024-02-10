import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spit_hack_2024/presentation/splash_page.dart';

import 'components/subscription_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Bar"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: 355,
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Monthly Expenses: ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                      ),
                    ),
                    Text(
                      '1000',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        height: 2.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Categories: ",
            style: TextStyle(
              color: Colors.purpleAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    SubscriptionCard(
                      searchedString: "spotify",
                      onChanged: () {
                        // Navigate to the dedicated page
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}