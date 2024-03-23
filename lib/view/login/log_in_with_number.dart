import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hack/common_widget/buttons.dart';
import 'package:hack/view/app_color.dart';
import 'package:hack/view/login/verify_codeScreen.dart';
import 'package:hack/view/utils.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111111),
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        title: const Text(
          'Log In With Phone',
          style: TextStyle(color: Color(0xffffffff)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: 350,
                height: 86,
                child: TextFormField(
                  style: const TextStyle(color: Color(0xffffffff)),
                  keyboardType: TextInputType.emailAddress,
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Phone Number',
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: Color(0xff999999),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 27, horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter email';
                    }
                    return null;
                  },
                ),
              ),
            ),
          
            const SizedBox(
              height: 80,
            ),CustomizeButton(
                onPressed: () {
                  auth.verifyPhoneNumber(
                      phoneNumber: phoneNumberController.text,
                      verificationCompleted: (_) {},
                      verificationFailed: (e) {
                        Utils.toastMessage(e.toString());
                      },
                      codeSent: (String verificationId, int? token) {
                        Navigator.push(
                            context,
                            // ignore: inference_failure_on_instance_creation
                            MaterialPageRoute(
                                builder: (context) => VerifyCodeScreen(
                                      verificationId: verificationId,
                                    ),),);
                      },
                      codeAutoRetrievalTimeout: (e) {
                        Utils.toastMessage(e);
                      },);
                }, color: AppColor.whiteColor, text: 'Login', textcolor: AppColor.blueColor, height: 48, width: 270, fontfamily: 'Quicksand', fontweightt:  FontWeight.w500, )
          ],
        ),
      ),
    );
  }
}
