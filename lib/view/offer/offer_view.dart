import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hack/review.dart';

class AllReviewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text('All Reviews'),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // Navigate to the screen where users can add their thoughts
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Review(),
                ),
              );
            },
            child: Column(
              children: [
                Padding(
                      padding: const EdgeInsets.only(right: 10),
                child: Icon(Icons.add,size: 28,color: Colors.amber.shade900,),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    'Add your thoughts',
                  
                    style: TextStyle(fontSize: 10,color: Colors.amber.shade900,fontFamily: 'Montserrat',fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('review').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final reviews = snapshot.data!.docs;
          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              final title = review['title'] as String?;
              final description = review['description'] as String?;
              final imageUrl = review['image_url'] as String?;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 1),
                child: Card(
                  elevation: 5,
                  color: Colors.amber.shade900,
                  child: ListTile(
                    title: Text(
                      title ?? 'No Title',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      description ?? 'No Description',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: imageUrl != null
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white, // Border color
                                width: 2, // Border width
                              ),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                imageUrl,
                                width: 50, // Adjust width if necessary
                                height: 50, // Adjust height if necessary
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Icon(Icons.image),
                    onTap: () {
                      // Handle onTap if needed
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
