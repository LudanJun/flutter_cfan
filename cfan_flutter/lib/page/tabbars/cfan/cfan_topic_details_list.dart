import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_detail(%E5%B8%96%E5%AD%90%E8%AF%A6%E6%83%85)/cfan_post_nes_detail_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_posts_contenttrans.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_userPosts_list_model.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/provider/cfan_provider.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

///话题详情列表
class CfanTopicDetailsListPage extends StatefulWidget {
  final String topicStr; //传入话题
  const CfanTopicDetailsListPage({super.key, required this.topicStr});

  @override
  State<CfanTopicDetailsListPage> createState() => _CfanTopicListPageState();
}

class _CfanTopicListPageState extends State<CfanTopicDetailsListPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  CfanProvider _cfanProvider = CfanProvider();
  CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();

  List<String> listStr = [
    "aaa",
    "aaa",
    "aaa",
    "aaa",
    "aaa",
    "aaa",
    "aaa",
    "aaa",
    "aaa",
    "aaa",
  ];

  //帖子数组
  List<CfanUserpostsItemModel> _postsItemModelList = <CfanUserpostsItemModel>[];

  //当前点赞操作的item
  CfanUserpostsItemModel? _currentItemModel = CfanUserpostsItemModel();
  //分页
  int _page = 1;
  bool _flag = true; //解决重复请求的问题
  bool _hasData = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPostsDetailList(1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  ///获取帖子详情列表
  getPostsDetailList(int page) {
    if (_flag && _hasData) {
      _flag = false;
      _cfanCommunityHomeProvider.userPostsTagposts(
        "周杰伦", //widget.topicStr,
        page,
        onSuccess: (data) {
          if (data['code'] == 200) {
            var tempData = CfanUserpostsModel.fromJson(data);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("话题列表"),
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
        controller: _controller,
        // firstRefresh: true,
        onRefresh: () async {
          KTLog('下拉刷新-----');
          _postsItemModelList = [];
          _page = 1;
          _hasData = true;
          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              getPostsDetailList(_page);
            }
          });
        },
        onLoad: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            KTLog('上拉加载-----');
            if (mounted) {
              getPostsDetailList(_page);
            }
          });
        },
        child: Container(
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return StickyHeader(
                    header: Container(
                      height: ScreenAdapter.height(80),
                      color: Colors.yellow[700],
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: ScreenAdapter.height(50),
                            height: ScreenAdapter.height(50),
                            decoration: BoxDecoration(
                              // color: Colors.red,
                              border: Border.all(
                                color: Colors.black,
                                width: ScreenAdapter.width(0.5),
                              ),
                            ),
                            child: Text(
                              "#",
                              style: TextStyle(
                                fontSize: ScreenAdapter.fontSize(30),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ScreenAdapter.width(10),
                          ),
                          Text(
                            widget.topicStr,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    //列表
                    content: Column(
                      children: buildCell(_postsItemModelList),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }

  List<Widget> buildCell(List<CfanUserpostsItemModel> modelList) {
    //通过asMap函数获取的是下标
    return modelList.asMap().keys.map((index) {
      var itemModel = modelList[index];
      //是否已经点赞
      bool isAleadyLike = Provider.of<CfanProvider>(context).zanList.any(
            (element) => element == itemModel,
          );
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
              postsId: (itemModel.postsId!).toString(),
              cellHeight: 0, //cellheight + resultHeight + 10,
            ),
          );
        },
        child: Container(
          // key: cellkeys[index],
          color: KTColor.white,
          child: Column(
            children: [
              //第四个 添加商品
              // if (index == 3)
              //   Container(
              //     height: ScreenAdapter.height(270),
              //     color: Colors.white,
              //     child: _buildGoodsHead(),
              //   ),

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
                          //名字
                          Text(
                            itemModel.name!,
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

                    // //添加轮播图
                    // if (index == 5)
                    //   InkWell(
                    //     onTap: () {
                    //       KTLog("asd");
                    //     },
                    //     child: Container(
                    //       clipBehavior: Clip.antiAlias,
                    //       decoration: BoxDecoration(
                    //         //设置完圆角度数后,需要设置裁切属性
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       height: ScreenAdapter.height(150),
                    //       child: CfanFocuseWidget(
                    //         imgList: _bannerList,
                    //       ),
                    //     ),
                    //   )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      // return Container(
      //   alignment: Alignment.centerLeft,
      //   color: KTColor.getRandomColor(),
      //   height: 100,
      //   child: Text("当前第$index行"),
      // );
    }).toList();
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
