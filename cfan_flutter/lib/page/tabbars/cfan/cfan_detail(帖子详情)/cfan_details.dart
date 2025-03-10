import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_detail(%E5%B8%96%E5%AD%90%E8%AF%A6%E6%83%85)/cfan_detail_bottom_view.dart';
import 'package:cfan_flutter/provider/cfan_details_provider.dart';
import 'package:cfan_flutter/tools/keepAliveWrapper.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

//暂且废弃
class CfanDetailsPage extends StatefulWidget {
  const CfanDetailsPage({super.key});

  @override
  State<CfanDetailsPage> createState() => _CfanDetailsPageState();
}

class _CfanDetailsPageState extends State<CfanDetailsPage> {
  CfanDetailsProvider _cfanDetailsProvider = CfanDetailsProvider();

  final ScrollController scrollController = ScrollController();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _cfanDetailsProvider.scrollControllerListener();
    scrollControllerListener();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _cfanDetailsProvider.scrollController.dispose();
    // _cfanDetailsProvider.scrollController
    //     .removeListener(_cfanDetailsProvider.scrollControllerListener);
    scrollController.dispose();
    scrollController.removeListener(scrollControllerListener);
  }

  //改变商品内容tab索引值
  void changeSelectedSubTabsindex(index) {
    selectedSubTabsIndex = index;
    //点击商品介绍 或者规格参数 要重新跳到起始位置,
    //使用scrollController.jumpTo();方法
    // scrollController.jumpTo(gk2Position);
    setState(() {});
  }

  //监听滚动视图的方法
  scrollControllerListener() {
    scrollController.addListener(() {
      KTLog(scrollController.position.pixels);

      if (gk2Position == 0) {
        //获取Container高度的时候获取的是距离顶部的高度,如果要从0开始计算要加下滚动条下拉的高度
        getContainerPosition(scrollController.position.pixels);
      }

      //显示隐藏详情tab切换
      if (scrollController.position.pixels > gk2Position) {
        if (showSubHeaderTabs == false) {
          showSubHeaderTabs = true;
          setState(() {});
        }
      } else if (scrollController.position.pixels > 0 &&
          scrollController.position.pixels < gk2Position) {
        if (showSubHeaderTabs == true) {
          showSubHeaderTabs = false;
          setState(() {});
        }
      } else if (scrollController.position.pixels > gk2Position) {
        if (showSubHeaderTabs == true) {
          showSubHeaderTabs = false;
          setState(() {});
        }
      }
    });
  }

  //获取元素位置 注意是在渲染后获取的
  getContainerPosition(pixels) {
    //通过box获取高度
    RenderBox box2 = gk2.currentContext!.findRenderObject() as RenderBox;

    // KTLog(box2);
    //获取纵轴位置
    //获取的位置是屏幕顶部(0,0位置)所以需要减掉-状态栏高度和appbar高度
    gk2Position = box2.localToGlobal(Offset.zero).dy +
        pixels -
        (ScreenAdapter.getStatusBarHeight()); //当做固定写法

    //通过box获取高度
    // RenderBox box3 = gk3.currentContext!.findRenderObject() as RenderBox;
    //获取纵轴位置
    //获取的位置是屏幕顶部(0,0位置)所以需要减掉-状态栏高度和appbar高度
    // gk3Position = box3.localToGlobal(Offset.zero).dy +
    //     pixels -
    //     (ScreenAdapter.getStatusBarHeight() +
    //         ScreenAdapter.height(120)); //当做固定写法
    KTLog("啊啊啊啊 - $gk2Position");
    // print(gk3Position);
  }

  @override
  Widget build(BuildContext context) {
    return KeepAliveWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text("帖子正文"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                KTLog("右上角三个点");
                showMenu(
                  color: Colors.black87.withOpacity(0.7),
                  context: context,
                  position: RelativeRect.fromLTRB(
                      ScreenAdapter.width(400),
                      ScreenAdapter.height(100),
                      ScreenAdapter.width(20),
                      0), //弹出菜单显示的位置
                  items: [
                    PopupMenuItem(
                      padding:
                          EdgeInsets.fromLTRB(ScreenAdapter.width(35), 0, 0, 0),
                      onTap: () {
                        KTLog("删除");
                      },
                      child: const Row(
                        children: [
                          // Icon(Icons.home, color: Colors.white,),
                          Text(
                            "删除",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      padding:
                          EdgeInsets.fromLTRB(ScreenAdapter.width(35), 0, 0, 0),
                      onTap: () {
                        KTLog("举报");
                      },
                      child: const Row(
                        children: [
                          // Icon(
                          //   Icons.message,
                          //   color: Colors.white,
                          // ),
                          Text(
                            "举报",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
              icon: Icon(Icons.more_vert_outlined),
            ),
          ],
        ),
        body: Stack(
          children: [
            _body(),
            // _cfanDetailsProvider.showSubHeaderTabs
            showSubHeaderTabs
                ? Positioned(
                    bottom: ScreenAdapter.height(150),
                    child: _subHeader(), //需要使用定位进行配置使用
                  )
                : Text(""),
          ],
        ),
      ),
    );
  }

  /// 抽离body
  Widget _body() {
    return SingleChildScrollView(
      //绑定scrollController 不然监听不到滚动
      controller: scrollController,
      /*
      BouncingScrollPhysics ：允许滚动超出边界，但之后内容会反弹回来。iOS下弹性效果
      ClampingScrollPhysics ： 防止滚动超出边界，夹住 。
      AlwaysScrollableScrollPhysics ：始终响应用户的滚动。
      NeverScrollableScrollPhysics ：不响应用户的滚动。 
      */
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          //1.添加头部详情内容
          _buildHeadView(),
          //2.添加底部tabbar内容
          CfanDetailBottomView(
            key: gk2,
            subHeader: _subHeader,
          ),
        ],
      ),
    );
  }

  //添加
  Widget _buildHeadView() {
    return Container(
      color: KTColor.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  // color: KTColor.getRandomColor(),
                  // height: ScreenAdapter.width(35),
                  child: CircleAvatar(
                    radius: ScreenAdapter.width(35),
                    backgroundImage: const NetworkImage(
                        "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  // color: Colors.blue,
                  // height: ScreenAdapter.width(35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "明星成员艺名",
                        style: TextStyle(
                            fontSize: ScreenAdapter.fontSize(14),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: ScreenAdapter.height(10),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "2小时前",
                            style: TextStyle(
                                fontSize: ScreenAdapter.fontSize(12),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: ScreenAdapter.width(15),
                          ),
                          Text(
                            "马来西亚",
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
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(
              ScreenAdapter.width(5),
            ),
            child: Column(
              children: [
                //1.单文章
                ExpandableText(
                  "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容",
                  expandText: "全文",
                  collapseText: "收起",
                  maxLines: 5,
                  linkColor: Colors.blue,
                ),

                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.all(ScreenAdapter.width(8)),
                  child: _addNinePic(),
                ),

                //4.视频

                //社群来源
                Row(
                  children: [
                    const Icon(Icons.safety_check_outlined),
                    Text(
                      "周杰伦社群",
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(14),
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      ScreenAdapter.width(15),
                      ScreenAdapter.width(5),
                      ScreenAdapter.width(15),
                      ScreenAdapter.width(0)),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Color.fromRGBO(238, 238, 238, 1),
                      ),
                    ),
                  ),
                )
                // _bottomToolsbar(itemModel, index, isAleadyLike),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //添加九图控件
  // Widget _addNinePic(List images) {
  Widget _addNinePic() {
    List imagsUrl = [
      'https://www.itying.com/images/flutter/1.png',
      'https://www.itying.com/images/flutter/2.png',
      'https://www.itying.com/images/flutter/3.png'
    ];
    // for (var i = 0; i < images.length; i++) {
    // imagsUrl.add(
    //   images[i]["url"],
    // );
    // }

    // KTLog("图片地址数组---$imagsUrl");

    List<StaggeredGridTile> titles = [];
    for (var i = 0; i < imagsUrl.length; i++) {
      final title = _picesTitle(imagsUrl, i);
      titles.add(title);
    }
    if (titles.isEmpty) {
      return Container();
    }
    int corseCount = titles.length >= 2 ? 3 : titles.length;
    corseCount = titles.length < 2 ? 2 : corseCount;
    return StaggeredGrid.count(
      crossAxisCount: corseCount,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: titles,
    );
  }

  //点击图片放大查看
  StaggeredGridTile _picesTitle(List images, int index) {
    //相片
    final img = CachedNetworkImage(
      imageUrl: images[index],
      fit: BoxFit.cover,
      width: double.maxFinite,
      height: double.maxFinite,
    );
    //相框装上相片
    final frame = InkWell(
      onTap: () => _callPhotosGallery(images, index),
      child: img,
    );
    return StaggeredGridTile.count(
      crossAxisCellCount: 1,
      mainAxisCellCount: 1,
      child: frame,
    );
  }

  //调用照片库
  void _callPhotosGallery(List images, int index) {
    List<NetworkImage> cacImages = [];
    for (var img in images) {
      cacImages.add(
        NetworkImage(img),
      );
    }
    //初始化添加图片放大工具
    MultiImageProvider multiImageProvider =
        MultiImageProvider(cacImages, initialIndex: index);
    showImageViewerPager(
      context,
      multiImageProvider, //传入图片数据
      swipeDismissible: true, //向下滑动关闭
      doubleTapZoomable: true, //双击缩放
      onPageChanged: (page) {
        print("page changed to $page");
      },
      onViewerDismissed: (page) {
        print("dismissed while on page $page");
      },
      // infinitelyScrollable: true, //连续滚动浏览
    );
  }

  Widget _subHeader() {
    return Container(
      color: Colors.blue,
      //在外层包裹一个容器可以控制它的padding和背景颜色还有尺寸大小
      height: ScreenAdapter.height(40),
      child: Row(
        children: subTabsList.map((value) {
          return Expanded(
              //需要再Container外层加 如果在Expanded外面加会破坏布局
              child: InkWell(
            onTap: () {
              // 实时刷新选中功能
              setState(() {
                changeSelectedSubTabsindex(value["id"]);
                KTLog(selectedSubTabsIndex);
              });
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "${value["title"]}",
                style: TextStyle(
                    color: selectedSubTabsIndex == value["id"]
                        ? Colors.red
                        : Colors.black87),
              ),
            ),
          ));
        }).toList(),
      ),
    );
  }
}
