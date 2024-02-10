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
  Map<String, dynamic>? userData;

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        userData = value.data();
      });
    });
    super.initState();
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
              child: StreamBuilder<DocumentSnapshot>(
                stream: firestore
                    .collection('users')
                    .doc(auth.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    try {
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          snapshot.data!.get('profile_image'),
                        ),
                      );
                    } catch (e) {
                      return const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person),
                      );
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
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
