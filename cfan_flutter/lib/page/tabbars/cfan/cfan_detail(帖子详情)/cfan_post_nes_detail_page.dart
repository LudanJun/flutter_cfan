import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_detail(%E5%B8%96%E5%AD%90%E8%AF%A6%E6%83%85)/cfan_detail_head_widget.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_detail(%E5%B8%96%E5%AD%90%E8%AF%A6%E6%83%85)/likebutton/like_butotn.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_detail(%E5%B8%96%E5%AD%90%E8%AF%A6%E6%83%85)/likebutton/like_button_model.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_post_detail_zan.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_posts_detail_comment.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_posts_detail_model.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/tools/asset_utils/asset_utils.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/widget/toast_utils/toast_util.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math' as math;

/// 帖子详情页
class CfanPostNesDetailPage extends StatefulWidget {
  //传入帖子id
  final String postsId;
  final double cellHeight;
  const CfanPostNesDetailPage(
      {super.key, required this.postsId, required this.cellHeight});

  @override
  State<CfanPostNesDetailPage> createState() => _CfanPostNesDetailPageState();
}

class _CfanPostNesDetailPageState extends State<CfanPostNesDetailPage>
    with SingleTickerProviderStateMixin {
  final CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();
  //评论滚动控制器
  ScrollController commentScrollController = ScrollController();

  late TabController _tabController;
  //发送评论文本框
  final TextEditingController _editController = TextEditingController();
  late FocusNode myFocusNode;
  //记录是不是 true:回复评论  false:底部评论
  bool _isReply = false;
  //获取点击了哪条评论
  CfanPostsDetailCommentItemModel _commentItemModel =
      CfanPostsDetailCommentItemModel();

  //帖子详情模型
  CfanPostDetailModel _cfanPostDetailModel = CfanPostDetailModel();

  //帖子评论模型数组
  List<CfanPostsDetailCommentItemModel> _cfanPostsDetailCommentItemModelList =
      <CfanPostsDetailCommentItemModel>[];
  //帖子评论回复数组
  List<CfanPostsDetailCommentItemReplyListItemModel>
      _cfanPostsDetailCommentItemReplyListItemModelList =
      <CfanPostsDetailCommentItemReplyListItemModel>[];

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
  //评论
  int commentCurPage = 1; //评论当前页
  bool isCommentloadingMore = false; //是否显示加载中
  bool isCommenthasMore = true; //是否还有更多
  //底部点赞按钮
  bool isLiked = false;

  //帖子点赞列表
  List<CfanPostDetailZanItemModel> _cfanPostDetailZanItemModelList =
      <CfanPostDetailZanItemModel>[];
  int zanCurPage = 1; //点赞当前页
  bool isZanloadingMore = false; //是否显示加载中
  bool isZanhasMore = true; //是否还有更多
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);
    //初始化焦点
    myFocusNode = FocusNode();

    //获取帖子详情
    getPostDetailData();
    //获取详情评论
    getPostDetailcomment(1);
    //获取点赞列表
    getPostDetailZanListData(1);
  }

  //当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _tabController.dispose();
    myFocusNode.dispose(); // 记得在组件销毁时释放焦点资源
    super.dispose();
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

  ///获取帖子评论
  getPostDetailcomment(
    int page,
  ) {
    _cfanCommunityHomeProvider.userPostsDetailcomment(
      widget.postsId,
      page,
      onSuccess: (data) {
        if (data["code"] == 200) {
          var tempData = CfanPostsDetailCommentModel.fromJson(data);
          setState(() {
            _cfanPostsDetailCommentItemModelList
                .addAll(tempData.data?.list ?? []);
            isCommentloadingMore = false;
            isCommenthasMore = tempData.data!.list!.length >= 9;
            // KTLog("长度 - ${tempData.data!.list!.length}");
            // KTLog(
            //     "_cfanPostsDetailCommentItemModelList - ${_cfanPostsDetailCommentItemModelList.length}");

            // KTLog("isCommenthasMore - $isCommenthasMore");
          });
        }
      },
      onFailure: (error) {
        isCommentloadingMore = false;
        isCommenthasMore = false;
      },
    );
  }

  //获取点赞列表
  getPostDetailZanListData(
    int page,
  ) {
    _cfanCommunityHomeProvider.userPostsDetailZanList(
      int.parse(widget.postsId),
      page,
      onSuccess: (data) {
        if (data['code'] == 200) {
          var temp = CfanPostDetailZanModel.fromJson(data);
          setState(() {
            _cfanPostDetailZanItemModelList.addAll(temp.data?.list ?? []);
            isZanloadingMore = false;
            isZanhasMore = temp.data!.list!.length >= 9;
          });
        }
      },
      onFailure: (error) {},
    );
  }

  //点赞
  Future<bool> onLikeButtonTapped(
      bool isLiked, CfanPostDetailModel detailModel) async {
    final Completer<bool> completer = Completer<bool>();

    _cfanCommunityHomeProvider.userPostsLike(
      detailModel.data!.postsId.toString(),
      onSuccess: (data) {
        setState(() {
          if (data['code'] == 200) {
            //点赞成功
            if (detailModel.data!.isLike! == false) {
              KTLog("点赞成功");
              detailModel.data!.isLike = true;
              showToast("点赞成功!");
              completer.complete(false);
            } else {
              //取消点赞
              KTLog("取消点赞");
              showToast("取消点赞!");
              detailModel.data!.isLike = false;
              completer.complete(true);
            }
          }
        });
      },
      onFailure: (error) {
        if (detailModel.data!.isLike! == false) {
          completer.complete(false);
        } else {
          completer.complete(true);
        }
      },
    );
    return completer.future;
  }

  //帖子评论的点赞或取消点赞
  Future<bool> onCommentLikeButtonTapped(
      bool isLiked, CfanPostsDetailCommentItemModel commentItemModel) async {
    final Completer<bool> completer = Completer<bool>();

    _cfanCommunityHomeProvider.userPostsCommentLike(
      commentItemModel.commentId!,
      onSuccess: (data) {
        setState(() {
          if (data['code'] == 200) {
            //点赞成功
            if (commentItemModel.isLike! == false) {
              KTLog("点赞成功");
              commentItemModel.isLike = true;
              showToast("点赞成功!");
              completer.complete(false);
            } else {
              //取消点赞
              KTLog("取消点赞");
              showToast("取消点赞!");
              commentItemModel.isLike = false;
              completer.complete(true);
            }
          }
        });
      },
      onFailure: (error) {
        if (commentItemModel.isLike! == false) {
          completer.complete(false);
        } else {
          completer.complete(true);
        }
      },
    );

    return completer.future;
  }

  //发送评论
  _sendCommentData(String content, String picIds) {
    _cfanCommunityHomeProvider.userPostsDetailSendComment(
      widget.postsId,
      content,
      picIds,
      onSuccess: (data) {
        KTLog("发送消息$data");
        if (data["code"] == 200) {
          setState(() {
            showToast("评论成功!");

            // commentScrollController.animateTo(
            //   .0,
            //   duration: Duration(milliseconds: 100),
            //   curve: Curves.ease,
            // );
            commentCurPage = 1; //评论当前页
            isCommentloadingMore = false; //是否显示加载中
            isCommenthasMore = true; //是否还有更多
            _cfanPostsDetailCommentItemModelList = [];
            //发送评论成功重新获取评论数据
            getPostDetailcomment(commentCurPage);
          });
        }
      },
      onFailure: (error) {},
    );
  }

  //发送评论回复
  _sendCommentReplyData(int commentId, String content) {
    _cfanCommunityHomeProvider.userPostsDetailSendCommentReply(
      commentId,
      content,
      "",
      onSuccess: (data) {
        if (data["code"] == 200) {
          setState(() {
            showToast("评论成功!");

            // commentScrollController.animateTo(
            //   .0,
            //   duration: Duration(milliseconds: 100),
            //   curve: Curves.ease,
            // );
            commentCurPage = 1; //评论当前页
            isCommentloadingMore = false; //是否显示加载中
            isCommenthasMore = true; //是否还有更多
            _cfanPostsDetailCommentItemModelList = [];
            //发送评论成功重新获取评论数据
            getPostDetailcomment(commentCurPage);
          });
        }
      },
      onFailure: (error) {},
    );
  }

  //获取帖子评论的回复
  // _getPostCommentReplyData(int commentId, int page) {
  //   _cfanCommunityHomeProvider.userPostsDetailGetCommentReply(
  //     commentId,
  //     page,
  //     onSuccess: (data) {
  //       if (data["code"] == 200) {}
  //     },
  //     onFailure: (error) {},
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            // height: ScreenAdapter.height(100),
            child: CfanDetailHeadWidget(title: "正文"),
          ),
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: (context, bool) {
                return [
                  SliverToBoxAdapter(
                    child: Container(height: 8, color: Color(0xffEFEFEF)),
                  ),
                  //添加头部详情内容
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      child: _weiBoDetailTopWidget(),
                    ),
                  ),
                  //添加悬浮tab
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: ScreenAdapter.height(51),
                      maxHeight: ScreenAdapter.height(51),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: ScreenAdapter.height(50),
                                  // color: Colors.orange,
                                  child: TabBar(
                                    isScrollable: true,
                                    indicatorColor: Color(0xffFF3700),
                                    indicator: UnderlineTabIndicator(
                                      borderSide: BorderSide(
                                        color: Color(0xffFF3700),
                                        width: ScreenAdapter.width(2),
                                      ),
                                      //控制tabdib线的长短
                                      // insets: EdgeInsets.only(
                                      //   left: ScreenAdapter.width(10),
                                      //   right: ScreenAdapter.width(10),
                                      //   bottom: ScreenAdapter.width(7),
                                      // ),
                                    ),
                                    labelColor: Color(0xff333333),
                                    unselectedLabelColor: Color(0xff666666),
                                    labelStyle: TextStyle(
                                        fontSize: ScreenAdapter.fontSize(14),
                                        fontWeight: FontWeight.w700),
                                    unselectedLabelStyle: TextStyle(
                                        fontSize: ScreenAdapter.fontSize(14)),
                                    indicatorSize: TabBarIndicatorSize.label,
                                    controller: _tabController,
                                    onTap: (value) {},
                                    tabs: _tabList.map((value) {
                                      return Tab(
                                        child: Text(value['name']),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                /*
                                Spacer(),
                                //右边仿微博 点赞数量
                                Container(
                                  color: Colors.blue,
                                  child: Row(
                                    children: <Widget>[
                                      Text("赞",
                                          style: TextStyle(
                                              color: Color(0xff949494),
                                              fontSize: 14)),
                                      Text("222",
                                          style: TextStyle(
                                              color: Color(0xff949494),
                                              fontSize: 14)),
                                    ],
                                  ),
                                  margin: EdgeInsets.only(
                                    right: ScreenAdapter.width(15),
                                  ),
                                )
                                */
                              ],
                            ),
                            Container(
                              height: ScreenAdapter.height(0.5),
                              color: Color(0xffE6E4E3),
                              // color: Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  //添加评论内容
                  _commentWidget(),
                  //添加点赞列表
                  _zanWidget(),
                ],
              ),
            ),
          ),
          //底部工具栏
          Container(
            height: ScreenAdapter.height(50),
            color: Color(0xffF9F9F9),
            child: _detailBottom(context, _cfanPostDetailModel),
          )
        ],
      ),
    );
  }

  ///详情顶部内容
  Widget _weiBoDetailTopWidget() {
    return Container(
      color: KTColor.white,
      child: Column(
        children: [
          Row(
            children: [
              //顶部详情头像
              Container(
                child: CircleAvatar(
                  radius: ScreenAdapter.width(35),
                  backgroundImage: _cfanPostDetailModel.data?.avatar! != null
                      ? CachedNetworkImageProvider(
                          _cfanPostDetailModel.data!.avatar!,
                        )
                      : const AssetImage("assets/images/default_zjl.png"),
                ),
              ),
              SizedBox(
                width: ScreenAdapter.width(10),
              ),
              Container(
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
                    _cfanPostDetailModel.data?.content ?? "",
                    expandText: "全文", //展开
                    collapseText: "收起", //收起
                    maxLines: 5, //最多显示行数
                    linkColor: Colors.blue,
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

  //添加评论内容
  Widget _commentWidget() {
    return NotificationListener<ScrollNotification>(
      child: _cfanPostsDetailCommentItemModelList.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _cfanPostsDetailCommentItemModelList.length,
              itemBuilder: (context, index) {
                return Container(
                    // height: 100,
                    // color: KTColor.getRandomColor(),
                    child: _commentItem(
                  context,
                  _cfanPostsDetailCommentItemModelList[index],
                  index,
                ));
              },
              // controller: commentScrollController,
            )
          : Container(
              child: Center(
                child: Text(
                  "暂无评论",
                  style: TextStyle(
                    color: Color(0xff666666),
                    fontSize: ScreenAdapter.fontSize(14),
                  ),
                ),
              ),
            ),
      onNotification: (ScrollNotification scrollInfo) =>
          _onScrollNotificationcommnet(scrollInfo),
    );
  }

  _onScrollNotificationcommnet(ScrollNotification scrollInfo) {
    if (scrollInfo is UserScrollNotification &&
        scrollInfo.direction == ScrollDirection.idle) {
      // 执行滚动到底部时的逻辑
      //滑到了底部
      KTLog("评论滑到了底部");
      if (!isCommentloadingMore) {
        if (isCommenthasMore) {
          setState(() {
            isCommentloadingMore = true;
            commentCurPage += 1;
          });
          //请求加载更多数据
          Future.delayed(Duration(seconds: 1), () {
            getPostDetailcomment(commentCurPage);
          });
        } else {
          setState(() {
            isCommenthasMore = false;
          });
        }
      }
    }
    // if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {}
    return true;
  }

  //添加点赞内容
  Widget _zanWidget() {
    return NotificationListener<ScrollNotification>(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _cfanPostDetailZanItemModelList.length,
          itemBuilder: (context, index) {
            return Container(
              // height: 100,
              // color: KTColor.getRandomColor(),
              //添加每个点赞的cell
              child: _dianzanCell(
                context,
                _cfanPostDetailZanItemModelList[index],
                index,
              ),
            );
          }),
      onNotification: (ScrollNotification scrollInfo) =>
          _onScrollNotificationzan(scrollInfo),
    );
  }

  _onScrollNotificationzan(ScrollNotification scrollInfo) {
    if (scrollInfo is UserScrollNotification &&
        scrollInfo.direction == ScrollDirection.idle) {
      KTLog("点赞滑到了底部");
      if (!isZanloadingMore) {
        if (isZanhasMore) {
          setState(() {
            isZanloadingMore = true;
            zanCurPage += 1;
          });
          //请求加载更多数据
          Future.delayed(Duration(seconds: 1), () {
            getPostDetailZanListData(zanCurPage);
          });
        } else {
          setState(() {
            isZanhasMore = false;
          });
        }
      }
    }
    // if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {}
    return true;
  }

  //评论cell
  Widget _commentItem(
      context, CfanPostsDetailCommentItemModel itemmodel, index) {
    //是最后一个cell 显示加载更多
    // KTLog(index);
    // KTLog(
    //     "_cfanPostsDetailCommentItemModelList.length${_cfanPostsDetailCommentItemModelList.length}");

    if (index == _cfanPostsDetailCommentItemModelList.length - 1) {
      return _buildLoadMore(isCommentloadingMore, isCommenthasMore);
    }
    // if (itemmodel.replyList![9].content == "哥哥过") {
    // KTLog("######## ${itemmodel.replyList!.length}  ########");
    // }
    Widget? commentReplyWidget;
    //如果单个评论里的回复数量为空不显示东西
    if (itemmodel.replyCount == 0) {
    } else {
      commentReplyWidget = Container(
        padding: EdgeInsets.all(
          ScreenAdapter.width(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: itemmodel.replyList!.map((model) {
            KTLog("itemmodel.replyList! - ${itemmodel.replyList!}");
            return Container(
              child: RichText(
                text: TextSpan(
                  // text: "回复评论的名字:",
                  text: "${model.name} : ",
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(12),
                    color: const Color(0xff45587E),
                  ),
                  children: [
                    TextSpan(
                      // text: "回复评论的评论",
                      text: "${model.content}",
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(12),
                        color: const Color(0xff333333),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    /*
    //如果单个评论里的回复数量为空不显示东西
    if (itemmodel.replyCount == 0) {
    }
    //如果单个评论里的回复数量为1条显示样式
    else if (itemmodel.replyCount == 1) {
      commentReplyWidget = Container(
        padding: EdgeInsets.all(
          ScreenAdapter.width(5),
        ),
        child: RichText(
          text: TextSpan(
            text: "回复评论的名字:",
            // text: itemmodel.,
            style: TextStyle(
              fontSize: ScreenAdapter.fontSize(12),
              color: const Color(0xff45587E),
            ),
            children: <TextSpan>[
              TextSpan(
                text: "回复评论的评论",
                style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(12),
                  color: const Color(0xff333333),
                ),
              ),
            ],
          ),
        ),
      );
    }
    //如果单个评论里的回复数量为2条显示样式
    else if (itemmodel.replyCount == 2) {
      commentReplyWidget = Container(
        padding: EdgeInsets.all(
          ScreenAdapter.width(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: RichText(
                text: TextSpan(
                  text: "回复评论的名字:",
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(12),
                    color: const Color(0xff45587E),
                  ),
                  children: [
                    TextSpan(
                      text: "回复评论的评论",
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(12),
                        color: const Color(0xff333333),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: ScreenAdapter.width(3),
              ),
              child: RichText(
                text: TextSpan(
                  text: "回复评论的名字:",
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(12),
                    color: const Color(0xff45587E),
                  ),
                  children: [
                    TextSpan(
                      text: "回复评论的评论",
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(12),
                        color: const Color(0xff333333),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      commentReplyWidget = Container(
        padding: EdgeInsets.all(
          ScreenAdapter.width(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: RichText(
                text: TextSpan(
                  text: "回复评论的名字:",
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(12),
                    color: const Color(0xff45587E),
                  ),
                  children: [
                    TextSpan(
                      text: "回复评论的评论",
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(12),
                        color: const Color(0xff333333),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: ScreenAdapter.width(3),
              ),
              child: RichText(
                text: TextSpan(
                  text: "回复评论的名字:",
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(12),
                    color: const Color(0xff45587E),
                  ),
                  children: [
                    TextSpan(
                      text: "回复评论的评论",
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(12),
                        color: const Color(0xff333333),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 2),
              child: Row(
                children: <Widget>[
                  Text(
                    "共" + itemmodel.replyCount.toString() + "条回复 >",
                    style: TextStyle(
                      color: Color(0xff45587E),
                      fontSize: ScreenAdapter.fontSize(12),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
    */
    //单个评论的显示
    return Container(
      margin: EdgeInsets.only(
        top: ScreenAdapter.width(5),
      ),
      // color: KTColor.getRandomColor(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: ScreenAdapter.width(10),
                    right: ScreenAdapter.width(10),
                  ),
                  child: Stack(
                    children: [
                      //评论头像
                      Container(
                        width: ScreenAdapter.width(35),
                        height: ScreenAdapter.width(35),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.pink,
                          image: DecorationImage(
                            image: itemmodel.avatar != null
                                ? CachedNetworkImageProvider(
                                    _cfanPostDetailModel.data!.avatar!,
                                  )
                                : AssetUtils.getAssetImage("home_vertify"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          child: Image.asset(
                            width: ScreenAdapter.width(15),
                            height: ScreenAdapter.width(15),
                            AssetUtils.getAssetImage("home_vertify"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //名称  时间   评论
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    //名称
                    Center(
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Text(
                          itemmodel.name == "" ? "周杰伦" : itemmodel.name!,
                          style: TextStyle(
                            fontSize: ScreenAdapter.width(11),
                            color: Color(0xffF86119),
                          ),
                        ),
                      ),
                    ),
                    //会员图标
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: ScreenAdapter.width(5),
                        ),
                        child: Image.asset(
                          AssetUtils.getAssetImage("home_memeber"),
                          width: ScreenAdapter.width(15),
                          height: ScreenAdapter.height(13),
                        ),
                      ),
                    ),
                  ],
                ),
                //评论内容
                Container(
                  child: InkWell(
                    onTap: () {
                      KTLog("点击了评论");
                      // _getPostCommentReplyData(itemmodel.commentId!, 1);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenAdapter.width(3),
                          ),
                          child: Text(
                            itemmodel.content!,
                            style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: ScreenAdapter.fontSize(13),
                            ),
                          ),
                        ),
                        //回复评论的内容背景
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            //背景
                            color: Color(0xffF7F7F7),
                            //设置四周圆角 角度
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                          ),
                          margin: EdgeInsets.only(
                            top: itemmodel.replyCount == 0
                                ? 0
                                : ScreenAdapter.width(5),
                            right: ScreenAdapter.width(15),
                          ),
                          child: commentReplyWidget,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: ScreenAdapter.width(7),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //时间
                      Container(
                        child: Text(
                          itemmodel.createdAt!,
                          style: TextStyle(
                            color: Color(0xff909090),
                            fontSize: ScreenAdapter.fontSize(11),
                          ),
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          //评论按钮
                          InkWell(
                            onTap: () {
                              KTLog("点击了第$index个评论");
                              KTLog(
                                  "###### ${itemmodel.replyList!.length}    ######"); //弹起键盘
                              myFocusNode.requestFocus();
                              _commentItemModel = itemmodel;
                              _isReply = true;
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                right: ScreenAdapter.width(15),
                              ),
                              child: Image.asset(
                                AssetUtils.getAssetImage("icon_comment"),
                                width: ScreenAdapter.width(15),
                                height: ScreenAdapter.width(15),
                              ),
                            ),
                          ),
                          // //点赞按钮
                          // InkWell(
                          //   onTap: () {
                          //     KTLog("点的第$index个赞");
                          //   },
                          //   child: Container(
                          //     margin: EdgeInsets.only(
                          //       right: ScreenAdapter.width(15),
                          //     ),
                          //     child: Image.asset(
                          //       AssetUtils.getAssetImage("icon_like"),
                          //       width: ScreenAdapter.width(15),
                          //       height: ScreenAdapter.width(15),
                          //     ),
                          //   ),
                          // ),
                          // LikeButton(
                          //   //这个跳转进来会红一下屏幕
                          //   isLiked:
                          //       (_cfanPostDetailModel.data?.isLike ?? false) ==
                          //           true,
                          //   onTap: (isLiked) {
                          //     return onLikeButtonTapped(
                          //         isLiked, _cfanPostDetailModel);
                          //   },
                          //   // size: ScreenAdapter.width(25),
                          //   circleColor: CircleColor(
                          //       start: Colors.orange, end: Colors.deepOrange),
                          //   bubblesColor: BubblesColor(
                          //     dotPrimaryColor: Colors.orange,
                          //     dotSecondaryColor: Colors.deepOrange,
                          //   ),
                          //   likeBuilder: (bool isLiked) {
                          //     return Image.asset(
                          //       AssetUtils.getAssetImage(
                          //           isLiked ? "ic_home_liked" : "ic_home_like"),
                          //       width: ScreenAdapter.width(15),
                          //       height: ScreenAdapter.width(15),
                          //     );
                          //   },
                          //   likeCount: 0,
                          //   countBuilder: (likeCount, isLiked, text) {
                          //     var color =
                          //         isLiked ? Colors.orange : Colors.black;
                          //     Widget result;
                          //     if (likeCount == 0) {
                          //       result = Text(
                          //         "",
                          //         style: TextStyle(color: color, fontSize: 13),
                          //       );
                          //     } else
                          //       result = Text(
                          //         text,
                          //         style: TextStyle(color: color, fontSize: 13),
                          //       );
                          //     return result;
                          //   },
                          // )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: ScreenAdapter.width(7),
                  ),
                  height: 0.5,
                  color: Color(0xffE6E4E3),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  //评论加载更多
  Widget _buildLoadMore(isloadingMore, ishasMore) {
    return isloadingMore
        ? Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: ScreenAdapter.width(10)),
                      child: SizedBox(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                        height: ScreenAdapter.width(12),
                        width: ScreenAdapter.width(12),
                      ),
                    ),
                    Text("加载中..."),
                  ],
                ),
              ),
            ),
          )
        : Container(
            child: ishasMore
                ? Container()
                : Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        "没有更多数据",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ),
          );
  }

  ///添加 点赞cell
  Widget _dianzanCell(context, CfanPostDetailZanItemModel itemModel, index) {
    if (index == _cfanPostDetailZanItemModelList.length) {
      return _buildLoadMore(isZanloadingMore, isZanhasMore);
    }

    return Container(
      margin: EdgeInsets.only(
        top: ScreenAdapter.width(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: ScreenAdapter.width(10),
                    right: ScreenAdapter.width(10),
                  ),
                  child: Stack(
                    children: [
                      //头像
                      Container(
                        width: ScreenAdapter.width(35),
                        height: ScreenAdapter.width(35),
                        decoration: BoxDecoration(
                          //形状圆形
                          shape: BoxShape.circle,
                          color: Colors.pink,
                          image: DecorationImage(
                            image: itemModel.avatar != null
                                ? CachedNetworkImageProvider(itemModel.avatar!)
                                : AssetImage(
                                    AssetUtils.getAssetImage("default_zjl"),
                                  ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      //头像上带个小图标
                      Positioned(
                        //定位组件
                        right: 0,
                        bottom: 0,
                        child: Container(
                          child: Image.asset(
                            width: ScreenAdapter.width(15),
                            height: ScreenAdapter.width(15),
                            AssetUtils.getAssetImage("home_vertify"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //名称 图标  时间 底部横线
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenAdapter.height(5),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //名称
                    Center(
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Text(
                          itemModel.name != "" ? itemModel.name! : "周杰伦",
                          style: TextStyle(
                            fontSize: ScreenAdapter.width(11),
                            color: Color(0xffF86119),
                          ),
                        ),
                      ),
                    ),
                    //会员图标
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: ScreenAdapter.width(5),
                        ),
                        child: Image.asset(
                          AssetUtils.getAssetImage("home_memeber"),
                          width: ScreenAdapter.width(15),
                          height: ScreenAdapter.height(13),
                        ),
                      ),
                    ),
                    const Spacer(),
                    //名称
                    Center(
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Text(
                          itemModel.name != "" ? itemModel.name! : "周杰伦",
                          style: TextStyle(
                            fontSize: ScreenAdapter.width(11),
                            color: Color(0xffF86119),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenAdapter.width(15),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenAdapter.height(5),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: ScreenAdapter.width(7),
                    right: ScreenAdapter.width(15),
                  ),
                  height: 0.5,
                  color: Color(0xffE6E4E3),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  //详情底部搜索 点赞工具栏
  Widget _detailBottom(
      BuildContext context, CfanPostDetailModel _cfanPostDetailModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buidSearch(),
        LikeButton(
          //这个跳转进来会红一下屏幕
          isLiked: (_cfanPostDetailModel.data?.isLike ?? false) == true,
          onTap: (isLiked) {
            return onLikeButtonTapped(isLiked, _cfanPostDetailModel);
          },
          // size: ScreenAdapter.width(25),
          circleColor:
              CircleColor(start: Colors.orange, end: Colors.deepOrange),
          bubblesColor: BubblesColor(
            dotPrimaryColor: Colors.orange,
            dotSecondaryColor: Colors.deepOrange,
          ),
          likeBuilder: (bool isLiked) {
            return Image.asset(
              AssetUtils.getAssetImage(
                  isLiked ? "ic_home_liked" : "ic_home_like"),
              width: ScreenAdapter.width(21),
              height: ScreenAdapter.width(21),
            );
          },
          likeCount: 0,
          countBuilder: (likeCount, isLiked, text) {
            var color = isLiked ? Colors.orange : Colors.black;
            Widget result;
            if (likeCount == 0) {
              result = Text(
                "",
                style: TextStyle(color: color, fontSize: 13),
              );
            } else
              result = Text(
                text,
                style: TextStyle(color: color, fontSize: 13),
              );
            return result;
          },
        )
      ],
    );
  }

  //构建搜索框
  buidSearch() {
    Widget SearchWidget = Container(
      margin: EdgeInsets.all(5),
      width: ScreenAdapter.width(200),
      height: ScreenAdapter.height(40),
      decoration: BoxDecoration(
        color: Color.fromRGBO(238, 238, 238, 1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: ScreenAdapter.width(10),
          ),
          Expanded(
            child: TextField(
              // autofocus: true, //表示进入到页面后就弹起键盘
              enabled: true, // 确保TextField可编辑
              focusNode: myFocusNode,
              onTap: () {
                KTLog("点击了文本框");
                myFocusNode.requestFocus();
              },
              controller: _editController,
              textAlign: TextAlign.start,
              decoration: const InputDecoration(
                hintText: "发送评论", //提示信息
                border: InputBorder.none, //去掉下划线
              ),
              // maxLines: 1,
              //修改键盘为发送按钮
              textInputAction: TextInputAction.send,
              //输入框内容改变
              onChanged: (value) {
                KTLog(value);
                setState(() {});
              },
              onEditingComplete: () {
                //是回复评论
                if (_isReply == true) {
                  KTLog("评论回复");
                  _sendCommentReplyData(
                      _commentItemModel.commentId!, _editController.text);
                  _isReply = false;
                } else {
                  //这里触发发送评论的请求
                  _sendCommentData(
                    _editController.text,
                    "",
                  );
                }
                //收起键盘
                FocusScope.of(context).requestFocus(FocusNode());
                _editController.clear();
              },
            ),
          ),
        ],
      ),
    );
    return SearchWidget;
  }

/************************************************** */
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
