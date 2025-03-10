import 'dart:convert';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/base/global_size.dart';
import 'package:cfan_flutter/page/login/listData.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_test(%E6%B5%8B%E9%AA%8C)/model/cfan_test_paper_model.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/widget/image/default_image.dart';
import 'package:cfan_flutter/widget/toast_utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CfanTestPaperPage extends StatefulWidget {
  final int examId;
  const CfanTestPaperPage({super.key, required this.examId});

  @override
  State<CfanTestPaperPage> createState() => _CfanTestStartPageState();
}

class _CfanTestStartPageState extends State<CfanTestPaperPage>
    with SingleTickerProviderStateMixin {
  final CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();

  //试题数组
  List<CfanTestPaperItemModel> _paperItemList = [];

  //底部自动下一题按钮
  bool _checkboxValue = true;
  //用于选项索引
  int? _optionSelectIndex;

  bool isInCart = false;
  // //用于跟踪当前选项中的页面索引
  // int? _selectedPage;
  // // 使用一个Map来跟踪每个页面每个选项的选中状态
  // // 键是一个包含页面索引和选项索引的元组
  // Map<List, bool> selectedOptions = {};

  String answerJsonString = '';
  PageController _pageController = PageController(); // 控制器
  //当前页数
  int _currentPage = 0; // 当前页码
  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // 初始化控制器
    //每次进来都要移除所有数据
    Provider.of<CfanCommunityHomeProvider>(context, listen: false).removeAll();

    //请求测验试题
    getTestpaper();
  }

  @override
  void dispose() {
    // Provider.of<CfanCommunityHomeProvider>(context, listen: false).removeAll();
    super.dispose();
    // _cfanCommunityHomeProvider.dispose();
    _pageController.dispose();
  }

  //获取测验试题
  getTestpaper() {
    _cfanCommunityHomeProvider.userTestPaper(
      widget.examId,
      onSuccess: (data) {
        if (data['code'] == 200) {
          var tempData = CfanTestPaperModel.fromJson(data);
          setState(() {
            _paperItemList.addAll(tempData.data ?? []);
          });
        }
      },
      onFailure: (error) {},
    );
  }

  ///提交测验
  submitTestData() {
    _cfanCommunityHomeProvider.userTestUserAnswer(
      widget.examId,
      answerJsonString,
      onSuccess: (data) {
        if (data['code'] == 200) {
          showToast("提交成功!");
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {
          showToast("提交失败:${data['message']}");
          Navigator.of(context).pop();
        }
      },
      onFailure: (error) {
        Navigator.of(context).pop();
        showToast(error);
      },
    );
  }

  //上一页
  void previousPage() {
    setState(() {
      _currentPage = (_pageController.page ?? 0).round(); //获取当前页码并取整
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeIn,
      );
    });
  }

  //下一页
  void nextPage() {
    setState(() {
      _currentPage = (_pageController.page ?? 0).round(); //获取当前页码并取整
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeIn,
      );
    });
  }

  // bool _willPop = true; // 控制是否允许退出

  @override
  Widget build(BuildContext context) {
    var mmmmap =
        Provider.of<CfanCommunityHomeProvider>(context).selectedOptionsNew;
    return MaterialApp(
      home: PopScope(
        onPopInvoked: (didPop) async {},
        child: Scaffold(
          appBar: AppBar(
            title: Text("测验"),
            centerTitle: true,
            leading: IconButton(
              onPressed: () async {
                KTLog("返回按钮");

                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("提示信息"),
                      //弹框背景色修改
                      backgroundColor: Colors.white,
                      content: const Text(
                        "确定要退出,并提交吗?",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        //标题居中显示
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              print("ok");
                              Navigator.of(context).pop("确定"); //执行返回
                              Navigator.of(context).pop("确定"); //执行返回
                            },
                            child: const Text("确定")),
                        TextButton(
                            onPressed: () {
                              print("cancel");
                              Navigator.of(context).pop("取消"); //执行返回
                            },
                            child: const Text("取消")),
                      ],
                      //点击按钮 排布方式
                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                    );
                  },
                );
              },
              icon: Icon(Icons.arrow_back_ios_new_outlined),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(margin_10),
                child: OutlinedButton(
                  onPressed: () {
                    KTLog("提交");
                    //循环遍历字典数据存放到 数组里
                    //{
                    //  0: {1: Instance of 'CfanTestPaperItemOptionModel'},
                    //  1: {1: Instance of 'CfanTestPaperItemOptionModel'}
                    // }
                    // Map<String, int> result = {};
                    // result["question_id"] = questionModel.questionId ?? 0;
                    // result["option_id"] = optionModel.optionId ?? 0;
                    // _optionList.add(result);
                    // Provider.of<CfanCommunityHomeProvider>(context)
                    //     .selectedOptions
                    //     .forEach((key, value) {
                    //   KTLog("key : $key");
                    //   KTLog("value : $value");

                    // });
                    List arr = [];
                    mmmmap.forEach((key, value) {
                      //key:代表的是当前页从0开始算
                      //value:
                      Map<String, int> result = {};

                      KTLog("key : $key --- value : $value");
                      result["question_id"] = key;
                      result["option_id"] = value;
                      arr.add(result);
                    });
                    KTLog("arr$arr");
                    answerJsonString = jsonEncode(arr);
                    KTLog("answerJsonString$answerJsonString");
                    if (arr.length != _paperItemList.length) {
                      // showToast("还有题目未选择是否提交");

                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("提示信息"),
                            //弹框背景色修改
                            backgroundColor: Colors.white,
                            content: const Text(
                              "还有题目未选择,是否提交?",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              //标题居中显示
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    print("ok");

                                    submitTestData();
                                    // Navigator.of(context).pop("确定"); //执行返回
                                    // Navigator.of(context).pop("确定"); //执行返回
                                  },
                                  child: const Text("确定")),
                              TextButton(
                                  onPressed: () {
                                    print("cancel");
                                    Navigator.of(context).pop("取消"); //执行返回
                                  },
                                  child: const Text("取消")),
                            ],
                            //点击按钮 排布方式
                            actionsAlignment: MainAxisAlignment.spaceEvenly,
                          );
                        },
                      );

                      return;
                    } else {
                      submitTestData();
                    }

                    // Navigator.of(context).pop();
                  },
                  child: const Text("提交"),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              PageView.builder(
                //TabBarView
                controller: _pageController,
                scrollDirection: Axis.horizontal, //垂直滑动 默认水平滑动
                allowImplicitScrolling: true, //缓存当前页面的前后两页
                onPageChanged: (value) {
                  KTLog(value);
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: _paperItemList.length,
                itemBuilder: (context, index) {
                  var itemModel = _paperItemList[index];
                  return _bodyWidget(itemModel, _currentPage, index);
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _bottomWidegt(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //主内容 相当于 OptionsPage
  Widget _bodyWidget(CfanTestPaperItemModel model, int pageIndex, int index) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          //1.题目和图文资料
          _buildQuestionWidget(model, index),
          //2.题目选项
          _buildOptionWidget(model, pageIndex),
        ],
      ),
    );
  }

  //构建题目
  Widget _buildQuestionWidget(CfanTestPaperItemModel model, int index) {
    return Container(
      padding: EdgeInsets.all(padding_10),
      alignment: Alignment.centerLeft,
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "(${_currentPage + 1}/${_paperItemList.length}) ${model.title ?? ""}",
            style: TextStyle(
              fontSize: ScreenAdapter.fontSize(16),
            ),
          ),
          SizedBox(
            height: padding_5,
          ),
          CachedNetworkImage(
            imageUrl: model.introImage ?? "", //imageUrl6,
            fit: BoxFit.cover,
            placeholder: (context, url) => defaultHeadImage(),
            errorWidget: (context, url, error) => defaultHeadImage(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionWidget(CfanTestPaperItemModel model, int pageIndex) {
    return Container(
      padding: EdgeInsets.all(padding_10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "请选择",
            style: TextStyle(
              fontSize: ScreenAdapter.fontSize(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: ScreenAdapter.height(61) *
                model.optionList?.length, //高度根据选项多少来计算
            child: ListView.builder(
              //GridView
              physics: const NeverScrollableScrollPhysics(),
              itemCount: model.optionList?.length,
              itemBuilder: (context, index) {
                var optionModel = model.optionList?[index];
                //会遍历数组的选项然后进行每个cell 的赋值是否选中
                // bool isInCart = Provider.of<CfanCommunityHomeProvider>(context)
                //     .optionList
                //     .any((elemnt) => elemnt == optionModel);

                Provider.of<CfanCommunityHomeProvider>(context)
                    .selectedOptions
                    .forEach((key, value) {
                  // KTLog("key:$key,value:${value[index]}");
                  // if (value[index] == optionModel) {
                  //   isInCart = true;
                  // } else {
                  //   isInCart = false;
                  // }
                  if (key == _currentPage) {
                    if (value[index] == optionModel) {
                      isInCart = true;
                    } else {
                      isInCart = false;
                    }
                  }
                });
                return InkWell(
                  onTap: () {
                    setState(() {
                      // KTLog("选择的当前页是:$_currentPage");
                      // _optionSelectIndex = index; //用来单选
                      // KTLog("选择的第$index个选项");
                      if (isInCart) {
                        KTLog("存在 要移除");
                        // Provider.of<CfanCommunityHomeProvider>(context,
                        //         listen: false)
                        //     .removeOption(_currentPage, index, optionModel!);
                      } else {
                        // KTLog("_optionSelectIndex $_optionSelectIndex");
                        // KTLog("index $index");
                        KTLog("不存在 要添加");

                        Provider.of<CfanCommunityHomeProvider>(context,
                                listen: false)
                            .addOption(
                                model.questionId ?? 0,
                                optionModel?.optionId ?? 0,
                                _currentPage,
                                index,
                                model,
                                optionModel!,
                                true);
                      }

                      // Map<int, CfanTestPaperItemOptionModel> map = {};
                      // map[index] = model.optionList![index];
                      // KTLog(map[index]?.content ?? "");
                      // Provider.of<CfanCommunityHomeProvider>(context,
                      //         listen: false)
                      //     .addOption(_currentPage, index, map);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(
                      ScreenAdapter.width(5),
                    ),
                    height: margin_50,
                    // color: KTColor.getRandomColor(),
                    decoration: BoxDecoration(
                      // color: (_optionSelectIndex == index)
                      //     ? Colors.green
                      //     : Colors.white,
                      color: isInCart ? Colors.green : Colors.white,
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
                        SizedBox(
                          width: padding_5,
                        ),
                        // (_optionSelectIndex == index)
                        //     ? Icon(Icons.circle_rounded)
                        //     : Icon(Icons.circle_outlined),

                        isInCart
                            ? Icon(Icons.circle_rounded)
                            : Icon(Icons.circle_outlined),
                        SizedBox(
                          width: padding_10,
                        ),
                        //选项
                        Text("${optionModel?.optionChar ?? ""}:"),
                        SizedBox(
                          width: padding_10,
                        ),
                        //选项内容
                        Text(optionModel?.content ?? ""),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  ///底部添加工具栏定位组件
  Widget _bottomWidegt() {
    return Container(
      height: ScreenAdapter.height(90),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: ScreenAdapter.width(0.5),
            color: Colors.grey,
          ),
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            activeColor: Colors.grey, //选中的按钮颜色
            checkColor: Colors.white,
            value: _checkboxValue, //false:未选中
            onChanged: (value) {
              setState(() {
                KTLog(value ?? false);
                _checkboxValue = value!;
              });
            },
          ),
          Text(
            "自动下一题",
            style: TextStyle(
              fontSize: ScreenAdapter.fontSize(14),
            ),
          ),
          SizedBox(
            width: ScreenAdapter.width(10),
          ),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                KTLog("上一题");
                previousPage();
              },
              child: Text("上一题"),
            ),
          ),
          SizedBox(
            width: ScreenAdapter.width(10),
          ),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                KTLog("下一题");
                nextPage();
              },
              child: Text("下一题"),
            ),
          ),
          SizedBox(
            width: ScreenAdapter.width(10),
          ),
        ],
      ),
    );
  }
}

class _AutomaticKeepAlive extends StatefulWidget {
  final Widget child;

  const _AutomaticKeepAlive({
    required this.child,
  });

  @override
  State<_AutomaticKeepAlive> createState() => _AutomaticKeepAliveState();
}

class _AutomaticKeepAliveState extends State<_AutomaticKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
