import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hack/view/utils.dart';

class Auth_Provider extends ChangeNotifier {
  ViewState state = ViewState.Idle;

  String message = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference profileRef =
      FirebaseFirestore.instance.collection("users");

  
  DateTime? _birthday;
  

  // Getter methods for height, weight, and birthday

  DateTime? get birthday => _birthday;

  // Setter methods for height, weight, and birthday


  void setBirthday(DateTime value) {
    _birthday = value;
    notifyListeners();
  }
loginUser(String? email, String? password) async {
    state = ViewState.Busy;
    notifyListeners();

    try {
        if (email != null && password != null) {
            await auth.signInWithEmailAndPassword(email: email, password: password);
            message = "Login success";
            state = ViewState.Success;
            notifyListeners();
        } else {
            message = "Email or password is null";
            state = ViewState.Error;
            notifyListeners();
        }
    } on FirebaseException catch (e) {
        message = e.message.toString();
        state = ViewState.Error;
        notifyListeners();
    } catch (e) {
        message = e.toString();
        state = ViewState.Error;
        notifyListeners();
    }
}
registerUser(String? email, String? password, String mobileNumber) async {
  state = ViewState.Busy;
  notifyListeners();

  try {
    await auth.createUserWithEmailAndPassword(
        email: email!, password: password!);

    ///Create user profile
    createUserProfile(mobileNumber); // Pass mobileNumber to createUserProfile
    message = "Register success";
    state = ViewState.Success;
    notifyListeners();
  } on FirebaseException catch (e) {
    message = e.message.toString();
    state = ViewState.Error;
    notifyListeners();
  } catch (e) {
    message = e.toString();
    state = ViewState.Error;
    notifyListeners();
  }
}

  static const String _defaultPhotoUrl = 'https://t3.ftcdn.net/jpg/00/98/28/04/360_F_98280405_zpv1mUjUzx7AKn63v97TYR7ITNojzStp.jpg';


void createUserProfile(String mobileNumber) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    final body = {
      "refCode": uid,
      "email": FirebaseAuth.instance.currentUser!.email,
      "mobileNumber": mobileNumber,
      "date_created": DateTime.now(),
      "referals": <String>[],
      "refEarnings": 0,
      "birthday": _birthday ?? DateTime.now(),
      "photoUrl": _defaultPhotoUrl,
      "age": 0,
    };

    // Check if the document already exists
    var userProfile = await profileRef.doc(uid).get();

    if (userProfile.exists) {
      // If the document exists, update it
      await profileRef.doc(uid).update(body);
      print('User profile updated successfully!');
    } else {
      // If the document doesn't exist, create a new one
      await profileRef.doc(uid).set(body);
      print('User profile created successfully!');
    }
  } catch (error) {
    print('Error creating/updating user profile: $error');
    // Handle error as needed
  }
}

  Future<void> updateUserProfileImageUrl(String imageUrl) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      var userProfile = await profileRef.doc(uid).get();

      if (userProfile.exists) {
        await profileRef.doc(uid).update({'photoUrl': imageUrl});
        print('User profile image URL updated successfully!');
      } else {
        print('User profile does not exist. Cannot update image URL.');
      }
    } catch (error) {
      print('Error updating user profile image URL: $error');
    }
  }

  Future<void> updateSandU(int streak, DateTime lastAppOpenDate) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      var userProfile = await profileRef.doc(uid).get();
      if (userProfile.exists) {
        await profileRef.doc(uid).update({
          'streak': streak,
          'lastAppOpenDate': lastAppOpenDate,
        });
        print('User profile updated successfully!');
      } else {
        print('User profile does not exist. Cannot update profile.');
      }
    } catch (error) {
      print('Error updating user profile: $error');
    }
  }

  Future<void> updateS(int streak) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      var userProfile = await profileRef.doc(uid).get();
      if (userProfile.exists) {
        await profileRef.doc(uid).update({
          'streak': streak,
        });
        print('User profile updated successfully!');
      } else {
        print('User profile does not exist. Cannot update profile.');
      }
    } catch (error) {
      print('Error updating user profile: $error');
    }
  }
}
