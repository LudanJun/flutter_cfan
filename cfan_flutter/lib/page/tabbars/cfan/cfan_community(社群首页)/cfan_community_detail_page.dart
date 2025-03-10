import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/login/listData.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_detail.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_manager.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/widget/image/default_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

///社群详情页面
class CfanCommunityDetailPage extends StatefulWidget {
  //传入社群id
  final String communityId;
  const CfanCommunityDetailPage({super.key, required this.communityId});

  @override
  State<CfanCommunityDetailPage> createState() =>
      _CfanCommunityDetailPageState();
}

class _CfanCommunityDetailPageState extends State<CfanCommunityDetailPage>
    with SingleTickerProviderStateMixin {
  EasyRefreshController _easyController = EasyRefreshController();

  ///社群主页状态
  final CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();

  ///社群详情模型
  CfanCommunityDetailModel _cfanCommunityDetailModel =
      CfanCommunityDetailModel();

  ///社群管理员数组模型
  List<CfanCommunityManagerItemModel> _managerItemListModel =
      <CfanCommunityManagerItemModel>[];
  //管理员分页guanliyuan 简称gl
  int _glPage = 1;
  bool _glflag = true; //解决重复请求的问题
  bool _glHasData = true; //是否有数据

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    getUserPostsCommunityDetail(widget.communityId);

    getUserPostsCommunitymanager(widget.communityId, 1);
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
          });
        }
      },
      onFailure: (error) {},
    );
  }

  ///获取社群管理员
  getUserPostsCommunitymanager(String communityId, int page) {
    KTLog('管理员$_glflag--$_glHasData');

    if (_glflag && _glHasData) {
      _glflag = false;
      _cfanCommunityHomeProvider.userPostsCommunitymanager(
        communityId,
        page,
        onSuccess: (data) {
          if (data['code'] == 200) {
            var temp = CfanCommunityManagerModel.fromJson(data);
            setState(() {
              _managerItemListModel.addAll(temp.data!);
              _glPage++;
              _glflag = true;
            });
            //判断有没有数据
            if (temp.data!.length < 9) {
              setState(() {
                _glHasData = false;
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
        title: Text("社群详情"),
        centerTitle: true,
        bottom: TabBar(
          isScrollable: false, //是否可以滚动
          indicatorColor: Colors.black, //指示器颜色
          indicatorWeight: 2, //指示器高度
          // indicatorPadding:const EdgeInsets.all(5),//上下左右5个间距
          indicatorSize: TabBarIndicatorSize.label, //跟文字一样长
          // indicator: BoxDecoration(//不常用
          //   //指示器边框设置
          //   color: Colors.red,
          //   //配置圆角
          //   borderRadius: BorderRadius.circular(10),
          // ),
          labelColor: Colors.black, //选中label后的文字颜色
          labelStyle: const TextStyle(fontSize: 20 //选中的文字大小
              ),
          // unselectedLabelColor: Colors.white,//未选中的文字颜色
          unselectedLabelStyle: const TextStyle(
            fontSize: 15, //未选中文字大小
          ),
          controller: _tabController, //注意:配置controller需要去掉TabBar的cost属性
          onTap: (value) {
            print(value);
          },
          tabs: const [
            Tab(
              child: Text("简介"),
            ),
            Tab(
              child: Text("管理"),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.orange,
        child: TabBarView(
          controller: _tabController,
          children: [
            //添加简介页面
            _buildIntroWidget(),

            //添加管理页面
            _buildManagerWidget(),
          ],
        ),
      ),
    );
  }

  ///构建简介界面
  Widget _buildIntroWidget() {
    var tempModel = _cfanCommunityDetailModel.data;
    // var avatarStr = tempModel?.avatar ?? tempModel?.avatar;
    return Padding(
      padding: EdgeInsets.all(
        ScreenAdapter.width(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: KTColor.getRandomColor(),
            height: ScreenAdapter.height(150),
            child: Row(
              children: [
                //头像
                Container(
                  width: ScreenAdapter.width(80),
                  height: ScreenAdapter.width(80),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      ScreenAdapter.width(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: (_cfanCommunityDetailModel.data?.avatar != null)
                          ? _cfanCommunityDetailModel.data!.avatar!
                          : "",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => defaultHeadImage(),
                      errorWidget: (context, url, error) => defaultHeadImage(),
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenAdapter.width(15),
                ),
                Expanded(
                  child: Container(
                    width: ScreenAdapter.width(80),
                    height: ScreenAdapter.width(80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // (tempModel?.intro != null) ? tempModel!.intro! : "",

                        Text((tempModel?.title != null)
                            ? tempModel!.title!
                            : "明星"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                "${(tempModel?.postsTotal != null) ? tempModel!.postsTotal : "0"}个帖子"),
                            SizedBox(
                              width: ScreenAdapter.width(10),
                            ),
                            Text(
                                "${(tempModel?.fansTotal != null) ? tempModel!.fansTotal : "0"}个fans"),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          //2.相关艺人
          Text(
            "相关艺人",
            style: TextStyle(
              fontSize: ScreenAdapter.fontSize(20),
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(
            //根据数据来扩展高度
            height: tempModel?.artist?.length != null
                ? ScreenAdapter.height(100) * tempModel?.artist!.length
                : 0,
            child: ListView.builder(
              itemCount: tempModel?.artist?.length,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.topCenter,
                  height: ScreenAdapter.height(100),
                  child: Container(
                    // color: KTColor.getRandomColor(),
                    height: ScreenAdapter.width(80),
                    decoration: BoxDecoration(
                      color: KTColor.getRandomColor(),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: ScreenAdapter.width(5),
                        ),
                        CircleAvatar(
                          radius: ScreenAdapter.width(30),
                          backgroundImage:
                              NetworkImage(tempModel!.artist![index].avatar!),
                        ),
                        SizedBox(
                          width: ScreenAdapter.width(5),
                        ),
                        Text(tempModel.artist![index].name!),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          //3.社群简介
          Text(
            "社群简介",
            style: TextStyle(
              fontSize: ScreenAdapter.fontSize(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            (tempModel?.intro != null) ? tempModel!.intro! : "",
            // tempModel.intro != null ? tempModel!.intro : "",
            style: TextStyle(
              fontSize: ScreenAdapter.fontSize(14),
            ),
            maxLines: 3,
            //当文本溢出时显示省略号....
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildManagerWidget() {
    return EasyRefresh(
      controller: _easyController,
      onRefresh: () async {
        KTLog("下拉刷新");

        //下拉刷新
        await Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _managerItemListModel = [];
              _glPage = 1;
              _glHasData = true;
              //获取管理员
              getUserPostsCommunitymanager(widget.communityId, _glPage);
            });
          }
        });
      },
      onLoad: () async {
        KTLog("上拉加载");
        await Future.delayed(
          const Duration(seconds: 1),
          () {
            if (mounted) {
              setState(() {
                //获取管理员
                getUserPostsCommunitymanager(widget.communityId, _glPage);
              });
            }
          },
        );
      },
      child: ListView.builder(
        itemCount: _managerItemListModel.length,
        itemBuilder: (context, index) {
          return Container(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: ScreenAdapter.width(5),
                    ),
                    CircleAvatar(
                      radius: ScreenAdapter.width(30),
                      backgroundImage:
                          NetworkImage(_managerItemListModel[index].avatar!),
                    ),
                    SizedBox(
                      width: ScreenAdapter.width(10),
                    ),
                    Text(_managerItemListModel[index].name!),
                  ],
                ),
                SizedBox(
                  height: ScreenAdapter.width(5),
                ),
                Divider(
                  color: Theme.of(context).dividerColor,
                  height: 1, // 分隔线的高度，默认为16.0
                  thickness: 1, // 分隔线的厚度，默认为1.0,
                  indent: ScreenAdapter.width(60), // 分隔线的左缩进，默认为0.0
                  endIndent: 0.0, // 分隔线的右缩进，默认为0.0
                ),
              ],
            ),
          );
        },
      ),
    );
  }
/*
  Widget _buildManagerWidget() {
    return Padding(
      padding: EdgeInsets.all(
        ScreenAdapter.width(5),
      ),
      child: ListView.builder(
        itemCount: _managerItemListModel.length,
        itemBuilder: (context, index) {
          return EasyRefresh.builder(
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
            // controller: _easyController,
            onRefresh: () async {
              KTLog("下拉刷新");

              //下拉刷新
              await Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  setState(() {
                    if (_tabController.index == 0) {
                      _managerItemListModel = [];
                      _glPage = 1;
                      _glHasData = true;
                      //获取管理员
                      getUserPostsCommunitymanager(
                          widget.community_id, _glPage);
                    }
                  });
                }
              });
            },
            childBuilder: (context, physics) {
              return Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: ScreenAdapter.width(5),
                        ),
                        CircleAvatar(
                          radius: ScreenAdapter.width(30),
                          backgroundImage: NetworkImage(
                              _managerItemListModel[index].avatar!),
                        ),
                        SizedBox(
                          width: ScreenAdapter.width(10),
                        ),
                        Text(_managerItemListModel[index].name!),
                      ],
                    ),
                    SizedBox(
                      height: ScreenAdapter.width(5),
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                      height: 1, // 分隔线的高度，默认为16.0
                      thickness: 1, // 分隔线的厚度，默认为1.0,
                      indent: ScreenAdapter.width(60), // 分隔线的左缩进，默认为0.0
                      endIndent: 0.0, // 分隔线的右缩进，默认为0.0
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
  */
}
