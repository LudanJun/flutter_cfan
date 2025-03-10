import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/base/global_size.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/login/listData.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/widget/public_widget/grade_name_widget.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/widget/public_widget/post_head_widget.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_ontherHomeInfo.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_otherhomePosts.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
///他人在社群的主页和帖子
class CfanCommunityOntherhomeinfoPage extends StatefulWidget {
  final int community_id;
  final int user_id;
  const CfanCommunityOntherhomeinfoPage(
      {super.key, required this.community_id, required this.user_id});

  @override
  State<CfanCommunityOntherhomeinfoPage> createState() =>
      _CfanCommunityOntherhomeinfoPageState();
}

class _CfanCommunityOntherhomeinfoPageState
    extends State<CfanCommunityOntherhomeinfoPage> {
  //刷新控制器
  EasyRefreshController _easyController = EasyRefreshController();
  CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();

  //主页头部信息model
  CfanCommunityOntherhomeinfoModel _ontherhomeinfoModel =
      CfanCommunityOntherhomeinfoModel();

  //帖子数组
  List<CfanCommunityOtherhomepostsItemModel> _postsItemModelList =
      <CfanCommunityOtherhomepostsItemModel>[];
  //分页
  int _page = 1;
  bool _flag = true; //解决重复请求的问题
  bool _hasData = true;

  @override
  void initState() {
    super.initState();
    getUserInfo();
    getUserPostsCommunityOtherposts(1);
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///获取他人在社群中的主页信息
  getUserInfo() {
    _cfanCommunityHomeProvider.userPostsCommunityOtherHomeInfo(
      widget.community_id,
      widget.user_id,
      onSuccess: (data) {
        if (data['code'] == 200) {
          var tempModel = CfanCommunityOntherhomeinfoModel.fromJson(data);
          setState(() {
            _ontherhomeinfoModel = tempModel;
          });
        }
      },
      onFailure: (error) {},
    );
  }

  //获取社群某个用户的帖子
  getUserPostsCommunityOtherposts(int page) {
    if (_flag && _hasData) {
      _flag = false;
      _cfanCommunityHomeProvider.userPostsCommunityOtherposts(
        widget.community_id,
        widget.user_id,
        page,
        onSuccess: (data) {
          if (data['code'] == 200) {
            var tempData = CfanCommunityOtherhomepostsModel.fromJson(data);
            setState(() {
              _postsItemModelList.addAll(tempData.data?.list ?? []);
              _page++;
              _flag = true;
            });
            //判断有没有数据
            if (tempData.data!.list!.length < 9) {
              setState(() {
                _hasData = false;
              });
            }
          }
        },
        onFailure: (error) {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ta在xx社群"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(ScreenAdapter.width(180)),
          child: Container(
            color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //1.头像 昵称
                Row(
                  children: [
                    Container(
                      width: ScreenAdapter.width(50),
                      height: ScreenAdapter.width(50),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        //设置完圆角度数后,需要设置裁切属性
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: _ontherhomeinfoModel.data?.avatar ?? "",
                        // width: ScreenAdapter.width(35),
                        // height: ScreenAdapter.width(35),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text("用户所在社群的昵称"),
                  ],
                ),
                //2.粉丝 关注 关注按钮
                Row(
                  children: [
                    SizedBox(
                      width: padding_15,
                    ),
                    Column(
                      children: [
                        Text(_ontherhomeinfoModel.data?.fansNum.toString() ??
                            ""),
                        Text("粉丝"),
                      ],
                    ),
                    SizedBox(
                      width: padding_15,
                    ),
                    Column(
                      children: [
                        Text(_ontherhomeinfoModel.data?.watchNum.toString() ??
                            ""),
                        Text("关注"),
                      ],
                    ),
                    Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        KTLog("关注");
                      },
                      child: Text("关注"),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: ScreenAdapter.height(50),
                  color: Colors.white,
                  child: Text(
                    "他的帖子",
                    style: TextStyle(
                      fontSize: ScreenAdapter.fontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: EasyRefresh(
        header: const ClassicHeader(
          dragText: '下拉刷新...',
          armedText: '释放立即刷新',
          readyText: '正在刷新...',
          // showMessage: false,
          processedText: '刷新完成',
          processingText: '正在刷新...',
          textStyle: TextStyle(
            color: KTColor.color9E9E9E,
          ),
        ),
        footer: const ClassicFooter(
          //这个属性意思是如果上拉加载完数据,就不显示加载控件
          // position: IndicatorPosition.locator,
          dragText: '正在刷新...',
          armedText: '释放立即刷新',
          readyText: '正在刷新...',
          // showMessage: false,
          processedText: '刷新完成',
          processingText: '正在刷新...',
          noMoreText: '没有更多内容',
          textStyle: TextStyle(
            color: KTColor.color9E9E9E,
          ),
        ),
        onRefresh: () async {
          KTLog("下拉刷新");
          _postsItemModelList = [];
          _page = 1;
          _hasData = true;

          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              getUserPostsCommunityOtherposts(_page);
            }
          });
        },
        onLoad: () async {
          KTLog("上拉加载");
          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              getUserPostsCommunityOtherposts(_page);
            }
          });
        },
        controller: _easyController,
        child: ListView.builder(
          itemCount: _postsItemModelList.length,
          itemBuilder: (context, index) {
            var model = _postsItemModelList[index];
            return _buildGuanzhuCell(context, model, index);
            // return Container(
            //   color: KTColor.getRandomColor(),
            //   height: 200,
            // );
          },
        ),
      ),
    );
  }

  //构建关注cell
  Widget _buildGuanzhuCell(
      context, CfanCommunityOtherhomepostsItemModel itemModel, int index) {
    //是否已经点赞
    // bool isAleadyLike = Provider.of<CfanProvider>(context).zanList.any(
    //       (element) => element == itemModel,
    //     );
    // bool islik = Provider.of<CfanProvider>(context).zanList.any(
    //   (element) {
    //     KTLog(element.name!);
    //     return element.isLike!;
    //   },
    // );
    // KTLog("islik$islik");
    // KTLog("itemModel.isLike---${itemModel.isLike!}");
    // KTLog("isAleadyLike---$isAleadyLike");

    return InkWell(
      onTap: () {
        // NavigationUtil.getInstance().pushPage(
        //   context,
        //   RouterName.cfanPostNesDetailPage,
        //   widget: CfanPostNesDetailPage(
        //     postsId: (_cfanUserpostsItemModelList[index].postsId!).toString(),
        //     cellHeight: 0, //cellheight + resultHeight + 10,
        //   ),
        // );
      },
      child: Container(
        color: KTColor.white,
        child: Column(
          children: [
            // PostHeadWidget(
            //   itemModel: itemModel,
            //   rightIconCall: () {},
            // ),

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: CircleAvatar(
                      radius: ScreenAdapter.width(35),
                      //   backgroundImage: const NetworkImage(
                      //       "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800"),
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
                              itemModel.createdAt ?? "",
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

                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.all(ScreenAdapter.width(8)),
                    child: itemModel.picList?.length != null
                        ? _addNinePic(itemModel.picList!)
                        : Container(),
                  ),

                  //4.视频

                  // //社群来源
                  // Row(
                  //   children: [
                  //     const Icon(Icons.safety_check_outlined),
                  //     Text(
                  //       itemModel.community_name ?? "",
                  //       style: TextStyle(
                  //         fontSize: ScreenAdapter.fontSize(14),
                  //         color: Colors.blue,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  //添加评论 点赞
                  _bottomToolsbar(itemModel, index, true),
                ],
              ),
            ),
          ],
        ),
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
                setState(() {
                  // _currentItemModel = itemModel;
                });

                // _onLike();
              },
              icon: itemModel.isLike == true
                  ? const Icon(
                      Icons.thumb_up_off_alt_rounded,
                      color: Colors.black,
                    )
                  : const Icon(Icons.thumb_up_off_alt_outlined,
                      color: Colors.black),
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
}

class PreferredSize extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a widget that has a preferred size that the parent can query.
  const PreferredSize({
    super.key,
    required this.preferredSize,
    required this.child,
  });

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) => child;
}
