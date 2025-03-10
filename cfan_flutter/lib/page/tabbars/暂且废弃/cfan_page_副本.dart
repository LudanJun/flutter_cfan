import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_model.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_userPosts_list_model.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/login/listData.dart';
import 'package:cfan_flutter/page/tabbars/cfan/video_player_singleton.dart';
import 'package:cfan_flutter/provider/cfan_provider.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/tools/keepAliveWrapper.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:chewie/chewie.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CfanPage extends StatefulWidget {
  const CfanPage({super.key});

  @override
  State<CfanPage> createState() => _CfanPageState();
}

class _CfanPageState extends State<CfanPage>
    with SingleTickerProviderStateMixin {
  CfanProvider _cfanProvider = CfanProvider();
  // //ScrollController创建滚动控制器才能用来监听滚动视图滚动的状态
  // final ScrollController _scrollController = ScrollController();
  //浮动导航
  bool flag = false;

  //选择的tabBar
  int _selectTabBarIndex = 0;

  //节目视频
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  int _visibleItemIndex = -1;

  ///tab 标签数据
  final List<Map<String, dynamic>> _tabData = [
    {
      'id': 1,
      'name': '明星动态',
    },
    {
      'id': 2,
      'name': '节目',
    },
    {
      'id': 3,
      'name': '投票',
    },
    {
      'id': 4,
      'name': '活动',
    },
  ];

  ///我的社群
  List<CfanCommunityItemModel> _cfanMycommunityItemModelList = [];

  ///明星动态
  List<CfanUserpostsItemModel> _cfanUserpostsItemModelList = [];
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < tabListData.length; i++) {
      _cfanProvider.scroList.add(ScrollController());
    }
    _cfanProvider.tabController =
        TabController(length: _tabData.length, vsync: this);
    scrollControllerListener();
    videoScrollController();

    getMyCommunityData();
  }

  ///获取我的社群
  getMyCommunityData() {
    _cfanProvider.myCommunity(
      onSuccess: (data) {
        if (data['code'] == 200) {
          var tempList = CfanCommunityModel.fromJson(data);
          setState(() {
            _cfanMycommunityItemModelList.addAll(tempList.data!);
          });
        }
      },
      onFailure: (error) {},
    );
  }

  //明星动态
  getUserPostsData() {
    _cfanProvider.userPosts(
      "1",
      "",
      onSuccess: (data) {
        if (data['code'] == 200) {
          var tempList = CfanUserpostsModel.fromJson(data);
          setState(() {
            _cfanUserpostsItemModelList.addAll(tempList.data!.list!);
          });
        }
      },
      onFailure: (error) {},
    );
  }

  @override
  void dispose() {
    super.dispose();
    _cfanProvider.tabController.dispose();
    _cfanProvider.removeListener(scrollControllerListener);
    _cfanProvider.scrollController.dispose();
    //记得销毁两个播放器
    videoPlayerController.dispose();
    chewieController.dispose();
  }

  videoScrollController() {
    _cfanProvider.scroList[1].addListener(
      () {
        KTLog(_cfanProvider.scroList[0].offset);

        // double offset = _cfanProvider.videoScrollController.offset;
        // // 假设每个item的高度为500.0
        // double itemHeight = ScreenAdapter.height(500);
        // //计算当前屏幕中间的item索引
        // int itemIndex = (offset / itemHeight).round() + 1;
        // KTLog("itemIndex-$itemIndex");
        // KTLog("_visibleItemIndex$_visibleItemIndex");

        // if (itemIndex != _visibleItemIndex) {
        //   setState(() {
        //     _visibleItemIndex = itemIndex;
        //     // 可以在这里触发动画或其他逻辑
        //   });
        // }
      },
    );
  }

  ///监听滚动视图的方法
  scrollControllerListener() {
    _cfanProvider.scrollController.addListener(() {
      // KTLog(_cfanProvider.scrollController.position.pixels);

      //如果滚动10个像素 将把导航设置为白色
      if (_cfanProvider.scrollController.position.pixels > 20) {
        if (flag == false) {
          // KTLog(_cfanProvider.scrollController.position.pixels);
          setState(() {
            flag = true;
          });
        }
      }
      if (_cfanProvider.scrollController.position.pixels < 20) {
        if (flag = true) {
          // KTLog(_cfanProvider.scrollController.position.pixels);
          setState(() {
            flag = false;
          });
        }
      }
    });
  }

  /// 轮播图
  Widget _focuse() {
    return SizedBox(
      // width: ScreenAdapter.width(1080),
      height: ScreenAdapter.height(340),
      child: Swiper(
        itemBuilder: (context, index) {
          return Image.network(
            "https://img0.baidu.com/it/u=115477036,3250579454&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800",
            fit: BoxFit.fill,
          );
        },
        itemCount: 3,
        // pagination:
        //     const SwiperPagination(builder: SwiperPagination.dots //可以不设置默认是圆点
        //         ),
        //自定义分页指示器
        pagination: SwiperPagination(
          margin: const EdgeInsets.all(0),
          builder: SwiperCustomPagination(
              builder: (BuildContext context, SwiperPluginConfig config) {
            return ConstrainedBox(
              constraints: BoxConstraints.expand(
                height: ScreenAdapter.height(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: const DotSwiperPaginationBuilder(
                        color: Colors.white,
                        activeColor: Colors.green,
                      ).build(context, config),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        autoplay: true, //自动轮播
        loop: true, //无限轮播
      ),
    );
  }

  //推荐社群
  Widget _recommend() {
    return Container(
      height: ScreenAdapter.height(300 - 48),
      color: Colors.orange,
      child: Column(
        children: [
          _sectionHead("推荐社群", "社群广场 >"),
          Container(
            color: Colors.blue,
            height: ScreenAdapter.height(235 - 48),
            padding: const EdgeInsets.all(5),
            child: ListView.builder(
                itemCount: _cfanMycommunityItemModelList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: _initGridViewData),
          ),
        ],
      ),
    );
  }

  /// 单独封装推荐社群子item
  Widget _initGridViewData(context, index) {
    return Container(
      width: ScreenAdapter.width(150),
      // height: ScreenAdapter.width(470),
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.white,
      )),
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Column(
        children: [
          Container(
            width: ScreenAdapter.width(150),
            height: ScreenAdapter.width(130),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  _cfanMycommunityItemModelList[index].avatar!,
                  // "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800",
                ),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(
                ScreenAdapter.width(10),
              ),
            ),
          ),
          SizedBox(
            height: ScreenAdapter.height(5),
          ),
          Text(
            // tableDatList[index],
            _cfanMycommunityItemModelList[index].title!,
            maxLines: 1,
            style: TextStyle(
              fontSize: ScreenAdapter.fontSize(16),
              color: Colors.black,
            ),
          ),
          // SizedBox(
          //   height: ScreenAdapter.height(8),
          // ),
          // Container(
          //   height: ScreenAdapter.height(40),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       KTLog("点击了第$index个");
          //     },
          //     child: Text("关注"),
          //   ),
          // ),
        ],
      ),
    );
  }

  //公共区头
  Widget _sectionHead(leftTitle, rightTitle) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ScreenAdapter.width(15),
        ScreenAdapter.height(20),
        ScreenAdapter.width(15),
        ScreenAdapter.height(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            leftTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ScreenAdapter.fontSize(18),
            ),
          ),
          Text(
            rightTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ScreenAdapter.fontSize(12),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeepAliveWrapper(
      child: Scaffold(
        // //该属性可以让appbar下面的控件在导航栏下面显示
        // extendBodyBehindAppBar: true, //实现透明导航
        // //PreferredSize用来设置高度
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(ScreenAdapter.height(44)),
        //   child: _appTopBar(),
        // ),
        //1.DefaultTabController 是不需要提供传入controller,如需要检测滚动来改变导航
        //则不需要DefaultTabController嵌套,需要定义一个scrollerController 来使用
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        // ),
        body: NestedScrollView(
            //如果不想加DefaultTabController 就需要写这个controller参数
            controller: _cfanProvider.scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                //1.添加轮播图 //2.添加我的社群
                _buildHeader(context, innerBoxIsScrolled),
              ];
            },
            body: Container(
              color: KTColor.getRandomColor(),
            )
            //_buildTabBarView(),
            ),
      ),
    );
  }

  //自定义顶部导航搜索框 轮播按钮
  Widget _buildHeader(BuildContext context, bool innerBoxIsScrolled) {
    // SliverOverlapAbsorber 的作用是处理重叠滚动效果，
    // 防止 CustomScrollView 中的滚动视图与其他视图重叠。
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      // SliverAppBar 的作用是创建可折叠的顶部应用程序栏，
      // 它可以随着滚动而滑动或固定在屏幕顶部，并且可以与其他 Sliver 小部件一起使用。
      sliver: SliverAppBar(
        title: InkWell(
          //自定义导航标题
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            //设置搜索栏
            width: flag ? ScreenAdapter.width(430) : ScreenAdapter.width(220),
            height: ScreenAdapter.height(40),
            decoration: BoxDecoration(
              // color: const Color.fromRGBO(246, 246, 246, 1),
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      ScreenAdapter.width(17), 0, ScreenAdapter.width(5), 0),
                  child: const Icon(
                    Icons.search,
                    color: Color.fromARGB(200, 0, 0, 0),
                  ),
                ),
                Text(
                  "搜索社群/用户/节目/投票",
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(14),
                    color: Colors.black54,
                  ),
                )
              ],
            ),
          ),
          onTap: () {
            KTLog("跳转搜索页面");
            NavigationUtil.getInstance().pushNamed(RouterName.cfanSearchPage);
          },
        ),
        // backgroundColor: KTColor.white,
        // foregroundColor: Colors.orange,
        // shadowColor: KTColor.white,
        //压制住不把导航划走
        pinned: true,
        //影深
        elevation: 0,
        //展开的高度  轮播 和 社群 控件占用高度在这设置
        expandedHeight: ScreenAdapter.height(620 - 48),
        //为true时展开有阴影
        forceElevated: innerBoxIsScrolled,
        //弹性空间 轮播 和 社群 控件在这里面设置
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            color: Colors.blue,
            child: Column(
              children: [
                //1.添加轮播图
                _focuse(),
                //2.添加社群控件
                _recommend(),
              ],
            ),
          ),
        ),
        //添加悬浮tabbar功能
        bottom: HomeCustomAppBar(
          selectTabBarIndex: _selectTabBarIndex,
          child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  buildTabBar(),
                  _selectTabBarIndex == 2 || _selectTabBarIndex == 3
                      ? Container(
                          height: ScreenAdapter.height(45),
                          color: Colors.orange,
                          child: Row(
                            children: [
                              SizedBox(
                                width: ScreenAdapter.width(10),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_selectTabBarIndex == 2) {
                                    KTLog("投票 进行中");
                                  } else {
                                    KTLog("活动 进行中");
                                  }
                                },
                                child: Text("进行中"),
                              ),
                              SizedBox(
                                width: ScreenAdapter.width(10),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_selectTabBarIndex == 2) {
                                    KTLog("投票 已结束");
                                  } else {
                                    KTLog("活动 已结束");
                                  }
                                },
                                child: Text("已结束"),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              )
              // buildTabBar(),
              ),
        ),
      ),
    );
  }

  //自定义tabBar
  buildTabBar() {
    //构造 TabBar
    Widget tabBar = TabBar(
      //tabs 的长度超出屏幕宽度后，TabBar，是否可滚动
      //设置为false tab 将平分宽度，为true tab 将会自适应宽度
      isScrollable: false,
      //设置tab文字得类型  选中的文字大小
      labelStyle: TextStyle(
          fontSize: ScreenAdapter.fontSize(16), fontWeight: FontWeight.w500),
      //设置tab选中得颜色
      labelColor: Color(0xFF035DFF),
      //设置tab未选中得颜色
      unselectedLabelColor: Colors.black,
      unselectedLabelStyle: TextStyle(
        fontSize: ScreenAdapter.fontSize(14), //未选中文字大小
      ),
      //设置自定义tab的指示器，CustomUnderlineTabIndicator
      //若不需要自定义，可直接通过
      //设置指示器颜色
      indicatorColor: Color(0xFF035DFF),
      //indicatorWight 设置指示器厚度
      indicatorPadding: EdgeInsets.only(left: 10, right: 10),
      indicatorWeight: ScreenAdapter.height(2), //指示器高度
      ///指示器大小计算方式，TabBarIndicatorSize.label跟文字等宽,TabBarIndicatorSize.tab跟每个tab等宽
      indicatorSize: TabBarIndicatorSize.label,
      //生成Tab菜单
      controller: _cfanProvider.tabController,
      onTap: (value) {
        KTLog("点击了第$value");
        setState(() {
          _selectTabBarIndex = value;
        });
      },
      //构造Tab集合
      tabs: _tabData.map((value) {
        return Tab(
          child: Text(value['name']),
        );
      }).toList(),
    );
    return tabBar;
  }

  Widget _buildTabBarViewNew() {
    return TabBarView(
      controller: _cfanProvider.tabController,
      children: _tabData.map((value) {
        return CustomScrollView(
          slivers: [
            // SliverOverlapInjector 的作用是处理重叠滚动效果，
            // 确保 CustomScrollView 中的滚动视图不会与其他视图重叠。
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
          ],
        );
      }).toList(),
    );
  }

  ///添加分页列表容器
  Widget _buildTabBarView() {
    //这个是添加每个tabbar分页的列表容器
    return TabBarView(
      controller: _cfanProvider.tabController,

      ///通过 asMap()获取的是下标
      children: tabListData.asMap().keys.map(
        (model) {
          return SafeArea(
            top: false,
            bottom: false,
            child: Builder(builder: (context) {
              return CustomScrollView(
                //使用controller该功能 嵌套滚动就会失效
                // controller: _cfanProvider.scroList[model],
                // controller: _cfanProvider.videoScrollController,
                // key: PageStorageKey<String>(model['name']),
                key: PageStorageKey<String>(tabListData[model]['name']),
                slivers: [
                  // SliverOverlapInjector 的作用是处理重叠滚动效果，
                  // 确保 CustomScrollView 中的滚动视图不会与其他视图重叠。
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  // NotificationListener<ScrollNotification>(
                  //   onNotification: (notification) {
                  //     if (notification is ScrollStartNotification) {
                  //       print("Scroll started");
                  //     } else if (notification is ScrollUpdateNotification) {
                  //       print("Scroll updated");
                  //     } else if (notification is ScrollEndNotification) {
                  //       print('Scroll ended');
                  //     }
                  //     return true;
                  //   },
                  //   child: buildListContent(model),
                  // ),
                  //传入每个列表要展示的数据内容
                  buildListContent(tabListData[model]),
                ],
              );
            }),
          );
        },
      ).toList(),
    );
  }

  //tabbar下面的内容列表
  Widget buildListContent(model) {
    // KTLog("传过来的---$model");
    return SliverPadding(
      padding: EdgeInsets.all(
        ScreenAdapter.height(8.0),
      ),

      // sliver: SliverList(
      //   delegate: SliverChildBuilderDelegate(
      //     (context, index) {
      //       //在这里判断每个cell的不同添加
      //       return buildStarTitle(model['items'][index], index);
      //     },
      //     childCount: model['items'].length,
      //   ),
      // ),

      sliver: SliverList.builder(
        itemCount: model['items'].length,
        itemBuilder: (context, index) {
          //在这里判断每个cell的不同添加
          return buildStarTitle(model['items'][index], index);
        },
      ),

      //固定cell高度的写法
      //     SliverFixedExtentList(
      //   itemExtent: 200.0,
      //   delegate: SliverChildBuilderDelegate(
      //     childCount: model['items'].length,
      //     (context, index) {
      //       // return ListTile(
      //       //     title: Text('${model['items'][index]['title']} --- $index'));
      //       return buildStarTitle(model['items'][index]);
      //     },
      //   ),
      // ),
    );
  }

  //cell内容
  Widget buildStarTitle(itemModel, index) {
    //是否已经点赞
    bool isAleadyLike = Provider.of<CfanProvider>(context)
        .zanList
        .any((element) => element == itemModel);

    /// 明星动态
    if (_selectTabBarIndex == 0) {
      return InkWell(
        onTap: () {
          KTLog("点击了第$index个");
          NavigationUtil.getInstance().pushNamed(RouterName.cfanPostDetailPage);
        },
        child: Container(
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
                    child: Container(
                      alignment: Alignment.centerRight,
                      // color: Colors.green,
                      child: Icon(Icons.more_vert_outlined),
                    ),
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
                      itemModel['content'],
                      expandText: "全文",
                      collapseText: "收起",
                      maxLines: 5,
                      linkColor: Colors.blue,
                    ),

                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.all(ScreenAdapter.width(8)),
                      child: _addNinePic(itemModel['images']),
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
                    _bottomToolsbar(itemModel, index, isAleadyLike),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    //节目 视频 cell
    else if (_selectTabBarIndex == 1) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ScreenAdapter.width(10),
          ),
          border: Border.all(
            width: ScreenAdapter.height(1),
            color: Color.fromRGBO(238, 238, 238, 1),
          ),
        ),
        child: Column(
          children: [
            //1.图标 名字 日期 50
            Container(
              height: ScreenAdapter.height(40),
              padding: EdgeInsets.all(ScreenAdapter.width(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.safety_check_outlined),
                      SizedBox(
                        width: ScreenAdapter.width(10),
                      ),
                      Text("周杰伦"),
                    ],
                  ),
                  Text("2024.6.6"),
                ],
              ),
            ),
            //2.视频 350
            Container(
              color: Colors.black,
              height: ScreenAdapter.height(350),
              child: const SingletonVideoPlayer(
                videoUrl:
                    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
              ),
            ),

            //3.标题 55
            Container(
              padding: EdgeInsets.all(ScreenAdapter.height(5)),
              height: ScreenAdapter.height(50),
              child: const Text(
                "标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题",
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            //4.评论&点赞 45
            _bottomToolsbar(itemModel, index, isAleadyLike),
          ],
        ),
      );
    }
    // 投票 cell
    else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ScreenAdapter.width(10),
          ),
          border: Border.all(
            width: ScreenAdapter.height(1),
            color: Color.fromRGBO(238, 238, 238, 1),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: ScreenAdapter.height(5),
              ),

              ///矩形圆角
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  ScreenAdapter.width(5),
                ),
                child: CachedNetworkImage(
                  // width: 100,
                  // height: 100,
                  fit: BoxFit.cover,
                  imageUrl: imageUrl3,
                  // placeholder: (context, url) => defaultImage(),
                  // errorWidget: (context, url, error) => defaultImage(),
                ),
              ),
            ),
            Text(
              "投票/活动标题投票/活动标题投票/活动标题投票/活动标题投票/活动标题投票/活动标题投票/活动标题",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.safety_check_outlined),
                    SizedBox(
                      width: ScreenAdapter.width(10),
                    ),
                    Text("周杰伦"),
                    Icon(Icons.safety_check_outlined),
                    SizedBox(
                      width: ScreenAdapter.width(10),
                    ),
                    Text("周杰伦"),
                  ],
                ),
                Text("2024.6.6"),
              ],
            ),
          ],
        ),
      );
    }
  }
  /*
  Widget _videoWidget() {
    //1.在这里初始化
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'));

    //2.配置chewie
    //要想改这个播放器进度条的颜色需要改主题色
    //   theme: ThemeData(
    //   primarySwatch: Colors.blue,
    // ),
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      //配置视频宽高比
      aspectRatio: 3 / 2,
      //自动播放
      autoPlay: false,
      //循环播放
      looping: true,
      optionsBuilder: (context, defaultOptions) async {
        await showModalBottomSheet(
            context: context,
            builder: (context) {
              return ListView(
                //这播放进度汉化针对安卓有效 iOS只显示速度选项
                children: [
                  ListTile(
                    title: Text("播放速度"),
                    onTap: () {
                      defaultOptions[0].onTap!();
                    },
                  ),
                  ListTile(
                    title: const Text("取消"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      },
    );
    return Chewie(controller: chewieController);
  }*/

  //评论 点赞  tools
  Widget _bottomToolsbar(itemModel, int index, bool isAleadyLike) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(
              bottom: ScreenAdapter.height(5),
            ),
            height: ScreenAdapter.height(40),
            alignment: Alignment.center,
            // color: Colors.white,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                    width: ScreenAdapter.height(1), color: Colors.grey),
                bottom: BorderSide(
                    width: ScreenAdapter.height(1), color: Colors.grey),
              ),
            ),
            child: TextButton.icon(
              onPressed: () {
                KTLog("评论 --- $index");
              },
              icon: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.black,
              ),
              label: const Text(
                "888",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(
              bottom: ScreenAdapter.height(5),
            ),
            height: ScreenAdapter.height(40),
            alignment: Alignment.center,
            // color: Colors.white,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: ScreenAdapter.height(1), color: Colors.grey),
              ),
            ),
            child: TextButton.icon(
              onPressed: () {
                if (isAleadyLike) {
                  KTLog(isAleadyLike);
                  //从点赞数组移除
                  Provider.of<CfanProvider>(context, listen: false)
                      .remove(itemModel);
                } else {
                  //fase 所以要加入数组
                  KTLog(isAleadyLike);

                  //添加点赞数组
                  Provider.of<CfanProvider>(context, listen: false)
                      .addLike(itemModel);
                }
              },
              icon: isAleadyLike
                  ? const Icon(
                      //已经点赞
                      Icons.thumb_up_off_alt_rounded,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.thumb_up_off_alt_outlined,
                      color: Colors.black,
                    ),
              label: const Text(
                "888",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //添加九图控件
  Widget _addNinePic(List images) {
    List imagsUrl = [];
    for (var i = 0; i < images.length; i++) {
      imagsUrl.add(
        images[i]["url"],
      );
    }

    // KTLog("图片地址数组---$imagsUrl");

    List<StaggeredGridTile> titles = [];
    for (var i = 0; i < images.length; i++) {
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
}

class HomeCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final int selectTabBarIndex;
  const HomeCustomAppBar(
      {super.key, required this.child, required this.selectTabBarIndex});

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight +
            (selectTabBarIndex == 2 || selectTabBarIndex == 3
                ? ScreenAdapter.height(45)
                : 0),
      );
}
