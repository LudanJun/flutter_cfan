import 'package:flutter/material.dart';

//国际化设置
class CurrentlocaleProvider with ChangeNotifier {
  //默认是中文
  Locale _locale = const Locale('zh', 'CH');

  Locale get value => _locale;
  void setLocale(locale) {
    _locale = locale;
    notifyListeners(); //通知依赖的Widegt
  }
}
