import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:hack/common_widget/buttons.dart';
import 'package:hack/view/app_color.dart';
import 'package:hack/view/main_tabview/main_tabview.dart';
import 'package:hack/view/utils.dart';
import 'package:pinput/pinput.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({required this.verificationId, super.key});
  final String verificationId;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final auth = FirebaseAuth.instance;

  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();

  void createUserProfile() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
  DateTime? _birthday;

   const String defaultPhotoUrl = 'https://t3.ftcdn.net/jpg/00/98/28/04/360_F_98280405_zpv1mUjUzx7AKn63v97TYR7ITNojzStp.jpg';


      Map<String, Object?> body = {
        "refCode": uid,
        "email": FirebaseAuth.instance.currentUser!.email,
        "date_created": DateTime.now(),
        "referals": <String>[],
        "refEarnings": 0,
        "birthday": _birthday ?? DateTime.now(),
        "photoUrl": defaultPhotoUrl,
        "age": 0,
      };

      // Example: You can perform operations like storing user profile in database here
      // For example:
      // await FirebaseFirestore.instance.collection('users').doc(uid).set(body);
      print("User profile created: $body");
    } catch (e) {
      print("Error creating user profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.whiteColor,
        title: Center(
          child: Text(
            'Verify Your Code',
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  offset: Offset(3.0, 3.0),
                  blurRadius: 5.0,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: AppColor.blueColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Pinput(
              closeKeyboardWhenCompleted: true,
              autofocus: true,
              keyboardType: TextInputType.number,
              length: 6,
              controller: _pinPutController,
              focusNode: _pinPutFocusNode,
              onSubmitted: (pin) async {
                if (pin.isEmpty) {
                  Utils.toastMessage('Please enter the verification code.');
                  return;
                }

                setState(() {
                  loading = true;
                });

                try {
                  final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: pin,
                  );

                  await auth.signInWithCredential(credential);
                  // Call the function to create user profile after successful sign-in
                  createUserProfile();
                  await Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainTabView()),
                    (Route<dynamic> route) => false,
                  );
                } catch (e) {
                  setState(() {
                    loading = false;
                  });

                  Utils.toastMessage(e.toString());
                }
              },
            ),
            const SizedBox(
              height: 80,
            ),
            CustomizeButton(
              color: AppColor.whiteColor,
              text: loading ? 'Verifying...' : 'Log In',
              textcolor: AppColor.blueColor,
              height: 48,
              width: 270,
              fontfamily: 'Quicksand',
              onPressed: () {
                _pinPutFocusNode.requestFocus();
              },
              fontweightt: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}
