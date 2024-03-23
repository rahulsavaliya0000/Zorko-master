import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hack/view/utils.dart';


class RefProvider extends ChangeNotifier {
  ViewState state = ViewState.Idle;

  String message = "";

  CollectionReference profileRef =
      FirebaseFirestore.instance.collection("users");

  FirebaseAuth auth = FirebaseAuth.instance;

  setReferral(String refCode) async {
    state = ViewState.Busy;
    notifyListeners();

    try {
      final value = await profileRef.where("refCode", isEqualTo: refCode).get();

      if (value.docs.isEmpty) {
        message = 'Refcode is not available';
        state = ViewState.Error;
        notifyListeners();
      } else {
        final data = value.docs[0];

        List referrals = data.get("referals");

        referrals.add(auth.currentUser!.email);

        final body = {
          "referals": referrals,
          "refEarnings": data.get("refEarnings") + 100
        };

        await profileRef.doc(data.id).update(body);

        message = "Ref success";
        state = ViewState.Success;
        notifyListeners();
      }
    } on FirebaseException catch (e) {
      message = e.message.toString();
      state = ViewState.Error;
      notifyListeners();
    }
  }
}
