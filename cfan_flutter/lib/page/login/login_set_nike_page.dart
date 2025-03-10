import 'dart:math';

import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/main/index_page.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//登录后基本信息填写完 跳转的修改昵称页面
class LoginSetNikePage extends StatefulWidget {
  const LoginSetNikePage({super.key});

  @override
  State<LoginSetNikePage> createState() => _LoginSetNikePageState();
}

class _LoginSetNikePageState extends State<LoginSetNikePage> {
  //用户昵称
  // final TextEditingController _usernameController = TextEditingController();

  List nickList = [
    {
      'id': 1,
      'imageUrl': 'https://www.itying.com/images/flutter/1.png',
      'name': '周杰伦',
      'nick': '默认昵称',
      'contr': '',
    },
    {
      'id': 2,
      'imageUrl': 'https://www.itying.com/images/flutter/2.png',
      'name': '五月天',
      'nick': '默认昵称',
      'contr': '',
    },
    {
      'id': 3,
      'imageUrl': 'https://www.itying.com/images/flutter/3.png',
      'name': '孙燕姿',
      'nick': '默认昵称',
      'contr': '',
    },
    {
      'id': 4,
      'imageUrl': 'https://www.itying.com/images/flutter/4.png',
      'name': '梁静茹',
      'nick': '默认昵称',
      'contr': '',
    },
  ];

  //初始化输入框Map
  Map<String, TextEditingController> _textControllers = Map();

  @override
  void initState() {
    super.initState();

    // _usernameController.addListener((lister) {
    //   KTLog("输入的昵称:$lister");
    // } as VoidCallback);
    //通过获得的网络数据 循环遍历创建TextEditingController
    nickList.forEach((element) {
      var a = element['contr'];
      _textControllers[a] = TextEditingController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置所在社群昵称"),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: nickList.length,
            itemBuilder: (BuildContext context, int index) {
              // return ListTile(
              //   leading: Image.network(nickList[index]["imageUrl"]),
              //   title: Text(nickList[index]["name"]),
              //   subtitle: Text(nickList[index]["nick"]),
              // );
              return Container(
                padding: EdgeInsets.all(
                  ScreenAdapter.width(10),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: ScreenAdapter.height(0.5),
                      color: Colors.black,
                    ),
                    bottom: index == nickList.length - 1
                        ? BorderSide(
                            width: ScreenAdapter.height(0.5),
                            color: Colors.black,
                          )
                        : BorderSide(
                            width: 0,
                            color: Colors.white,
                          ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        //头像
                        Container(
                          margin:
                              EdgeInsets.only(right: ScreenAdapter.width(10)),
                          width: 80,
                          height: 80,
                          // color: KTColor.getRandomColor(),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                ScreenAdapter.width(10),
                              ),
                            ),
                            image: DecorationImage(
                                image: NetworkImage(
                                  nickList[index]["imageUrl"],
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),

                        //社群名字
                        Text(
                          nickList[index]["name"],
                          style: TextStyle(
                            fontSize: ScreenAdapter.fontSize(16),
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: ScreenAdapter.width(50),
                    ),

                    //用户昵称
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: _textControllers[nickList[index]],
                        //输入规则
                        // inputFormatters: [],
                        textAlign: TextAlign.center, //文本内容实现左右居中
                        style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(18),
                        ),
                        maxLines: 1, //最大行数
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ], // 过滤空格和换行
                        ////表示进入到页面后就弹出键盘
                        // autocorrect: true,

                        /////监听文本框输入内容
                        onChanged: (value) {
                          KTLog("输入的内容$value");
                          KTLog(nickList[index]);
                        },
                        decoration: const InputDecoration(
                          hintText: "用户昵称", //提示文字
                          border: InputBorder.none, //去掉下划线
                        ),
                      ),
                    ),
                    //按钮编辑
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          KTLog(index);
                        },
                        icon: Icon(Icons.edit_calendar_outlined),
                      ),
                    ),
                  ],
                ),
              );
            },
            // children: nikeList.map((value) {
            //   return Container(
            //     child: Row(
            //       children: [
            //         Container(
            //           margin: EdgeInsets.only(top: ScreenAdapter.height(5)),
            //           width: 100,
            //           height: 100,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.all(
            //               Radius.circular(
            //                 ScreenAdapter.width(10),
            //               ),
            //             ),
            //             image: DecorationImage(
            //                 image: NetworkImage(
            //                   value[index]["imageUrl"],
            //                 ),
            //                 fit: BoxFit.cover),
            //           ),
            //         )
            //       ],
            //     ),
            //   );
            // }).toList(),
          ),
          //底部 全选 工具
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              // padding: const EdgeInsets.only(right: 20),
              width: ScreenAdapter.getScreenWidth(),
              height: ScreenAdapter.height(80),
              decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: Color.fromARGB(211, 240, 236, 236), width: 2),
                  ),
                  color: Colors.orange),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: ScreenAdapter.width(300),
                    height: ScreenAdapter.height(45),
                    child: ElevatedButton(
                      onPressed: () {
                        KTLog("下一步");
                        // NavigationUtil.getInstance()
                        //     .pushNamed(RouterName.logoSetNikePage);
                        //登录跳转到tabbar首页
                        NavigationUtil.getInstance().pushAndRemoveUtil(
                          context,
                          RouterName.indexPage,
                          widget: const IndexPage(),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Color.fromRGBO(23, 176, 163, 1),
                        ),
                      ),
                      child: Text("下一步"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
