import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/base/text_size.dart';
import 'package:cfan_flutter/page/login/listData.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_home_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_detail(%E5%B8%96%E5%AD%90%E8%AF%A6%E6%83%85)/cfan_post_detail_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_detail(%E5%B8%96%E5%AD%90%E8%AF%A6%E6%83%85)/cfan_post_nes_detail_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_focuse_widget.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_test(%E6%B5%8B%E9%AA%8C)/cfan_test_detail_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_test(%E6%B5%8B%E9%AA%8C)/model/cfan_test_home_model.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_topic_details_list.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_vote(%E6%8A%95%E7%A5%A8)/cfan_vote_detail_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_goods.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_model.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_home_banner.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_posts_contenttrans.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_userPosts_list_model.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_vote(%E6%8A%95%E7%A5%A8)/model/cfan_vote_home_model.dart';
import 'package:cfan_flutter/page/tabbars/cfan/video_player_singleton.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/provider/cfan_provider.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/widget/image/default_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CfanHomePage extends StatefulWidget {
  const CfanHomePage({super.key});

  @override
  State<CfanHomePage> createState() => _CfanHomePageState();
}

class _CfanHomePageState extends State<CfanHomePage>
    with SingleTickerProviderStateMixin {
  // final ScrollController scrollController = ScrollController();

  CfanProvider _cfanProvider = CfanProvider();
  CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();

  late TabController _tabController;
  //搜索框
  final TextEditingController searchController = TextEditingController();

  ///banner图组
  List<CfanHomeBannerItemModel> _bannerList = <CfanHomeBannerItemModel>[];

  ///我的社群
  List<CfanCommunityItemModel> _cfanMycommunityItemModelList = [];

  //当前点赞操作的item
  CfanUserpostsItemModel? _currentItemModel = CfanUserpostsItemModel();
//  List<GlobalKey> keys = List.generate(
//         _cfanUserpostsItemModelList.length, (index) => GlobalKey());
  //每个cell给个key
  List<GlobalKey> cellkeys = [];
  //轮播图图片数组
  final List _bannerImagUrlList = [
    imageUrl1,
    imageUrl2,
    imageUrl3,
  ];

  ///tab 标签数据
  final List<Map<String, dynamic>> _subTabList = [
    {
      'id': 1,
      'name': '关注',
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
    {
      'id': 5,
      'name': '测验',
    },
  ];

  //中间tab切换选择的标签
  int _selectedSubTabsIndex = 0;

  //关注分页guanzhu 简称gz
  ///明星动态
  List<CfanUserpostsItemModel> _cfanUserpostsItemModelList = [];
  int _gzPage = 1;
  bool _gzflag = true; //解决重复请求的问题
  bool _gzHasData = true; //是否有数据

  ///商品数据
  List<CfanCommunityGoodsItemModel> _cfanCommunityGoodsItemModelList = [];

  //投票toupiao 简称tp
  ///投票
  List<CfanVoteHomeItemModel> _cfanVoteHomeItemModelList = [];
  int _tpPage = 1;
  bool _tpflag = true; //解决重复请求的问题
  bool _tpHasData = true; //是否有数据

  ///测验ceyan 简称cy
  ///测验
  List<CfanTestHomeItemModel> _testHomeItemModelList = [];
  int _cyPage = 1;
  bool _cyflag = true; //解决重复请求的问题
  bool _cyHasData = true; //是否有数据

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _subTabList.length, vsync: this);

    //获取banner图
    getHomeBanner();
    //获取商品 首页communityId 参数可选 去掉
    getGoodsListData(1);
    //获取我的社群数据
    getMyCommunityData();
    //获取动态
    getUserPostsData("1", "");
    //获取投票
    getVoterData("1", "");
    //获取测验接口
    getTestData(1, "");

    //界面都渲染完之后才调用
    WidgetsBinding.instance.addPostFrameCallback((_) {
      KTLog("调用了WidgetsBinding.instance.addPostFrameCallback");
    });
  }

  /// banner图获取
  void getHomeBanner() {
    _cfanProvider.homeBanner(
      onSuccess: (data) {
        if (data['code'] == 200) {
          var tempData = CfanHomeBannerModel.fromJson(data);
          setState(() {
            _bannerList.addAll(tempData.data ?? []);
          });
        }
      },
      onFailure: (error) {},
    );
  }

  /// 获取商品列表
  void getGoodsListData(int page) {
    _cfanProvider.communityGoods(
      "",
      page,
      onSuccess: (data) {
        if (data['code'] == 200) {
          var tempData = CfanCommunityGoodsModel.fromJson(data);
          var temList = tempData.data?.list ?? [];
          setState(() {
            _cfanCommunityGoodsItemModelList.addAll(temList);
            KTLog(_cfanCommunityGoodsItemModelList.length);
          });
        }
      },
      onFailure: (error) {},
    );
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
  getUserPostsData(String page, String searchStr) {
    KTLog('107-执行了$_gzflag--$_gzHasData');

    if (_gzflag && _gzHasData) {
      _gzflag = false;
      _cfanProvider.userPosts(
        searchStr,
        page,
        onSuccess: (data) {
          if (data['code'] == 200) {
            var tempList = CfanUserpostsModel.fromJson(data);
            setState(() {
              _cfanUserpostsItemModelList.addAll(tempList.data!.list!);
              cellkeys = List.generate(
                  _cfanUserpostsItemModelList.length, (index) => GlobalKey());
              _gzPage++;
              _gzflag = true;
              // //请求完后 循环遍历 把islike已经点赞的模型存入数组
              // for (var i = 0; i < _cfanUserpostsItemModelList.length; i++) {
              //   if (_cfanUserpostsItemModelList[i].isLike == true) {
              //     _cfanProvider.zanList.add(_cfanUserpostsItemModelList[i]);
              //   }
              // }
              // KTLog(_cfanProvider.zanList.length);
            });
            //判断有没有数据
            if (tempList.data!.list!.length < 9) {
              setState(() {
                _gzHasData = false;
              });
            }
          }
        },
        onFailure: (error) {},
      );
    }
  }

  //获取投票
  getVoterData(String page, String searchStr) {
    KTLog('107-执行了$_tpflag--$_tpHasData');

    if (_tpflag && _tpHasData) {
      _tpflag = false;
      _cfanProvider.userVoteList(
        searchStr,
        page,
        onSuccess: (data) {
          if (data['code'] == 200) {
            var tempList = CfanVoteHomeModel.fromJson(data);
            setState(() {
              _cfanVoteHomeItemModelList.addAll(tempList.data!.list!);
              // cellkeys = List.generate(
              //     _cfanVoteHomeItemModelList.length, (index) => GlobalKey());
              _tpPage++;
              _tpflag = true;
              // //请求完后 循环遍历 把islike已经点赞的模型存入数组
              // for (var i = 0; i < _cfanUserpostsItemModelList.length; i++) {
              //   if (_cfanUserpostsItemModelList[i].isLike == true) {
              //     _cfanProvider.zanList.add(_cfanUserpostsItemModelList[i]);
              //   }
              // }
              // KTLog(_cfanProvider.zanList.length);
            });
            //判断有没有数据
            if (tempList.data!.list!.length < 9) {
              setState(() {
                _tpHasData = false;
              });
            }
          }
        },
        onFailure: (error) {},
      );
    }
  }

  //获取测验数据
  getTestData(int page, String searchStr) {
    KTLog('107-执行了$_cyflag--$_cyHasData');

    if (_cyflag && _cyHasData) {
      _cyflag = false;
      _cfanCommunityHomeProvider.userTestHomeList(
        searchStr,
        page,
        onSuccess: (data) {
          if (data['code'] == 200) {
            var tempList = CfanTestHomeModel.fromJson(data);
            setState(() {
              _testHomeItemModelList.addAll(tempList.data!.list!);
              _cyPage++;
              _cyflag = true;
            });
            //判断有没有数据
            if (tempList.data!.list!.length < 9) {
              setState(() {
                _cyHasData = false;
              });
            }
          }
        },
        onFailure: (error) {},
      );
    }
  }

  //点赞操作
  void _onLike() {
    //安全检查
    if (_currentItemModel == null) return;
    //先设置设置交互状态
    setState(() {
      _currentItemModel?.isLike = !(_currentItemModel?.isLike ?? false);
    });
    //再执行请求 异步处理 点赞接口
    sendUserPostsLikeData(_currentItemModel!.postsId.toString());
  }

  //发送点赞
  //await 是前端很严谨 需要服务端返回一个状态才用的到
  sendUserPostsLikeData(String postsId) {
    _cfanProvider.userPostsLike(
      postsId,
      onSuccess: (data) {
        if (data['code'] == 200) {
          // setState(() {
          //   getUserPostsData();
          // });
        }
      },
      onFailure: (error) {},
    );
  }

  //请求翻译
  //传入点击每行的索引
  sendFanyiData(int postsId, int index) {
    _cfanCommunityHomeProvider.userPostsContenttrans(
      postsId,
      onSuccess: (data) {
        if (data['code'] == 200) {
          // CfanPostsContenttransDataModel
          var temp = CfanPostsContenttransModel.fromJson(data);
          setState(() {
            CfanPostsContenttransDataModel fanyiModel =
                temp.data ?? CfanPostsContenttransDataModel();
            // getMyCommunityData();
            //请求后把对应索引的模型放入字典里 根据对应的键来取值
            Provider.of<CfanProvider>(context, listen: false)
                .addFanyi(index.toString(), fanyiModel.dstContent ?? "");
          });
        }
      },
      onFailure: (error) {},
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  ///监听滚动视图的方法
  // scrollControllerListener() {
  //   _cfanProvider.scrollController.addListener(() {
  //     KTLog(_cfanProvider.scrollController.position.pixels);

  //     //如果滚动10个像素 将把导航设置为白色
  //     if (_cfanProvider.scrollController.position.pixels > 20) {
  //       if (flag == false) {
  //         // KTLog(_cfanProvider.scrollController.position.pixels);
  //         setState(() {
  //           flag = true;
  //         });
  //       }
  //     }
  //     if (_cfanProvider.scrollController.position.pixels < 20) {
  //       if (flag = true) {
  //         // KTLog(_cfanProvider.scrollController.position.pixels);
  //         setState(() {
  //           flag = false;
  //         });
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
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
            _cfanUserpostsItemModelList = [];
            // cellkeys = [];
            _gzPage = 1;
            _gzHasData = true;
            //下拉刷新
            await Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                setState(() {
                  //获取banner图
                  _bannerList = [];
                  getHomeBanner();

                  ///获取商品 首页communityId 参数可选 去掉
                  _cfanCommunityGoodsItemModelList = [];
                  //获取商品列表
                  getGoodsListData(1);
                  _cfanMycommunityItemModelList = [];
                  //获取我的社群
                  getMyCommunityData();
                  //获取关注动态
                  if (_tabController.index == 0) {
                    _cfanUserpostsItemModelList = [];
                    _gzPage = 1;
                    _gzHasData = true;
                    getUserPostsData(_gzPage.toString(), "");
                  }
                  //获取投票
                  else if (_tabController.index == 2) {
                    _cfanVoteHomeItemModelList = [];
                    _tpPage = 1;
                    _tpHasData = true;
                    getVoterData(_tpPage.toString(), "");
                  }
                  //获取测验
                  else if (_tabController.index == 3) {
                    _testHomeItemModelList = [];
                    _cyPage = 1;
                    _cyHasData = true;
                    getTestData(_cyPage, "");
                  }
                });
              }
            });
          },
          onLoad: () async {
            //上拉加载
            await Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                setState(() {
                  KTLog("_tabController.index${_tabController.index}");
                  //判断是哪个tab 就加载哪个tab数据
                  if (_tabController.index == 0) {
                    getUserPostsData(_gzPage.toString(), "");
                  } else {}
                });
              }
            });
          },
          childBuilder: (context, physics) {
            return ExtendedNestedScrollView(
              controller: _cfanProvider.scrollController,
              physics: const ClampingScrollPhysics(),
              onlyOneScrollInBody: true,
              //固定头部的高度
              pinnedHeaderSliverHeightBuilder: () {
                return MediaQuery.of(context).padding.top + kToolbarHeight;
              },
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  const HeaderLocator.sliver(clearExtent: false),
                  SliverAppBar(
                    //展开的高度  轮播 和 社群 控件占用高度在这设置
                    expandedHeight: ScreenAdapter.height(340) +
                        ScreenAdapter.height(240) +
                        ScreenAdapter.height(55) -
                        kToolbarHeight,
                    //压制住不让tab划走
                    pinned: true,

                    ///添加自定义导航
                    title: _nav(),
                    backgroundColor: Colors.red,
                    elevation: 0, //去掉阴影
                    flexibleSpace: FlexibleSpaceBar(
                      //更改滚动视图往上推折叠方式引脚
                      collapseMode: CollapseMode.pin,
                      background: Container(
                        color: Colors.orange,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 1.添加轮播图
                            CfanFocuseWidget(
                              imgList: _bannerList,
                            ),
                            // 2.添加社群
                            _recommend(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body:
                  // Container(
                  //   color: Colors.orange,
                  // )
                  //布局溢出通常被视为一个错误，因为它意味着有内容可能无法被用户看到
                  Column(
                children: [
                  TabBar(
                    //分隔器高度 tab底部的线
                    // dividerHeight: 1,
                    controller: _tabController,
                    labelColor: themeData.colorScheme.primary,
                    indicatorColor: themeData.colorScheme.primary,
                    onTap: (value) {
                      setState(() {
                        _selectedSubTabsIndex = value;
                        KTLog(_selectedSubTabsIndex);
                      });
                    },
                    tabs: _subTabList.map((value) {
                      return Tab(
                        child: Text(value['name']),
                      );
                    }).toList(),

                    // const <Widget>[
                    //   Tab(
                    //     text: 'List',
                    //   ),
                    //   Tab(
                    //     text: 'Grid',
                    //   ),
                    // ],
                  ),

                  //判断如果是 投票和活动 显示的内容
                  _selectedSubTabsIndex == 2 ||
                          _selectedSubTabsIndex == 3 ||
                          _selectedSubTabsIndex == 4
                      ? Container(
                          height: ScreenAdapter.height(45),
                          color: Colors.white,
                          child: Row(
                            children: [
                              SizedBox(
                                width: ScreenAdapter.width(10),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_selectedSubTabsIndex == 2) {
                                    KTLog("投票 进行中");
                                  } else if (_selectedSubTabsIndex == 3) {
                                    KTLog("活动 进行中");
                                  } else {
                                    KTLog("测验 进行中");
                                  }
                                },
                                child: Text("进行中"),
                              ),
                              SizedBox(
                                width: ScreenAdapter.width(10),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_selectedSubTabsIndex == 2) {
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
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        //关注
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
                                      return _buildGuanzhuCell(
                                          context,
                                          _cfanUserpostsItemModelList[index],
                                          index);
                                    },
                                        childCount:
                                            _cfanUserpostsItemModelList.length),
                                  ),
                                ),
                                const FooterLocator.sliver(),
                              ],
                            ),
                          ),
                        ),
                        //节目
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
                                      return _buildProgramVideoCell(
                                          _cfanUserpostsItemModelList[index],
                                          index);
                                    },
                                        childCount:
                                            _cfanUserpostsItemModelList.length),
                                  ),
                                ),
                                const FooterLocator.sliver(),
                              ],
                            ),
                          ),
                        ),
                        //投票
                        ExtendedVisibilityDetector(
                          uniqueKey: const Key('Tab2'),
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
                                      return _buildVoteCell(
                                          _cfanVoteHomeItemModelList[index],
                                          index);
                                    },
                                        childCount:
                                            _cfanVoteHomeItemModelList.length),
                                  ),
                                ),
                                const FooterLocator.sliver(),
                              ],
                            ),
                          ),
                        ),
                        //活动
                        ExtendedVisibilityDetector(
                          uniqueKey: const Key('Tab3'),
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
                                      return _buildVoteCell(
                                          _cfanVoteHomeItemModelList[index],
                                          index);
                                    },
                                        childCount:
                                            _cfanVoteHomeItemModelList.length),
                                  ),
                                ),
                                /*
                                SliverGrid(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return Container(
                                      color: KTColor.getRandomColor(),
                                    );
                                  }, childCount: _gridCount),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 6 / 7,
                                  ),
                                ),
                                */
                                const FooterLocator.sliver(),
                              ],
                            ),
                          ),
                        ),

                        //测验
                        ExtendedVisibilityDetector(
                          uniqueKey: const Key('Tab4'),
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
                                      return _buildTestCell(
                                          _testHomeItemModelList[index], index);
                                    },
                                        childCount:
                                            _testHomeItemModelList.length),
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

  //导航
  Widget _nav() {
    return InkWell(
      //自定义导航标题
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        //设置搜索栏
        width: ScreenAdapter.width(450),
        height: ScreenAdapter.height(40),
        decoration: BoxDecoration(
          // color: const Color.fromRGBO(246, 246, 246, 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                NavigationUtil.getInstance().pushPage(
                  context,
                  RouterName.cfanTopicListPage,
                  widget: CfanTopicDetailsListPage(
                    topicStr: "#周杰伦#",
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    ScreenAdapter.width(17), 0, ScreenAdapter.width(5), 0),
                child: const Icon(
                  Icons.search,
                  color: Color.fromARGB(200, 0, 0, 0),
                ),
              ),
            ),
            // Text(
            //   "搜索社群/用户/节目/投票",
            //   style: TextStyle(
            //     fontSize: ScreenAdapter.fontSize(14),
            //     color: Colors.black54,
            //   ),
            // ),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  color: Colors.red,
                  width: ScreenAdapter.width(300),
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(
                      fontSize: ScreenAdapter.fontSize(14),
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    //修改键盘为发送按钮
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(
                      hintText: "搜索社群/节目",
                      hintStyle: TextStyle(
                        color: Colors.black54,
                      ),
                      border: InputBorder.none, //取消TextField输入下划线
                      fillColor: Colors.white, // 设置输入框背景色为灰色
                      filled: true,
                    ),
                    onChanged: (value) {
                      KTLog(value);
                      //监听文本框输入内容
                      // controller.keyWords = value;
                    },
                    onSubmitted: (value) {
                      KTLog(value);
                      if (_selectedSubTabsIndex == 0) {
                        _cfanUserpostsItemModelList = [];
                        _gzPage = 1;
                        _gzHasData = true;
                        //搜索关注
                        getUserPostsData(_gzPage.toString(), value);
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      // onTap: () {
      //   KTLog("跳转搜索页面");
      //   NavigationUtil.getInstance().pushNamed(RouterName.cfanSearchPage);
      // },
    );
  }

  //推荐社群
  Widget _recommend() {
    return Container(
      height: ScreenAdapter.height(250),
      color: Colors.red,
      child: Column(
        children: [
          _sectionHead("我的社群", "社群广场 >"),
          Container(
            color: Colors.white,
            height: ScreenAdapter.height(235 - 48),
            padding: const EdgeInsets.all(5),
            child: ListView.builder(
              itemCount: _cfanMycommunityItemModelList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: _initGridViewData,
            ),
          ),
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
          Row(
            children: [
              Text(
                leftTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenAdapter.fontSize(18),
                ),
              ),
              SizedBox(
                width: ScreenAdapter.width(20),
              ),
              InkWell(
                onTap: () {
                  KTLog("更多");
                  NavigationUtil.getInstance()
                      .pushNamed(RouterName.cfanCommunityFollowPage);
                },
                child: Text(
                  "更多>>",
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(14),
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              KTLog("社区广场");
              NavigationUtil.getInstance().pushNamed(RouterName.cfanSearchPage);
            },
            child: Text(
              rightTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenAdapter.fontSize(12),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 单独封装推荐社群子item
  Widget _initGridViewData(context, index) {
    return InkWell(
      onTap: () {
        KTLog("我的社群点击了第$index个");
        NavigationUtil.getInstance().pushPage(
          context,
          RouterName.cfanCommunityHomePage,
          widget: CfanCommunityHomePage(
            communityId:
                (_cfanMycommunityItemModelList[index].communityId!).toString(),
          ),
        );
      },
      child: Container(
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
              width: ScreenAdapter.width(130),
              height: ScreenAdapter.width(110),
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
                fontSize: ScreenAdapter.fontSize(14),
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //构建关注cell
  Widget _buildGuanzhuCell(
      context, CfanUserpostsItemModel itemModel, int index) {
    //是否已经点赞
    bool isAleadyLike = Provider.of<CfanProvider>(context).zanList.any(
          (element) => element == itemModel,
        );
    // bool islik = Provider.of<CfanProvider>(context).zanList.any(
    //   (element) {
    //     KTLog(element.name!);
    //     return element.isLike!;
    //   },
    // );
    // KTLog("islik$islik");
    // KTLog("itemModel.isLike---${itemModel.isLike!}");
    // KTLog("isAleadyLike---$isAleadyLike");
    //是否已经翻译
    // bool isFanyi = Provider.of<CfanProvider>(context).fanyiLis.any(
    //       (model) => model == _fanyiModel,
    //     );
    //如果点击的索引 取出对应的值 有数据
    bool isFanyi =
        Provider.of<CfanProvider>(context).fanyiDic[index.toString()] != null;
    KTLog("isFanyi - $isFanyi");
    return InkWell(
      onTap: () {
/* 计算文本高度先不用
        //获取折叠的文本内容高度
        double collapseTextHeight = calculateTextHeight(
            itemModel.content!,
            ScreenAdapter.fontSize(14),
            FontWeight.normal,
            ScreenAdapter.getScreenWidth(),
            5);
        //获取展开的文本高度
        double expendTextHeight = calculateTextHeight(
            itemModel.content!,
            ScreenAdapter.fontSize(14),
            FontWeight.normal,
            ScreenAdapter.getScreenWidth(),
            1000);

        KTLog("文本折叠高度$collapseTextHeight");

        KTLog("文本展开高度$expendTextHeight");
        //如果是折叠状态  需要 总展开高度 - 折叠高度  把剩下的高度传到下个界面展示
        double resultHeight = expendTextHeight - collapseTextHeight;
        KTLog("需要的文本高度$resultHeight");

        //获取cell高度
        RenderBox? renderBox =
            cellkeys[index].currentContext!.findRenderObject() as RenderBox?;
        double cellheight =
            renderBox!.semanticBounds.size.height; //这个是获取单个cell高度
        // double cellheight1 = renderBox.size.height;//这个获取的高度很高不低
        KTLog("cellheight$cellheight");
        // KTLog("cellheight1$cellheight1");
*/
        // NavigationUtil.getInstance().pushPage(
        //   context,
        //   RouterName.cfanPostDetailPage,
        //   widget: CfanPostDetailPage(
        //     postsId: (_cfanUserpostsItemModelList[index].postsId!).toString(),
        //     cellHeight: cellheight + resultHeight + 10,
        //   ),
        // );

        NavigationUtil.getInstance().pushPage(
          context,
          RouterName.cfanPostNesDetailPage,
          widget: CfanPostNesDetailPage(
            postsId: (_cfanUserpostsItemModelList[index].postsId!).toString(),
            cellHeight: 0, //cellheight + resultHeight + 10,
          ),
        );
      },
      child: Container(
        key: cellkeys[index],
        color: KTColor.white,
        child: Column(
          children: [
            //第四个 添加商品
            if (index == 3)
              Container(
                height: ScreenAdapter.height(270),
                color: Colors.white,
                child: _buildGoodsHead(),
              ),

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: CircleAvatar(
                      radius: ScreenAdapter.width(35),
                      //   backgroundImage: const NetworkImage(
                      //       "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
                      backgroundImage: NetworkImage(itemModel.avatar!),
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenAdapter.width(10),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    // color: Colors.blue,
                    // height: ScreenAdapter.width(35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // //名字
                        // Text(
                        //   itemModel.name!,
                        //   style: TextStyle(
                        //       fontSize: ScreenAdapter.fontSize(14),
                        //       fontWeight: FontWeight.bold),
                        // ),
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
                            // //等级名称 传入等级 和 等级名称
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
                                  Icon(
                                    Icons.ac_unit_outlined,
                                    size: 20,
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
                              itemModel.createTime!,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //1.单文章
                  Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.white,
                    child: ExpandableText(
                      // itemModel['content'],
                      itemModel.content!,
                      // textAlign: TextAlign.left,

                      expandText: "全文", //展开
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(14),
                        fontWeight: FontWeight.normal,
                      ),
                      collapseText: "收起", //收起
                      maxLines: 5, //最多显示行数
                      linkColor: Colors.blue,

                      // prefixText: "开头",
                      // //@点击
                      // mentionStyle: const TextStyle(
                      //   color: Colors.red,
                      //   fontWeight: FontWeight.w600,
                      // ),
                      // onMentionTap: (value) {
                      //   print(value);
                      // },
                      // //#话题点击
                      // hashtagStyle: const TextStyle(
                      //   color: Color(0xFF30B6F9),
                      // ),
                      // onHashtagTap: (name) {
                      //   print(name);
                      // },
                    ),
                  ),
                  //2.翻译的内容
                  Container(
                    alignment: Alignment.centerLeft,
                    //             Provider.of<CfanProvider>(context, listen: false)
                    // .removeFanyi(_fanyiModel);
                    // todo
                    //
                    // child: Text(_fanyiModel.dstContent ?? ""),
                    child: Text(
                      Provider.of<CfanProvider>(context)
                              .fanyiDic[index.toString()] ??
                          "",
                    ),

                    // child: Text(isFanyi ? "" : _fanyiModel.dstContent ?? "暂无"),
                  ),

                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.all(ScreenAdapter.width(8)),
                    child: itemModel.picList?.length != null
                        ? _addNinePic(itemModel.picList!)
                        : Container(),
                  ),

                  //4.视频

                  //社群来源
                  Row(
                    children: [
                      const Icon(Icons.safety_check_outlined),
                      Text(
                        itemModel.communityName ?? "",
                        style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(14),
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  //添加评论 点赞
                  //todo
                  // _bottomToolsbar(itemModel, index, isAleadyLike, isFanyi),
                  _bottomToolsbar(itemModel, index, isAleadyLike, isFanyi),

                  //添加轮播图
                  if (index == 5)
                    InkWell(
                      onTap: () {
                        KTLog("asd");
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          //设置完圆角度数后,需要设置裁切属性
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: ScreenAdapter.height(150),
                        child: CfanFocuseWidget(
                          imgList: _bannerList,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //商品列表
  Widget _buildGoodsHead() {
    return Container(
      padding: EdgeInsets.all(
        ScreenAdapter.width(5),
      ),
      child: Column(
        children: [
          //1.logo  更多按钮
          Container(
            height: ScreenAdapter.height(50),
            color: Colors.white,
            child: Row(
              children: [
                //logo
                Container(
                  //设置裁切属性
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    //设置完圆角度数后,需要设置裁切属性
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl3,
                    width: ScreenAdapter.width(35),
                    height: ScreenAdapter.width(35),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: ScreenAdapter.width(5),
                ),
                const Text("社群商品推荐"),
                const Spacer(),
                Container(
                  width: ScreenAdapter.width(75),
                  height: ScreenAdapter.width(30),
                  child: OutlinedButton(
                    onPressed: () {
                      KTLog("更多");
                    },
                    child: Text(
                      "更多",
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //2.商品左右滚动列表
          Container(
            height: ScreenAdapter.height(200),
            color: Colors.white,
            child: ListView.builder(
              itemCount: _cfanCommunityGoodsItemModelList.length,
              scrollDirection: Axis.horizontal,
              //要请求商品数据赋值
              itemBuilder: _initGoodsViewData,
            ),
          ),
        ],
      ),
    );
  }

  /// 单独封装推荐社群子item
  Widget _initGoodsViewData(context, index) {
    var itemModel = _cfanCommunityGoodsItemModelList[index];
    return InkWell(
      onTap: () async {
        KTLog("$index");
        KTLog("点击了第$index个");
        // launchi
        Uri uri = Uri.parse(itemModel.linkUrl ?? "");
        try {
          if (Platform.isAndroid) {
            KTLog("Android");
            launchUrl(uri);
          } else {
            //iOS系统 内部外部跳转都没事
            KTLog("iOS");
            if (await canLaunchUrl(uri)) {
              //打开浏览器
              launchUrl(uri);
            } else {
              throw 'Could not launch $uri';
            }
          }
        } catch (error) {
          KTLog(error);
        }
      },
      child: Container(
        width: ScreenAdapter.width(100),
        margin: EdgeInsets.all(ScreenAdapter.width(5)),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          // color: KTColor.getRandomColor(),
          borderRadius: BorderRadius.all(
            Radius.circular(ScreenAdapter.width(5.0)),
          ),
          border: Border.all(
            width: ScreenAdapter.width(0.5),
            color: Colors.grey,
          ),
        ),
        child: Column(
          children: [
            //商品图片
            Expanded(
              flex: 3,
              child: CachedNetworkImage(
                imageUrl: itemModel.image ?? "",
                fit: BoxFit.cover,
                placeholder: (context, url) => defaultBannerImage(),
                errorWidget: (context, url, error) => defaultBannerImage(),
              ),
            ),
            //商品名称
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(
                  // top: ScreenAdapter.width(5),
                  left: ScreenAdapter.width(5),
                  right: ScreenAdapter.width(5),
                ),
                child: Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  itemModel.name ?? "",
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(12),
                  ),
                ),
              ),
            ),
            //商品金额
            Container(
              padding: EdgeInsets.only(
                left: ScreenAdapter.width(5),
              ),
              alignment: Alignment.centerLeft,
              // color: Colors.amber,
              child: Text(
                "¥ ${itemModel.price}",
                style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //构建节目视频cell
  Widget _buildProgramVideoCell(CfanUserpostsItemModel itemModel, int index) {
    //是否已经点赞
    bool isAleadyLike = Provider.of<CfanProvider>(context).zanList.any(
          (element) => element == itemModel,
        );
    //是否已经翻译
    // bool isFanyi = Provider.of<CfanProvider>(context).fanyiLis.any(
    //       (model) => model == _fanyiModel,
    //     );
    // //如果点击的索引 取出对应的值 有数据
    // bool isFanyi = Provider.of<CfanProvider>(context).fanyiDic[index] != null;
    // KTLog("isFanyi - $isFanyi");
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ScreenAdapter.width(10),
        ),
        border: Border.all(
          width: ScreenAdapter.height(1),
          color: const Color.fromRGBO(238, 238, 238, 1),
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
                    const Icon(Icons.safety_check_outlined),
                    SizedBox(
                      width: ScreenAdapter.width(10),
                    ),
                    const Text("周杰伦"),
                  ],
                ),
                const Text("2024.6.6"),
              ],
            ),
          ),
          //2.视频 350
          Container(
            color: Colors.black,
            height: ScreenAdapter.height(350),
            child: const SingletonVideoPlayer(
              videoUrl: "https://media.w3.org/2010/05/sintel/trailer.mp4",
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
          _bottomToolsbar(
            itemModel,
            index,
            isAleadyLike,
            false,
          ),
        ],
      ),
    );
  }

  //投票cell
  Widget _buildVoteCell(CfanVoteHomeItemModel itemModel, int index) {
    return InkWell(
      onTap: () {
        //投票
        if (_selectedSubTabsIndex == 2) {
          NavigationUtil.getInstance().pushPage(
            context,
            RouterName.cfanVoteDetailPage,
            widget: CfanVoteDetailPage(
              voteId: itemModel.pollsId ?? 0,
            ),
          );
        }
        //活动
        else if (_selectedSubTabsIndex == 3) {}
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ScreenAdapter.width(10),
          ),
          border: Border.all(
            width: ScreenAdapter.width(1),
            // color: Color.fromRGBO(238, 238, 238, 1),
            color: Colors.grey,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  imageUrl: itemModel.logo ?? "",
                  placeholder: (context, url) => defaultHeadImage(),
                  errorWidget: (context, url, error) => defaultHeadImage(),
                ),
              ),
            ),
            Text(
              itemModel.title ?? "",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: itemModel.communityList?.length != 0
                      ? itemModel.communityList!.map((model) {
                          return Container(
                            // color: Colors.red,
                            child: Row(
                              children: [
                                Icon(Icons.safety_check_outlined),
                                Text("周杰伦"),
                              ],
                            ),
                          );
                        }).toList()
                      : [Container()],
                ),
                const Text("2024.6.6"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //测验cell
  Widget _buildTestCell(CfanTestHomeItemModel itemModel, int index) {
    return InkWell(
      onTap: () {
        NavigationUtil.getInstance().pushPage(
          context,
          RouterName.cfanTestDetailPage,
          widget: CfanTestDetailPage(
            examId: itemModel.examId ?? 0,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ScreenAdapter.width(10),
          ),
          border: Border.all(
            width: ScreenAdapter.width(1),
            // color: Color.fromRGBO(238, 238, 238, 1),
            color: Colors.grey,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  imageUrl: itemModel.logo ?? "",
                  placeholder: (context, url) => defaultHeadImage(),
                  errorWidget: (context, url, error) => defaultHeadImage(),
                ),
              ),
            ),
            Text(
              itemModel.title ?? "",
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: itemModel.communityList?.length != 0
                      ? itemModel.communityList!.map((model) {
                          return Container(
                            // color: Colors.red,
                            child: Row(
                              children: [
                                Icon(Icons.safety_check_outlined),
                                Text(model.title ?? ""),
                              ],
                            ),
                          );
                        }).toList()
                      : [Container()],
                ),
                const Text("2024.6.6"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //评论 点赞  tools
  Widget _bottomToolsbar(CfanUserpostsItemModel itemModel, int index,
      bool isAleadyLike, bool isFanyi) {
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
              // color: KTColor.getRandomColor(),
              border: Border(
                right: BorderSide(
                    width: ScreenAdapter.height(1), color: Colors.grey),
                bottom: BorderSide(
                    width: ScreenAdapter.height(1), color: Colors.grey),
              ),
            ),
            child: IconButton(
              onPressed: () {
                KTLog("翻译 --- $index");
                //1.点击翻译 请求数据 把模型加入数组

                //如果翻译了
                if (isFanyi) {
                  //移除
                  // Provider.of<CfanProvider>(context, listen: false)
                  //     .removeFanyi(_fanyiModel);
                } else {
                  //没翻译就添加进状态管理数组
                  sendFanyiData(itemModel.postsId!, index);
                }
              },
              icon: const Icon(
                Icons.translate,
                color: Colors.black,
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
                right: BorderSide(
                    width: ScreenAdapter.height(1), color: Colors.grey),
                bottom: BorderSide(
                    width: ScreenAdapter.height(1), color: Colors.grey),
              ),
            ),
            child: TextButton.icon(
              onPressed: () {
                KTLog("评论 --- $index");
                NavigationUtil.getInstance().pushPage(
                  context,
                  RouterName.cfanPostNesDetailPage,
                  widget: CfanPostNesDetailPage(
                    postsId: (itemModel.postsId).toString(),
                    cellHeight: 0, //cellheight + resultHeight + 10,
                  ),
                );
              },
              icon: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.black,
              ),
              label: Text(
                // "888",
                itemModel.commentCount.toString(),
                style: const TextStyle(
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
                /*能用 但有bug
                if (isAleadyLike) {
                  KTLog(isAleadyLike);
                  //从点赞数组移除
                  Provider.of<CfanProvider>(context, listen: false)
                      .remove(itemModel);
                  //取消点赞请求
                  sendUserPostsLikeData(itemModel.postsId.toString());
                  // setState(() {
                  //   //表面点赞 + 1
                  //   _addLike = 0;
                  // });
                } else {
                  //fase 所以要加入数组
                  KTLog(isAleadyLike);

                  //添加点赞数组
                  Provider.of<CfanProvider>(context, listen: false)
                      .addLike(itemModel);
                  //发送点赞请求
                  sendUserPostsLikeData(itemModel.postsId.toString());
                  // setState(() {
                  //   //表面点赞 + 1
                  //   _addLike = 1;
                  // });
                }
                */
                setState(() {
                  _currentItemModel = itemModel;
                });

                _onLike();
              },
              icon: itemModel.isLike == true
                  ? const Icon(
                      Icons.thumb_up_off_alt_rounded,
                      color: Colors.black,
                    )
                  : const Icon(Icons.thumb_up_off_alt_outlined,
                      color: Colors.black),
              /*能用 但有bug 
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
                    */
              /*
              itemModel.isLike == true
                  ? const Icon(
                      //已经点赞
                      Icons.thumb_up_off_alt_rounded,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.thumb_up_off_alt_outlined,
                      color: Colors.black,
                    ),*/
              /*
              isAleadyLike
                  ? itemModel.isLike == true
                      ? const Icon(
                          //已经点赞
                          Icons.thumb_up_off_alt_rounded,
                          color: Colors.black,
                        )
                      : const Icon(
                          Icons.thumb_up_off_alt_outlined,
                          color: Colors.black,
                        )
                  : const Icon(
                      Icons.thumb_up_off_alt_outlined,
                      color: Colors.black,
                    ),*/

              // itemModel.isLike == true
              //     ? isAleadyLike
              //         ? const Icon(
              //             //已经点赞
              //             Icons.thumb_up_off_alt_rounded,
              //             color: Colors.black,
              //           )
              //         : const Icon(
              //             Icons.thumb_up_off_alt_outlined,
              //             color: Colors.black,
              //           )
              //     : const Icon(
              //         Icons.thumb_up_off_alt_outlined,
              //         color: Colors.black,
              //       ),
              /**
               * (itemModel.likeCount! < _currentItemModel!.likeCount!)
                        ? (itemModel.likeCount! + 1).toString()
                        : itemModel.likeCount.toString()
               */
              label: Text(
                // "888",
                itemModel.isLike == true
                    ? (itemModel.likeCount! + 1).toString()
                    : itemModel.likeCount.toString(),

                style: const TextStyle(
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
        // images[i]["url"],
        images[i],
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
