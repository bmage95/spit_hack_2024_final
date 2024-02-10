import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spit_hack_2024/presentation/browse_all.dart'; // Import BrowseAll page
import 'package:spit_hack_2024/presentation/splash_page.dart';

import 'about_me.dart';
import 'components/subscription_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0;

  // Define pages
  List<Widget> _pages = [
    Center(child: Text("Home")),
    Center(child: Text("About")),
    BrowseAll(), // Replace the Product placeholder with BrowseAll
    Center(child: Text("Contact")),
    AboutMe(),
  ];

  // Function to change the selected tab
  void _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });

    // Navigation logic for the Product tab
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BrowseAll(),
        ),
      );
    }

    if (index == 4) {
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
        title: const Text("App Bar"),
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
            "Your subscriptions: ",
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
                    const SizedBox(
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _signOutAndNavigateToSplashPage,
            child: const Text('Sign Out'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => _changeTab(index),
        selectedItemColor: Colors.amberAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "About"),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_3x3_outlined), label: "Product"),
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_mail), label: "Contact"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
