// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hack/view/home/home_view.dart';
import 'package:hack/view/main_tabview/main_tabview.dart';
import 'package:hack/view/ref_provider.dart';
import 'package:hack/view/step_three.dart';
import 'package:hack/view/utils.dart';

import 'package:provider/provider.dart';

class RefCodePage extends StatefulWidget {
  @override
  _RefCodePageState createState() => _RefCodePageState();
}

class _RefCodePageState extends State<RefCodePage> {
  final TextEditingController _refController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<RefProvider>(builder: (context, model, child) {
      return model.state == ViewState.Busy
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.orange.shade700),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Enter referral code",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(30.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  TextFormField(
                                    controller:
                                        _refController, // Make sure to use controller instead of the first parameter
                                    decoration: InputDecoration(
                                      hintText: 'Referral code',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange.shade600),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () async {
                                  //Validate User Inputs
                                  if (_refController.text.isEmpty) {
                                    showMessage(
                                        context, "All field are required");
                                  } else {
                                    await model.setReferral(
                                        _refController.text.trim());

                                    if (model.state == ViewState.Success) {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => HomeView()),
                                          (route) => false);
                                    } else {
                                      showMessage(context, model.message);
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15.0),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade700,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //Navigate to Register Page

                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => BirthdayPickerContent()),
                                      (route) => false);
                                },
                                child: Text(
                                  "No referral? continue instead",
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            );
    }));
  }
}
