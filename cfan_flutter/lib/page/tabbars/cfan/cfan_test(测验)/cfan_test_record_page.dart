import 'package:cfan_flutter/base/global_size.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_test(%E6%B5%8B%E9%AA%8C)/cfan_test_result_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_test(%E6%B5%8B%E9%AA%8C)/model/cfan_test_record_model.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

//测验记录
class CfanTestRecordPage extends StatefulWidget {
  final int examId; //传入一个测验id

  const CfanTestRecordPage({super.key, required this.examId});

  @override
  State<CfanTestRecordPage> createState() => _CfanTestRecordPageState();
}

class _CfanTestRecordPageState extends State<CfanTestRecordPage> {
  EasyRefreshController _easyController = EasyRefreshController();
  final CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();

  //测验记录
  List<CfanTestRecordItemModel> _recordModelList = <CfanTestRecordItemModel>[];

  //分页
  int _page = 1;
  bool _flag = true; //解决重复请求的问题
  bool _hasData = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserTestRecordListData(1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //获取测验记录列表
  getUserTestRecordListData(int page) {
    if (_flag && _hasData) {
      _flag = false;
      _cfanCommunityHomeProvider.userTestExamlog(
        widget.examId,
        // page,
        onSuccess: (data) {
          if (data['code'] == 200) {
            var tempData = CfanTestRecordModel.fromJson(data);
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
        title: Text("测验记录"),
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
              getUserTestRecordListData(_page);
            }
          });
        },
        onLoad: () async {
          KTLog("上拉加载");
          await Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              getUserTestRecordListData(_page);
            }
          });
        },
        controller: _easyController,
        child: _recordModelList.isNotEmpty
            ? ListView.builder(
                itemCount: _recordModelList.length,
                itemBuilder: (context, index) {
                  var model = _recordModelList[index];
                  return _buildCell(
                    context,
                    model,
                    index,
                  );
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

  Widget _buildCell(context, CfanTestRecordItemModel itemModel, int index) {
    return InkWell(
      onTap: () {
        KTLog("点击了第$index行");
        NavigationUtil.getInstance().pushPage(
          context,
          RouterName.cfanTestRecordPage,
          widget: CfanTestResultPage(
            answerId: itemModel.answerId ?? 0,
            // voteId: _detailModel.data?.pollsId ?? 0,
            // testId: 0,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(
          ScreenAdapter.width(margin_10),
        ),
        padding: EdgeInsets.all(
          ScreenAdapter.width(padding_10),
        ),
        decoration: BoxDecoration(
          color: Colors.grey[350],
          //边框颜色和宽度
          // border: Border.all(
          //   width: ScreenAdapter.width(0.5),
          //   color: Colors.grey,
          // ),
          //圆角
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("正确: ${itemModel.rightNum}  错误: ${itemModel.errorNum}"),
                Text("${itemModel.time}"),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_outlined),
          ],
        ),
      ),
    );
  }
}
