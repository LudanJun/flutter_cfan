import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/provider/cfan_details_provider.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:flutter/material.dart';

class CfanDetailBottomView extends StatefulWidget {
  final Function subHeader; //传入评论 点赞
  const CfanDetailBottomView({super.key, required this.subHeader});

  @override
  State<CfanDetailBottomView> createState() => _CfanDetailBottomViewState();
}

class _CfanDetailBottomViewState extends State<CfanDetailBottomView> {
  //生命周期函数:当组件初始化的时候就会触发
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenAdapter.width(414),
      child: Column(
        children: [
          widget.subHeader(),
          SizedBox(
            width: ScreenAdapter.width(414),
            height: ScreenAdapter.getScreenHeight() - ScreenAdapter.height(120),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
                ListTile(
                  title: Text("哈哈哈哈哈"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
