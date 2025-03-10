import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';

import 'at_text.dart';
import 'emoji_text.dart';
import 'topic_text.dart';

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  MySpecialTextSpanBuilder({this.showAtBackground = false});

  /// whether show background for @somebody
  final bool showAtBackground;

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      int? index}) {
    if (flag == '') {
      return null;
    }

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    // if (isStart(flag, EmojiText.flag)) {
    //   return EmojiText(textStyle, start: index! - (EmojiText.flag.length - 1));
    // }
    //表情 微博demo这样写
    // if (isStart(flag, EmojiText.flag)) {
    //   return EmojiText(textStyle, onTap, start: null);
    // }
    //extended_text_field demo这样写
    // if (isStart(flag, EmojiText.flag)) {
    //   return EmojiText(textStyle, start: null);
    // }
    // //@
    // else
    if (isStart(flag, AtText.flag)) {
      return AtText(
        textStyle,
        onTap,
        start: index! - (AtText.flag.length - 1),
        showAtBackground: showAtBackground,
      );
    }
    //#话题
    else if (isStart(flag, TopicText.flag)) {
      return TopicText(
        textStyle,
        onTap,
        start: index! - (TopicText.flag.length - 1),
        showAtBackground: showAtBackground,
      );
    }
    //疑似链接
    // else if (isStart(flag, DollarText.flag)) {
    //   return DollarText(textStyle, onTap,
    //       start: index! - (DollarText.flag.length - 1));
    // }
    return null;
  }
}
