import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  FirebaseStorage storage = FirebaseStorage.instance;

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
                ImagePicker()
                    .pickImage(source: ImageSource.gallery)
                    .then((value) {
                  if (value != null) {
                    File file = File(value.path);
                    storage
                        .ref(
                            'users/${FirebaseAuth.instance.currentUser!.uid}/profile.${file.path.split(".").last}')
                        .putFile(file)
                        .then((snapshot) {
                      snapshot.ref.getDownloadURL().then((url) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({'profile_image': url}).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Profile image updated successfully')),
                          );
                        }).catchError((error) {
                          print('Error updating profile image: $error');
                        });
                      });
                    });
                  }
                });
              },
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person),
                    );
                  }
                  try {
                    return CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage(snapshot.data!['profile_image']),
                    );
                  } catch (e) {
                    return const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            // Editable Text Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    enabled: _isEditing,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    enabled: _isEditing,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 20),
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
