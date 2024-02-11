import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spit_hack_2024/presentation/browse_all.dart'; // Import BrowseAll page
import 'package:spit_hack_2024/presentation/splash_page.dart';

import 'about_me.dart';
import 'components/bottomNavBar.dart';
import 'components/subscription_card.dart';
import 'your_feed.dart';
import 'your_subs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 1; // Start with index 1 selected

  List<String> subscriptions = [
    "elbato", "netflix", "office", "prime", "spotify"
  ];

  // Define pages
  List<Widget> _pages = [
    Center(child: Text("About")),
    BrowseAll(),
    Center(child: Text("Contact")),
    AboutMe(),
  ];

  // Function to change the selected tab
  void _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });

    // Navigation logic for the corresponding tabs
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BrowseAll(),
        ),
      );
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => YourSubs(),
        ),
      );
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AboutMe(),
        ),
      );
    }
  }

  // Sign out and navigate to SplashPage
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _signOutAndNavigateToSplashPage() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SplashPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
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
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
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
            const SizedBox(height: 20),
            const Text(
              "Your Subscriptions: ",
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
                itemCount: subscriptions.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      SubscriptionCard(
                        searchedString: subscriptions[index],
                        aspectRatio: 3 / 4,
                        borderRadius: 10,
                        onChanged: () {
                          // Navigate to the dedicated page
                        },
                      ),

                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Today's Top Subs: ",
              style: TextStyle(
                color: Colors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: const [
                Icon(Icons.recommend),
                Icon(Icons.recommend),
                Icon(Icons.recommend),
                Icon(Icons.recommend),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar()
    );
  }
}

