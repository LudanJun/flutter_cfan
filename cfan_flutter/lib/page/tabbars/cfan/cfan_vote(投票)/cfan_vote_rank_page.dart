import 'package:cfan_flutter/base/global_size.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_vote(%E6%8A%95%E7%A5%A8)/model/cfan_vote_rank_model.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

///投票榜单
class CfanVoteRankPage extends StatefulWidget {
  final int voteId; //传入一个投票id
  const CfanVoteRankPage({super.key, required this.voteId});

  @override
  State<CfanVoteRankPage> createState() => _CfanVoteListPageState();
}

class _CfanVoteListPageState extends State<CfanVoteRankPage> {
  EasyRefreshController _easyController = EasyRefreshController();
  final CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();
//榜单数组
  List<CfanVoteRankItemModel> _rankList = <CfanVoteRankItemModel>[];
//分页
  int _page = 1;
  bool _flag = true; //解决重复请求的问题
  bool _hasData = true;

  @override
  void initState() {
    super.initState();

    getUserVoteRankListData(1);
  }

  @override
  void dispose() {
    super.dispose();
    _easyController.dispose();
  }

  //获取rank列表
  getUserVoteRankListData(int page) {
    if (_flag && _hasData) {
      _flag = false;
      _cfanCommunityHomeProvider.userVoteRank(
        widget.voteId,
        page,
        onSuccess: (data) {
          if (data['code'] == 200) {
            var tempData = CfanVoteRankModel.fromJson(data);
            setState(() {
              _rankList.addAll(tempData.data ?? []);
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
        title: Text("投票榜单"),
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            ScreenAdapter.height(50),
          ),
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: ScreenAdapter.height(50),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("查询时间:2024年07月02日11:37:15"),
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
           _rankList = [];
          _page = 1;
          _hasData = true;

          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              getUserVoteRankListData(_page);
            }
          });
        },
        onLoad: () async {
          KTLog("上拉加载");
          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              // getUserVoteRankListData(_page);
            }
          });
        },
        controller: _easyController,
        child: ListView.builder(
          itemCount: _rankList.length,
          itemBuilder: (context, index) {
            var model = _rankList[index];
            return _buildCell(context, model, index);
          },
        ),
      ),
    );
  }

  Widget _buildCell(context, CfanVoteRankItemModel itemModel, index) {
    return Container(
      margin: EdgeInsets.all(ScreenAdapter.width(10)),
      height: ScreenAdapter.height(50),
      decoration: BoxDecoration(
        border: Border.all(
          width: ScreenAdapter.width(0.5),
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          SizedBox(
            width: ScreenAdapter.width(padding_5),
          ),
          Text(itemModel.optionId.toString()),
          SizedBox(
            width: ScreenAdapter.width(padding_15),
          ),
          Text(itemModel.content ?? ""),
          const Spacer(),
          Text(itemModel.voteNum.toString()),
          SizedBox(
            width: ScreenAdapter.width(padding_5),
          ),
        ],
      ),
    );
  }
}
