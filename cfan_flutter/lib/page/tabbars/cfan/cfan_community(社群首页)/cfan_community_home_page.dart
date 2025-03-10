import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/base/global_size.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_detail_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_ontherHomeInfo.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_publish_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_userInfo_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_detail(%E5%B8%96%E5%AD%90%E8%AF%A6%E6%83%85)/cfan_post_nes_detail_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_detail.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_goods.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_program_category.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_program_list.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_userPosts_list_model.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/provider/cfan_provider.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/tools/asset_utils/asset_utils.dart';
import 'package:cfan_flutter/tools/keepAliveWrapper.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/widget/HJWidget/hj_dialog.dart';
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

///社群主页
class CfanCommunityHomePage extends StatefulWidget {
  //传入帖子id
  final String communityId;

  const CfanCommunityHomePage({super.key, required this.communityId});

  @override
  State<CfanCommunityHomePage> createState() => _CfanCommunityPageState();
}

class _CfanCommunityPageState extends State<CfanCommunityHomePage>
    with SingleTickerProviderStateMixin {
  final CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();
  final CfanProvider _cfanProvider = CfanProvider();

  late TabController _tabController;

  ///tab 标签数据
  final List<Map<String, dynamic>> _subTabList = [
    {
      'id': 1,
      'name': '帖子',
    },
    {
      'id': 2,
      'name': '动态',
    },
    {
      'id': 3,
      'name': '节目',
    },
    {
      'id': 4,
      'name': '商品',
    },
  ];

  //中间tab切换选择的标签
  int _selectedSubTabsIndex = 0;

  ///社群详情模型
  CfanCommunityDetailModel _cfanCommunityDetailModel =
      CfanCommunityDetailModel();

  ///帖子数组
  List<CfanUserpostsItemModel> _cfanCommunityItemModelList = [];
  //帖子分页tiezi 简称tz
  int _tzPage = 1;
  bool _tzflag = true; //解决重复请求的问题
  bool _tzHasData = true; //是否有数据
  //当前点赞操作的item
  CfanUserpostsItemModel? _currentItemModel = CfanUserpostsItemModel();

  ///动态艺人数组
  List<CfanUserpostsItemModel> _cfanArtistItemModelList = [];
  //艺人动态分页dt 简称dt
  int _dtPage = 1;
  bool _dtflag = true; //解决重复请求的问题
  bool _dtHasData = true; //是否有数据
  int _artistSelectIndex = 0; //记录点击了哪个明星

  ///分类
  ///分类标签模型
  List<CfanCommunityProgramCategoryItemModel>
      _cfanCommunityProgramCategoryItemListModel =
      <CfanCommunityProgramCategoryItemModel>[];

  ///分类列表数组
  List<CfanCommunityProgramListItemModel>
      _cfanCommunityProgramListItemModelList = [];
  //分类列表fenlei 简称fl
  int _flPage = 1;
  bool _flflag = true; //解决重复请求的问题
  bool _flHasData = true; //是否有数据
  int _categorySelectIndex = 0; //记录点击了哪个明星

  ///商品
  List<CfanCommunityGoodsItemModel> _cfanCommunityGoodsItemModelList = [];
  //帖子分页shangpin 简称sp
  int _spPage = 1;
  bool _spflag = true; //解决重复请求的问题
  bool _spHasData = true; //是否有数据
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _subTabList.length, vsync: this);
    listenerTabController();

    ///获取社群详情 才能拿到artist_id艺人id
    getUserPostsCommunityDetail(widget.communityId);

    ///获取社群帖子
    getUserPostsCommunitposts(widget.communityId, "1");

    ///获取分类标签
    getProgramCategoryData();

    ///获取商品
    getGoodsListData(widget.communityId, 1);
  }

  @override
  void dispose() {
    super.dispose();
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
        setState(() {
          _selectedSubTabsIndex = _tabController.index;
        });
      }
    });
  }

  //必须加延时函数  showDialog 才能使用不报错
  Future<void> delayedFunction() async {
    await Future.delayed(Duration(seconds: 1)); // 延时1秒
    print("这是在延时后执行的函数");
  }

  ///获取社群详情
  getUserPostsCommunityDetail(String communityId) {
    _cfanCommunityHomeProvider.userPostsCommunitdetail(
      communityId,
      onSuccess: (data) {
        if (data['code'] == 200) {
          var tempModel = CfanCommunityDetailModel.fromJson(data);
          setState(() {
            _cfanCommunityDetailModel = tempModel;

            ///获取艺人动态
            getUserPostsArtistposts(widget.communityId,
                _cfanCommunityDetailModel.data!.artist![0].id.toString(), "1");
          });
        }
      },
      onFailure: (error) {},
    );
  }

  ///社群帖子
  getUserPostsCommunitposts(String communityId, String page) {
    KTLog('社群帖子$_tzflag--$_tzHasData');

    if (_tzflag && _tzHasData) {
      _tzflag = false;
      _cfanCommunityHomeProvider.userPostsCommunitposts(
        communityId,
        page,
        onSuccess: (data) {
          if (data['code'] == 200) {
            var tempList = CfanUserpostsModel.fromJson(data);
            setState(() {
              _cfanCommunityItemModelList.addAll(tempList.data!.list!);
              _tzPage++;
              _tzflag = true;
              KTLog(_cfanCommunityItemModelList.length);
            });
            //判断有没有数据
            if (tempList.data!.list!.length < 9) {
              setState(() {
                _tzHasData = false;
              });
            }
          }
        },
        onFailure: (error) {},
      );
    }
  }

  //获取社群动态
  getUserPostsArtistposts(String communityId, String artistId, String page) {
    KTLog('社群动态$_dtflag--$_dtHasData');

    if (_dtflag && _dtHasData) {
      _cfanCommunityHomeProvider.userPostsArtistposts(
        communityId,
        artistId,
        page,
        onSuccess: (data) {
          if (data['code'] == 200) {
            var tempList = CfanUserpostsModel.fromJson(data);
            setState(() {
              _cfanArtistItemModelList.addAll(tempList.data!.list!);
              _dtPage++;
              _dtflag = true;
              KTLog(_cfanArtistItemModelList.length);
            });
            //判断有没有数据
            if (tempList.data!.list!.length < 9) {
              setState(() {
                _dtHasData = false;
              });
            }
          }
        },
        onFailure: (error) {},
      );
    }
  }

  ///获取节目分类
  getProgramCategoryData() {
    _cfanCommunityHomeProvider.userPostsProgramCategory(
      onSuccess: (data) {
        if (data['code'] == 200) {
          var tempModel = CfanCommunityProgramCategoryModel.fromJson(data);
          setState(() {
            _cfanCommunityProgramCategoryItemListModel = tempModel.data ?? [];

            ///获取节目列表
            getProgramCategoryListData(
                widget.communityId,
                _cfanCommunityProgramCategoryItemListModel[0]
                    .videoType
                    .toString(),
                "1");
          });
        }
      },
      onFailure: (error) {},
    );
  }

  //获取节目列表
  getProgramCategoryListData(
      String communityId, String videoType, String page) {
    KTLog('节目列表$_flflag--$_flHasData');

    if (_flflag && _flHasData) {
      _cfanCommunityHomeProvider.userPostsProgramCategoryList(
        communityId,
        videoType,
        page,
        onSuccess: (data) {
          if (data['code'] == 200) {
            var tempData = CfanCommunityProgramListModel.fromJson(data);
            var temList = tempData.data?.list ?? [];
            setState(() {
              _cfanCommunityProgramListItemModelList.addAll(temList);
              _flPage++;
              _flflag = true;
              KTLog(_cfanCommunityProgramListItemModelList.length);
            });
            //判断有没有数据
            if (temList.length < 9) {
              setState(() {
                _flHasData = false;
              });
            }
          }
        },
        onFailure: (error) {},
      );
    }
  }

  /// 获取商品列表
  void getGoodsListData(String communityId, int page) {
    KTLog('节目列表$_spflag--$_spHasData');

    if (_spflag && _spHasData) {
      _cfanProvider.communityGoods(
        communityId,
        page,
        onSuccess: (data) {
          if (data['code'] == 200) {
            var tempData = CfanCommunityGoodsModel.fromJson(data);
            var temList = tempData.data?.list ?? [];
            setState(() {
              _cfanCommunityGoodsItemModelList.addAll(temList);
              _spPage++;
              _spflag = true;
              KTLog(_cfanCommunityGoodsItemModelList.length);
            });
            //判断有没有数据
            if (temList.length < 9) {
              setState(() {
                _spHasData = false;
              });
            }
          }
        },
        onFailure: (error) {},
      );
    }
  }

  //发送点赞
  sendUserPostsLikeData(String postsId) {
    _cfanCommunityHomeProvider.userPostsLike(
      postsId,
      onSuccess: (data) {
        if (data['code'] == 200) {
          KTLog("点赞成功");
        }
      },
      onFailure: (error) {},
    );
  }

  //签到
  _sendUserPostsQiandao() {
    _cfanCommunityHomeProvider.userPostsCommunityQiandao(
      widget.communityId,
      onSuccess: (data) {
        if (data['code'] == 200) {
          HJDialog.showAllCustomDialog(
            context,
            clickBgHidden: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                print('这是完全自定义的弹框，点击红色部分隐藏');
                Navigator.pop(context);
              },
              child: Container(
                // alignment: Alignment.topCenter,
                width: ScreenAdapter.height(300),
                height: ScreenAdapter.height(300),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: padding_5,
                      top: padding_5,
                      child: TextButton(
                        onPressed: () {
                          KTLog("关闭");
                          Navigator.pop(context);
                        },
                        child: Text(
                          "X",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    //1.弹框头像
                    Positioned(
                      left: ScreenAdapter.height(300) / 2 - padding_30,
                      top: padding_50,
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: CachedNetworkImage(
                          width: ScreenAdapter.width(60),
                          height: ScreenAdapter.width(60),
                          imageUrl:
                              (_cfanCommunityDetailModel.data?.logo != null)
                                  ? _cfanCommunityDetailModel.data!.logo!
                                  : "",
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          // imageUrl: imageUrl2,
                          placeholder: (context, url) =>
                              defaultCommunityDetailImage(),
                          errorWidget: (context, url, error) =>
                              defaultCommunityDetailImage(),
                        ),
                      ),
                    ),
                    //2.社群名称
                    Positioned(
                      left: 0,
                      right: 0,
                      top: ScreenAdapter.height(120),
                      child: Text(
                          textAlign: TextAlign.center,
                          _cfanCommunityDetailModel.data?.title ?? ""),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: ScreenAdapter.height(140),
                      child: Text(
                        "签到成功",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: ScreenAdapter.height(160),
                      child: Text(
                        "今日第${data['data']['rank_num']}名",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: ScreenAdapter.height(180),
                      child: Text(
                        "社群经验值+${data['data']['get_exp']}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
      onFailure: (error) {},
    );
  }

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

          //下拉刷新
          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(
                () {
                  if (_tabController.index == 0) {
                    _cfanCommunityItemModelList = [];
                    _tzPage = 1;
                    _tzHasData = true;
                    //获取帖子列表数据
                    getUserPostsCommunitposts(
                        widget.communityId, _tzPage.toString());
                  } else if (_tabController.index == 1) {
                    _cfanArtistItemModelList = [];
                    _dtPage = 1;
                    _dtHasData = true;
                    //获取艺人动态列表数据
                    getUserPostsArtistposts(
                      widget.communityId,
                      (_cfanCommunityDetailModel
                              .data!.artist![_artistSelectIndex].id!)
                          .toString(),
                      _dtPage.toString(),
                    );
                  } else if (_tabController.index == 2) {
                    _cfanCommunityProgramListItemModelList = [];
                    _flPage = 1;
                    _flHasData = true;
                    //获取艺人动态列表数据
                    getProgramCategoryListData(
                      widget.communityId,
                      _cfanCommunityProgramCategoryItemListModel[
                              _categorySelectIndex]
                          .videoType
                          .toString(),
                      _flPage.toString(),
                    );
                  } else if (_tabController.index == 3) {
                    KTLog("商品");
                    _cfanCommunityGoodsItemModelList = [];
                    _spPage = 1;
                    _spHasData = true;
                    //获取商品
                    getGoodsListData(
                      widget.communityId,
                      _spPage,
                    );
                  }
                },
              );
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
                  getUserPostsCommunitposts(
                      widget.communityId, _tzPage.toString());
                } else if (_tabController.index == 1) {
                  getUserPostsArtistposts(
                      widget.communityId,
                      (_cfanCommunityDetailModel
                              .data!.artist![_artistSelectIndex].id!)
                          .toString(),
                      _dtPage.toString());
                } else if (_tabController.index == 2) {
                  getProgramCategoryListData(
                      widget.communityId,
                      _cfanCommunityProgramCategoryItemListModel[
                              _categorySelectIndex]
                          .videoType
                          .toString(),
                      _flPage.toString());
                } else if (_tabController.index == 3) {
                  getGoodsListData(
                    widget.communityId,
                    _spPage,
                  );
                }
              });
            }
          });
        },
        childBuilder: (context, physics) {
          return ExtendedNestedScrollView(
            controller: _cfanCommunityHomeProvider.scrollController,
            physics: const ClampingScrollPhysics(),
            onlyOneScrollInBody: true,
            //固定tab这个头部的高度
            pinnedHeaderSliverHeightBuilder: () {
              return MediaQuery.of(context).padding.top + kToolbarHeight;
            },
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                const HeaderLocator.sliver(clearExtent: false),
                SliverAppBar(
                  //展开的高度  轮播 和 社群 控件占用高度在这设置
                  expandedHeight: ScreenAdapter.height(255),
                  //压制住不让tab划走
                  pinned: true,

                  ///添加自定义导航
                  title: _nav(),
                  backgroundColor: Colors.white,
                  elevation: 0, //去掉阴影
                  flexibleSpace: FlexibleSpaceBar(
                    //更改滚动视图往上推折叠方式引脚
                    collapseMode: CollapseMode.pin,
                    background: Container(
                      color: Colors.blue,
                      child: Stack(
                        children: [
                          //头部图片
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              color: Colors.orange,
                              child: CachedNetworkImage(
                                imageUrl:
                                    (_cfanCommunityDetailModel.data?.logo !=
                                            null)
                                        ? _cfanCommunityDetailModel.data!.logo!
                                        : "",
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                // imageUrl: imageUrl2,
                                placeholder: (context, url) =>
                                    defaultCommunityDetailImage(),
                                errorWidget: (context, url, error) =>
                                    defaultCommunityDetailImage(),
                              ),
                            ),
                          ),
                          //头部信息
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: ScreenAdapter.height(20),
                            child: Column(
                              children: [
                                Text(
                                  (_cfanCommunityDetailModel.data?.fansTotal !=
                                          null)
                                      ? "${_cfanCommunityDetailModel.data?.fansTotal}  fans"
                                      : "0 fans",
                                  style: TextStyle(
                                    color: KTColor.black,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    KTLog(
                                        _cfanCommunityDetailModel.data!.title!);

                                    ///跳转社群详情页
                                    NavigationUtil.getInstance().pushPage(
                                      context,
                                      RouterName.cfanCommunityDetailPage,
                                      widget: CfanCommunityDetailPage(
                                        communityId: widget.communityId,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    (_cfanCommunityDetailModel.data?.title !=
                                            null)
                                        ? "${_cfanCommunityDetailModel.data?.title}"
                                        : "",
                                    style: TextStyle(
                                      fontSize: ScreenAdapter.fontSize(18),
                                      fontWeight: FontWeight.bold,
                                      color: KTColor.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  (_cfanCommunityDetailModel.data?.intro !=
                                          null)
                                      ? "${_cfanCommunityDetailModel.data?.intro}"
                                      : "",
                                  style: TextStyle(
                                    color: KTColor.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Positioned(
                              right: 0,
                              top: ScreenAdapter.height(120),
                              child: InkWell(
                                onTap: () {
                                  KTLog("签到");
                                  _sendUserPostsQiandao();
                                },
                                child: Container(
                                  width: ScreenAdapter.width(60),
                                  height: ScreenAdapter.height(30),
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.calendar_month_outlined),
                                      Text("签到"),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: themeData.colorScheme.primary,
                  indicatorColor: themeData.colorScheme.primary,
                  onTap: (value) {
                    //            await Future.delayed(const Duration(seconds: 1), () {
                    //   if (mounted) {

                    //   }
                    // });
                    _selectedSubTabsIndex = value;
                    KTLog("选择的第$_selectedSubTabsIndex个tab");
                    if (_selectedSubTabsIndex == 0) {
                      //获取帖子列表数据
                      setState(() {
                        getUserPostsCommunitposts(
                          widget.communityId,
                          "1",
                        );
                      });
                    }
                    //获取艺人动态
                    if (_selectedSubTabsIndex == 1) {
                      setState(() {
                        getUserPostsArtistposts(
                            widget.communityId,
                            _cfanCommunityDetailModel.data!.artist![0].id!
                                .toString(),
                            "1");
                      });
                    }
                    //获取节目
                    else if (_selectedSubTabsIndex == 2) {
                      KTLog("节目");

                      setState(() {
                        getProgramCategoryListData(
                          widget.communityId,
                          _cfanCommunityProgramCategoryItemListModel[0]
                              .videoType
                              .toString(),
                          "1",
                        );
                      });
                    }
                  },
                  tabs: _subTabList.map((value) {
                    return Tab(
                      child: Text(
                        value['name'],
                      ),
                    );
                  }).toList(),
                ),
                //在这判断添加 动态是否显示艺人头像
                _selectedSubTabsIndex == 1
                    //如果有两个明星显示头像
                    ? _cfanCommunityDetailModel.data!.artist!.length > 1
                        ? Container(
                            // color: Colors.orange,
                            height: ScreenAdapter.height(100),
                            padding: EdgeInsets.all(ScreenAdapter.width(5)),
                            child: ListView.builder(
                              itemCount: _cfanCommunityDetailModel
                                          .data!.artist!.length >
                                      1
                                  ? _cfanCommunityDetailModel
                                      .data!.artist!.length
                                  : 0,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: _initGridViewData,
                            ),
                          )
                        : Container()
                    : Container(),
                // 节目分类
                _selectedSubTabsIndex == 2
                    ? Container(
                        // color: Colors.orange,
                        height: ScreenAdapter.height(50),
                        padding: EdgeInsets.all(ScreenAdapter.width(5)),
                        child: ListView.builder(
                          itemCount:
                              _cfanCommunityProgramCategoryItemListModel.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: _buildProgramItem,
                        ),
                      )
                    : Container(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      //帖子
                      ExtendedVisibilityDetector(
                        uniqueKey: const Key('Tab0'),
                        child: KeepAliveWrapper(
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
                                        _cfanCommunityItemModelList[index],
                                        index,
                                      );
                                    },
                                    childCount:
                                        _cfanCommunityItemModelList.length,
                                  ),
                                ),
                              ),
                              const FooterLocator.sliver(),
                            ],
                          ),
                        ),
                      ),

                      //动态
                      ExtendedVisibilityDetector(
                        uniqueKey: const Key('Tab1'),
                        child: KeepAliveWrapper(
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
                                      return _buildDynamicCell(
                                        _cfanArtistItemModelList[index],
                                        index,
                                      );

                                      // _buildGuanzhuCell(
                                      //   _cfanArtistItemModelList[index],
                                      //   index,
                                      // );
                                    },
                                    childCount: _cfanArtistItemModelList.length,
                                  ),
                                ),
                              ),
                              const FooterLocator.sliver(),
                            ],
                          ),
                        ),
                      ),

                      //节目
                      ExtendedVisibilityDetector(
                        uniqueKey: const Key('Tab2'),
                        child: KeepAliveWrapper(
                          child: CustomScrollView(
                            physics: physics,
                            slivers: [
                              SliverPadding(
                                padding: EdgeInsets.all(
                                  ScreenAdapter.height(10),
                                ),
                                sliver: SliverGrid(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      ///分类单个item
                                      return _buildProgramCell(
                                          _cfanCommunityProgramListItemModelList[
                                              index],
                                          index);
                                    },
                                    childCount:
                                        _cfanCommunityProgramListItemModelList
                                            .length,
                                  ),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: ScreenAdapter.width(10),
                                    crossAxisSpacing: ScreenAdapter.width(10),
                                    childAspectRatio: 7 / 6,
                                  ),
                                ),

                                /*
                                 SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return _buildGuanzhuCell(
                                        _cfanCommunityItemModelList[index],
                                        index);
                                  },
                                      childCount:
                                          _cfanCommunityItemModelList.length),
                                ),*/
                              ),
                              const FooterLocator.sliver(),
                            ],
                          ),
                        ),
                      ),

                      //商品
                      ExtendedVisibilityDetector(
                        uniqueKey: const Key('Tab3'),
                        child: KeepAliveWrapper(
                          child: CustomScrollView(
                            physics: physics,
                            slivers: [
                              SliverPadding(
                                padding: EdgeInsets.all(
                                  ScreenAdapter.height(10),
                                ),
                                sliver: SliverGrid(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      ///分类单个item
                                      return _buildGoodsCell(
                                          _cfanCommunityGoodsItemModelList[
                                              index],
                                          index);
                                    },
                                    childCount:
                                        _cfanCommunityGoodsItemModelList.length,
                                    // _cfanCommunityProgramListItemModelList
                                    //     .length,
                                  ),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: ScreenAdapter.width(10),
                                    crossAxisSpacing: ScreenAdapter.width(10),
                                    childAspectRatio: 4 / 5,
                                  ),
                                ),

                                /*
                                 SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return _buildGuanzhuCell(
                                        _cfanCommunityItemModelList[index],
                                        index);
                                  },
                                      childCount:
                                          _cfanCommunityItemModelList.length),
                                ),*/
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          KTLog("发帖");
          NavigationUtil.getInstance().pushPage(
            context,
            RouterName.cfanPostNesDetailPage,
            widget: CfanCommunityPublishPage(
              communityId: int.parse(widget.communityId),
            ),
          );
        },
      ),
    );
  }

  /// 单独封装动态item
  Widget _initGridViewData(context, index) {
    var tempModel = _cfanCommunityDetailModel.data?.artist?[index];
    return InkWell(
      onTap: () {
        KTLog("点击了第$index个");
        setState(() {
          //记录点击了哪个明星
          _artistSelectIndex = index;
          _dtPage = 1;
          _dtflag = true;
          _dtHasData = true;
          _cfanArtistItemModelList = [];
          getUserPostsArtistposts(
              widget.communityId, tempModel.id.toString(), "1");
        });
      },
      child: Container(
        width: ScreenAdapter.width(100),
        // height: ScreenAdapter.width(470),
        decoration: BoxDecoration(
            border: Border.all(
          color: Colors.white,
        )),
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Column(
          children: [
            Container(
              // color: Colors.green,
              width: ScreenAdapter.width(200),
              height: ScreenAdapter.width(60),
              child: CircleAvatar(
                radius: ScreenAdapter.width(60),
                backgroundImage: tempModel?.avatar != null
                    ? NetworkImage(tempModel!.avatar!)
                    : NetworkImage(tempModel!.avatar!),
              ),

              /*
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
              ),*/
            ),
            SizedBox(
              height: ScreenAdapter.height(5),
            ),
            Text(
              // tableDatList[index],
              // _cfanMycommunityItemModelList[index].title!,
              tempModel.name ?? "明星",
              maxLines: 1,
              style: TextStyle(
                fontSize: ScreenAdapter.fontSize(16),
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //构建分类标签
  Widget _buildProgramItem(context, index) {
    var tempModel = _cfanCommunityProgramCategoryItemListModel[index];

    return InkWell(
      onTap: () {
        KTLog("点击了第$index个");
        //记录点击了哪个分类标签
        _categorySelectIndex = index;

        _flPage = 1;
        _flflag = true;
        _flHasData = true;
        _cfanCommunityProgramListItemModelList = [];
        getProgramCategoryListData(
            widget.communityId,
            _cfanCommunityProgramCategoryItemListModel[_categorySelectIndex]
                .videoType
                .toString(),
            "1");
        // getUserPostsArtistposts(
        //     widget.community_id, tempModel.id.toString(), "1");
      },
      child: Padding(
        padding: EdgeInsets.all(ScreenAdapter.width(5)),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            // color: KTColor.getRandomColor(),
            border: Border.all(
              color: KTColor.back2,
              width: ScreenAdapter.width(0.5),
            ),
            borderRadius: BorderRadius.circular(
              ScreenAdapter.height(20),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(ScreenAdapter.width(5)),
            child: Text("   ${tempModel.title}   "),
          ),
        ),
      ),
    );
  }

  //自定义导航
  Widget _nav() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Padding(padding: EdgeInsets.fr)
          // Text("周杰伦社区"),
          Text((_cfanCommunityDetailModel.data?.title != null)
              ? "${_cfanCommunityDetailModel.data?.title}"
              : ""),

          Row(
            children: [
              IconButton(
                onPressed: () {
                  KTLog("个人中心");
                  NavigationUtil.getInstance().pushPage(
                    context,
                    RouterName.cfanCommunityUserinfoPage,
                    widget: CfanCommunityUserinfoPage(
                      communityId: int.parse(widget.communityId),
                    ),
                  );
                },
                icon: Icon(
                  Icons.person_rounded,
                  color: Color.fromARGB(200, 0, 0, 0),
                ),
              ),
              // Icon(
              //   Icons.search,
              //   color: Color.fromARGB(200, 0, 0, 0),
              // ),
            ],
          )
        ],
      ),
    );
  }

  //构建关注cell
  Widget _buildGuanzhuCell(CfanUserpostsItemModel itemModel, int index) {
    //是否已经点赞
    bool isAleadyLike =
        Provider.of<CfanCommunityHomeProvider>(context).zanList.any(
              (element) => element == itemModel,
            );
    return InkWell(
      child: Container(
        color: KTColor.white,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      NavigationUtil.getInstance().pushPage(
                        context,
                        RouterName.cfanPostNesDetailPage,
                        widget: CfanCommunityOntherhomeinfoPage(
                          community_id: int.parse(widget.communityId),
                          user_id: itemModel.userId ?? 0,
                        ),
                      );
                    },
                    child: Container(
                      child: CircleAvatar(
                        radius: ScreenAdapter.width(35),
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
                              itemModel.location ?? "",
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
                      collapseText: "收起", //收起
                      maxLines: 5, //最多显示行数
                      linkColor: Colors.blue,
                    ),
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
                        "周杰伦社群",
                        style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(14),
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  //添加评论 点赞
                  _bottomToolsbar(itemModel, index, isAleadyLike),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //构建动态cell
  Widget _buildDynamicCell(CfanUserpostsItemModel itemModel, int index) {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenAdapter.width(5),
      ),
      // color: KTColor.getRandomColor(),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //顶部详情头像
              InkWell(
                onTap: () {
                  KTLog("点击了动态头像");
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: ScreenAdapter.width(10),
                    right: ScreenAdapter.width(10),
                  ),
                  child: //评论头像
                      Container(
                    width: ScreenAdapter.width(35),
                    height: ScreenAdapter.width(35),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          itemModel.avatar ?? "",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   width: ScreenAdapter.width(10),
              // ),
              Expanded(
                //整体圆角背景
                child: Container(
                  margin: EdgeInsets.only(
                    top: ScreenAdapter.width(5),
                    right: ScreenAdapter.width(15),
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    //背景
                    color: Color.fromRGBO(233, 233, 233, 1),
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //1,名称 时间
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //名称
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(ScreenAdapter.width(5)),
                              child: Text(
                                itemModel.name == "" ? "周杰伦" : itemModel.name!,
                                style: TextStyle(
                                  fontSize: ScreenAdapter.width(11),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          //名时间
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(ScreenAdapter.width(5)),
                              child: Text(
                                itemModel.createTime == ""
                                    ? "周杰伦"
                                    : itemModel.createTime!,
                                style: TextStyle(
                                  fontSize: ScreenAdapter.width(11),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //2.文章 图片 视频  语音
                      Padding(
                        padding: EdgeInsets.all(
                          ScreenAdapter.width(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //2.1.单文章
                            Container(
                              alignment: Alignment.centerLeft,
                              color: Colors.transparent,
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
                              ),
                            ),
                            //2.2图片
                            Container(
                              color: Colors.amber,
                              width: double.maxFinite,
                              margin: EdgeInsets.all(ScreenAdapter.width(8)),
                              child: itemModel.picList?.length != null
                                  ? _addNinePic(itemModel.picList!)
                                  : Container(),
                            ),
                            //2.3视频
                            //2.4语音
                            //添加评论 点赞
                            // _bottomToolsbar(itemModel, index, false),
                            _dynamicTool(itemModel, index),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //构建节目cell
  Widget _buildProgramCell(
      CfanCommunityProgramListItemModel itemModel, int index) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: KTColor.getRandomColor(),
        borderRadius: BorderRadius.all(
          Radius.circular(ScreenAdapter.width(5.0)),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: CachedNetworkImage(
              imageUrl: itemModel.logo ?? "",
              fit: BoxFit.fill,
              placeholder: (context, url) => defaultBannerImage(),
              errorWidget: (context, url, error) => defaultBannerImage(),
            ),
          ),
          Expanded(
            child: Text(
              itemModel.title ?? "",
              style: TextStyle(
                fontSize: ScreenAdapter.fontSize(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //构建商品cell
  Widget _buildGoodsCell(
    CfanCommunityGoodsItemModel itemModel,
    int index,
  ) {
    return InkWell(
      onTap: () async {
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
              child: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                itemModel.name ?? "",
                style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(14),
                ),
              ),
            ),
            //商品金额
            Container(
              padding: EdgeInsets.all(
                ScreenAdapter.width(5),
              ),
              alignment: Alignment.centerLeft,
              color: Colors.amber,
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

  //帖子的关注 评论 点赞  tools
  Widget _bottomToolsbar(
      CfanUserpostsItemModel itemModel, int index, bool isAleadyLike) {
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
                  Provider.of<CfanCommunityHomeProvider>(context, listen: false)
                      .remove(itemModel);
                  //取消点赞请求
                  sendUserPostsLikeData(itemModel.postsId.toString());
                  // setState(() {
                  //   //表面点赞 + 1
                  // _addLike = 0;
                  // });
                } else {
                  //fase 所以要加入数组
                  KTLog(isAleadyLike);

                  //添加点赞数组
                  Provider.of<CfanCommunityHomeProvider>(context, listen: false)
                      .addLike(itemModel);
                  //发送点赞请求
                  sendUserPostsLikeData(itemModel.postsId.toString());
                  // setState(() {
                  //   //表面点赞 + 1
                  //   _addLike = 1;
                  // });
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
              label: Text(
                // "888",
                isAleadyLike
                    ? (itemModel.likeCount! + 1).toString()
                    : itemModel.likeCount.toString(),
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

  ///动态评论 点赞
  Widget _dynamicTool(CfanUserpostsItemModel itemModel, int index) {
    return Container(
      height: ScreenAdapter.height(40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: () {
              KTLog("评论");
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
            label: Text("111"),
          ),
          TextButton.icon(
            onPressed: () {
              KTLog("点赞");

              setState(() {
                _currentItemModel = itemModel;
              });

              _onLike();
            },
            icon: itemModel.isLike == true
                ? const Icon(
                    //已经点赞
                    Icons.thumb_up_off_alt_rounded,
                    color: Colors.black,
                  )
                : const Icon(
                    //未点赞
                    Icons.thumb_up_off_alt_outlined,
                    color: Colors.black,
                  ),
            label: Text(
              //点赞加+1 如果要改的话可以重新请求列表数据来展示
              itemModel.isLike == true
                  ? (itemModel.likeCount! + 1).toString()
                  : itemModel.likeCount.toString(),
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
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
