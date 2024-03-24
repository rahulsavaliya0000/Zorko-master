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
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.blackColor,
        title: const Text(
          'Log In With Phone',
          style: TextStyle(color: Color(0xfffc6011)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                    style: const TextStyle(
                      color: Color(0xffffffff),
                    ),
                    keyboardType: TextInputType.phone,
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
                      prefixText: '+91 ',
                      prefixStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.black,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 27, horizontal: 16),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white38),
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter phone num';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              CustomizeButton(
                onPressed: () {
                  String phoneNumber = '+91${phoneNumberController.text}';

                  auth.verifyPhoneNumber(
                    phoneNumber: phoneNumber,
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
                          ),
                        ),
                      );
                    },
                    codeAutoRetrievalTimeout: (e) {
                      Utils.toastMessage(e);
                    },
                  );
                },
                color: Colors.orange.shade700,
                text: 'Login',
                textcolor: Colors.white,
                height: 48,
                width: 270,
                fontfamily: 'Quicksand',
                fontweightt: FontWeight.w500,
              ),
              SizedBox(height: 130,),
              Image.asset("assets/img/zorko.png",height: 90,)
            ],
          ),
        ),
      ),
    );
  }
}
