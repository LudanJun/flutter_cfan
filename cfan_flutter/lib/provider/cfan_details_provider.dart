import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:flutter/cupertino.dart';

class CfanDetailsProvider extends ChangeNotifier {
  // ScrollController创建滚动控制器才能用来监听滚动视图滚动的状态
  final ScrollController scrollController = ScrollController();

  /*
  GlobalKey gk2 = GlobalKey();

  //container的位置
  double gk2Position = 0;

  //详情tab切换选择的标签
  int selectedSubTabsIndex = 1;
  //是否显示详情tab切换
  bool showSubHeaderTabs = false;
  //详情tab切换数据
  List subTabsList = [
    {
      "id": 1,
      "title": "评论",
    },
    {
      "id": 2,
      "title": "点赞",
    },
  ];
  */
/*
  //改变商品内容tab索引值
  void changeSelectedSubTabsindex(index) {
    selectedSubTabsIndex = index;
    //点击商品介绍 或者规格参数 要重新跳到起始位置,
    //使用scrollController.jumpTo();方法
    // scrollController.jumpTo(gk2Position);
    notifyListeners();
  }

  //监听滚动视图的方法
  scrollControllerListener() {
    scrollController.addListener(() {
      if (gk2Position == 0) {
        //获取Container高度的时候获取的是距离顶部的高度,如果要从0开始计算要加下滚动条下拉的高度
        getContainerPosition(scrollController.position.pixels);
      }
      KTLog("111");
      KTLog(scrollController.position.pixels);
      KTLog(gk2Position);
      // 显示隐藏详情tab切换

      if (scrollController.position.pixels > gk2Position) {
        // KTLog("111");
        // KTLog(scrollController.position.pixels);
        // KTLog(gk2Position);
        if (showSubHeaderTabs == false) {
          showSubHeaderTabs = true;
          notifyListeners();
        }
      } else if (scrollController.position.pixels > 0 &&
          scrollController.position.pixels < gk2Position) {
        // KTLog("222");
        // KTLog(scrollController.position.pixels);
        // KTLog(gk2Position);
        if (showSubHeaderTabs == true) {
          showSubHeaderTabs = false;
          notifyListeners();
        }
      } else if (scrollController.position.pixels < gk2Position) {
        // KTLog("333");
        // KTLog(scrollController.position.pixels);
        // KTLog(gk2Position);
        if (showSubHeaderTabs == true) {
          showSubHeaderTabs = false;
          notifyListeners();
        }
      }

      // notifyListeners();
    });
  }

  //获取元素位置 注意是在渲染后获取的
  getContainerPosition(pixels) {
    //通过box获取高度
    RenderBox box2 = gk2.currentContext!.findRenderObject() as RenderBox;

    //获取纵轴位置
    //获取的位置是屏幕顶部(0,0位置)所以需要减掉-状态栏高度和appbar高度
    KTLog("评论高度:${box2.localToGlobal(Offset.zero).dy}");
    KTLog("滚动高度:$pixels");
    gk2Position = box2.localToGlobal(Offset.zero).dy +
        pixels -
        (ScreenAdapter.height(120)); //当做固定写法

    //通过box获取高度
    // RenderBox box3 = gk3.currentContext!.findRenderObject() as RenderBox;
    //获取纵轴位置
    //获取的位置是屏幕顶部(0,0位置)所以需要减掉-状态栏高度和appbar高度
    // gk3Position = box3.localToGlobal(Offset.zero).dy +
    //     pixels -
    //     (ScreenAdapter.getStatusBarHeight() +
    //         ScreenAdapter.height(120)); //当做固定写法
    KTLog("啊啊啊啊 -  $gk2Position");
    // print(gk3Position);
    // notifyListeners();
  }
  */
}
