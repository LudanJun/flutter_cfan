import 'package:flutter/material.dart';

class CfanLocalizations {
  final Locale locale;

  CfanLocalizations(this.locale);

  static final Map<String, Map<String, String>> _localizeValues = {
    'zh': {
      'discover': '发现',
      'cfan': 'cfan',
      'message': '消息',
      'my': '个人',
      'login': '登录',
    },
    'en': {
      'discover': 'Discover',
      'cfan': 'cfan',
      'message': 'message',
      'my': 'me',
      'login': 'Login',
    },
  };

  get discoverTitle {
    return _localizeValues[locale.languageCode]?['discover'];
  }

  get cfanTitle {
    return _localizeValues[locale.languageCode]?['cfan'];
  }

  get messageTitle {
    return _localizeValues[locale.languageCode]?['message'];
  }

  get myTitle {
    return _localizeValues[locale.languageCode]?['my'];
  }

  get loginTitle {
    return _localizeValues[locale.languageCode]?['login'];
  }

  // 这个特殊的Localizations.of()表达式会经常使用，这样可以直接调用便捷方法
  static CfanLocalizations? of(BuildContext context) {
    return Localizations.of<CfanLocalizations>(context, CfanLocalizations);
  }
}
