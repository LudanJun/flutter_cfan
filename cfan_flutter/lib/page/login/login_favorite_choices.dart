import 'dart:convert';

import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/main/index_page.dart';
import 'package:cfan_flutter/page/login/model/login_community_list_model.dart';
import 'package:cfan_flutter/provider/login_provider.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/page/login/listData.dart';
import 'package:cfan_flutter/provider/favorite_provider.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/widget/toast_utils/toast_util.dart';
import 'package:cfan_flutter/widget/dialog/net_dialog.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

//登录后 设置完基本信息  明星喜好 选择
class LoginFavoriteChoicesPage extends StatefulWidget {
  const LoginFavoriteChoicesPage({super.key});

  @override
  State<LoginFavoriteChoicesPage> createState() =>
      _LoginFavoriteChoicesPageState();
}

class _LoginFavoriteChoicesPageState extends State<LoginFavoriteChoicesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  LoginProvider _loginProvider = LoginProvider();

  //刷新控制器
  EasyRefreshController _easyController = EasyRefreshController();

  List<Map<String, dynamic>> tabData = [
    {
      'id': 1,
      'name': '全部',
    },
    {
      'id': 2,
      'name': '男明星',
    },
    {
      'id': 3,
      'name': '女明星',
    },
    {
      'id': 4,
      'name': '组合',
    },
    {
      'id': 5,
      'name': '官方',
    },
  ];
  /*
  List<Map<String, dynamic>> tabListData = [
    {
      'id': 1,
      'name': '全部',
      'items': [
        {
          "id": 1,
          "title": 'Tony shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/1.png',
          "checked": false,
        },
        {
          "id": 2,
          "title": 'Candy shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/2.png',
          "checked": false,
        },
        {
          "id": 3,
          "title": 'Jeffy shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/3.png',
          "checked": false,
        },
        {
          "id": 4,
          "title": 'Money shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/4.png',
          "checked": false,
        },
        {
          "id": 5,
          "title": 'Thank shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/5.png',
          "checked": false,
        },
        {
          "id": 6,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 7,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 8,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 9,
          "title": 'Shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
      ],
    },
    {
      'id': 2,
      'name': '男明星',
      'items': [
        {
          "id": 1,
          "title": '撒上的',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/1.png',
          "checked": false,
        },
        {
          "id": 2,
          "title": '去外地',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/2.png',
          "checked": false,
        },
        {
          "id": 3,
          "title": 'Jeffy shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/3.png',
          "checked": false,
        },
        {
          "id": 4,
          "title": 'Money shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/4.png',
          "checked": false,
        },
        {
          "id": 5,
          "title": 'Thank shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/5.png',
          "checked": false,
        },
        {
          "id": 6,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 7,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 8,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 9,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
      ],
    },
    {
      'id': 3,
      'name': '女明星',
      'items': [
        {
          "id": 1,
          "title": '给钱啊',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/1.png',
          "checked": false,
        },
        {
          "id": 2,
          "title": 'Tony shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/2.png',
          "checked": false,
        },
        {
          "id": 3,
          "title": 'Jeffy shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/3.png',
          "checked": false,
        },
        {
          "id": 4,
          "title": 'Money shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/4.png',
          "checked": false,
        },
        {
          "id": 5,
          "title": 'Thank shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/5.png',
          "checked": false,
        },
        {
          "id": 6,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 7,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 8,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 9,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
      ],
    },
    {
      'id': 4,
      'name': '组合',
      'items': [
        {
          "id": 1,
          "title": '擦饿啊去污粉',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/1.png',
          "checked": false,
        },
        {
          "id": 2,
          "title": 'Tony shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/2.png',
          "checked": false,
        },
        {
          "id": 3,
          "title": 'Jeffy shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/3.png',
          "checked": false,
        },
        {
          "id": 4,
          "title": 'Money shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/4.png',
          "checked": false,
        },
        {
          "id": 5,
          "title": 'Thank shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/5.png',
          "checked": false,
        },
        {
          "id": 6,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 7,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 8,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 9,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
      ],
    },
    {
      'id': 5,
      'name': '官方',
      'items': [
        {
          "id": 1,
          "title": '废弃物',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/1.png',
          "checked": false,
        },
        {
          "id": 2,
          "title": 'Tony shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/2.png',
          "checked": false,
        },
        {
          "id": 3,
          "title": 'Jeffy shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/3.png',
          "checked": false,
        },
        {
          "id": 4,
          "title": 'Money shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/4.png',
          "checked": false,
        },
        {
          "id": 5,
          "title": 'Thank shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/5.png',
          "checked": false,
        },
        {
          "id": 6,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 7,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 8,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 9,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
      ],
    },
  ];
  */
  //选择单页的数据
  List<LoginCommunityItemModel> _itemsList = [];
  int selectTabbasIndex = 0;

  List<LoginCommunityItemModel> _loginCommunityListModel =
      <LoginCommunityItemModel>[];
  //分页
  int _page = 1;
  bool _flag = true; //解决重复请求的问题
  bool _hasData = true;

  //生命周期函数:当组件初始化的时候就会触发
  @override
  void initState() {
    super.initState();
    // _easyController = EasyRefreshController(
    //   controlFinishRefresh: true,
    //   controlFinishLoad: true,
    // );
    delayedFunction();
    // _easyController.finishRefresh();

    _tabController = TabController(length: tabData.length, vsync: this);

    _tabController.addListener(() {
      KTLog(_tabController.index);
      //把选择的所有 赋值给全局变量以防丢失
      selectTabbasIndex = _tabController.index;

      //1.选择顶部tabbars的时候清除全选
      //1.1传入选择状态 全选改false
      Provider.of<FavoriteProvider>(context, listen: false)
          .checkAllBoxFunc(false);
      // //1.2清除全选的内容
      Provider.of<FavoriteProvider>(context, listen: false)
          .removeAll(_itemsList);
    });
  }

  //获取社群
  getCommunityList(String categoryId, String page) {
    if (_flag && _hasData) {
      _flag = false;
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return NetLoadingDialog(
              outsideDismiss: false,
            );
          },);

      ///分类(0全部,1男明星，2女明星，3艺人组合，4节目官方)
      _loginProvider.communityList(
        categoryId, //分类
        page, //分页
        onSuccess: (data) {
          var tempList = LoginCommunityModel.fromJson(data);
          setState(() {
            _loginCommunityListModel.addAll(tempList.data!.list!);
            _page++;
            _flag = true;
            KTLog(_loginCommunityListModel.length);
          });
          //判断有没有数据
          if (tempList.data!.list!.length < 9) {
            setState(() {
              _hasData = false;
            });
          }
          Navigator.of(context).pop();
        },
        onFailure: (error) {
          Navigator.of(context).pop();
        },
      );
    }
  }

  //必须加延时函数  showDialog 才能使用不报错
  Future<void> delayedFunction() async {
    await Future.delayed(Duration(seconds: 1)); // 延时2秒
    print("这是在延时后执行的函数");
    getCommunityList(selectTabbasIndex.toString(), '1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("喜好选择"),
        bottom: TabBar(
          isScrollable: false, //是否可以滚动
          indicatorColor: Colors.blue, //指示器颜色
          indicatorWeight: 2, //指示器高度
          // indicatorPadding:const EdgeInsets.all(5),//上下左右5个间距
          indicatorSize: TabBarIndicatorSize.label, //跟文字一样长
          // indicator: BoxDecoration(//不常用
          //   //指示器边框设置
          //   color: Colors.red,
          //   //配置圆角
          //   borderRadius: BorderRadius.circular(10),
          // ),
          labelColor: Colors.blue, //选中label后的文字颜色
          labelStyle: TextStyle(
              fontSize: ScreenAdapter.fontSize(14), //选中的文字大小
              fontWeight: FontWeight.w800),
          // unselectedLabelColor: Colors.white,//未选中的文字颜色
          unselectedLabelStyle: TextStyle(
            fontSize: ScreenAdapter.fontSize(14), //未选中文字大小
          ),
          controller: _tabController,
          onTap: (value) {
            KTLog("选择第$value个tabbas");

            //把选择的所以 赋值给全局变量以防丢失
            selectTabbasIndex = value;
            _page = 1;
            _hasData = true;
            _loginCommunityListModel = [];
            getCommunityList(selectTabbasIndex.toString(), _page.toString());
            // delayedFunction();

            //1.选择顶部tabbars的时候清除全选
            //1.1传入选择状态 全选改false
            Provider.of<FavoriteProvider>(context, listen: false)
                .checkAllBoxFunc(false);
            // //1.2清除全选的内容
            Provider.of<FavoriteProvider>(context, listen: false)
                .removeAll(_itemsList);
          },
          tabs: tabData.map((value) {
            return Tab(
              child: Text(value['name']),
            );
          }).toList(),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: ScreenAdapter.height(80),
            child: TabBarView(
              //也要配置_tabController
              controller: _tabController,
              children: tabData.map((value) {
                return EasyRefresh(
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
                    _loginCommunityListModel = [];
                    _page = 1;
                    _hasData = true;

                    await Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) {
                        getCommunityList(
                            selectTabbasIndex.toString(), _page.toString());
                      }
                    });
                  },
                  onLoad: () async {
                    KTLog("上拉加载");
                    await Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) {
                        getCommunityList(
                            selectTabbasIndex.toString(), _page.toString());
                      }
                    });
                  },
                  controller: _easyController,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 2, //横轴水平间距
                      crossAxisCount: 3, //配置一行有几个
                      mainAxisSpacing: 5, //垂直间距
                      childAspectRatio: 2 / 3, //宽高比
                    ),
                    itemCount: _loginCommunityListModel.length,
                    itemBuilder: (context, index) {
                      // bool isInCart = Provider.of<FavoriteProvider>(context)
                      //     .list
                      //     .any((element) => element == value['items'][index]);

                      bool isInCart = Provider.of<FavoriteProvider>(context)
                          .list
                          .any((element) =>
                              element ==
                              _loginCommunityListModel[index].communityId);

                      if (index >= _loginCommunityListModel.length) {
                        // throw Exception('Index out of range');
                        return Container();
                      } else {
                        return Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  ScreenAdapter.width(10)),
                              border: Border.all(
                                color: Colors.black87,
                              )),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: ScreenAdapter.height(5)),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      ScreenAdapter.width(10),
                                    ),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      _loginCommunityListModel[index].avatar!,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _loginCommunityListModel[index].title!,
                                style: TextStyle(
                                  fontSize: ScreenAdapter.fontSize(12),
                                  color: Colors.red,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  KTLog("关注第$index个");

                                  if (isInCart) {
                                    //从购物车移除数据
                                    Provider.of<FavoriteProvider>(context,
                                            listen: false)
                                        .remove(_loginCommunityListModel[index]
                                            .communityId!);
                                  } else {
                                    //给购物车添加数据
                                    Provider.of<FavoriteProvider>(context,
                                            listen: false)
                                        .add(_loginCommunityListModel[index]
                                            .communityId!);
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: isInCart
                                      ? WidgetStateProperty.all(
                                          Color.fromRGBO(230, 230, 230, 1),
                                        )
                                      : WidgetStateProperty.all(Colors.white),
                                ),
                                child: isInCart ? Text("已关注") : Text("关注"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                );

                /*
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2, //横轴水平间距
                  crossAxisCount: 3, //配置一行有几个
                  mainAxisSpacing: 5, //垂直间距
                  childAspectRatio: 2 / 3, //宽高比
                ),
                itemCount: value['items'].length,
                // itemBuilder: _initGridViewData,
                itemBuilder: (context, index) {
                  bool isInCart = Provider.of<FavoriteProvider>(context)
                      .list
                      .any((element) => element == value['items'][index]);
                  return Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenAdapter.width(10)),
                        border: Border.all(
                          color: Colors.black87,
                        )),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: ScreenAdapter.height(5)),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                ScreenAdapter.width(10),
                              ),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                value['items'][index]["imageUrl"],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          value['items'][index]["title"],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            KTLog("关注第$index个");

                            if (isInCart) {
                              //从购物车移除数据
                              Provider.of<FavoriteProvider>(context,
                                      listen: false)
                                  .remove(value['items'][index]);
                            } else {
                              //给购物车添加数据
                              Provider.of<FavoriteProvider>(context,
                                      listen: false)
                                  .add(value['items'][index]);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: isInCart
                                ? WidgetStateProperty.all(
                                    Color.fromRGBO(230, 230, 230, 1),
                                  )
                                : WidgetStateProperty.all(Colors.white),
                          ),
                          child: isInCart ? Text("已关注") : Text("关注"),
                        ),
                      ],
                    ),
                  );
                },
              );*/
              }).toList(),
            ),
          ),
          //底部 全选 工具
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(right: 20),
              width: ScreenAdapter.getScreenWidth(),
              height: ScreenAdapter.height(80),
              decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: Color.fromARGB(211, 240, 236, 236), width: 2),
                  ),
                  color: Colors.orange),
              child: Row(
                children: [
                  Checkbox(
                    value: Provider.of<FavoriteProvider>(context, listen: true)
                        .checkAllBox,
                    onChanged: (value) {
                      KTLog(value!);
                      // KTLog(itemsList);
                      //传入选择状态 是否全选
                      Provider.of<FavoriteProvider>(context, listen: false)
                          .checkAllBoxFunc(value);

                      //获取选择的数据
                      _itemsList = _loginCommunityListModel;
                      //如果不是全选移除所有数据
                      if (value == false) {
                        Provider.of<FavoriteProvider>(context, listen: false)
                            .removeAll(_itemsList);
                      } else {
                        //全选当前页所有数据
                        Provider.of<FavoriteProvider>(context, listen: false)
                            .addAll(_itemsList);
                      }
                    },
                  ),
                  Text(
                    '本页全选',
                    style: TextStyle(),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenAdapter.width(15)),
                    width: ScreenAdapter.width(250),
                    height: ScreenAdapter.height(45),
                    child: ElevatedButton(
                      onPressed: () {
                        KTLog("下一步");

                        String ids = jsonEncode(Provider.of<FavoriteProvider>(
                                context,
                                listen: false)
                            .list);
                        _loginProvider.addCommunity(
                          ids,
                          onSuccess: (data) async {
                            if (data['code'] == 200) {
                              showToast("加入成功");

                              await Future.delayed(const Duration(seconds: 2),
                                  () {
                                // NavigationUtil.getInstance()
                                //     .pushNamed(RouterName.indexPage);
                                // NavigationUtil.getInstance()
                                //     .pushReplacementPage(
                                //   context,
                                //   RouterName.indexPage,
                                //   widget: const IndexPage(),
                                // );

                                NavigationUtil.getInstance().pushAndRemoveUtil(
                                  context,
                                  RouterName.indexPage,
                                  widget: const IndexPage(),
                                );
                                if (mounted) {}
                              });
                            }
                          },
                          onFailure: (error) {},
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Color.fromRGBO(23, 176, 163, 1),
                        ),
                      ),
                      child: Text("下一步"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
/*
  // 喜好item
  Widget _initGridViewData(context, index) {
    KTLog("590----$index");
    //通过这个方式来判断商品是否在购物车里面
    // bool isInCart = Provider.of<FavoriteProvider>(context)
    //     .list
    //     .any((element) => element == listData[index]);
    KTLog(tabListData[index]['items']);
    KTLog(tabListData[index]['items'][index]);

    bool isInCart = Provider.of<FavoriteProvider>(context)
        .list
        .any((element) => element == tabListData[index]['items'][index]);
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.black26,
      )),
      child: Column(
        children: [
          // Image.network(listData[index]["imageUrl"]),
          Image.network(tabListData[index]['items'][index]["imageUrl"]),
          const SizedBox(height: 10),
          Text(
            tabListData[index]['items'][index]["title"],
            style: const TextStyle(
              fontSize: 18,
              color: Colors.red,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              print(index);
              if (isInCart) {
                //从购物车移除数据
                Provider.of<FavoriteProvider>(context, listen: false)
                    .remove(listData[index]);
              } else {
                //给购物车添加数据
                Provider.of<FavoriteProvider>(context, listen: false)
                    .add(listData[index]);
              }
            },
            style: ButtonStyle(
              backgroundColor: isInCart
                  ? WidgetStateProperty.all(
                      Color.fromRGBO(230, 230, 230, 1),
                    )
                  : WidgetStateProperty.all(Colors.white),
            ),
            child: isInCart ? Text("已关注") : Text("关注"),
          ),
        ],
      ),
    );
  }
  */
}
