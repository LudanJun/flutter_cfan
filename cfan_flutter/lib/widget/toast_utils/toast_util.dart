import 'dart:ui';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:fluttertoast/fluttertoast.dart';

showToast(String msg, {Color? bgColor, bool? toastLength}) async {
  await Fluttertoast.cancel(); //防止toast频繁触发
  Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
      textColor: KTColor.white,
      fontSize: 16,
      toastLength: toastLength == true ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      backgroundColor: bgColor ?? KTColor.color172422);
}

showBidTip() {
  showToast("请完善帐号", bgColor: KTColor.colorC000);
}
