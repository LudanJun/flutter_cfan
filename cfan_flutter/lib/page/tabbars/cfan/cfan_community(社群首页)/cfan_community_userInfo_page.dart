import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_expinfo_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_fans_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_guanzhu_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/widget/public_widget/cfan_community_userInfo_head.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_commuity_userInfo.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_userPosts_list_model.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/widget/toast_utils/toast_util.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

///社群个人信息页面
class CfanCommunityUserinfoPage extends StatefulWidget {
  ///传入社群id
  final int communityId;
  const CfanCommunityUserinfoPage({super.key, required this.communityId});

  @override
  State<CfanCommunityUserinfoPage> createState() =>
      _CfanCommunityUserinfoPageState();
}

class _CfanCommunityUserinfoPageState extends State<CfanCommunityUserinfoPage>
    with SingleTickerProviderStateMixin {
  final CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();

  late TabController _tabController;
  //发送评论文本框
  final TextEditingController _editController = TextEditingController();
  late FocusNode myFocusNode;

  //用户信息模型
  CfanCommuityUserinfoItemModel _cfanCommuityUserinfoItemModel =
      CfanCommuityUserinfoItemModel();
  double _progressValue = 0.0; //进度值
  ///tab 标签数据
  final List<Map<String, dynamic>> _tabList = [
    {
      'id': 1,
      'name': '我的帖子',
    },
    {
      'id': 2,
      'name': '我赞过的',
    },
  ];

  //我的帖子
  List<CfanUserpostsItemModel> _mypostsItemModelList =
      <CfanUserpostsItemModel>[];
  //当前我的帖子的赞操作的item
  CfanUserpostsItemModel? _currentItemModel = CfanUserpostsItemModel();
  int postsCurPage = 1; //帖子当前页
  bool isPostsloadingMore = false; //是否显示加载中
  bool isPostshasMore = true; //是否还有更多

  //我的帖子
  List<CfanUserpostsItemModel> _myZanItemModelList = <CfanUserpostsItemModel>[];
  //当前我的帖子的赞操作的item
  CfanUserpostsItemModel? _currentZanItemModel = CfanUserpostsItemModel();
  int zanCurPage = 1; //帖子当前页
  bool isZanloadingMore = false; //是否显示加载中
  bool isZanhasMore = true; //是否还有更多

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);
    //初始化焦点
    myFocusNode = FocusNode();

    ///获取自己在社群中的信息
    getUseInfoDetailData();
    //获取自己在社群下的帖子
    getUserSelfPosts(1);
    //获取自己在社群下的点赞帖子
    getUserSelfLikePosts(1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
    myFocusNode.dispose(); // 记得在组件销毁时释放焦点资源
  }

  //获取自己在社群下的帖子
  getUserSelfPosts(int page) {
    _cfanCommunityHomeProvider.userPostsCommunitySelfposts(
      widget.communityId,
      page,
      onSuccess: (data) {
        if (data['code'] == 200) {
          var tempdata = CfanUserpostsModel.fromJson(data);
          setState(() {
            _mypostsItemModelList.addAll(tempdata.data?.list ?? []);
            isPostsloadingMore = false;
            isPostshasMore = tempdata.data!.list!.length >= 9;
          });
        }
      },
      onFailure: (error) {
        isPostsloadingMore = false;
        isPostshasMore = false;
      },
    );
  }

  //获取自己在社群下的点赞帖子
  getUserSelfLikePosts(int page) {
    _cfanCommunityHomeProvider.userPostsCommunitySelfLikeposts(
      widget.communityId,
      page,
      onSuccess: (data) {
        if (data['code'] == 200) {
          var tempdata = CfanUserpostsModel.fromJson(data);
          setState(() {
            _myZanItemModelList.addAll(tempdata.data?.list ?? []);
            isZanloadingMore = false;
            isZanhasMore = tempdata.data!.list!.length >= 9;
          });
        }
      },
      onFailure: (error) {
        isZanloadingMore = false;
        isZanhasMore = false;
      },
    );
  }

  ///获取自己在社群中的信息
  getUseInfoDetailData() {
    _cfanCommunityHomeProvider.userPostsCommunityUserInfoDetail(
      widget.communityId.toString(),
      onSuccess: (data) {
        if (data['code'] == 200) {
          if (data != null) {
            var tempModel = CfanCommuityUserinfoModel.fromJson(data);
            setState(() {
              _cfanCommuityUserinfoItemModel =
                  tempModel.data ?? CfanCommuityUserinfoItemModel();

              _editController.text = _cfanCommuityUserinfoItemModel.name ?? "";

              //计算经验进度条值
              double vvv1 = _cfanCommuityUserinfoItemModel.userExp! / 1.0;
              double vvv2 = _cfanCommuityUserinfoItemModel.nextLevelExp! / 1.0;
              _progressValue = vvv1 / vvv2;
              KTLog(_progressValue);
            });
          }
        }
      },
      onFailure: (error) {},
    );
  }

  ///编辑名称
  _editUserInfoNameData(String name) {
    _cfanCommunityHomeProvider.userPostsCommunityEditnickname(
      widget.communityId.toString(),
      name,
      onSuccess: (data) {
        if (data['code'] == 200) {
          showToast("修改成功");
        } else {
          showToast("数据异常");
        }
      },
      onFailure: (error) {
        showToast("修改失败");
      },
    );
  }

  //退出社群
  void _quitCommunityData() {
    _cfanCommunityHomeProvider.userPostsCommunityQuitcommunity(
      widget.communityId.toString(),
      onSuccess: (data) {
        if (data['code'] == 200) {
          showToast("退出社群成功!");
        } else {
          showToast("退出失败!");
        }
      },
      onFailure: (error) {
        showToast("退出失败!");
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            // height: ScreenAdapter.height(100),
            child: CfanCommunityUserinfoHeadPage(
              title: "xxx社群",
              rightBtnClick: () {
                KTLog("退出社群");
                _quitCommunityData();
                //退出到根
                NavigationUtil.getInstance().popUntil(RouterName.indexPage);
              },
            ),
          ),
          Expanded(
            //在列组件中 添加scrollview  需要在外部添加一个Expanded组件
            child: NestedScrollView(
              headerSliverBuilder: (context, inbool) {
                return [
                  SliverToBoxAdapter(
                    child: Container(height: 8, color: Color(0xffEFEFEF)),
                  ),
                  //添加头部详情内容
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      child: _buildHeadView(),
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
                        color: Colors.orange,
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Color(0xff333333),
                          unselectedLabelColor: Color(0xff666666),
                          indicatorColor: Color(0xffFF3700),
                          unselectedLabelStyle:
                              TextStyle(fontSize: ScreenAdapter.fontSize(14)),
                          indicatorSize: TabBarIndicatorSize.label,
                          onTap: (value) {},
                          tabs: _tabList.map((value) {
                            return Tab(
                              child: Text(
                                value['name'],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildMyPostsWidget(),
                  _buildMyZanWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //构建头部视图
  Widget _buildHeadView() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //1.社群内昵称
              _buildHeadSubEditView("社区内名称"),
              //2.加入时长
              _buildHeadSubContentView(
                  "加入时长",
                  "${_cfanCommuityUserinfoItemModel.joinDay.toString()} 天",
                  _cfanCommuityUserinfoItemModel.joinTime ?? ""),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //3.社群内关注

              InkWell(
                onTap: () {
                  ///跳转社群内关注页
                  NavigationUtil.getInstance().pushPage(
                    context,
                    RouterName.cfanCommunityGuanzhuPage,
                    widget: CfanCommunityGuanzhuPage(
                      community_id: widget.communityId,
                    ),
                  );
                },
                child: _buildHeadSubContentView(
                  "社群内关注",
                  "${_cfanCommuityUserinfoItemModel.watchNum.toString()} 个",
                  "",
                ),
              ),

              InkWell(
                onTap: () {
                  ///跳转社群内粉丝页
                  NavigationUtil.getInstance().pushPage(
                    context,
                    RouterName.cfanCommunityFansPage,
                    widget: CfanCommunityFansPage(
                      community_id: widget.communityId,
                    ),
                  );
                },
                child: _buildHeadSubContentView(
                  "社群内粉丝数量",
                  "${_cfanCommuityUserinfoItemModel.fansNum.toString()} 个",
                  "",
                ),
              )

              //4.社群内粉丝数量
            ],
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(
                  ScreenAdapter.width(5),
                ),
                child: Text(
                  "社群等级",
                  textAlign: TextAlign.left,
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: ScreenAdapter.width(5),
              ),
              //1.等级名称
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
                    Icon(Icons.ac_unit_outlined),
                    Text("等级名称"),
                  ],
                ),
              ),
              SizedBox(
                width: ScreenAdapter.width(15),
              ),

              //2.经验条
              Container(
                width: ScreenAdapter.getScreenWidth() / 2,
                // decoration: BoxDecoration(
                //   color: Colors.amberAccent,
                //   borderRadius: BorderRadius.circular(10),
                // ),
                child: Stack(
                  children: [
                    // 圆角矩形剪裁（`ClipRRect`）组件，使用圆角矩形剪辑其子项的组件。
                    ClipRRect(
                      // 边界半径（`borderRadius`）属性，圆角的边界半径。
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: LinearProgressIndicator(
                        value: _progressValue, // 进度条的当前值，0.0表示0%，1.0表示100%。
                        minHeight: ScreenAdapter.height(15),
                      ),
                    ),
                    Positioned(
                      left: 30.0, // 文字距离进度条左侧的距离
                      top: 0.0, // 文字距离进度条顶部的距离
                      child: Text(
                        '${_cfanCommuityUserinfoItemModel.userExp}/${_cfanCommuityUserinfoItemModel.nextLevelExp}', // 显示的文本
                        style: TextStyle(
                          color: Colors.black, // 文字颜色
                          fontSize: 12.0, // 文字大小
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //3.
              TextButton(
                onPressed: () {
                  KTLog("明细");

                  ///跳转社群明细
                  NavigationUtil.getInstance().pushPage(
                    context,
                    RouterName.cfanCommunityFansPage,
                    widget: CfanCommunityExpinfoPage(
                      community_id: widget.communityId,
                    ),
                  );
                },
                child: Text("明细>"),
              ),
            ],
          )
        ],
      ),
    );
  }

  //头部四个小控件封装 带编辑的
  Widget _buildHeadSubEditView(
    String title,
  ) {
    return Container(
      padding: EdgeInsets.all(
        ScreenAdapter.width(5),
      ),
      width: ScreenAdapter.getScreenWidth() / 2,
      // color: KTColor.getRandomColor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          SizedBox(
            height: ScreenAdapter.height(10),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(
                    ScreenAdapter.width(5),
                  ),
                  width: ScreenAdapter.getScreenWidth() / 2 -
                      ScreenAdapter.width(20),
                  height: ScreenAdapter.height(50),
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(
                      ScreenAdapter.width(5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: ScreenAdapter.getScreenWidth() / 2 / 2,
                        child: TextField(
                          onTap: () {
                            KTLog("点击了文本框");
                          },
                          maxLines: 1,
                          focusNode: myFocusNode,
                          controller: _editController,
                          textAlign: TextAlign.start,
                          //修改键盘为发送按钮
                          textInputAction: TextInputAction.send,
                          //输入框内容改变
                          onChanged: (value) {
                            KTLog(value);
                            setState(() {});
                          },
                          onEditingComplete: () {
                            KTLog("编辑完成");
                            _editUserInfoNameData(_editController.text);
                            //收起键盘
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          myFocusNode.requestFocus();
                        },
                        icon: Icon(Icons.edit_note_rounded),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //不带编辑
  Widget _buildHeadSubContentView(
    String title,
    String content,
    String strTime,
  ) {
    return Container(
      padding: EdgeInsets.all(
        ScreenAdapter.width(5),
      ),
      width: ScreenAdapter.getScreenWidth() / 2,
      // color: KTColor.getRandomColor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          SizedBox(
            height: ScreenAdapter.height(10),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(
                    ScreenAdapter.width(5),
                  ),
                  width: ScreenAdapter.getScreenWidth() / 2 -
                      ScreenAdapter.width(20),
                  height: ScreenAdapter.height(50),
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(
                      ScreenAdapter.width(5),
                    ),
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        content,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: ScreenAdapter.width(15),
                      ),
                      Text(
                        strTime,
                        style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(12),
                        ),
                      ), //文本框
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  //添加我的帖子
  Widget _buildMyPostsWidget() {
    return NotificationListener<ScrollNotification>(
      child: _mypostsItemModelList.isNotEmpty == true
          ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _mypostsItemModelList.length,
              itemBuilder: (context, index) {
                var itemmodel = _mypostsItemModelList[index];
                return Container(
                  child:
                      //  _commentItem(
                      //   context,
                      //   _cfanPostsDetailCommentItemModelList[index],
                      //   index,
                      // ),
                      _postsItem(
                    context,
                    itemmodel,
                    index,
                    _mypostsItemModelList,
                    isPostsloadingMore,
                    isPostshasMore,
                  ),
                );
              },
            )
          : Container(
              child: Center(
                child: Text(
                  "暂无数据",
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
        scrollInfo.direction == ScrollDirection.forward) {
      KTLog("下拉了");
    } else if (scrollInfo is UserScrollNotification &&
        scrollInfo.direction == ScrollDirection.idle) {
      // 执行滚动到底部时的逻辑
      //滑到了底部
      KTLog("评论滑到了底部");
      if (!isPostsloadingMore) {
        if (isPostshasMore) {
          setState(() {
            isPostsloadingMore = true;
            postsCurPage += 1;
          });
          //请求加载更多数据
          Future.delayed(Duration(seconds: 1), () {
            getUserSelfPosts(postsCurPage);
          });
        } else {
          setState(() {
            isPostshasMore = false;
          });
        }
      }
    }
    return true;
  }

  //添加我的赞帖子
  Widget _buildMyZanWidget() {
    return NotificationListener<ScrollNotification>(
      child: _myZanItemModelList.isNotEmpty == true
          ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _myZanItemModelList.length,
              itemBuilder: (context, index) {
                var itemmodel = _myZanItemModelList[index];
                return Container(
                  child:
                      //  _commentItem(
                      //   context,
                      //   _cfanPostsDetailCommentItemModelList[index],
                      //   index,
                      // ),
                      _postsItem(
                    context,
                    itemmodel,
                    index,
                    _myZanItemModelList,
                    isZanloadingMore,
                    isZanhasMore,
                  ),
                );
              },
            )
          : Container(
              child: Center(
                child: Text(
                  "暂无数据",
                  style: TextStyle(
                    color: Color(0xff666666),
                    fontSize: ScreenAdapter.fontSize(14),
                  ),
                ),
              ),
            ),
      onNotification: (ScrollNotification scrollInfo) =>
          _onScrollNotificationzan(scrollInfo),
    );
  }

  _onScrollNotificationzan(ScrollNotification scrollInfo) {
    if (scrollInfo is UserScrollNotification &&
        scrollInfo.direction == ScrollDirection.forward) {
      KTLog("下拉了");
    } else if (scrollInfo is UserScrollNotification &&
        scrollInfo.direction == ScrollDirection.idle) {
      // 执行滚动到底部时的逻辑
      //滑到了底部
      KTLog("评论滑到了底部");
      if (!isZanloadingMore) {
        if (isZanhasMore) {
          setState(() {
            isZanloadingMore = true;
            zanCurPage += 1;
          });
          //请求加载更多数据
          Future.delayed(Duration(seconds: 1), () {
            getUserSelfLikePosts(zanCurPage);
          });
        } else {
          setState(() {
            isZanhasMore = false;
          });
        }
      }
    }
    return true;
  }

  Widget _postsItem(
      context,
      CfanUserpostsItemModel itemModel,
      int index,
      List<CfanUserpostsItemModel> _mypostsItemModelList,
      isloadingMore,
      ishasMore) {
    if (index == _mypostsItemModelList.length - 1) {
      return _buildLoadMore(isloadingMore, ishasMore);
    }
    return InkWell(
      child: Container(
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
                      backgroundImage: NetworkImage(itemModel.avatar ?? ""),
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
                        // 名字
                        // Text(
                        //   itemModel.name!,
                        //   // "名字",
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
                              // "2024年06月26日",
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
                      // itemModel.content!,
                      "撒力大无穷你到哪了那是到哪;安的;啊是的呢;啊是的呢;按你说的",
                      // textAlign: TextAlign.left,

                      expandText: "全文", //展开
                      collapseText: "收起", //收起
                      maxLines: 5, //最多显示行数
                      linkColor: Colors.blue,
                    ),
                  ),

                  //2.九宫图
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.all(ScreenAdapter.width(8)),
                    child: itemModel.picList?.length != null
                        ? _addNinePic(itemModel.picList!)
                        : Container(),
                  ),

                  //4.视频

                  //5.社群来源 不需要
                  // Row(
                  //   children: [
                  //     const Icon(Icons.safety_check_outlined),
                  //     Text(
                  //       // "周杰伦社群",
                  //       itemModel.communityName ?? "",
                  //       style: TextStyle(
                  //         fontSize: ScreenAdapter.fontSize(14),
                  //         color: Colors.blue,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  //添加评论 点赞
                  _bottomToolsbar(itemModel, index),
                ],
              ),
            ),
          ],
        ),
      ),
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

  //帖子的关注 评论 点赞  tools
  Widget _bottomToolsbar(CfanUserpostsItemModel itemModel, int index) {
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
                // NavigationUtil.getInstance().pushPage(
                //   context,
                //   RouterName.cfanPostNesDetailPage,
                //   widget: CfanPostNesDetailPage(
                //     postsId: (itemModel.postsId).toString(),
                //     cellHeight: 0, //cellheight + resultHeight + 10,
                //   ),
                // );
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
