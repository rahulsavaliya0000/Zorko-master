import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hack/view/login/welcome_view.dart';

import 'package:hack/view/main_tabview/main_tabview.dart';

import '../../common/globs.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StarupViewState();
}

class _StarupViewState extends State<StartupView> {

  @override
  void initState() {
    super.initState();
    goWelcomePage();
  }

  void goWelcomePage() async {

      await Future.delayed( const Duration(seconds: 3) );
      welcomePage();
  }
  void welcomePage(){
  Firebase.initializeApp();
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user!= null) {
       Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MainTabView()));
    }else{
       Navigator.push(
        context, MaterialPageRoute(builder: (context) => const WelcomeView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/img/splash_bg.png",
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
          Image.asset(
            "assets/img/zorko.png",
             width: media.width * 0.55,
            height: media.width * 0.55,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
