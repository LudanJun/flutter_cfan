import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/base/global_size.dart';
import 'package:cfan_flutter/page/login/listData.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_test(%E6%B5%8B%E9%AA%8C)/cfan_test_record_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_test(%E6%B5%8B%E9%AA%8C)/cfan_test_paper_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_test(%E6%B5%8B%E9%AA%8C)/model/cfan_test_detail_model.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/widget/image/default_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 测验首页
class CfanTestDetailPage extends StatefulWidget {
  final int examId; //传入一个测验id
  const CfanTestDetailPage({
    super.key,
    required this.examId,
  });

  @override
  State<CfanTestDetailPage> createState() => _CfanTestHomePageState();
}

class _CfanTestHomePageState extends State<CfanTestDetailPage> {
  final CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();

  CfanTestDetailModel _detailModel = CfanTestDetailModel();
  List<CfanTestDetaiCommunityitemModel> _communityList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //获取投票详情数据
    getTestDetailData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //获取测验详情数据
  getTestDetailData() {
    _cfanCommunityHomeProvider.userVoteDetail(
      widget.examId,
      onSuccess: (data) {
        if (data['code'] == 200) {
          _detailModel = CfanTestDetailModel.fromJson(data);
          setState(() {
            _communityList.addAll(_detailModel.data?.communityList ?? []);
          });
        }
      },
      onFailure: (error) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("测验"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _bodyWidget(),
          Align(
            alignment: Alignment.bottomCenter,
            child: _bottomWidegt(),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          //1.banner图
          Container(
            // color: KTColor.getRandomColor(),
            // height: 150,
            child: InkWell(
              onTap: () {
                KTLog("asd");
              },
              child: Container(
                margin: EdgeInsets.all(margin_10),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  //设置完圆角度数后,需要设置裁切属性
                  borderRadius: BorderRadius.circular(10),
                ),
                width: ScreenAdapter.getScreenWidth(),
                height: ScreenAdapter.height(150),
                child: CachedNetworkImage(
                  imageUrl: _detailModel.data?.logo ?? "",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => defaultBannerImage(),
                  errorWidget: (context, url, error) => defaultBannerImage(),
                ),
              ),
            ),
          ),

          //2.投票时间,投票人
          Container(
            alignment: Alignment.centerLeft,
            // color: KTColor.getRandomColor(),
            // height: 150,
            child: Column(
              children: [
                //1.时间
                Text(
                  "投票时间:2024年07月02日 - 2024年07月02日",
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(14),
                    color: Colors.grey,
                  ),
                ),
                //2.投票人 wrap
                // ..._communityList.isNotEmpty
                //     ? _communityList.map((model) {
                //         return Container(
                //           // color: Colors.red,
                //           child: Row(
                //             children: [
                //               Icon(Icons.safety_check_outlined),
                //               Text("周杰伦"),
                //             ],
                //           ),
                //         );
                //       }).toList()
                //     : [Container()]
              ],
            ),
          ),

          //3.标题 图文
          Container(
            // color: KTColor.getRandomColor(),
            // height: 150,
            child: Column(
              children: [
                Text(
                  // "标题标题标题标题标题标题",
                  _detailModel.data?.title ?? "",
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(16),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(margin_10),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        //设置完圆角度数后,需要设置裁切属性
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: ScreenAdapter.getScreenWidth(),
                      height: ScreenAdapter.height(250),
                      child: CachedNetworkImage(
                        imageUrl: _detailModel.data?.introImage ?? "",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => defaultBannerImage(),
                        errorWidget: (context, url, error) =>
                            defaultBannerImage(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomWidegt() {
    //底部添加定位组件
    return Container(
      height: ScreenAdapter.height(90),
      color: Colors.grey,
      child: Column(
        children: [
          SizedBox(
            height: ScreenAdapter.height(15),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  KTLog("测验记录");
                  NavigationUtil.getInstance().pushPage(
                    context,
                    RouterName.cfanTestRecordPage,
                    widget: CfanTestRecordPage(
                      // voteId: _detailModel.data?.pollsId ?? 0,
                      examId: widget.examId,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.account_balance_wallet_outlined,
                ),
              ),
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {
                    KTLog("开始测验");

                    NavigationUtil.getInstance().pushPage(
                      context,
                      RouterName.cfanTestPaperPage,
                      widget: CfanTestPaperPage(
                        // voteId: _detailModel.data?.pollsId ?? 0,
                        // testId: 0,
                        examId: widget.examId,
                      ),
                    );
                  },
                  child: Text("开始测验"),
                ),
              ),
              SizedBox(
                width: ScreenAdapter.width(10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
