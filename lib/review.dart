import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hack/view/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class Review extends StatefulWidget {
  const Review({Key? key}) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  XFile? _image;
  final fire_ref = FirebaseFirestore.instance.collection("review");
  final Post = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> _imageFromCamera() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }
Future<void> _showReviewDialog(String title, String description, String imageUrl) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Big image
              Image.network(
                imageUrl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              // Title
              ListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // Description
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(description),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}

  Future<void> _imageFromGallery() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  Future<String?> _uploadImageToFirebase() async {
    if (_image == null) {
      // No image selected, return null
      return null;
    }

    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${path.basename(_image!.path)}');

    UploadTask uploadTask = storageReference.putFile(File(_image!.path));

    try {
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print("Download URL: $downloadUrl");

      // Return the download URL of the uploaded image
      return downloadUrl;
    } catch (error) {
      print("Upload Error: $error");
      return null; // Return null in case of error
    }
  }

  Future<void> _uploadDataToFirebase() async {
    if (Post.text.isEmpty || descriptionController.text.isEmpty) {
      Utils.toastMessage('Error: Title and Description are required.');
      return;
    }

    String? imageUrl = await _uploadImageToFirebase();

    String id = DateTime.now().microsecondsSinceEpoch.toString();
    await fire_ref.doc(id).set({
      'title': Post.text,
      'description': descriptionController.text,
      'id': id,
      'timestamp': DateTime.now(),
      'image_url': imageUrl,
    });

    setState(() {
      Post.clear();
      descriptionController.clear();
      _image = null;
    });

    Utils.toastMessage("Review added successfully.");
  }


+

  @override
  Widget build(BuildContext context) {
      Map<String, dynamic> userData = {'birthday': Timestamp.now()}; // Example userData

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Review",style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: GestureDetector(
         onTap: () {
    _showReviewDialog(Post.text, descriptionController.text, descriptionController.text);
  },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Title TextField
                TextField(
                  controller: Post,
                  decoration: InputDecoration(
                    hintText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Description TextField
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 20),
                _image != null
                    ? Image.file(
                        File(_image!.path),
                        width: 200,
                        height: 200,
                      )
                    : Text('No image selected.'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _imageFromCamera,
                  child: Text('Select Image from Camera'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _imageFromGallery,
                  child: Text('Select Image from Gallery'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadDataToFirebase,
                  child: Text('Add Review'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
