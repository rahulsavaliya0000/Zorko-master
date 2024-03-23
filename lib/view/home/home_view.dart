import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hack/common/color_extension.dart';
import 'package:hack/common_widget/round_textfield.dart';
import 'package:hack/googlemap.dart';

import '../../common/globs.dart';
import '../../common/service_call.dart';
import '../../common_widget/most_popular_cell.dart';
import '../../common_widget/recent_item_row.dart';
import '../../common_widget/view_all_title_row.dart';
import '../more/my_order_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController txtSearch = TextEditingController();

  List catArr = [
    {"image": "assets/img/cat_offer.png", "name": "Offers"},
    {"image": "assets/img/cat_sri.png", "name": "Sri Lankan"},
    {"image": "assets/img/cat_3.png", "name": "Italian"},
    {"image": "assets/img/cat_4.png", "name": "Indian"},
  ];

  List popArr = [
    {
      "image": "assets/img/res_1.png",
      "name": "Minute by tuk tuk",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food",
      "price": "100/-"
    },
    {
      "image": "assets/img/res_2.png",
      "name": "Café de Noir",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food",
      "price": "150/-"
    },
    {
      "image": "assets/img/res_3.png",
      "name": "Bakes by Tella",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food",
      "price": "250/-"
    },
  ];

  List mostPopArr = [
    {
      "image": "assets/img/m_res_1.png",
      "name": "Minute by tuk tuk",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/m_res_2.png",
      "name": "Café de Noir",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];

  List recentArr = [
    {
      "image": "assets/img/item_1.png",
      "name": "Mulberry Pizza by Josh",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/item_2.png",
      "name": "Barita",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/item_3.png",
      "name": "Pizza Rush Hour",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];
  List price = ["100 /-", " 145 /-", " 150/-"];
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
          physics:
              const NeverScrollableScrollPhysics(), // Prevent nested scrolling
          shrinkWrap: true, // Adjust to the height of its contents
          itemCount: foodItems.length,
          itemBuilder: (context, index) {
            final foodItem = foodItems[index];
            final foodName = foodItem['foodName'] as String;
            final description = foodItem['description'] as String;
            final imageUrl = foodItem['imageUrl'] as String;
            final price =
                foodItem['price'] as double; // Assuming 'price' is a double

            return ListTile(
              contentPadding: EdgeInsets.zero, // Remove default padding
              title: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                20), // Adjust the radius as needed
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                20), // Same as the container's border radius
                            child: Image.network(
                              imageUrl,
                              height: 150,
                              width: 350,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 8), // Add some space between image and text
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(foodName, // Display price
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                    )),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 200,
                                  height: 18,
                                  child:RichText(
  text: TextSpan(
    style: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    children: [
    
      TextSpan(
        text: description,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      // TextSpan(
      //   text: '..', // Second occurrence of description
      //   style: TextStyle(
      //     fontSize: 14,
      //     color: Colors.grey.shade600,
      //   ),
      // ),
    ],
  ),
),

                                ),

                              ],
                            ),
                           
                          ],
                        ),
                        Text(
                          '\$${price.toStringAsFixed(2)}', // Display price
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.orange.shade900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Good evening ${ServiceCall.userPayload[KKey.name] ?? ""}!",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyOrderView()));
                      },
                      icon: Image.asset(
                        "assets/img/shopping_cart.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nearby Zorko",
                      style:
                          TextStyle(color: TColor.secondaryText, fontSize: 11),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MapScreen(
                            city: 'surat',
                          );
                        }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "SVNIT",
                            style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Image.asset(
                            "assets/img/dropdown.png",
                            width: 12,
                            height: 12,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoundTextfield(
                  hintText: "Search Food",
                  controller: txtSearch,
                  left: Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: Image.asset(
                      "assets/img/search.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // SizedBox(
              //   height: 120,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     padding: const EdgeInsets.symmetric(horizontal: 15),
              //     itemCount: catArr.length,
              //     itemBuilder: ((context, index) {
              //       var cObj = catArr[index] as Map? ?? {};
              //       return CategoryCell(
              //         cObj: cObj,
              //         onTap: () {},
              //       );
              //     }),
              //   ),
              // ),
              const SizedBox(
                height: 150,
                width: 400,
                child: MySlider(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Budget Food",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.filter_alt,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // Show filter dialog to enter price
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Filter by Price'),
                                  content: TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        labelText: 'Enter Price'),
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
                          icon: Icon(Icons.close),
                          onPressed: () {
                            // Clear filter
                            clearFilter();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildExistingFoodListView(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ViewAllTitleRow(
                  title: "Most Popular",
                  onView: () {},
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: mostPopArr.length,
                  itemBuilder: ((context, index) {
                    var mObj = mostPopArr[index] as Map? ?? {};
                    return MostPopularCell(
                      mObj: mObj,
                      onTap: () {},
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ViewAllTitleRow(
                  title: "Recent Items",
                  onView: () {},
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: recentArr.length,
                itemBuilder: ((context, index) {
                  var rObj = recentArr[index] as Map? ?? {};
                  return RecentItemRow(
                    rObj: rObj,
                    onTap: () {},
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MySlider extends StatelessWidget {
  const MySlider({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        aspectRatio: 364 / 128,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 2),
        enlargeCenterPage: true,
        initialPage: 1,
      ),
      items: [
        Stack(
          children: [
            Container(
              height: 200,
              alignment: Alignment.bottomCenter,
              width: 400,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 120,
                width: 315,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    "assets/img/cel.webp",
                    fit: BoxFit
                        .cover, // Ensures the image covers the entire container
                  ),
                ),
              ),
            ),
            Positioned(
              // bottom: 40,
              right: 0,
              top: 0,
              child: Image.asset(
                'assets/img/special.png', // Replace with your image asset path
                // width: 70,
                height: 100,
              ),
            ),
            Positioned(
              right: 5,
              bottom: 10,
              child: Image.asset(
                'assets/img/zorko.png',
                color: Colors.white, // Replace with your image asset path
                // width: 70,
                height: 15,
              ),
            ),
            const Positioned(
              bottom: 30,
              left: 10,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    ' Your First Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Text(
                  //   ' OFF ',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontFamily: 'Montserrat',
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  // Text(
                  //   '  Ever',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontFamily: 'Montserrat',
                  //     fontSize: 19,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    '  code :-First111',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Stack(
          children: [
            Container(
              height: 200,
              alignment: Alignment.bottomCenter,
              width: 400,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 120,
                width: 315,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    "assets/img/holi1.jpg",
                    fit: BoxFit
                        .cover, // Ensures the image covers the entire container
                  ),
                ),
              ),
            ),
            Positioned(
              // bottom: 40,
              right: 0,
              top: 0,
              child: Image.asset(
                'assets/img/holi.png', // Replace with your image asset path
                // width: 70,
                height: 100,
              ),
            ),
            Positioned(
              right: 5,
              bottom: 10,
              child: Image.asset(
                'assets/img/zorko.png',
                color: Colors.black, // Replace with your image asset path
                // width: 70,
                height: 15,
              ),
            ),
            const Positioned(
              bottom: 35,
              left: 10,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    ' Special Offer',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Text(
                  //   ' OFF ',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontFamily: 'Montserrat',
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  // Text(
                  //   '  Ever',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontFamily: 'Montserrat',
                  //     fontSize: 19,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    '  code :-HOLI4569',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Stack(
          children: [
            Container(
              height: 200,
              alignment: Alignment.bottomCenter,
              width: 400,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 120,
                width: 315,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(28),
                ),
                // Second Container's background color
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Image.asset(
                'assets/img/happy.png', // Replace with your image asset path
                // width: 70,
                height: 120,
              ),
            ),
            Positioned(
              right: 5,
              bottom: 10,
              child: Image.asset(
                'assets/img/zorko.png',
                color: Colors.black, // Replace with your image asset path
                // width: 70,
                height: 15,
              ),
            ),
            const Positioned(
              bottom: 35,
              left: 10,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    ' 50% OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Text(
                  //   ' OFF ',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontFamily: 'Montserrat',
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  // Text(
                  //   '  Ever',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontFamily: 'Montserrat',
                  //     fontSize: 19,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    '  code :-ZORAKO123',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
