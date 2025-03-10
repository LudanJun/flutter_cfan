/*
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EmojiText extends SpecialText {
  EmojiText(TextStyle? textStyle, SpecialTextGestureTapCallback? onTap,
      {this.showAtBackground = false, required this.start})
      : super(flag, ']', textStyle, onTap: onTap);

  static const String flag = '[/';
  final int? start;

  /// whether show background for @somebody
  final bool showAtBackground;

  @override
  InlineSpan finishText() {
    final TextStyle? textStyle =
        this.textStyle?.copyWith(color: Colors.blue, fontSize: 16.0);

    final str = toString();
    int mEmojiNew = 0;
    try {
      String mEmoji = str.replaceAll(RegExp('(\\[][)|(\\/)|(\\])'), "");
      mEmojiNew = int.parse(mEmoji);
    } on Exception catch (_) {}

    return showAtBackground
        ? BackgroundTextSpan(
            background: Paint()..color = Colors.blue.withOpacity(0.15),
            text: String.fromCharCode(mEmojiNew),
            actualText: str,
            start: start!,

            ///caret can move into special text
            deleteAll: true,
            style: textStyle,
            recognizer: (TapGestureRecognizer()
              ..onTap = () {
                if (onTap != null) onTap!(str);
              }))
        : SpecialTextSpan(
            text: String.fromCharCode(mEmojiNew),
            actualText: str,
            start: start!,
            style: textStyle,
            recognizer: (TapGestureRecognizer()
              ..onTap = () {
                if (onTap != null) onTap!(str);
              }));
  }
}
*/

 import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';

///emoji/image text
class EmojiText extends SpecialText {
  EmojiText(TextStyle? textStyle, {this.start})
      : super(EmojiText.flag, ']', textStyle);
  static const String flag = '[';
  final int? start;
  @override
  InlineSpan finishText() {
    final String key = toString();

    if (EmojiUitl.instance.emojiMap.containsKey(key)) {
      double size = 18;

      if (textStyle?.fontSize != null) {
        size = textStyle!.fontSize! * 1.15;
      }

      return ImageSpan(
          AssetImage(
            EmojiUitl.instance.emojiMap[key]!,
          ),
          actualText: key,
          imageWidth: size,
          imageHeight: size,
          start: start!,
          //fit: BoxFit.fill,
          margin: const EdgeInsets.all(2));
    }

    return TextSpan(text: toString(), style: textStyle);
  }
}

class EmojiUitl {
  EmojiUitl._() {
    for (int i = 1; i < 49; i++) {
      _emojiMap['[$i]'] = '$_emojiFilePath/$i.png';
    }
  }

  final Map<String, String> _emojiMap = <String, String>{};

  Map<String, String> get emojiMap => _emojiMap;

  final String _emojiFilePath = 'assets';

  static EmojiUitl? _instance;
  static EmojiUitl get instance => _instance ??= EmojiUitl._();
}
