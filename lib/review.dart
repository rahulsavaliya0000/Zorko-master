import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hack/view/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    if (Post.text.isEmpty) {
      Utils.toastMessage('Error: Text is required.');
      return;
    }

    String? imageUrl = await _uploadImageToFirebase();

    String id = DateTime.now().microsecondsSinceEpoch.toString();
    await fire_ref.doc(id).set({
      'title': Post.text,
      'id': id,
      'timestamp': DateTime.now(),
      'image_url': imageUrl, // This may be null if no image was uploaded
    });

    setState(() {
      Post.clear();
      _image = null; // Reset selected image
    });

    Utils.toastMessage("Post added successfully.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Review"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
              TextField(
                controller: Post,
                decoration: InputDecoration(
                  hintText: "What's in your mind?",
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
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
    );
  }
}
