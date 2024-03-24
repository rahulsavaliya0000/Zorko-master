import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hack/view/app_color.dart';
import 'package:hack/view/utils.dart';

import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InviteFriendScreen extends StatefulWidget {
  @override
  State<InviteFriendScreen> createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  CollectionReference profileRef =
      FirebaseFirestore.instance.collection("users");

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryTextColor.withOpacity(.9),
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'Invite Friends',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 21.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColor.blueColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,size: 28,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Image.asset(
                    'assets/img/coin.png',
                    height: 39.0,
                  ),
                  FutureBuilder<QuerySnapshot>(
                      future: profileRef
                          .where("refCode", isEqualTo: auth.currentUser!.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final data = snapshot.data!.docs[0];
                        final earnings = data.get("refEarnings");

                        return Text(
                          '$earnings',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: -0.1,
                          ),
                        );
                      })
                ]))
          ]),
      body: SingleChildScrollView(
        child: FutureBuilder<QuerySnapshot>(
            future: profileRef
                .where("refCode", isEqualTo: auth.currentUser!.uid)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final data = snapshot.data!.docs[0];
              List referalsList = data.get('referals');

              final refCode = data.get("refCode");

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColor.blueColor,
                      AppColor.primaryTextColor.withOpacity(.9),
                    ],
                  ),
                ),
                child: ResponsivePadding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(top: 20, left: 15, right: 15),
                            child: Text('Join our food community and bring along 10 friends to unlock a complimentary meal! Share your culinary adventures, discover new flavors, and enjoy exclusive rewards.'

,
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 35.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColor.redColor,
                                  AppColor.redColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                String shareLink =
                                    "Hey! use this app to do stuffs and earn NGN 100 after using my ref code ($refCode) ";

                                Share.share(shareLink);
                              },
                              child: Text(
                                'Share via Social Media',
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 5.0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                textStyle: TextStyle(
                                  letterSpacing: 1.2,
                                ),
                                primary: Colors.transparent,
                               onPrimary: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Refer your friend and earn 100 coins!',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 16.0,
                              color: Colors.blue[200],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                ClipboardData data =
                                    ClipboardData(text: refCode);

                                Clipboard.setData(data);

                                showMessage(context, "Ref code copied");
                              },
                              icon: const Icon(
                                Icons.copy,
                                size: 20,
                                color: Colors.grey,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset('assets/img/findfd.png',
                                height: 70, color: AppColor.redColor),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Image.asset(
                                'assets/img/share.png',
                                height: 70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      const Divider(
                        thickness: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Referals",
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${referalsList.length}",
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (referalsList.isEmpty)
                        const Text(
                          "No referrals",
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ...List.generate(referalsList.length, (index) {
                        final data = referalsList[index];
                        return Container(
                          height: 50,
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            title: Text(
                              data,
                              style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class ResponsivePadding extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;

  const ResponsivePadding(
      {Key? key, required this.padding, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          MediaQuery.of(context).size.width > 600 ? padding * 1.5 : padding,
      child: child,
    );
  }
}
