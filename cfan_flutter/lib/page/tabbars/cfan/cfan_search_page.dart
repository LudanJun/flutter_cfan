import 'dart:convert';

import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_guangchang.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_model.dart';
import 'package:cfan_flutter/provider/cfan_provider.dart';
import 'package:cfan_flutter/provider/login_provider.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/page/login/listData.dart';
import 'package:cfan_flutter/provider/cfan_search_provider.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/widget/toast_utils/toast_util.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CfanSearchPage extends StatefulWidget {
  const CfanSearchPage({super.key});

  @override
  State<CfanSearchPage> createState() => _CfanSearchPageState();
}

class _CfanSearchPageState extends State<CfanSearchPage>
    with SingleTickerProviderStateMixin {
  CfanSearchProvider _cfanSearchProvider = CfanSearchProvider();
  LoginProvider _loginProvider = LoginProvider();

  CfanProvider _cfanProvider = CfanProvider();

  late TabController _tabController;
  //刷新控制器
  EasyRefreshController _easyController = EasyRefreshController();
  late FocusNode myFocusNode;
  //搜索文本框
  final TextEditingController _editController = TextEditingController();

  ///tab 标签数据
  final List<Map<String, dynamic>> _subTabList = [
    {
      'id': 1,
      'name': '全部',
    },
    {
      'id': 2,
      'name': '男明星',
    },
    {
      'id': 3,
      'name': '女明星',
    },
    {
      'id': 4,
      'name': '艺人组合',
    },
    {
      'id': 5,
      'name': '节目官方',
    },
  ];

  ///社群列表item
  List<CfanCommunityGuangchangItemModel> _cfancommunitygcItemModelList = [];

  //tab切换选择的标签
  int _selectTabbarIndex = 0;

  int _Page = 1;

  //全部分页quanbu 简称qb
  bool _qbflag = true; //解决重复请求的问题
  bool _qbHasData = true; //是否有数据

  //男明星分页男明星 简称man
  // int _manPage = 1;
  bool _manflag = true; //解决重复请求的问题
  bool _manHasData = true; //是否有数据

  //女明星分页女明星 简称wm
  // int _wmPage = 1;
  bool _wmflag = true; //解决重复请求的问题
  bool _wmHasData = true; //是否有数据

  //艺人组合分页艺人组合 简称yr
  // int _yrPage = 1;
  bool _yrflag = true; //解决重复请求的问题
  bool _yrHasData = true; //是否有数据

  //节目官方分页节目官方 简称jm
  // int _jmPage = 1;
  bool _jmflag = true; //解决重复请求的问题
  bool _jmHasData = true; //是否有数据

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _subTabList.length, vsync: this);
    listenerTabController();
    //初始化焦点
    myFocusNode = FocusNode();
    getCommunityGuangchangData(0, "", "1", true, true);
  }

  //监听tabcontroller滚动改变的索引值
  listenerTabController() {
    //监听tab滑动改变事件
    _tabController.addListener(() {
      //会获取两次值,是因为点击后离开调用一次,进入有调用一次
      // print(_tabController.index);
      //要精确获取索引值需要进行判断
      if (_tabController.animation!.value == _tabController.index) {
        KTLog(_tabController.index);
        _cfancommunitygcItemModelList = [];
        _Page = 1;
        _selectTabbarIndex = _tabController.index;

        KTLog("点击了第${_tabController.index}");
        setState(() {
          if (_tabController.index == 0) {
            _qbHasData = true;
            //获取社群广场全部
            getCommunityGuangchangData(
              _selectTabbarIndex,
              _editController.text,
              _Page.toString(),
              true,
              true,
            );
          } else if (_tabController.index == 1) {
            _manHasData = true;
            //获取社群广场男明星
            getCommunityGuangchangData(
              _selectTabbarIndex,
              _editController.text,
              _Page.toString(),
              true,
              true,
            );
          } else if (_tabController.index == 2) {
            _wmHasData = true;
            //获取社群广场女明星
            getCommunityGuangchangData(
              _selectTabbarIndex,
              _editController.text,
              _Page.toString(),
              true,
              true,
            );
          } else if (_tabController.index == 3) {
            _yrHasData = true;
            //获取社群广场艺人组合
            getCommunityGuangchangData(
              _selectTabbarIndex,
              _editController.text,
              _Page.toString(),
              true,
              true,
            );
          } else if (_tabController.index == 4) {
            _jmHasData = true;
            //获取社群广场节目官方
            getCommunityGuangchangData(
              _selectTabbarIndex,
              _editController.text,
              _Page.toString(),
              true,
              true,
            );
          }
        });
      }
    });
  }

  ///获取社群广场信息
  getCommunityGuangchangData(
    int categorId,
    String searchTitle,
    String page,
    bool flag,
    bool hasData,
  ) {
    KTLog('执行了$flag--$hasData');

    if (flag && hasData) {
      flag = false;
      _cfanProvider.communityGuangchang(
        categorId,
        searchTitle,
        page,
        onSuccess: (data) {
          if (data['code'] == 200) {
            var tempList = CfanCommunityGuangchangModel.fromJson(data);
            setState(() {
              _cfancommunitygcItemModelList.addAll(tempList.data?.list ?? []);
              _Page++;
              flag = true;
            });
            //判断有没有数据
            if (tempList.data!.list!.length < 9) {
              setState(() {
                hasData = false;
              });
            }
          }
        },
        onFailure: (error) {},
      );
    }
  }

  //构建搜索框
  buidSearch() {
    Widget SearchWidget = Container(
      margin: EdgeInsets.all(5),
      width: ScreenAdapter.width(430),
      height: ScreenAdapter.height(45),
      decoration: BoxDecoration(
        color: Color.fromRGBO(238, 238, 238, 1),
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
          Expanded(
            child: TextField(
              controller: _editController,
              textAlign: TextAlign.start,
              decoration: const InputDecoration(
                hintText: "搜索社群名称", //提示信息
                border: InputBorder.none, //去掉下划线
              ),
              //最多一行
              maxLines: 1,
              //修改键盘为发送按钮
              textInputAction: TextInputAction.send,
              onTap: () {
                KTLog("点击了文本框");
                myFocusNode.requestFocus();
              },
              //输入框内容改变
              onChanged: (value) {
                KTLog(value);
                setState(() {
                  // cellData = cell5Data;
                });
              },
              //当用户提交可编辑内容时调用（例如，用户按下“完成” 键盘上的按钮）。
              onEditingComplete: () {
                _cfancommunitygcItemModelList = [];
                _Page = 1;
                _qbHasData = true;
                getCommunityGuangchangData(
                  _selectTabbarIndex,
                  _editController.text,
                  _Page.toString(),
                  true,
                  true,
                ); //收起键盘
                FocusScope.of(context).requestFocus(FocusNode());
                // _editController.clear();
              },
            ),
          ),
        ],
      ),
    );
    return SearchWidget;
  }

  //构建tabbar
  buildTabBar() {
    //构造 TabBar
    Widget tabBar = TabBar(
      //tabs 的长度超出屏幕宽度后，TabBar，是否可滚动
      //设置为false tab 将平分宽度，为true tab 将会自适应宽度
      isScrollable: false,
      //设置tab文字得类型  选中的文字大小
      labelStyle: TextStyle(
          fontSize: ScreenAdapter.fontSize(13), fontWeight: FontWeight.w500),
      //设置tab选中得颜色
      labelColor: const Color(0xFF035DFF),
      //设置tab未选中得颜色
      unselectedLabelColor: Colors.black,
      unselectedLabelStyle: TextStyle(
        fontSize: ScreenAdapter.fontSize(11), //未选中文字大小
      ),
      //设置自定义tab的指示器，CustomUnderlineTabIndicator
      //若不需要自定义，可直接通过
      //设置指示器颜色
      indicatorColor: const Color(0xFF035DFF),
      //indicatorWight 设置指示器厚度
      indicatorPadding: const EdgeInsets.only(left: 10, right: 10),
      indicatorWeight: ScreenAdapter.height(2), //指示器高度
      ///指示器大小计算方式，TabBarIndicatorSize.label跟文字等宽,TabBarIndicatorSize.tab跟每个tab等宽
      indicatorSize: TabBarIndicatorSize.tab,
      //生成Tab菜单
      controller: _tabController,
      onTap: (value) {
        _selectTabbarIndex = value;
        _cfancommunitygcItemModelList = [];
        _Page = 1;

        KTLog("点击了第$value");
        setState(() {
          if (_tabController.index == 0) {
            _qbHasData = true;
            //获取社群广场全部
            getCommunityGuangchangData(
              _selectTabbarIndex,
              _editController.text,
              _Page.toString(),
              true,
              _qbHasData,
            );
          } else if (_tabController.index == 1) {
            _manHasData = true;
            //获取社群广场男明星
            getCommunityGuangchangData(
              _selectTabbarIndex,
              _editController.text,
              _Page.toString(),
              true,
              _manHasData,
            );
          } else if (_tabController.index == 2) {
            _wmHasData = true;
            //获取社群广场女明星
            getCommunityGuangchangData(
              _selectTabbarIndex,
              _editController.text,
              _Page.toString(),
              true,
              _wmHasData,
            );
          } else if (_tabController.index == 3) {
            _yrHasData = true;
            //获取社群广场艺人组合
            getCommunityGuangchangData(
              _selectTabbarIndex,
              _editController.text,
              _Page.toString(),
              true,
              _yrHasData,
            );
          } else if (_tabController.index == 4) {
            _jmHasData = true;
            //获取社群广场节目官方
            getCommunityGuangchangData(
              _selectTabbarIndex,
              _editController.text,
              _Page.toString(),
              true,
              _jmHasData,
            );
          }
        });
      },
      //构造Tab集合
      tabs: _subTabList.map((value) {
        return Tab(
          child: Text(value['name']),
        );
      }).toList(),
    );
    return tabBar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //创建互不影响的滚动图
      body: EasyRefresh.builder(
          header: const ClassicHeader(
            clamping: true,
            position: IndicatorPosition.locator,
            mainAxisAlignment: MainAxisAlignment.end,
            dragText: '下拉刷新...', //'Pull to refresh',
            armedText: '释放立即刷新', //'Release ready',
            readyText: '正在刷新...', //'Refreshing...',
            processingText: '正在刷新...', //'Refreshing...',
            processedText: '刷新完成', //'Succeeded',
            noMoreText: 'No more',
            failedText: 'Failed',
            messageText: 'Last updated at %T',
          ),
          footer: const ClassicFooter(
            position: IndicatorPosition.locator,
            dragText: '上拉加载', //'Pull to load',
            armedText: '释放立即刷新', //'Release ready',
            readyText: '正在加载...', //'Loading...',
            processingText: '正在加载...', //'Loading...',
            processedText: '加载完成', //'Succeeded',
            noMoreText: 'No more',
            failedText: 'Failed',
            messageText: 'Last updated at %T',
          ),
          onRefresh: () async {
            KTLog("下拉刷新");
            _Page = 1;
            _cfancommunitygcItemModelList = [];
            await Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                if (_tabController.index == 0) {
                  _cfancommunitygcItemModelList = [];
                  _qbHasData = true;
                  //获取社群广场全部
                  getCommunityGuangchangData(
                    _selectTabbarIndex,
                    _editController.text,
                    _Page.toString(),
                    true,
                    _qbHasData,
                  );
                } else if (_tabController.index == 1) {
                  _manHasData = true;
                  //获取社群广场男明星
                  getCommunityGuangchangData(
                    _selectTabbarIndex,
                    _editController.text,
                    _Page.toString(),
                    true,
                    _manHasData,
                  );
                } else if (_tabController.index == 2) {
                  _wmHasData = true;
                  //获取社群广场女明星
                  getCommunityGuangchangData(
                    _selectTabbarIndex,
                    _editController.text,
                    _Page.toString(),
                    true,
                    _wmHasData,
                  );
                } else if (_tabController.index == 3) {
                  _yrHasData = true;
                  //获取社群广场艺人组合
                  getCommunityGuangchangData(
                    _selectTabbarIndex,
                    _editController.text,
                    _Page.toString(),
                    true,
                    _yrHasData,
                  );
                } else if (_tabController.index == 4) {
                  _jmHasData = true;
                  //获取社群广场节目官方
                  getCommunityGuangchangData(
                    _selectTabbarIndex,
                    _editController.text,
                    _Page.toString(),
                    true,
                    _jmHasData,
                  );
                }
              }
            });
          },
          onLoad: () async {
            KTLog("上拉加载");
            await Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                if (_tabController.index == 0) {
                  //获取社群广场全部
                  getCommunityGuangchangData(
                    _selectTabbarIndex,
                    _editController.text,
                    _Page.toString(),
                    true,
                    _qbHasData,
                  );
                } else if (_tabController.index == 1) {
                  //获取社群广场男明星
                  getCommunityGuangchangData(
                    _selectTabbarIndex,
                    _editController.text,
                    _Page.toString(),
                    true,
                    _manHasData,
                  );
                } else if (_tabController.index == 2) {
                  //获取社群广场女明星
                  getCommunityGuangchangData(
                    _selectTabbarIndex,
                    _editController.text,
                    _Page.toString(),
                    true,
                    _wmHasData,
                  );
                } else if (_tabController.index == 3) {
                  //获取社群广场艺人组合
                  getCommunityGuangchangData(
                    _selectTabbarIndex,
                    _editController.text,
                    _Page.toString(),
                    true,
                    _yrHasData,
                  );
                } else if (_tabController.index == 4) {
                  //获取社群广场节目官方
                  getCommunityGuangchangData(
                    _selectTabbarIndex,
                    _editController.text,
                    _Page.toString(),
                    true,
                    _jmHasData,
                  );
                }
              }
            });
          },
          // controller: _easyController,
          childBuilder: (context, physics) {
            return ExtendedNestedScrollView(
              controller: _cfanSearchProvider.scrollController,
              physics: const ClampingScrollPhysics(),

              //固定头部的高度
              pinnedHeaderSliverHeightBuilder: () {
                return MediaQuery.of(context).padding.top + kToolbarHeight;
              },
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  const HeaderLocator.sliver(clearExtent: false),
                  SliverAppBar(
                    //展开的高度  轮播 和 社群 控件占用高度在这设置
                    expandedHeight: ScreenAdapter.height(0),
                    //压制住不让tab划走
                    pinned: true,

                    ///添加自定义导航
                    title: Container(
                      child: Text('社群广场'),
                    ),
                    backgroundColor: Colors.red,
                    elevation: 0, //去掉阴影
                    flexibleSpace: FlexibleSpaceBar(
                      //更改滚动视图往上推折叠方式引脚
                      collapseMode: CollapseMode.pin,
                      background: Container(
                        color: Colors.white,
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //这里面不需要添加控件
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: Column(
                children: [
                  // //添加一个导航
                  Container(
                    child: buidSearch(),
                  ),
                  Container(
                    child: buildTabBar(),
                  ),

                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        //全部
                        ExtendedVisibilityDetector(
                          uniqueKey: const Key('Tab0'),
                          child: _AutomaticKeepAlive(
                            child: CustomScrollView(
                              physics: physics,
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.all(
                                    ScreenAdapter.height(10),
                                  ),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        // var itemModel =
                                        //     _cfancommunitygcItemModelList[
                                        //             index]
                                        var itemModel =
                                            CfanCommunityGuangchangItemModel();
                                        if (_cfancommunitygcItemModelList
                                            .isEmpty) {
                                          itemModel =
                                              CfanCommunityGuangchangItemModel();
                                        } else {
                                          itemModel =
                                              _cfancommunitygcItemModelList[
                                                  index];
                                        }

                                        return buildCell(
                                          context,
                                          itemModel,
                                          index,
                                        );
                                      },
                                      childCount:
                                          _cfancommunitygcItemModelList.length,
                                      // _cfanUserpostsItemModelList.length,
                                    ),
                                  ),
                                ),
                                const FooterLocator.sliver(),
                              ],
                            ),
                          ),
                        ),
                        //男明星
                        ExtendedVisibilityDetector(
                          uniqueKey: const Key('Tab1'),
                          child: _AutomaticKeepAlive(
                            child: CustomScrollView(
                              physics: physics,
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.all(
                                    ScreenAdapter.height(10),
                                  ),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        // var itemModel =
                                        //     _cfancommunitygcItemModelList[
                                        //         index];
                                        var itemModel =
                                            CfanCommunityGuangchangItemModel();
                                        if (_cfancommunitygcItemModelList
                                            .isEmpty) {
                                          itemModel =
                                              CfanCommunityGuangchangItemModel();
                                        } else {
                                          itemModel =
                                              _cfancommunitygcItemModelList[
                                                  index];
                                        }
                                        return buildCell(
                                          context,
                                          itemModel,
                                          index,
                                        );
                                      },
                                      childCount:
                                          _cfancommunitygcItemModelList.length,
                                      // _cfanUserpostsItemModelList.length,
                                    ),
                                  ),
                                ),
                                const FooterLocator.sliver(),
                              ],
                            ),
                          ),
                        ),
                        //女明星
                        ExtendedVisibilityDetector(
                          uniqueKey: const Key('Tab1'),
                          child: _AutomaticKeepAlive(
                            child: CustomScrollView(
                              physics: physics,
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.all(
                                    ScreenAdapter.height(10),
                                  ),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        // var itemModel =
                                        //     _cfancommunitygcItemModelList[
                                        //         index];
                                        var itemModel =
                                            CfanCommunityGuangchangItemModel();
                                        if (_cfancommunitygcItemModelList
                                            .isEmpty) {
                                          itemModel =
                                              CfanCommunityGuangchangItemModel();
                                        } else {
                                          itemModel =
                                              _cfancommunitygcItemModelList[
                                                  index];
                                        }
                                        return buildCell(
                                          context,
                                          itemModel,
                                          index,
                                        );
                                      },
                                      childCount:
                                          _cfancommunitygcItemModelList.length,
                                      // _cfanUserpostsItemModelList.length,
                                    ),
                                  ),
                                ),
                                const FooterLocator.sliver(),
                              ],
                            ),
                          ),
                        ),
                        //艺人组合
                        ExtendedVisibilityDetector(
                          uniqueKey: const Key('Tab1'),
                          child: _AutomaticKeepAlive(
                            child: CustomScrollView(
                              physics: physics,
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.all(
                                    ScreenAdapter.height(10),
                                  ),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        // var itemModel =
                                        //     _cfancommunitygcItemModelList[
                                        //         index];
                                        var itemModel =
                                            CfanCommunityGuangchangItemModel();
                                        if (_cfancommunitygcItemModelList
                                            .isEmpty) {
                                          itemModel =
                                              CfanCommunityGuangchangItemModel();
                                        } else {
                                          itemModel =
                                              _cfancommunitygcItemModelList[
                                                  index];
                                        }
                                        return buildCell(
                                          context,
                                          itemModel,
                                          index,
                                        );
                                      },
                                      childCount:
                                          _cfancommunitygcItemModelList.length,
                                      // _cfanUserpostsItemModelList.length,
                                    ),
                                  ),
                                ),
                                const FooterLocator.sliver(),
                              ],
                            ),
                          ),
                        ),
                        //节目官方
                        ExtendedVisibilityDetector(
                          uniqueKey: const Key('Tab1'),
                          child: _AutomaticKeepAlive(
                            child: CustomScrollView(
                              physics: physics,
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.all(
                                    ScreenAdapter.height(10),
                                  ),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        // var itemModel =
                                        //     _cfancommunitygcItemModelList[
                                        //         index];
                                        var itemModel =
                                            CfanCommunityGuangchangItemModel();
                                        if (_cfancommunitygcItemModelList
                                            .isEmpty) {
                                          itemModel =
                                              CfanCommunityGuangchangItemModel();
                                        } else {
                                          itemModel =
                                              _cfancommunitygcItemModelList[
                                                  index];
                                        }
                                        return buildCell(
                                          context,
                                          itemModel,
                                          index,
                                        );
                                      },
                                      childCount:
                                          _cfancommunitygcItemModelList.length,
                                      // _cfanUserpostsItemModelList.length,
                                    ),
                                  ),
                                ),
                                const FooterLocator.sliver(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget buildCell(context, CfanCommunityGuangchangItemModel itemModel, index) {
    bool isInCart = Provider.of<CfanSearchProvider>(context).joinList.any(
          (element) => element == itemModel.communityId,
        );

    return Container(
      // height: ScreenAdapter.height(80),
      decoration: BoxDecoration(
        // color: Colors.orange,
        border: Border(
          bottom: BorderSide(
            color: Colors.red,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(
              ScreenAdapter.height(5),
            ),
            width: ScreenAdapter.width(60),
            height: ScreenAdapter.width(60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  ScreenAdapter.width(10),
                ),
              ),
              image: DecorationImage(
                image: NetworkImage(itemModel.avatar ?? ""),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: ScreenAdapter.width(10),
          ),
          Expanded(
            flex: 2,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text("${cellData[index]['name']}"),
                Text(itemModel.title ?? ""),
                SizedBox(
                  height: ScreenAdapter.height(10),
                ),
                // Text("${cellData[index]['name']}"),
                Text("${(itemModel.fansToal) ?? 0}"),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                if (isInCart) {
                  // Provider.of<CfanSearchProvider>(context, listen: false)
                  //     .remove(itemModel);
                  KTLog("已加入 不需要移除");
                  showToast("你已经加入!");
                } else {
                  Provider.of<CfanSearchProvider>(context, listen: false)
                      .addJoin(itemModel.communityId!);
                  KTLog("加入");

                  String ids = jsonEncode(
                      Provider.of<CfanSearchProvider>(context, listen: false)
                          .joinList);
                  addCommunity(ids);
                }
              },
              child: isInCart ? Text("已加入") : Text("加入"),
            ),
          ),
        ],
      ),
    );
  }

  //加入社群
  void addCommunity(String ids) {
    _loginProvider.addCommunity(
      ids,
      onSuccess: (data) {
        if (data['code'] == 200) {
          showToast("加入成功");
        }
      },
      onFailure: (error) {},
    );
  }
}

class _AutomaticKeepAlive extends StatefulWidget {
  final Widget child;

  const _AutomaticKeepAlive({
    required this.child,
  });

  @override
  State<_AutomaticKeepAlive> createState() => _AutomaticKeepAliveState();
}

class _AutomaticKeepAliveState extends State<_AutomaticKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
