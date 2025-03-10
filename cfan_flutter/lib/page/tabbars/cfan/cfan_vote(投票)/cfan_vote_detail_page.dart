import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/base/global_size.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/login/listData.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_focuse_widget.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_vote(%E6%8A%95%E7%A5%A8)/cfan_vote_rank_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_vote(%E6%8A%95%E7%A5%A8)/cfan_vote_record_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_vote(%E6%8A%95%E7%A5%A8)/widget/cfan_voters_widget.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_home_banner.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_vote(%E6%8A%95%E7%A5%A8)/model/cfan_vote_detail_model.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/widget/toast_utils/toast_util.dart';
import 'package:flutter/material.dart';

///投票详情
class CfanVoteDetailPage extends StatefulWidget {
  final int voteId; //传入投票id
  const CfanVoteDetailPage({
    super.key,
    required this.voteId,
  });

  @override
  State<CfanVoteDetailPage> createState() => _CfanVoteHomePageState();
}

class _CfanVoteHomePageState extends State<CfanVoteDetailPage> {
  final CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();
  //投票详情模型
  CfanVoteDetailModel _detailModel = CfanVoteDetailModel();
  //投票人名列表
  List<CfanVoteDetaiCommunityitemModel> _communityList =
      <CfanVoteDetaiCommunityitemModel>[];
  //选项人名列表
  List<CfanVoteDetaiOptionitemModel> _optionList =
      <CfanVoteDetaiOptionitemModel>[];

  //投票选项索引
  int? _optionSelectIndex;
  //是否开始投票
  bool _isStartVoter = false;
  //选择的投票选项
  String _optionIdStr = '';
  //记录投票次数
  int countVote = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //获取投票详情数据
    getVoterDetailData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  //获取投票详情数据
  getVoterDetailData() {
    _cfanCommunityHomeProvider.userVoteDetail(
      widget.voteId,
      onSuccess: (data) {
        if (data['code'] == 200) {
          _detailModel = CfanVoteDetailModel.fromJson(data);
          setState(() {
            _communityList.addAll(_detailModel.data?.communityList ?? []);
            _optionList.addAll(_detailModel.data?.optionList ?? []);
            //获取投票次数
            countVote = _detailModel.data?.todayAllowVoteNum ?? 0;
          });
        }
      },
      onFailure: (error) {},
    );
  }

  //提交投票
  submitVoteData(String optionId) {
    _cfanCommunityHomeProvider.userSubmitVote(
      widget.voteId,
      optionId,
      onSuccess: (data) {
        if (data['code'] == 200) {
          showToast("投票成功");
          if (countVote == 0) {
            return;
          } else {
            countVote--;
            setState(() {
              //投票成功获取投票详情
              _communityList = [];
              _optionList = [];
              KTLog("请求详情");
              getVoterDetailData();
            });
          }

          KTLog(countVote);
        } else if (data['code'] == 1000) {
          showToast(data['message']);
          return;
        }
      },
      onFailure: (error) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //该属性可以让appbar下面的控件在导航栏下面显示
      extendBodyBehindAppBar: false, //实现透明导航
      appBar: AppBar(
        title: Text("投票"),
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
                  fit: BoxFit.fill,
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
                ..._communityList.isNotEmpty
                    ? _communityList.map((model) {
                        return Container(
                          // color: Colors.red,
                          child: Row(
                            children: [
                              Icon(Icons.safety_check_outlined),
                              Text("周杰伦"),
                            ],
                          ),
                        );
                      }).toList()
                    : [Container()]
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
                        imageUrl: _detailModel.data?.logo ?? "",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          _isStartVoter == true
              ? Container(
                  // color: KTColor.getRandomColor(),
                  width: double.infinity,
                  // height: ScreenAdapter.height(90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "请投票",
                        style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "单选，每人每天可投2票，东八区凌晨12点更新",
                        style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(14),
                        ),
                      ),
                      Container(
                        height: ScreenAdapter.height(61) * _optionList.length,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _optionList.length,
                          itemBuilder: (context, index) {
                            var itemModel = _optionList[index];
                            return InkWell(
                              onTap: () {
                                _optionIdStr = itemModel.optionId.toString();
                                KTLog("选择的第$index个  id:$_optionIdStr");

                                setState(() {
                                  _optionSelectIndex = index;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(
                                  ScreenAdapter.width(5),
                                ),
                                height: margin_50,
                                // color: KTColor.getRandomColor(),
                                decoration: BoxDecoration(
                                  color: (_optionSelectIndex == index)
                                      ? Colors.green
                                      : Colors.white,
                                  border: Border.all(
                                    width: ScreenAdapter.width(0.5),
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    ScreenAdapter.width(padding_5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    (_optionSelectIndex == index)
                                        ? Icon(Icons.circle_rounded)
                                        : Icon(Icons.circle_outlined),
                                    SizedBox(
                                      height: padding_5,
                                    ),
                                    Text(itemModel.content ?? ""),
                                    Spacer(),
                                    Text(itemModel.voteNum.toString()),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          Container(
            // color: KTColor.getRandomColor(),
            height: ScreenAdapter.height(90),
          ),
          // Container(
          //   color: KTColor.getRandomColor(),
          //   height: 150,
          // ),
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
            height: ScreenAdapter.height(5),
          ),
          Text(
              "单选，每人每天可投${_detailModel.data?.everyDayLimitNum ?? 0}票，东八区凌晨12点更新"),
          SizedBox(
            height: ScreenAdapter.height(5),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  KTLog("投票榜单");
                  NavigationUtil.getInstance().pushPage(
                    context,
                    RouterName.cfanVoteListPage,
                    widget: CfanVoteRankPage(
                      voteId: _detailModel.data?.pollsId ?? 0,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.account_balance_wallet_outlined,
                ),
              ),
              IconButton(
                onPressed: () {
                  KTLog("投票记录");
                  NavigationUtil.getInstance().pushPage(
                    context,
                    RouterName.cfanVoteRecordPage,
                    widget: const CfanVoteRecordPage(
                      voteId: 1,
                    ),
                  );
                },
                icon: Icon(
                  Icons.account_balance_wallet_outlined,
                ),
              ),
              /**
               every_day_limit_num 每天限制投票次数
               today_allow_vote_num 今天还允许投票的次数
               time_status 0表示投票活动未开始，1进行中，2已结束
               is_multiple_choice 0表示单选，1表示多选
               */
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {
                    if (_detailModel.data?.todayAllowVoteNum == 0) {
                      showToast('已经投过票了');
                    } else {
                      if (_isStartVoter == true) {
                        KTLog("确定投票");
                        if (_optionIdStr.isEmpty) {
                          showToast("您还没选择,请选择后再投票。");
                          return;
                        }
                        //提交投票
                        submitVoteData(_optionIdStr);
                      } else {
                        KTLog("开始投票");
                        showToast(
                            "今日可投${_detailModel.data?.todayAllowVoteNum ?? 0}票");
                        setState(() {
                          _isStartVoter = true;
                        });
                      }
                    }
                  },
                  //先判断是否开始投票
                  //如果投票未开始false就继续判断 投票活动状态
                  // child: _isStartVoter == false
                  //     ? _detailModel.data?.timeStatus == 0
                  //         ? Text("投票未开始")
                  //         : _detailModel.data?.timeStatus == 1
                  //             ? _detailModel.data?.todayAllowVoteNum == 0
                  //                 ? Text("今日已投票")
                  //                 : Text("开始投票")
                  //             : Text("投票结束")
                  //     : Text("确认投票"),
                  child: _detailModel.data?.todayAllowVoteNum == 0
                      ? Text("今日已投票")
                      : _isStartVoter == false
                          ? _detailModel.data?.timeStatus == 0
                              ? Text("投票未开始")
                              : _detailModel.data?.timeStatus == 1
                                  ? Text("开始投票")
                                  : Text("投票结束")
                          : Text("确认投票"),
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
