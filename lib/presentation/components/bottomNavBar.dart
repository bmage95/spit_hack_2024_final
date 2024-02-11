import 'package:flutter/material.dart';

import '../about_me.dart';
import '../browse_all.dart';
import '../home_page.dart';
import '../your_subs.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedTab = 0;
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
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedTab,
      onTap: (index) => _changeTab(index),
      unselectedItemColor: Colors.amberAccent,
      selectedItemColor: Colors.blue,
      showUnselectedLabels: true,
      iconSize: 36, // Adjust the icon size here
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Your Subs"),
        BottomNavigationBarItem(
            icon: Icon(Icons.search), label: "Browse"),
        BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail), label: "Stats"),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings), label: "Settings"),
      ],);
  }
}
