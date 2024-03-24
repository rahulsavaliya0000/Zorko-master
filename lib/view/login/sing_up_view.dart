import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hack/common/color_extension.dart';
import 'package:hack/common/extension.dart';
import 'package:hack/common_widget/round_button.dart';
import 'package:hack/view/RefCodePage.dart';
import 'package:hack/view/auth_provider.dart';
import 'package:hack/view/utils.dart';
import 'package:provider/provider.dart';

import '../../common/globs.dart';
import '../../common/service_call.dart';
import '../../common_widget/round_textfield.dart';
import '../on_boarding/on_boarding_view.dart';
import 'login_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Consumer<Auth_Provider>(builder: (context, model, child) {
        return model.state == ViewState.Busy
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: 
              Form(
                    key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 64,
                    ),
                    Text(
                      "Sign Up",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 30,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      "Add your details to sign up",
                      style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundTextfield(
                      hintText: "Name",
                      controller: txtName,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundTextfield(
                      hintText: "Email",
                      controller: txtEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundTextfield(
                      hintText: "Mobile No",
                      controller: txtMobile,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundTextfield(
                      hintText: "Address",
                      controller: txtAddress,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundTextfield(
                      hintText: "Password",
                      controller: txtPassword,
                      obscureText: true,
                    ),
                     const SizedBox(
                      height: 25,
                    ),
                    RoundTextfield(
                      hintText: "Confirm Password",
                      controller: txtConfirmPassword,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                 RoundButton(
  title: "Sign Up",
  onPressed: () async {
    print(txtEmail.text);
    print(txtPassword.text);
    print(txtConfirmPassword.text);
    print(txtMobile.text); // Capture mobile number input

    if (txtEmail.text.isEmpty ||
        txtPassword.text.isEmpty ||
        txtConfirmPassword.text.isEmpty) {
      showMessage(context, "All fields are required");
    } else if (txtPassword.text !=
        txtConfirmPassword.text) {
      showMessage(context, "Passwords do not match");
    } else {
      // Continue with registration logic
      await model.registerUser(
          txtEmail.text.trim(),
          txtPassword.text.trim(),
          txtMobile.text); // Pass mobile number to registerUser method

      if (model.state == ViewState.Success) {
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
                builder: (context) => RefCodePage()),
            (route) => false);
      } else {
        showMessage(context, model.message);
      }
    }
  },
),
                    const SizedBox(
                      height: 30,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginView(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Already have an Account? ",
                            style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Login",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  

  void serviceCallSignUp(Map<String, dynamic> parameter) {
    Globs.showHUD();

    ServiceCall.post(parameter, SVKey.svSignUp,
        withSuccess: (responseObj) async {
      Globs.hideHUD();
      if (responseObj[KKey.status] == "1") {
        Globs.udSet(responseObj[KKey.payload] as Map? ?? {}, Globs.userPayload);
        Globs.udBoolSet(true, Globs.userLogin);
        
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const OnBoardingView(),
            ),
            (route) => false);
      } else {
        mdShowAlert(Globs.appName,
            responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert(Globs.appName, err.toString(), () {});
    });
  }
}
