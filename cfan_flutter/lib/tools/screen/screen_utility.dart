import 'dart:io';

import 'package:cfan_flutter/tools/screen/screen_util.dart';
import 'package:flutter/cupertino.dart';

void ScreenUtilityStandardInit(BuildContext context) {
  ScreenUtil1.init(context, width: 375, height: 667);
}

void ScreenUtilityCustomInit(
    BuildContext context, double width, double height) {
  ScreenUtil1.init(context, width: width, height: height);
}

extension NewSizeExtension on double {
  double get W {
    if (Platform.isIOS) return this.toDouble();
    return (ScreenUtil1().scaleWidth * this).toDouble();
  }

  double get H {
    if (Platform.isIOS) return this.toDouble();
    return (ScreenUtil1().scaleWidth * this).toDouble();
  }

  double get SP {
    // if (Platform.isIOS)
    return this.toDouble() / ScreenUtil1.textScaleFactor;
    // return (ScreenUtil().setSp(this, allowFontScalingSelf: false)).toDouble();
  }

  double get per {
    return this.toDouble() * ScreenUtil1.screenWidth;
  }
}

extension IntExtension on int {
  int get w {
    if (Platform.isIOS) return toInt();
    return (ScreenUtil1().scaleWidth * this).toInt();
  }

  int get h {
    if (Platform.isIOS) return toInt();
    return (ScreenUtil1().scaleWidth * this).toInt();
  }
}
