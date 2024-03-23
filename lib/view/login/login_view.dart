import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hack/common/color_extension.dart';
import 'package:hack/common/extension.dart';
import 'package:hack/common/globs.dart';
import 'package:hack/common_widget/round_button.dart';
import 'package:hack/view/auth_provider.dart';
import 'package:hack/view/home/home_view.dart';
import 'package:hack/view/login/rest_password_view.dart';
import 'package:hack/view/login/sing_up_view.dart';
import 'package:hack/view/on_boarding/on_boarding_view.dart';
import 'package:hack/view/utils.dart';
import 'package:provider/provider.dart';


import '../../common/service_call.dart';
import '../../common_widget/round_icon_button.dart';
import '../../common_widget/round_textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
    final _formKey = GlobalKey<FormState>();


  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
  }

  void login() {
    _auth
        .signInWithEmailAndPassword(
      email: txtEmail.text,
      password: txtPassword.text,
    )
        .then((value) {
      Utils.toastMessage(value.user!.email.toString());
      Navigator.pushReplacement(
        context,
        // ignore: inference_failure_on_instance_creation
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    }).onError((e, stackTrace) {
      debugPrint(e.toString());
      Utils.toastMessage(e.toString());
    });
  }


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Consumer<Auth_Provider>(builder: (context, model, child) {
        return model.state == ViewState.Busy
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: Form(
                 key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 64,
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 30,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      "Add your details to login",
                      style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundTextfield(
                      hintText: "Your Email",
                      controller: txtEmail,
                      keyboardType: TextInputType.emailAddress,
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
                    RoundButton(
                        title: "Login",
                       onPressed:() async {
                                          print(txtEmail.text);
                                          print(txtPassword.text);
                                          if (txtEmail.text.isEmpty ||
                                              txtPassword.text.isEmpty) {
                                            showMessage(
                                                context, "All field are required");
                                          } else {
                                            await model.loginUser(
                                                txtEmail.text.trim(),
                                                txtPassword.text.trim());
                          
                                            if (model.state == ViewState.Success) {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                           HomeView()),
                                                  (route) => false);
                                            } else {
                                              showMessage(context, model.message);
                                            }
                                          }
                                          //Validate User Inputs
                                        },),
                    const SizedBox(
                      height: 4,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResetPasswordView(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot your password?",
                        style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "or Login With",
                      style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RoundIconButton(
                      icon: "assets/img/facebook_logo.png",
                      title: "Login with Facebook",
                      color: const Color(0xff367FC0),
                      onPressed: () {},
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundIconButton(
                      icon: "assets/img/google_logo.png",
                      title: "Login with Google",
                      color: const Color(0xffDD4B39),
                      onPressed: () {},
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpView(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Don't have an Account? ",
                            style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Sign Up",
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

  void serviceCallLogin(Map<String, dynamic> parameter) {
    Globs.showHUD();

    ServiceCall.post(parameter, SVKey.svLogin,
        withSuccess: (responseObj) async {
      Globs.hideHUD();
      if (responseObj[KKey.status] == "1") {
        
        Globs.udSet( responseObj[KKey.payload] as Map? ?? {} , Globs.userPayload);
        Globs.udBoolSet(true, Globs.userLogin);

          Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
            builder: (context) => const OnBoardingView(),
          ), (route) => false);
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
