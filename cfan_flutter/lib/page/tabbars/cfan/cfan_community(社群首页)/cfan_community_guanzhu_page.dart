import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/login/listData.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_my_guanzhu.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/tools/asset_utils/asset_utils.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

///社群内关注的人列表
class CfanCommunityGuanzhuPage extends StatefulWidget {
  //传入社群id
  final int community_id;
  const CfanCommunityGuanzhuPage({super.key, required this.community_id});

  @override
  State<CfanCommunityGuanzhuPage> createState() =>
      _CfanCommunityGuanzhuPageState();
}

class _CfanCommunityGuanzhuPageState extends State<CfanCommunityGuanzhuPage> {
  //刷新控制器
  EasyRefreshController _easyController = EasyRefreshController();

  CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();

  List<CfanCommunityMyGuanzhuItemModel> _guanzhuItemModelList =
      <CfanCommunityMyGuanzhuItemModel>[];
  //分页
  int _page = 1;
  bool _flag = true; //解决重复请求的问题
  bool _hasData = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //初始化 关注信息
    getCommunityMyGuanzhuData(1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //获取自己在社群中的关注信息
  getCommunityMyGuanzhuData(int page) {
    if (_flag && _hasData) {
      _flag = false;
      _cfanCommunityHomeProvider.userPostsCommunityMyGuanzhu(
        widget.community_id,
        page,
        onSuccess: (data) {
          if (data['code'] == 200) {
            var tempData = CfanCommunityMyGuanzhuModel.fromJson(data);
            setState(() {
              _guanzhuItemModelList.addAll(tempData.data ?? []);
              _page++;
              _flag = true;
            });
            //判断有没有数据
            if (tempData.data!.length < 9) {
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
        title: Text("我在xxx社群的关注"),
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
          _guanzhuItemModelList = [];
          _page = 1;
          _hasData = true;

          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              getCommunityMyGuanzhuData(_page);
            }
          });
        },
        onLoad: () async {
          KTLog("上拉加载");
          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              getCommunityMyGuanzhuData(_page);
            }
          });
        },
        controller: _easyController,
        child: ListView.builder(
          itemCount: _guanzhuItemModelList.length,
          itemBuilder: (context, index) {
            var itemModel = _guanzhuItemModelList[index];
            return Container(
              // color: KTColor.getRandomColor(), //边框颜色

              padding: EdgeInsets.all(
                ScreenAdapter.width(5),
              ),
              // height: 100,
              // decoration: const BoxDecoration(
              //   border: Border(
              //     bottom: BorderSide(
              //       //Border不是常量构造函数 外面一层需要去掉const
              //       color: Colors.black, //边框颜色
              //       width: 0.5, //边框宽度
              //     ),
              //   ),
              // ),
              child: Row(
                children: [
                  //头像
                  Container(
                    //设置裁切属性
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      //设置完圆角度数后,需要设置裁切属性
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: itemModel.avatar ?? "",
                      // imageUrl: imageUrl5,
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
                      height: ScreenAdapter.width(80),
                      decoration: const BoxDecoration(
                        // color: Colors.red,
                        border: Border(
                          bottom: BorderSide(
                            //Border不是常量构造函数 外面一层需要去掉const
                            color: Colors.blue, //边框颜色
                            width: 0.5, //边框宽度
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: ScreenAdapter.height(10),
                          ),
                          Row(
                            children: [
                              Text(itemModel.name ?? ""),
                              SizedBox(
                                width: ScreenAdapter.width(10),
                              ),
                              Container(
                                padding: EdgeInsets.all(ScreenAdapter.width(2)),
                                height: ScreenAdapter.height(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    ScreenAdapter.width(5),
                                  ),
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    //等级图标
                                    Image.asset(
                                      AssetUtils.getAssetImage("home_memeber"),
                                    ),
                                    //等级名称
                                    Text(
                                      itemModel.levelName ?? "",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: ScreenAdapter.fontSize(12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: ScreenAdapter.width(10),
                              ),
                              itemModel.fansStatus == 1
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          ScreenAdapter.width(5),
                                        ),
                                        border: Border.all(
                                          color: Colors.red,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Text("互相关注"),
                                    )
                                  : Container(),
                            ],
                          ),
                          Text("${itemModel.time ?? ""} 关注"),
                          // SizedBox(
                          //   height: 50,
                          // )
                          // Container(
                          //   color: Colors.grey,
                          //   height: 0.5,
                          // )
                        ],
                      ),
                      // color: Colors.amber,
                      // child: Row(
                      //   children: [
                      //     Column(
                      //       //上中下
                      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //       //左中右 对齐方式
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         // Text(itemModel.title ?? ""),
                      //         Text("名字"),
                      //         Text("4879fans"),
                      //         Text("登记名称"),
                      //       ],
                      //     ),
                      //   ],
                      // ),
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
