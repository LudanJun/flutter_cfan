import 'package:cfan_flutter/base/cfan_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CfanLocalizationsDelegate
    extends LocalizationsDelegate<CfanLocalizations> {
  const CfanLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<CfanLocalizations> load(Locale locale) {
    return new SynchronousFuture<CfanLocalizations>(
        new CfanLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<CfanLocalizations> old) {
    return false;
  }

  static CfanLocalizationsDelegate delegate = const CfanLocalizationsDelegate();
}
