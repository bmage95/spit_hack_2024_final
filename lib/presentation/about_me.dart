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

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
            GestureDetector(
              onTap: () {
                ImagePicker().pickImage(source: ImageSource.gallery).then(
                  (value) {
                    if (value != null) {
                      debugPrint(value.path);
                      File file = File(value.path);
                      Reference storageRef = storage.refFromURL(
                          "gs://spit-hack-2024.appspot.com/users/${auth.currentUser!.uid}/profile.${file.path.split('.').last}");
                      storageRef.putData(file.readAsBytesSync()).then(
                        (p0) {
                          p0.ref.getDownloadURL().then(
                            (value) {
                              debugPrint(value);
                              firestore
                                  .collection('users')
                                  .doc(auth.currentUser!.uid)
                                  .update({
                                'profile_image': value,
                              });
                            },
                          );
                        },
                      );
                    }
                  },
                );
              },
              child: CircleAvatar(
                radius: 60,
                child: StreamBuilder<DocumentSnapshot>(
                  stream: firestore
                      .collection('users')
                      .doc(auth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      try {
                        return Image.network(
                          snapshot.data!.get('profile_image'),
                          fit: BoxFit.cover,
                        );
                      } catch (e) {
                        return const Icon(
                          Icons.person,
                          size: 60,
                        );
                      }
                    } else {
                      return const Icon(
                        Icons.person,
                        size: 60,
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Function to save user data
                    },
                    child: Text('Save'),
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
