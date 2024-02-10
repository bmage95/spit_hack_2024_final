import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({Key? key}) : super(key: key);

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Fetch user data from Firestore and populate text fields
    fetchUserData();
  }

  void fetchUserData() async {
    // Retrieve user data from Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (userDoc.exists) {
      // Populate text fields with user data
      setState(() {
        _nameController.text = userDoc['name'];
        _emailController.text = userDoc['email'];
        _phoneController.text = userDoc['phone'];
      });
    }
  }

  void _saveChanges() {
    // Save changes to Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully')),
      );
    }).catchError((error) {
      print('Error saving changes: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Me'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Image
            GestureDetector(
              onTap: () {
                // Handle image picking
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'Profile Image URL',
                ), // Replace 'Profile Image URL' with the user's profile image URL
              ),
            ),
            SizedBox(height: 20),
            // Editable Text Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    enabled: _isEditing,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    enabled: _isEditing,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    enabled: _isEditing,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                        if (!_isEditing) {
                          // Save changes when editing is complete
                          _saveChanges();
                        }
                      });
                    },
                    child: Text(_isEditing ? 'Save' : 'Edit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



