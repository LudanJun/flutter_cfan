import 'package:flutter/material.dart';

class Global {
  static GlobalKey<NavigatorState> navigatorkey = GlobalKey();

  ///当app从后台到前台的时候，是否需要执行刷新，默认需要
  static bool isNeedRefreshWhenAppResume = true;

  ///是否登录
  static bool isLogin = false;

  ///是否需要刷新token 默认需要刷新
  static bool isRefreshToken = true;

  ///当前网络状态
  static bool isNetState = false;

  ///网络状态
  static var netName = '';

  ///引导页
  static var guidepagesave = '';

  //协议
  static var agreementsave = '';
}

