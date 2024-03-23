import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddFoodItemScreen extends StatefulWidget {
  @override
  _AddFoodItemScreenState createState() => _AddFoodItemScreenState();
}

class _AddFoodItemScreenState extends State<AddFoodItemScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _foodNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  File? _image;
  String? _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Food Item'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _foodNameController,
                  decoration: InputDecoration(labelText: 'Food Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the food name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                _image == null
                    ? ElevatedButton(
                        onPressed: () {
                          getImage();
                        },
                        child: Text('Select Image'),
                      )
                    : Image.file(_image!),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      uploadFoodItem();
                    }
                  },
                  child: Text('Add Food Item'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadFoodItem() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String foodName = _foodNameController.text;
      String description = _descriptionController.text;
      double price = double.parse(_priceController.text);

      // Upload image to Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('food_images')
          .child(foodName)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      // Save food item details to Firestore with food name as document name
      await FirebaseFirestore.instance
          .collection('food_items')
          .doc(foodName)
          .set({
        'userId': userId,
        'foodName': foodName,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'createdTimestamp': Timestamp.now(),
      });

      // Successful addition
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food item added successfully')),
      );

      // Clear text fields and image
      _foodNameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      setState(() {
        _image = null;
      });
    } catch (error) {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add food item: $error')),
      );
    }
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zorko Dashboard'), // Customize the title here
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Existing Food'),
            onTap: () {
              // Navigate to the screen for adding new food items
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExistingFoodScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Add Food'),
            onTap: () {
              // Navigate to the screen for adding new food items
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFoodItemScreen()),
              );
            },
          ),
          // Add more ListTiles for additional functionalities as needed
        ],
      ),
    );
  }
}

// Example: ExistingFoodScreen.dart
// Example: ExistingFoodScreen.dart


class ExistingFoodScreen extends StatefulWidget {
  @override
  _ExistingFoodScreenState createState() => _ExistingFoodScreenState();
}

class _ExistingFoodScreenState extends State<ExistingFoodScreen> {
  double? filterPrice;

  void applyFilter(double price) {
    setState(() {
      filterPrice = price;
    });
  }

  void clearFilter() {
    setState(() {
      filterPrice = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Food'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              // Show filter dialog to enter price
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Filter by Price'),
                    content: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Enter Price'),
                      onChanged: (value) {
                        setState(() {
                          filterPrice = double.tryParse(value);
                        });
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Apply filter
                          applyFilter(filterPrice ?? 0);
                          Navigator.of(context).pop();
                        },
                        child: Text('Apply'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              // Clear filter
              clearFilter();
            },
          ),
        ],
      ),
      body: _buildExistingFoodListView(),
    );
  }

  Widget _buildExistingFoodListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('food_items').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No food items found.'));
        }
        final foodItems = snapshot.data!.docs.where((foodItem) {
          if (filterPrice != null) {
            final price = foodItem['price'] as double;
            return price <= filterPrice!;
          }
          return true;
        }).toList();
        // Sort food items by price in descending order
        foodItems.sort((a, b) {
          final priceA = a['price'] as double;
          final priceB = b['price'] as double;
          return priceB.compareTo(priceA);
        });
        return ListView.builder(
          itemCount: foodItems.length,
          itemBuilder: (context, index) {
            final foodItem = foodItems[index];
            final foodName = foodItem['foodName'] as String;
            final description = foodItem['description'] as String;
            final imageUrl = foodItem['imageUrl'] as String;
            final price =
                foodItem['price'] as double; // Assuming 'price' is a double

            return ListTile(
              contentPadding: EdgeInsets.all(0), // Remove default padding
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 180,
                    width: double.infinity, // Take full width
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover, // Cover the entire area
                    ),
                  ),
                  SizedBox(height: 8), // Add some space between image and text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$foodName\n$description",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        '\$${price.toStringAsFixed(2)}', // Display price
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
