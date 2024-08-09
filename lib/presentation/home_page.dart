import 'dart:math';
import 'package:flutter/material.dart';
import 'package:spit_hack_2024/presentation/subscription_details_page.dart';
import 'package:spit_hack_2024/utils/subscription_details.dart';
import 'components/bottomNavBar.dart';
import 'components/subscription_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> subscriptions = [];
  int monthlyExpenses = 0;
  List<int> randomIndexes = [];

  getRandIndex() {
    var rand = Random();
    var index = rand.nextInt(SubscriptionDetails.subscriptionData.keys.length);
    if (randomIndexes.contains(index)) {
      getRandIndex();
    } else {
      setState(() {
        randomIndexes.add(index);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SubSplit"),
          backgroundColor: Colors.transparent,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
            return Future.value(false);
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Monthly Expenses: ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                ),
                              ),
                              Text(
                                ' ₹ $monthlyExpenses',
                                style: const TextStyle(
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
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: Text(
                      "Your Subscriptions: ",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: subscriptions.isEmpty
                        ? const Center(
                            child: Text(
                              'You do not have any active subscriptions. Please add a subscription to get started.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: subscriptions.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SubscriptionDetailsPage(
                                            name: subscriptions[index]
                                                        ['imageName']
                                                    .split('/')
                                                    .last
                                                    .split('.')
                                                    .first ??
                                                '',
                                          ),
                                        ),
                                      );
                                    },
                                    child: SubscriptionCard(
                                      searchedString: subscriptions[index]
                                              ['imageName']
                                          .split('/')[1]
                                          .split('.')
                                          .first,
                                      aspectRatio: 3 / 4,
                                      borderRadius: 10,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: Text(
                      "Today's Top Subs: ",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    children: [
                      for (int i = 0; i < randomIndexes.length; i++)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubscriptionDetailsPage(
                                  name: SubscriptionDetails
                                      .subscriptionData.keys
                                      .elementAt(randomIndexes[i]),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              SubscriptionDetails.subscriptionData[
                                      SubscriptionDetails.subscriptionData.keys
                                          .elementAt(randomIndexes[i])]
                                  ['icon_image'],
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavBar(
          initialTabIndex: 0,
        ));
  }
}
