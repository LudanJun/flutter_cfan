import 'dart:io';
import 'package:cfan_flutter/tools/asset_utils/asset_utils.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/main/index_page.dart';
import 'package:cfan_flutter/main/like_select/like_item.dart';
import 'package:cfan_flutter/main/like_select/like_model.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/tools/screen/screen_utility.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late double width;
  late double height;
  bool hasInitialized = false;

  // final CommunityProvider _communityProvider = CommunityProvider();

  bool isSelect = false;
  List<LeftData> leftList = [];
  int _selectIndex = 0;

  Map<int, List<int>> totalItem = {};

  @override
  void initState() {
    super.initState();

    leftList =
        List.generate(20, (index) => LeftData('$index组', false, index + 1))
            .toList();

    //屏蔽如下代码 才不会报错因为是web运行 改为安卓和iOS 打开如下代码
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _init();
    });
  }

  Future<void> _init() async {
    if (hasInitialized) return;
    hasInitialized = true;

    // _alertDialog();
    // var isguidepagesave =
    //     await PersistentStorage().getStorage(KTConfig.guidepagesave);
    // Global.guidepagesave = isguidepagesave ?? false;

    // Future.delayed(const Duration(milliseconds: 800), () {
    //   if (Global.isSavexieyi == false) {
    //     _showDialog();
    //   } else {
    //     // 延迟1000毫秒 跳转到 首页tabbar
    KTLog("执行了");

    Future.delayed(const Duration(milliseconds: 800), () {
      print("执行了吗");
      NavigationUtil.getInstance().pushReplacementPage(
        context,
        RouterName.indexPage,
        widget: const IndexPage(),
      );
    });
  }

  @override
  void dispose() {
    hasInitialized = false;
    super.dispose();
  }

/*
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    //屏蔽如下代码 才不会报错因为是web运行 改为安卓和iOS 打开如下代码
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double hwAspectRatio = 1 / aspectRatio;

    if (aspectRatio > 0) {
      if (hwAspectRatio > 1.87 && Platform.isAndroid) {
        ScreenUtilityCustomInit(context, 414, 896);
      } else {
        ScreenUtilityStandardInit(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("喜欢选择"),
        actions: [
          GFButton(
            color: Colors.transparent,
            onPressed: () {
              NavigationUtil.getInstance().pushReplacementPage(
                context,
                RouterName.indexPage,
                widget: const IndexPage(),
              );
            },
            text: "跳过",
            textColor: Colors.lightBlue[800],
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: ScreenAdapter.height(45),
            child: GridView.builder(
              itemCount: leftList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, //配置一行有几个
                crossAxisSpacing: 5, //横轴水盆间距
                mainAxisSpacing: 10,
                // mainAxisExtent: 5,//限制高度
                // childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return _initGridViewData(
                  context,
                  index,
                  leftList[index],
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GFButton(
              onPressed: () {
                KTLog("确定");
              },
              size: ScreenAdapter.height(45),
              fullWidthButton: true,
              shape: GFButtonShape.square,
              text: "确定",
              textStyle: TextStyle(
                fontSize: ScreenAdapter.fontSize(24),
              ),
            ),
          )
        ],
      ),
      /*
      body: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 10, //横轴水平间距
        mainAxisSpacing: 10, //垂直间距
        padding: const EdgeInsets.all(5), //给上边左边也配间距
        children: const [
          CircleAvatar(
            radius: 200,
            backgroundImage: NetworkImage(
                "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
          ),
          CircleAvatar(
            radius: 200,
            backgroundImage: NetworkImage(
                "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
          ),
          CircleAvatar(
            radius: 200,
            backgroundImage: NetworkImage(
                "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
          ),
          CircleAvatar(
            radius: 200,
            backgroundImage: NetworkImage(
                "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
          ),
          CircleAvatar(
            radius: 200,
            backgroundImage: NetworkImage(
                "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
          ),
          CircleAvatar(
            radius: 200,
            backgroundImage: NetworkImage(
                "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
          ),
          CircleAvatar(
            radius: 200,
            backgroundImage: NetworkImage(
                "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
          ),
          CircleAvatar(
            radius: 200,
            backgroundImage: NetworkImage(
                "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
          ),
          CircleAvatar(
            radius: 200,
            backgroundImage: NetworkImage(
                "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
          ),
          CircleAvatar(
            radius: 200,
            backgroundImage: NetworkImage(
                "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
          ),
        ],
      ),
  */
    );
/*
    return Container(
      width: width,
      height: height,
      child: Image.asset(
        AssetUtils.getAssetImage('launch_image'),
        fit: BoxFit.fill,
      ),
    );
    */
  }
*/
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    //屏蔽如下代码 才不会报错因为是web运行 改为安卓和iOS 打开如下代码
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double hwAspectRatio = 1 / aspectRatio;

    if (aspectRatio > 0) {
      if (hwAspectRatio > 1.87 && Platform.isAndroid) {
        ScreenUtilityCustomInit(context, 414, 896);
      } else {
        ScreenUtilityStandardInit(context);
      }
    }
    return Container(
      width: width,
      height: height,
      child: Image.asset(
        AssetUtils.getAssetImage('launch_image'),
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _initGridViewData(context, index, value) {
    int length = 0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        KTLog(index);
        setState(() {
          //长度不能超过20个
          if (length < 20) {
            // //如果选择的索引在总数组里为空(就是没有加入进来)
            if (totalItem[_selectIndex] == null) {
              KTLog(_selectIndex);
              //初始化总数组
              //就把选择的索引锁所的数组位置置为空
              totalItem[_selectIndex] = [];
            }
            //总数组里取出当前选择的索引的数据
            List<int> list = totalItem[_selectIndex]!;
            //如果数组里不包含当前的索引数据
            if (!list.contains(index)) {
              //就把索引加入当前数组
              list.add(index);
              KTLog(list);
            } else {
              //否则就移除当前数据
              list.remove(index);
              KTLog(list);
            }
          }
        });
      },
      child: totalItem[_selectIndex] != null &&
              totalItem[_selectIndex]!.contains(index)
          ? Container(
              // color: Colors.orange,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        // color: Colors.red,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundImage: NetworkImage(
                              "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: GFCheckbox(
                            size: 20,
                            activeBgColor: GFColors.DANGER,
                            type: GFCheckboxType.circle,
                            onChanged: (value) {
                              setState(() {
                                //长度不能超过20个
                                if (length < 20) {
                                  // //如果选择的索引在总数组里为空(就是没有加入进来)
                                  if (totalItem[_selectIndex] == null) {
                                    KTLog(_selectIndex);
                                    //初始化总数组
                                    //就把选择的索引锁在的数组位置置为空
                                    totalItem[_selectIndex] = [];
                                  }
                                  //总数组里取出当前选择的索引的数据
                                  List<int> list = totalItem[_selectIndex]!;
                                  //如果数组里不包含当前的索引数据
                                  if (!list.contains(index)) {
                                    //就把索引加入当前数组
                                    list.add(index);
                                    KTLog(list);
                                  } else {
                                    //否则就移除当前数据
                                    list.remove(index);
                                    KTLog(list);
                                  }
                                }
                              });
                            },
                            value: true),
                      ),
                    ],
                  )
                ],
              ),
            )
          : Container(
              // color: Colors.orange,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        // color: Colors.red,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundImage: NetworkImage(
                              "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: GFCheckbox(
                            size: 20,
                            activeBgColor: GFColors.DANGER,
                            type: GFCheckboxType.circle,
                            onChanged: (value) {
                              setState(() {
                                //长度不能超过20个
                                if (length < 20) {
                                  // //如果选择的索引在总数组里为空(就是没有加入进来)
                                  if (totalItem[_selectIndex] == null) {
                                    KTLog(_selectIndex);
                                    //初始化总数组
                                    //就把选择的索引锁在的数组位置置为空
                                    totalItem[_selectIndex] = [];
                                  }
                                  //总数组里取出当前选择的索引的数据
                                  List<int> list = totalItem[_selectIndex]!;
                                  //如果数组里不包含当前的索引数据
                                  if (!list.contains(index)) {
                                    //就把索引加入当前数组
                                    list.add(index);
                                    KTLog(list);
                                  } else {
                                    //否则就移除当前数据
                                    list.remove(index);
                                    KTLog(list);
                                  }
                                }
                              });
                            },
                            value: false),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}

class LeftData {
  String name;
  bool iSelect;
  int id;

  LeftData(this.name, this.iSelect, this.id);
}
