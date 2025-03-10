import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/login/listData.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_posts_detail_model.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/tools/asset_utils/asset_utils.dart';
import 'package:cfan_flutter/tools/keepAliveWrapper.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/widget/image/default_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//帖子详情
class CfanPostDetailPage extends StatefulWidget {
  //传入帖子id
  final String postsId;
  final double cellHeight;
  const CfanPostDetailPage(
      {super.key, required this.postsId, required this.cellHeight});

  @override
  State<CfanPostDetailPage> createState() => _CfanPostDetailPageState();
}

class _CfanPostDetailPageState extends State<CfanPostDetailPage>
    with SingleTickerProviderStateMixin {
  final CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();
  late TabController _tabController;
  //帖子详情模型
  CfanPostDetailModel _cfanPostDetailModel = CfanPostDetailModel();

  ///tab 标签数据
  final List<Map<String, dynamic>> _tabList = [
    {
      'id': 1,
      'name': '评论',
    },
    {
      'id': 2,
      'name': '点赞',
    },
  ];
  //tab切换选择的标签
  int _selectedTabsIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);

    getPostDetailData();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  ///获取帖子详情
  getPostDetailData() {
    _cfanCommunityHomeProvider.userPostsDetail(
      widget.postsId,
      onSuccess: (data) {
        if (data['code'] == 200) {
          if (data != null) {
            var tempModel = CfanPostDetailModel.fromJson(data);
            setState(() {
              _cfanPostDetailModel = tempModel;
            });
          }
        }
      },
      onFailure: (error) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("帖子正文"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert_outlined),
          ),
        ],
      ),
      //必须添加TabBarView才能使用刷新
      body: 
      EasyRefresh.builder(
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
          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() {});
            }
          });
        },
        onLoad: () async {
          KTLog("上拉加载");
          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() {});
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
              return MediaQuery.of(context).padding.top;
            },

            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                const HeaderLocator.sliver(clearExtent: false),
                SliverAppBar(
                  //设置导航高度为0 这样tab就可以顶到导航栏下面了
                  toolbarHeight: 0,
                  //展开的高度  轮播 和 社群 控件占用高度在这设置
                  //fix 如何动态解决高度问题
                  //需要从外面传进来相关cell高度 试试
                  expandedHeight: ScreenAdapter.height(widget.cellHeight - 35),
                  //压制住不让tab划走
                  pinned: true,
                  ///添加自定义导航
                  // title: _nav(),
                  ///隐藏左边返回按钮
                  leading: Container(),
                  backgroundColor: Colors.orange,
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
                              color: Colors.red,
                              child: _headContent(),
                            ),
                          ),
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
                  onTap: (value) {},
                  tabs: _tabList.map((value) {
                    return Tab(
                      child: Text(value['name']),
                    );
                  }).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      NotificationListener<ScrollNotification>(
                        child: ExtendedVisibilityDetector(
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
                                        Widget? mCommentReplyWidget;
                                        //如果评论里的回复评论数为0 什么都不显示
                                        // if (mCommentList[index]
                                        //         .commentreplynum ==
                                        //     0) {}
                                        //如果评论里的回复评论数为1

                                        mCommentReplyWidget = new Container(
                                          padding: EdgeInsets.all(5),
                                          child: RichText(
                                            text: TextSpan(
                                              // text: mCommentList[index]
                                              //         .commentreply[0]
                                              //         .fromuname +
                                              //     ": ",
                                              text: "周杰伦:",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Color(0xff45587E)),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  // text: mCommentList[index]
                                                  //     .commentreply[0]
                                                  //     .content,
                                                  text: "我出新专辑了",
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Color(0xff333333)),
                                                )
                                              ],
                                            ),
                                          ),
                                        );

                                        //如果是最后一条评论了 上拉显示加载更多内容
                                        // if (index == mCommentList.length + 1) {
                                        //   return buildCommentLoadMore();
                                        // }
                                        //评论
                                        return Container(
                                          color: KTColor.getRandomColor(),
                                          height: 100,
                                          child: Container(),
                                        );
                                      },
                                      childCount: 10,
                                    ),
                                  ),
                                ),
                                const FooterLocator.sliver(),
                              ],
                            ),
                          ),
                        ),
                        // 评论监听滑动
                        // onNotification: (notification) => ,
                      ),
                      //评论
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
                                    //评论
                                    return Container(
                                      color: KTColor.getRandomColor(),
                                      height: 100,
                                      child: Container(),

                                      /*
                                       Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: CircleAvatar(
                                                radius: ScreenAdapter.width(35),
                                                backgroundImage: _cfanPostDetailModel
                                                            .data?.avatar! !=
                                                        null
                                                    ? CachedNetworkImageProvider(
                                                        _cfanPostDetailModel
                                                            .data!.avatar!,
                                                      )
                                                    : const AssetImage(
                                                        "assets/images/default_zjl.png"),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              color: Colors.red,
                                              child: Column(
                                                children: [
                                                  Container(
                                                      color: Colors.orange,
                                                      // height:
                                                      //     ScreenAdapter.height(
                                                      //         99),
                                                      child: Column(
                                                        children: [
                                                          //名字 图标
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width:
                                                                    ScreenAdapter
                                                                        .width(
                                                                            10),
                                                              ),
                                                              Text("超级小baby"),
                                                              SizedBox(
                                                                width:
                                                                    ScreenAdapter
                                                                        .width(
                                                                            10),
                                                              ),
                                                              Icon(Icons
                                                                  .ac_unit),
                                                            ],
                                                          ),

                                                          //第一楼 时间 地点 评论 点赞
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width:
                                                                    ScreenAdapter
                                                                        .width(
                                                                            10),
                                                              ),
                                                              Text("超级小baby"),
                                                              SizedBox(
                                                                width:
                                                                    ScreenAdapter
                                                                        .width(
                                                                            10),
                                                              ),
                                                              Spacer(),
                                                              Icon(Icons
                                                                  .ac_unit),
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  Divider(
                                                    color: Colors.black54,
                                                    height:
                                                        ScreenAdapter.height(
                                                            0.5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),*/
                                    );
                                  }, childCount: 10),
                                ),
                              ),
                              const FooterLocator.sliver(),
                            ],
                          ),
                        ),
                      ),

                      //点赞
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
                                      //点赞
                                      return Container(
                                        color: KTColor.getRandomColor(),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: CircleAvatar(
                                                  radius:
                                                      ScreenAdapter.width(35),
                                                  backgroundImage: _cfanPostDetailModel
                                                              .data?.avatar! !=
                                                          null
                                                      ? CachedNetworkImageProvider(
                                                          _cfanPostDetailModel
                                                              .data!.avatar!,
                                                        )
                                                      : const AssetImage(
                                                          "assets/images/default_zjl.png"),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                color: Colors.red,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      color: Colors.orange,
                                                      height:
                                                          ScreenAdapter.height(
                                                              99),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: ScreenAdapter
                                                                .width(10),
                                                          ),
                                                          Text("超级小baby"),
                                                          SizedBox(
                                                            width: ScreenAdapter
                                                                .width(10),
                                                          ),
                                                          Icon(Icons.ac_unit),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      color: Colors.black54,
                                                      height:
                                                          ScreenAdapter.height(
                                                              0.5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                // color: Colors.green,
                                                child: Text("三天前"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    childCount: 10,
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
        },
      ),
    );
  }
  //头部 内容
  Widget _headContent() {
    return Container(
      color: KTColor.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: CircleAvatar(
                    radius: ScreenAdapter.width(35),
                    backgroundImage: _cfanPostDetailModel.data?.avatar! != null
                        ? CachedNetworkImageProvider(
                            _cfanPostDetailModel.data!.avatar!,
                          )
                        : const AssetImage("assets/images/default_zjl.png"),
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
                      //名字
                      Text(
                        _cfanPostDetailModel.data?.name ?? "",
                        // "周杰伦",
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
                          //时间
                          Text(
                            _cfanPostDetailModel.data?.createTime ?? "",
                            // "2024年06月19日",
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
              /*
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerRight,
                  // color: Colors.green,
                  child: Icon(Icons.more_vert_outlined),
                ),
              ),
              */
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
                  child: Expanded(
                    child: ExpandableText(
                      _cfanPostDetailModel.data?.content ?? "",
                      expandText: "全文", //展开
                      collapseText: "收起", //收起
                      maxLines: 1000, //最多显示行数
                      linkColor: Colors.blue,
                    ),
                  ),
                ),

                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.all(ScreenAdapter.width(8)),
                  child:
                      // _addNinePic(
                      //   [imageUrl1],
                      // ),

                      _cfanPostDetailModel.data?.picList?.length != null
                          ? _addNinePic(
                              _cfanPostDetailModel.data?.picList ?? [])
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
              ],
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
