import 'dart:math';

import 'package:flutter/material.dart';

class SysSize {
  static const double avatar = 56;
  static const double iconBig = 40;
  static const double iconNormal = 24;
  static const double big = 18;
  static const double bigsmall = 16;
  static const double normal = 14;
  static const double small = 12;
  static const double smallprint = 11;
  static const double smallSS = 10;
}

class KTColor {
  //获取随机颜色
  static Color getRandomColor() {
    return Color.fromARGB(
      255,
      Random.secure().nextInt(200),
      Random.secure().nextInt(200),
      Random.secure().nextInt(200),
    );
  }

  ///十六进制记法  #FF000000  取值范围为：00 - FF。
  ///RGB色彩是通过对红(R)、绿(G)、蓝(B)
  ///   三个颜色通道的变化和它们相互之间的叠加来得到各式各样的颜色的。
  ///RGBA此色彩模式与RGB相同，只是在RGB模式上新增了Alpha透明度。

  ///获取随机透明的白色
  static Color getRandonWhightColor(Random random) {
    //0~255 0为完全透明 255 为不透明
    //这里生成的透明度取值范围为 10~200
    int a = random.nextInt(190) + 10;
    return Color.fromARGB(a, 255, 255, 255);
  }

  static const Color appsubColor = Color(0xff23D7A0);
  static const Color appsubColor2 = Color(0xff43CAA0);
  static const Color appsubColor3 = Color(0x55C3F3DB);
  static const Color appsubColor4 = Color(0xffC7EFE4);
  static const Color tabbar_noselect = Color(0xFF606266);
  static const Color tabbar_select = Color.fromRGBO(17, 150, 219, 1);

  static const Color colorC000 = Color(0xcc000000);
  static const Color color010101 = Color(0x0f010101);
  static const Color color172422 = Color(0xff172422);
  static const Color color333 = Color(0xff333333);
  static const Color color666 = Color(0xff666666);
  static const Color color8A8787 = Color(0xff8A8787);
  static const Color color999 = Color(0xff999999);

  static const Color colore8e9e9 = Color(0x69E8E9E9);
  static const Color colore5e1e1 = Color(0xFFE5E1E1);
  static const Color colorBEC1C0 = Color(0xFFBEC1C0);
  static const Color colorE5EDEA = Color(0x69E5EDEA);
  static const Color colorEBEAEA = Color(0xffEBEAEA);

  static const Color colorf0f0f0 = Color(0xFFF0F0F0);
  static const Color colorf6f6f6 = Color(0xFFF6F6F6);
  static const Color colorf8f8f8 = Color(0xFFF8F8F8);
  static const Color colorfafafa = Color(0xFFFAFAFA);
  static const Color colord3cdcd = Color(0xFFD3CDCD);
  static const Color color828282 = Color(0xFF828282);
  static const Color colorfdfbfb = Color(0xFFFDFBFB);

  static const Color bg0 = Color.fromRGBO(255, 255, 255, 0);
  static const Color bg5 = Color.fromRGBO(255, 255, 255, 0.05);
  static const Color bg20 = Color.fromRGBO(255, 255, 255, 0.2);
  static const Color bg50 = Color.fromRGBO(255, 255, 255, 0.5);
  static const Color bg75 = Color.fromRGBO(255, 255, 255, 0.75);
  static const Color bgb75 = Color.fromRGBO(0, 0, 0, 0.5);
  static const Color popupboxdividingLinef = Color(0x6f2D3836);

  ///黑色
  static const Color black = Color(0xff000000);
  static const Color color303133 = Color(0xff303133);
  static const Color color606266 = Color(0xff606266);
  static const Color color909399 = Color(0xff909399);
  static const Color color9E9E9E = Color(0xff9E9E9E);
  static const Color colorCCC = Color(0xFFCCCCCC);
  static const Color colorDCDFE6 = Color(0xffDCDFE6);
  static const Color colorE4E7ED = Color(0xffE4E7ED);
  static const Color colorF2F6FC = Color(0xffF2F6FC);

  ///app
  static const Color white = Color(0xffffffff);
  static const Color appColor = Color(0x1196db);
  static const Color app1Color = Color(0xff48D9AB);
  static const Color app2Color = Color(0xff45AE6B9);
  static const Color backgroundColor = Color(0xFFF5F5F5);

  ///green
  static const Color color8FDB8F = Color(0xff8FDB8F);
  static const Color color67C23A = Color(0xFF67C23A);
  static const Color color7CDEBF = Color(0xff7CDEBF);
  static const Color color44CCA2 = Color(0xff44CCA2);
  static const Color colorD9F3FF = Color(0xFFD9FFF3);
  static const Color color7CE6C6 = Color(0xFF7CE6C6);
  static const Color color27C393 = Color(0xFF27C393);

  ///red
  static const Color colorRed = Color(0xFFF80404);
  static const Color colorF56C6C = Color(0xFFF56C6C);

  ///blue
  static const Color colorBlue = Color(0xFF60E8F8);
  static const Color color2799E6 = Color(0xFF2799E6);
  static const Color color66C1FA = Color(0xFF66C1FA);

//yellow

  static const Color colorFFA940 = Color(0xFFFFA940);
  static const Color colorFF8D1A = Color(0xFFFF8D1A);
  static const Color colorfa994b = Color(0xFFFA994B);
  static const Color colorFD9418 = Color(0xFFFD9418);

/////
  static const Color titleImp = Color(0xffFFECC8);
  static const Color containerColor = Color(0xff172422);
  static const Color green = Color(0xff009E86);
  static const Color darkGray = Color(0xff999999);
  static const Color dividingLine = Color(0xff1C2222);
  static const Color back2 = Color(0xff121314);
}
