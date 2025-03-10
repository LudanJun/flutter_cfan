import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_expinfo.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_expinfo_rule.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/widget/HJWidget/hj_dialog.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
///我在社群的经验
class CfanCommunityExpinfoPage extends StatefulWidget {
  final int community_id;
  const CfanCommunityExpinfoPage({super.key, required this.community_id});

  @override
  State<CfanCommunityExpinfoPage> createState() =>
      _CfanCommunityExpinfoPageState();
}

class _CfanCommunityExpinfoPageState extends State<CfanCommunityExpinfoPage> {
  final EasyRefreshController _controller = EasyRefreshController();
  CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();

  CfanCommunityExpinfoModel expModel = CfanCommunityExpinfoModel();
  //经验明细数组
  List<CfanCommunityExpinfoItemModel> _expinfoItemModelList =
      <CfanCommunityExpinfoItemModel>[];

  CfanCommunityExpinfoRuleModel _RuleModel = CfanCommunityExpinfoRuleModel();
  //所需经验数组
  List<CfanCommunityExpinfoRuleLeveModel> _levelList =
      <CfanCommunityExpinfoRuleLeveModel>[];
  //经验获取数组
  List<CfanCommunityExpinfoRuleDailyModel> _expRuleList =
      <CfanCommunityExpinfoRuleDailyModel>[];

  //分页
  // int _page = 1;
  // bool _flag = true; //解决重复请求的问题
  // bool _hasData = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserPostsCommunityExpinfo();
    getUserPostsCommunityExpinfoRule();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  //获取自己在社群中的经验明细
  getUserPostsCommunityExpinfo() {
    _cfanCommunityHomeProvider.userPostsCommunityExpinfo(
      widget.community_id,
      onSuccess: (data) {
        if (data['code'] == 200) {
          expModel = CfanCommunityExpinfoModel.fromJson(data);
          setState(() {
            _expinfoItemModelList.addAll(expModel.data?.list ?? []);
          });
        }
      },
      onFailure: (error) {},
    );
  }

  //获取自己在社群中的经验明细规则
  getUserPostsCommunityExpinfoRule() {
    _cfanCommunityHomeProvider.userPostsCommunityExpinfoRule(
      widget.community_id,
      onSuccess: (data) {
        if (data['code'] == 200) {
          _RuleModel = CfanCommunityExpinfoRuleModel.fromJson(data);
          setState(() {
            _levelList.addAll(_RuleModel.data?.levelList ?? []);
            _expRuleList.addAll(_RuleModel.data?.expRuleList ?? []);
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
        title: Text("我在xx社群的经验"),
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
          await Future.delayed(const Duration(seconds: 1), () {
            KTLog('下拉刷新-----');
            // getNewData();
            // setState(() {
            //   _count = dataArr.length;
            //   print('最新条数 ${_count.toString()}');
            //   _controller.resetLoadState();
            // });
            _expinfoItemModelList = [];
            getUserPostsCommunityExpinfo();
          });
        },
        onLoad: () async {
          await Future.delayed(const Duration(seconds: 1), () {
            KTLog('上拉加载-----');
            // getMoreData();
            // setState(() {
            //   _count = dataArr.length;
            //   print('加载更多条数 ${_count.toString()}');
            // });
            // _controller.finishLoad(noMore: _count >= 30);
          });
        },
        // 不加header
        // child: cell(_count),
        // header跟随，方式1
        // child: ListView(
        //   children: [
        //     _header(),
        //     _listWidget(_count),
        //     _footer(),
        //   ],
        // ),
        // header跟随，方式2
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _header(),

                _listWidget(10),
                // _footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          color: Colors.white,
          height: ScreenAdapter.height(100),
          child: Row(
            children: [
              _buildHeadSubContentView(
                  "社群等级", expModel.data?.level.toString() ?? "", ""),
              _buildHeadSubContentView(
                  "累计经验值", expModel.data?.userExp.toString() ?? "", ""),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: ScreenAdapter.width(10),
            right: ScreenAdapter.width(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("经验明细"),
              OutlinedButton(
                onPressed: () {
                  KTLog("说明");
                  showRule();
                },
                child: Text("说明"),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _footer() {
    return Container(
      alignment: Alignment.center,
      color: Colors.orange,
      height: 50,
      child: const Text('footer', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _listWidget(int dataCount) {
    // if (dataCount == 0) {
    //   return const JhEmptyView();
    //   // return Container(
    //   //   alignment: Alignment.topCenter,
    //   //   padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
    //   //   child: Text("暂无数据", textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0)),
    //   // );
    // } else {
    //// }

    return ListView.separated(
      // 加header要加上这两个属性
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // 加header要加上这两个属性
      // 取消footer和cell之间的空白
      padding: const EdgeInsets.all(0),
      itemCount: _expinfoItemModelList.length, //dataCount,
      itemBuilder: (context, index) {
        // CustomViewModel model = CustomViewModel.fromJson(dataArr[index]);
        // print('title${model.title!}');
        // return ListViewTestCustomCell(data: model);
        var itemModel = _expinfoItemModelList[index];
        return Container(
          // color: KTColor.getRandomColor(),
          height: ScreenAdapter.height(80),
          child: Container(
            //控制圆角
            margin: EdgeInsets.only(
              top: ScreenAdapter.width(10),
              left: ScreenAdapter.width(10),
              right: ScreenAdapter.width(10),
            ),
            height: ScreenAdapter.height(75),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(itemModel.remark ?? ""),
                    Text(itemModel.time ?? ""),
                  ],
                ),
                Spacer(),
                Text("+ ${itemModel.exp}"),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        );
      },
      //添加底部横线可以控制长短
      separatorBuilder: (context, index) {
        return const Divider(
          height: .5,
          indent: 15,
          endIndent: 15,
          // color: Color(0xFFDDDDDD),
          color: Colors.transparent,
        );
      },
    );
  }

  //不带编辑
  Widget _buildHeadSubContentView(
    String title,
    String content,
    String strTime,
  ) {
    return Container(
      padding: EdgeInsets.all(
        ScreenAdapter.width(5),
      ),
      width: ScreenAdapter.getScreenWidth() / 2,
      // color: KTColor.getRandomColor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          SizedBox(
            height: ScreenAdapter.height(10),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(
                    ScreenAdapter.width(5),
                  ),
                  width: ScreenAdapter.getScreenWidth() / 2 -
                      ScreenAdapter.width(20),
                  height: ScreenAdapter.height(50),
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(
                      ScreenAdapter.width(5),
                    ),
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        content,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: ScreenAdapter.width(15),
                      ),
                      Text(
                        strTime,
                        style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(12),
                        ),
                      ), //文本框
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  showRule() {
    HJDialog.showAllCustomDialog(
      context,
      clickBgHidden: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          KTLog('这是完全自定义的弹框，点击红色部分隐藏');
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.only(
            left: ScreenAdapter.width(20),
            top: ScreenAdapter.width(20),
            right: ScreenAdapter.width(20),
          ),
          width: ScreenAdapter.height(300),
          height: ScreenAdapter.height(500),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("等级上限:${_RuleModel.data?.levelMax}级"),
              Text("每级所需经验"),
              Expanded(
                flex: 1,
                child: Container(
                  // color: Colors.orange,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _levelList.length,
                    itemBuilder: (context, index) {
                      var leveModel = _levelList[index];
                      return Container(
                        // color: KTColor.getRandomColor(),
                        height: ScreenAdapter.height(30),
                        child: Row(
                          children: [
                            Container(
                              width: ScreenAdapter.width(260 / 2),
                              height: ScreenAdapter.height(29),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: ScreenAdapter.width(0.5),
                                  ),
                                  top: BorderSide(
                                    width: ScreenAdapter.width(0.5),
                                  ),
                                  // bottom: BorderSide(
                                  //   width: ScreenAdapter.width(0.5),
                                  // ),
                                ),
                              ),
                              child: Text("${leveModel.level}级"),
                            ),
                            Container(
                              width: ScreenAdapter.width(260 / 2),
                              height: ScreenAdapter.height(29),
                              child: Text("${leveModel.exp}经验"),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: ScreenAdapter.width(0.5),
                                  ),
                                  right: BorderSide(
                                    width: ScreenAdapter.width(0.5),
                                  ),
                                  top: BorderSide(
                                    width: ScreenAdapter.width(0.5),
                                  ),
                                  // bottom: BorderSide(
                                  //   width: ScreenAdapter.width(0.5),
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: ScreenAdapter.height(20),
              ),
              Text("经验获取"),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _expRuleList.length,
                  itemBuilder: (context, index) {
                    var expRuleModel = _expRuleList[index];
                    return Container(
                      // color: KTColor.getRandomColor(),
                      height: ScreenAdapter.height(30),
                      child: Text(
                          "${index + 1}、${expRuleModel.name ?? ""}行为+${expRuleModel.expValue}经验,每天获取上限${expRuleModel.dailyMaxExp}"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
