import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:flutter/material.dart';

////////////---常量---/////////////

//间距
double spacing = ScreenAdapter.width(10);

//图片选取数量
const int maxAssets = 9;

//图片宽度
double imagePadding = ScreenAdapter.width(3);

//强调色
const Color accentColor = Colors.amber;


////////////---回调---/////////////
///typedef Failure = Function(dynamic error);
///不带参数回调
typedef NormalCallback = Function();
///带参数回调
typedef NormalParamCallback = Function(dynamic param);

typedef HJGestureTapCallback = void Function();
