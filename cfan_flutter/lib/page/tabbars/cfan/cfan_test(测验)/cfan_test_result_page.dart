import 'package:cfan_flutter/base/global_size.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_test(%E6%B5%8B%E9%AA%8C)/model/cfan_test_result_model.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//测验结果
class CfanTestResultPage extends StatefulWidget {
  final int answerId;
  const CfanTestResultPage({super.key, required this.answerId});

  @override
  State<CfanTestResultPage> createState() => _CfanTestResultPageState();
}

class _CfanTestResultPageState extends State<CfanTestResultPage> {
  final CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();

  CfanTestResultModel _resultModel = CfanTestResultModel();
  List<CfanTestResultItemModel> _resultModelList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserTestResultListData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //获取测验结果列表
  getUserTestResultListData() {
    _cfanCommunityHomeProvider.userTestAnswerresult(
      widget.answerId,
      // page,
      onSuccess: (data) {
        if (data['code'] == 200) {
          setState(() {
            _resultModel = CfanTestResultModel.fromJson(data);
            KTLog(_resultModel.data!.rightNum.toString());
            _resultModelList.addAll(_resultModel.data?.list ?? []);
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
        title: Text("测验结果"),
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              "正确: ${_resultModel.data?.rightNum.toString()} 错误: ${_resultModel.data?.errorNum.toString()}",
              style: TextStyle(
                fontSize: ScreenAdapter.fontSize(18),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: Table(
              // defaultVerticalAlignment: TableCellVerticalAlignment.top, //小部件垂直对齐发方式
              border: TableBorder.all(), //在表格周围添加边框装饰
              defaultColumnWidth: FlexColumnWidth(
                  10.0), //水平列的相对宽度    IntrinsicColumnWidth():固有列宽（）
              columnWidths: {1: FractionColumnWidth(.2)}, //为各列设置此特定行为
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey3,
                  ),
                  children: [
                    SizedBox(
                      height: 30,
                      child: Center(
                        child: Text('题目序号'),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Center(
                        child: Text('正确答案'),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Center(
                        child: Text('您的答案'),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Center(
                        child: Text('答题结果'),
                      ),
                    ),
                    //查看题目操作先屏蔽了
                    // SizedBox(
                    //   height: 30,
                    //   child: Center(
                    //     child: Text('操作'),
                    //   ),
                    // ),
                  ],
                ),
                //拼接数组添加数据 每行数据
                // TableRow(
                //   children: GetTableCell(),
                // ),
                // TableRow(
                //   children: GetTableCell(),
                // ),
                // TableRow(
                //   children: GetTableCell(),
                // ),
                // TableRow(
                //   children: GetTableCell(),
                // ),
                ..._resultModelList.map((model) {
                  return TableRow(children: GetTableCell(model));
                })
              ],
            ),
          ),
        ],
      ),
    );
  }

  // List<TableRow> _buildTableRow() {
  //   return _resultModelList.map((model) {});
  // }

  List<TableCell> GetTableCell(CfanTestResultItemModel itemModel) {
    List<TableCell> CList = [];
    CList.add(
      TableCell(
        //     child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center, // 在主轴方向上居中
        //   crossAxisAlignment: CrossAxisAlignment.center, // 在交叉轴方向上居中
        //   children: [
        //     Text(itemModel.num.toString()),
        //   ],
        // )

        child: Container(
          height: 50,
          // color: Colors.red,
          child: Center(
            child: Text(itemModel.num.toString()),
          ),
        ),
      ),
    );
    CList.add(
      TableCell(
        child: Container(
          height: 50,
          // color: Colors.red,
          child: Center(
            child: Text(itemModel.rightOption ?? "-"),
          ),
        ),
      ),
    );
    CList.add(
      TableCell(
        child: Container(
          height: 50,
          // color: Colors.red,
          child: Center(
            // child: Text('B'),
            child: Text(itemModel.userOption ?? "-"),
          ),
        ),
      ),
    );
    CList.add(
      TableCell(
        child: Container(
          height: 50,
          // color: Colors.red,
          child: Center(
            child: Text(itemModel.isRight! ? "✔️" : "❌"),
          ),
        ),
      ),
    );
    //查看题目先屏蔽了
    // CList.add(
    //   TableCell(
    //     child: Container(
    //       height: 50,
    //       // color: Colors.red,
    //       child: Center(
    //         child: TextButton(
    //           onPressed: () {
    //             // 根据模型点击
    //             KTLog(itemModel.num!);
    //           },
    //           child: Text("查看题目"),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return CList;
  }

  Widget _bottomWidegt() {
    return Container(
      padding: EdgeInsets.all(padding_10),
      width: double.infinity,
      height: ScreenAdapter.height(80),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: ScreenAdapter.width(0.5),
            color: Colors.grey,
          ),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () {
              KTLog("开始测验");
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text("返回开始测验"),
          ),
        ],
      ),
    );
  }
}
