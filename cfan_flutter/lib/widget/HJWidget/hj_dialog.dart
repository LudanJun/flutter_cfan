import 'package:flutter/material.dart';

class HJDialog {
  static bool _isShowDialog = false;

  /// 完全自定义弹框
  /// 更新弹窗内容使用StatefulBuilder
  static void showAllCustomDialog(
    BuildContext context, {
    Widget? child,
    bool clickBgHidden = false,
  }) {
    if (_isShowDialog) {
      return;
    }
    _isShowDialog = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _CustomDialog(clickBgHidden: clickBgHidden, child: child);
      },
    ).then((value) => _isShowDialog = false);
  }
}

class _CustomDialog extends Dialog {
  const _CustomDialog({
    Key? key,
    super.child,
    this.clickBgHidden = false, // 点击背景隐藏，默认不隐藏
  }) : super(key: key);

  final bool clickBgHidden;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (clickBgHidden == true) {
                Navigator.pop(context);
              }
            },
          ),
          // 内容
          Center(child: child)
        ],
      ),
    );
  }
}
