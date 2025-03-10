import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/base/config.dart';
import 'package:cfan_flutter/base/global_size.dart';
import 'package:cfan_flutter/tools/asset_utils/asset_utils.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:flutter/material.dart';

///帖子 头部封装
///包含 头像 名字 时间 位置 右边更多按钮

class PostHeadWidget extends StatelessWidget {
  //传入模型数据
  final dynamic itemModel;

  ///头像点击回调
  late Function headImageCall;
  final Function rightIconCall;
  PostHeadWidget({
    super.key,
    required this.itemModel,
    required this.rightIconCall,
  });

  @override
  Widget build(BuildContext context) {
    ///可以在这处理 图标等级
    String iconImagStr = '';
    switch (itemModel.gradeInfo?.level) {
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
    return Row(
      children: [
        //1.头像
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(padding_5),
            child: Container(
              child: CircleAvatar(
                radius: ScreenAdapter.width(35),
                //   backgroundImage: const NetworkImage(
                //       "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
                backgroundImage: itemModel.avatar != null
                    ? CachedNetworkImageProvider(itemModel.avatar!)
                    : AssetImage(
                        AssetUtils.getAssetImage("default_zjl"),
                      ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: ScreenAdapter.width(10),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //名字
              Row(
                children: [
                  Text(
                    itemModel.name!,
                    style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(14),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: ScreenAdapter.width(10),
                  ),
                  //等级名称 传入等级 和 等级名称
                  // GradeNameWidget(
                  //   level: itemModel.gradeInfo?.level ?? 1,
                  //   levelName: "等级名称",
                  // ),
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
                          "等级名称",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: ScreenAdapter.fontSize(12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: ScreenAdapter.height(10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //时间
                  Text(
                    itemModel.createdAt ?? "",
                    style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(12),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: ScreenAdapter.width(15),
                  ),
                  Text(
                    "北京市",
                    style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(12),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: ScreenAdapter.width(15),
                  ),
                  Text(
                    "发布",
                    style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(12),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.centerRight,
            // color: Colors.green,
            // child: Icon(Icons.more_vert_outlined),
            child: IconButton(
              onPressed: () {
                rightIconCall.call();
              },
              icon: const Icon(Icons.more_vert_outlined),
            ),
          ),
        ),
      ],
    );
    // co
  }
}
