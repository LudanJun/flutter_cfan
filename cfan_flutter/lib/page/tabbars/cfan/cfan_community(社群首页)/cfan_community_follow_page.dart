import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/login/listData.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_home_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_model.dart';
import 'package:cfan_flutter/provider/cfan_provider.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

//关注的社群列表
class CfanCommunityFollowPage extends StatefulWidget {
  const CfanCommunityFollowPage({super.key});

  @override
  State<CfanCommunityFollowPage> createState() =>
      _CfanCommunityFollowPageState();
}

class _CfanCommunityFollowPageState extends State<CfanCommunityFollowPage> {
  //刷新控制器
  EasyRefreshController _easyController = EasyRefreshController();
  CfanProvider _cfanProvider = CfanProvider();

  ///我的社群
  List<CfanCommunityItemModel> _cfanMycommunityItemModelList = [];

  ///获取我的社群
  getMyCommunityData() {
    _cfanProvider.myCommunity(
      onSuccess: (data) {
        if (data['code'] == 200) {
          var tempList = CfanCommunityModel.fromJson(data);
          setState(() {
            _cfanMycommunityItemModelList.addAll(tempList.data ?? []);
          });
        }
      },
      onFailure: (error) {},
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 获取关注的社群列表
    getMyCommunityData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("关注的社群"),
        centerTitle: true,
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
          _cfanMycommunityItemModelList = [];
          // _page = 1;
          // _hasData = true;

          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              getMyCommunityData();
              // getCommunityList(selectTabbasIndex.toString(), _page.toString());
            }
          });
        },
        onLoad: () async {
          KTLog("上拉加载");
          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              // getCommunityList(selectTabbasIndex.toString(), _page.toString());
            }
          });
        },
        controller: _easyController,
        child: ListView.builder(
          itemCount: _cfanMycommunityItemModelList.length,
          itemBuilder: (context, index) {
            var itemModel = _cfanMycommunityItemModelList[index];
            return Container(
              padding: EdgeInsets.all(
                ScreenAdapter.width(5),
              ),
              height: 100,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    //Border不是常量构造函数 外面一层需要去掉const
                    color: Colors.black, //边框颜色
                    width: 0.5, //边框宽度
                  ),
                ),
              ),
              child: Row(
                children: [
                  //头像
                  Container(
                    //设置裁切属性
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      //设置完圆角度数后,需要设置裁切属性
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: itemModel.avatar ?? "",
                      width: ScreenAdapter.width(60),
                      height: ScreenAdapter.width(60),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: ScreenAdapter.width(10),
                  ),
                  Expanded(
                    child: Container(
                      // color: Colors.amber,
                      child: Row(
                        children: [
                          Column(
                            //上中下
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //左中右 对齐方式
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(itemModel.title ?? ""),
                              Text("4879fans"),
                              Text("登记名称"),
                            ],
                          ),
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              KTLog("进群: $index");
                              NavigationUtil.getInstance().pushPage(
                                context,
                                RouterName.cfanCommunityHomePage,
                                widget: CfanCommunityHomePage(
                                  communityId:
                                      (itemModel.communityId ?? "").toString(),
                                ),
                              );
                            },
                            child: Text("进群"),
                          ),
                          SizedBox(
                            width: ScreenAdapter.width(15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
