import 'package:cfan_flutter/tools/asset_utils/asset_utils.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:flutter/material.dart';

/// 帖子详情 自定义导航栏
class CfanCommunityUserinfoHeadPage extends StatefulWidget {
  final String title;
  final Function rightBtnClick;
  const CfanCommunityUserinfoHeadPage(
      {super.key, required this.title, required this.rightBtnClick});

  @override
  State<CfanCommunityUserinfoHeadPage> createState() =>
      _CfanDetailHeadWidgetState();
}

class _CfanDetailHeadWidgetState extends State<CfanCommunityUserinfoHeadPage> {
  bool _highlight = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: ScreenAdapter.height(100),
          padding: EdgeInsets.only(
            left: ScreenAdapter.width(15),
            right: ScreenAdapter.width(15),
          ),
          child: Center(
            child: Stack(
              children: [
                Positioned(
                  left: ScreenAdapter.width(5),
                  bottom: ScreenAdapter.width(12),
                  child: Align(
                    child: Container(
                      child: InkWell(
                        onTap: () {
                          KTLog("返回");
                          Navigator.pop(context);
                        },
                        child: _highlight
                            ? Image.asset(
                                AssetUtils.getAssetImage(
                                    'icon_back_highlighted'),
                                width: ScreenAdapter.width(23),
                                height: ScreenAdapter.height(23),
                              )
                            : Image.asset(
                                AssetUtils.getAssetImage('icon_back'),
                                width: ScreenAdapter.width(23),
                                height: ScreenAdapter.height(23),
                              ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: ScreenAdapter.width(10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(16),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: ScreenAdapter.width(15),
                  bottom: ScreenAdapter.width(10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: ScreenAdapter.width(95),
                      height: ScreenAdapter.height(30),
                      child: OutlinedButton(
                        onPressed: () {
                          widget.rightBtnClick.call();
                        },
                        child: Text(
                          "退出社群",
                          style: TextStyle(
                            fontSize: ScreenAdapter.fontSize(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
