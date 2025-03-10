import 'package:cfan_flutter/base/global_size.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_vote(%E6%8A%95%E7%A5%A8)/model/cfan_vote_record_model.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

///投票记录
class CfanVoteRecordPage extends StatefulWidget {
  final int voteId; //传入一个投票id
  const CfanVoteRecordPage({super.key, required this.voteId});

  @override
  State<CfanVoteRecordPage> createState() => _CfanVoteRecordPageState();
}

class _CfanVoteRecordPageState extends State<CfanVoteRecordPage> {
  EasyRefreshController _easyController = EasyRefreshController();
  final CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();
  //投票记录
  List<CfanVoteRecordItemModel> _recordModelList = <CfanVoteRecordItemModel>[];
//分页
  int _page = 1;
  bool _flag = true; //解决重复请求的问题
  bool _hasData = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserVoteRecordListData(1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //获取投票记录列表
  getUserVoteRecordListData(int page) {
    if (_flag && _hasData) {
      _flag = false;
      _cfanCommunityHomeProvider.userVoteLog(
        widget.voteId,
        page,
        onSuccess: (data) {
          if (data['code'] == 200) {
            var tempData = CfanVoteRecordModel.fromJson(data);
            setState(() {
              _recordModelList.addAll(tempData.data ?? []);
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
        title: Text("投票记录"),
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
          _recordModelList = [];
          _page = 1;
          _hasData = true;

          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              getUserVoteRecordListData(_page);
            }
          });
        },
        onLoad: () async {
          KTLog("上拉加载");
          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              getUserVoteRecordListData(_page);
            }
          });
        },
        controller: _easyController,
        child: _recordModelList.isNotEmpty
            ? ListView.builder(
                itemCount: _recordModelList.length,
                itemBuilder: (context, index) {
                  var model = _recordModelList[index];
                  return _buildCell(context, model, index);
                },
              )
            : Center(
                child: Text(
                  "暂无数据",
                  style: TextStyle(color: Colors.black),
                ),
              ),
      ),
    );
  }

  Widget _buildCell(context, CfanVoteRecordItemModel itemModel, index) {
    return Container(
      margin: EdgeInsets.all(ScreenAdapter.width(margin_10)),
      padding: EdgeInsets.all(ScreenAdapter.width(padding_10)),
      height: ScreenAdapter.height(60),
      decoration: BoxDecoration(
        color: Colors.grey[350],
        // border: Border.all(
        //   width: ScreenAdapter.width(0.5),
        //   color: Colors.grey,
        // ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(itemModel.optionContent ?? ""),
          Text(itemModel.time ?? ""),
        ],
      ),
    );
  }
}
