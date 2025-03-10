import 'package:cfan_flutter/tools/asset_utils/asset_utils.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:flutter/material.dart';

enum IconLevel {
  iconlevel_1(1),
  iconlevel_2(2),
  iconlevel_3(3),
  iconlevel_4(4),
  iconlevel_5(5),
  iconlevel_6(6),
  iconlevel_7(6);

  final int value; // 存储整数值的字段

  const IconLevel(this.value); // 构造函数
}

///等级图标和名称 widget
class GradeNameWidget extends StatelessWidget {
  final int level;
  final String levelName;
  const GradeNameWidget(
      {super.key, required this.level, required this.levelName});

  @override
  Widget build(BuildContext context) {
    ///可以在这处理 图标等级
    String iconImagStr = '';
    switch (level) {
      case 1:
        iconImagStr = "home_memeber";
        break;
      case 2:
        iconImagStr = "home_memeber";
        break;
      case 3:
        iconImagStr = "home_memeber";
        break;
      case 4:
        iconImagStr = "home_memeber";
        break;
      case 5:
        iconImagStr = "home_memeber";
        break;
      case 6:
        iconImagStr = "home_memeber";
        break;
      case 7:
        iconImagStr = "home_memeber";
        break;
    }

    return //等级名称
        Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.red,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          //等级图标
          // Icon(
          //   Icons.ac_unit_outlined,
          //   size: 20,
          // ),
          Container(
            width: ScreenAdapter.width(12),
            height: ScreenAdapter.width(12),
            child: Image.asset(
              AssetUtils.getAssetImage(iconImagStr),
            ),
          ),

          //等级名称
          Text(
            levelName,
            style: TextStyle(
              color: Colors.red,
              fontSize: ScreenAdapter.fontSize(12),
            ),
          ),
        ],
      ),
    );
  }
}
