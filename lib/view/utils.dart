

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hack/view/app_color.dart';

enum ViewState { Idle, Busy, Error, Success }

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class Utils {


    static void fieldFocusChange(BuildContext context , FocusNode current , FocusNode  nextFocus ){
      current.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }


    static toastMessage(String message){
      Fluttertoast.showToast(
          msg: message ,
        backgroundColor: Colors.white ,
        textColor: AppColor.blueColor,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,


      );
    }


    static toastMessageCenter(String message){
      Fluttertoast.showToast(
        msg: message ,
        backgroundColor: AppColor.redColor ,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        textColor: AppColor.whiteColor,
      );
    }

    static snackBar(String title, String message){
      Get.snackbar(
          title,
          message ,
      );
    }
}