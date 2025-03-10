import 'package:cfan_flutter/base/config.dart';
import 'package:cfan_flutter/base/global_size.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:flutter/material.dart';

class CfanVotersWidget extends StatelessWidget {
  const CfanVotersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding_10),
      child: Wrap(
        spacing: ScreenAdapter.width(5), //水平间距
        runSpacing: ScreenAdapter.width(5), //垂直间距
        direction: Axis.horizontal, //在主轴显示,或者纵轴显示
        alignment: WrapAlignment.start, //主轴对齐方式
        children: [
          VotersItemWidget(onTap: () {}, name: "周杰伦"),
          VotersItemWidget(onTap: () {}, name: "乌木怼怼温恩耶吞欧萨斯"),
          VotersItemWidget(onTap: () {}, name: "杨幂"),
          VotersItemWidget(onTap: () {}, name: "刘西美子"),
          VotersItemWidget(onTap: () {}, name: "周杰伦"),
        ],
      ),
    );
  }
}

class VotersItemWidget extends StatelessWidget {
  final String name; //名字
  final HJGestureTapCallback? onTap; //封装的按钮点击方法
  const VotersItemWidget({
    super.key,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add),
      label: Text(name),
    );

    // InkWell(
    //   //执行事件在外面传入
    //   onTap: onTap,
    //   child: Container(
    //     color: KTColor.getRandomColor(),
    //     child: Row(
    //       children: [
    //         Icon(Icons.circle_sharp),
    //         Text(
    //           name,
    //           style: TextStyle(
    //             fontSize: ScreenAdapter.fontSize(14),
    //             color: Colors.orange,
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
