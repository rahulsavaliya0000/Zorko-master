import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hack/common_widget/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../common/color_extension.dart';

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
        title:AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "Add Food Item",
              style: TextStyle(
                  color: Colors.black, fontSize: 25, fontWeight: FontWeight.w800),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        automaticallyImplyLeading: false,
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
                  decoration: InputDecoration(
                    labelText: 'Food Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          40.0), // Adjust the radius as needed
                    ),
                  ),
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
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          40.0), // Adjust the radius as needed
                    ),
                  ),
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
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          40.0), // Adjust the radius as needed
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Container(
                  height: 200,
                  width: double.infinity,
                  child: _image == null
                      ? GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.orange.shade800,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate, size: 50),
                                  SizedBox(height: 8),
                                  Text('Add Photo'),
                                ],
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            getImage(); // You can replace this with your update photo logic
                          },
                          child: Container(
                            width: 100, // Adjust width as needed
                            height: 100, // Adjust height as needed
                            decoration: BoxDecoration(
                              shape: BoxShape
                                  .circle, // This makes the container circular
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(
                                      0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  50), // half of the width/height to make it circular
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                ),
                SizedBox(height: 32.0),

                Center(

                  child: RoundButton(
                      title: "ADD FOOD ITEM",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          uploadFoodItem();
                        }
                      }),
                )
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
        title: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            "Zorko Dashboard",
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.w800),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/img/splash_bg.png'), // Replace 'assets/background_image.jpg' with the path to your image asset
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Card(
              child: ListTile(
                title: Text(
                  "Existing Food",
                  style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 19,
                      fontWeight: FontWeight.w800),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExistingFoodScreen()),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  "Add Food",
                  style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 19,
                      fontWeight: FontWeight.w800),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddFoodItemScreen()),
                  );
                },
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Center(
                child: Image.asset(
              "assets/img/zorko.png",
              height: 80,
            ))
            // Add more Cards for additional functionalities as needed
          ],
        ),
      ),
    );
  }
}

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
            icon: Icon(Icons.filter_alt, color: Colors.orange.shade700),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Filter by Price',
                        style: TextStyle(color: Colors.orange.shade700)),
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
            icon: Icon(Icons.clear, color: Colors.orange.shade700),
            onPressed: () {
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
            final price = foodItem['price'] as double;

            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                contentPadding: EdgeInsets.all(8),
                leading: SizedBox(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  foodName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(description),
                    SizedBox(height: 4),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
