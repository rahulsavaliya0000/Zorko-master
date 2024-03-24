import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hack/review.dart';
import 'package:hack/view/RefCodePage.dart';
import 'package:hack/view/app_color.dart';
import 'package:hack/view/invite_friend.dart';
import 'package:hack/view/login/sing_up_view.dart';
import 'package:hack/view/login/welcome_view.dart';
import 'package:hack/view/more/about_us_view.dart';
import 'package:hack/view/more/admin_panel.dart';
import 'package:hack/view/more/inbox_view.dart';
import 'package:hack/view/more/noti.dart';
import 'package:hack/view/more/payment_details_view.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../../common/color_extension.dart';
import '../../common/service_call.dart';
import 'my_order_view.dart';
import 'notification_view.dart';

class MoreView extends StatefulWidget {
  const MoreView({super.key});

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  List moreArr = [
    {
      "index": "1",
      "name": "Payment Details",
      "image": "assets/img/more_payment.png",
      "base": 0
    },
    {
      "index": "2",
      "name": "My Orders",
      "image": "assets/img/more_my_order.png",
      "base": 0
    },
    {
      "index": "3",
      "name": "Notifications",
      "image": "assets/img/more_notification.png",
      "base": 15
    },
    {
      "index": "4",
      "name": "Add review",
      "image": "assets/img/more_info.png",
      "base": 0
    },
    {
      "index": "5",
      "name": "Refer and earn",
      "image": "assets/img/earn.png",
      "base": 0
    },
    {
      "index": "6",
      "name": "Admin",
      "image": "assets/img/more_inbox.png",
      "base": 0
    },
    {
      "index": "7",
      "name": "AboutUs",
      "image": "assets/img/more_info.png",
      "base": 0
    },{
      "index": "8",
      "name": "Logout",
      "image": "assets/img/more_info.png",
      "base": 0
    },
  ];


  Future<void> _signOut(BuildContext context) async {
    try {
      // Create a Completer to handle the result of the dialog
      Completer<bool> completer = Completer<bool>();

      // Show a confirmation dialog
      Dialogs.bottomMaterialDialog(
        msg: 'Are you sure you want to log out? You can\'t undo this action.',
        msgStyle: TextStyle(
            color: AppColor.blueColor,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w700,
            fontSize: 15),
        title: 'Logout',
        titleStyle: TextStyle(
                              color:AppColor.redColor,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              fontSize: 19),
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () {
              completer.complete(
                  false); // Complete with 'false' when Cancel is pressed
              Navigator.of(context).pop();
            },
            text: 'Cancel',
            iconData: Icons.cancel_outlined,
            textStyle: TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () async {
              completer.complete(
                  true); // Complete with 'true' when Logout is pressed
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => WelcomeView()),
                (route) => false,
              );
            },
            text: 'Logout',
            iconData: Icons.exit_to_app,
            color: Colors.blue,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ],
      );

      // Wait for the user's decision
      bool result = await completer.future;

      // If the user confirms the logout, result will be true
      if (result == true) {
        // Perform the logout
        await FirebaseAuth.instance.signOut();

        // Navigate to the CreateAccountPage and remove all previous routes
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeView()),
          (route) => false,
        );
      }
    } catch (error) {
      print('Error signing out: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      "More",
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
              ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: moreArr.length,
                  itemBuilder: (context, index) {
                    var mObj = moreArr[index] as Map? ?? {};
                    var countBase = mObj["base"] as int? ?? 0;
                    return InkWell(
                      onTap: () {
                        switch (mObj["index"].toString()) {
                          case "1":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PaymentDetailsView()));

                            break;

                          case "2":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyOrderView()));
                          case "3":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NotificationsPage()));
                          case "4":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Review()));
                          case "5":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InviteFriendScreen()));
                          case "6":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashboardScreen()));case "7":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutUsView()));
                          case "8":
                            _signOut(context);
                            break;
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              decoration: BoxDecoration(
                                  color: TColor.textfield,
                                  borderRadius: BorderRadius.circular(5)),
                              margin: const EdgeInsets.only(right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: TColor.placeholder,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    alignment: Alignment.center,
                                    child: Image.asset(mObj["image"].toString(),
                                        width: 25,
                                        height: 25,
                                        fit: BoxFit.contain),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      mObj["name"].toString(),
                                      style: TextStyle(
                                          color: TColor.primaryText,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  if (countBase > 0)
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(12.5)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        countBase.toString(),
                                        style: TextStyle(
                                            color: TColor.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: TColor.textfield,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Image.asset("assets/img/btn_next.png",
                                  width: 10,
                                  height: 10,
                                  color: TColor.primaryText),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
