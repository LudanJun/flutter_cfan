import 'dart:io';

import 'package:cfan_flutter/provider/login_provider.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/base/kt_style.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/widget/toast_utils/toast_util.dart';
import 'package:cfan_flutter/widget/bottom_sheet_widget.dart';
import 'package:cfan_flutter/widget/dialog/net_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//登录后 基本信息填写
class LoginSetInfoPage extends StatefulWidget {
  const LoginSetInfoPage({super.key});

  @override
  State<LoginSetInfoPage> createState() => _LoginSetInfoPageState();
}

class _LoginSetInfoPageState extends State<LoginSetInfoPage> {
  LoginProvider _loginProvider = LoginProvider();

  //用户昵称
  final TextEditingController usernameController = TextEditingController();

  ///性别选择
  final List<String> sexData = [
    '男',
    '女',
    '保密',
  ];
  //获取选择的性别 默认是男
  // late String _dropdownSexValue = sexData.first;
  late String _dropdownSexValue = '';

  //生日选择
  late DateTime _dateTime = DateTime.now();
  final TextEditingController _birthdayController = TextEditingController();

  final List<String> countryData = [
    '中国',
    '美国',
  ];

  ///国家选择
  // late String _dropdownCountryValue = countryData.first;
  late String _dropdownCountryValue = '';

  //实例化图片选择器
  final ImagePicker _picker = ImagePicker();
  //定义全局获取的图片属性 来实现显示
  XFile? _pickedFile;
  String getHeadImgUrl = '';

  ///底部弹框
  void _bottomSheet() async {
    print("_modelBottomSheet");
    var result = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 150,
          child: Center(
            child: Column(
              children: [
                ListTile(
                  title: const Text(
                    "相册",
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    print("aaa相册");
                    _pickGallery();
                    Navigator.of(context).pop("相册");
                  },
                ),
                ListTile(
                  title: const Text(
                    "拍照",
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    print("拍照");
                    _pickCamera();
                    Navigator.of(context).pop("拍照");
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //拍照 拍摄一张图片
  _pickCamera() async {
    //获取拍的照片
    XFile? image = await _picker.pickImage(
        //指定选择图片的类型
        source: ImageSource.camera,
        //默认选择的图片很大 需要指定下宽高
        maxWidth: ScreenAdapter.width(200),
        maxHeight: ScreenAdapter.width(200));
    print(image);
    if (image != null) {
      print(image.path);
      //选择完图片 开始上传
      _uploadImageFile(image.path);
      setState(() {
        _pickedFile = image;
      });
    }
  }

  //相册选择 只能选择一张图片
  _pickGallery() async {
    //获取选择的照片
    XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        //默认选择的图片很大 需要指定下宽高
        maxWidth: 800,
        maxHeight: 800);
    print(image);
    if (image != null) {
      KTLog(image.path);

      //选择完图片 开始上传

      _uploadImageFile(image.path);
      setState(() {
        _pickedFile = image;
      }); 
    }
  }

  //上传头像
  _uploadImageFile(imageDir) async {
    var formData = FormData.fromMap(
      {
        'image': await MultipartFile.fromFile(imageDir, filename: 'xxx.jpg'),
      },
    );
    _loginProvider.uplodHeadImage(
      formData,
      onSuccess: (data) {
        //{"success":true,"code":200,"message":"success","data":{"path":"https://ocfan.tt90.cc/uploadfile/20240613/659729011655589888.jpg"}}
        if (data['code'] == 200) {
          showToast("图像上传成功!");
          getHeadImgUrl = data['data']['path'];
          setState(() {});
        } else {
          showToast("失败!");
        }
      },
      onFailure: (error) {
        showToast(error ?? "");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "设置信息",
          style: KTTextStyle.appBarTitleBStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///1.头像
              InkWell(
                onTap: () {
                  KTLog("点击头像");
                  List list = [];
                  list.add('相册');
                  list.add('拍照');

                  _bottomSheet();
                },
                child: Container(
                  child: CircleAvatar(
                    radius: ScreenAdapter.width(60),
                    backgroundImage: getHeadImgUrl == ''
                        ? const NetworkImage(
                            "https://img0.baidu.com/it/u=1641416437,1150295750&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800")
                        : NetworkImage(getHeadImgUrl),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenAdapter.height(5),
              ),

              ///2.用户昵称
              Container(
                // alignment: Alignment.center,
                width: ScreenAdapter.width(150),
                child: TextField(
                  controller: usernameController,
                  //输入规则
                  // inputFormatters: [],
                  textAlign: TextAlign.center, //文本内容实现左右居中
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(18),
                  ),
                  maxLines: 1, //最大行数
                  ////表示进入到页面后就弹出键盘
                  // autocorrect: true,
                  /////监听文本框输入内容
                  onChanged: (value) {
                    KTLog(value);
                  },
                  decoration: const InputDecoration(
                    hintText: "用户昵称", //提示文字
                    // border: InputBorder.none, //去掉下划线
                  ),
                ),
              ),
              SizedBox(
                height: ScreenAdapter.height(80),
              ),

              ///3.性别选择
              Container(
                width: ScreenAdapter.height(300),
                alignment: Alignment.center,
                // color: Colors.orange,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "请选择性别",
                    style: TextStyle(
                      fontSize: ScreenAdapter.fontSize(16),
                    ),
                  ),
                ),
              ),
              DropdownMenu(
                width: ScreenAdapter.height(300),
                menuHeight: ScreenAdapter.height(200), //下拉菜单高度
                // initialSelection: sexData.first, //设置默认选中值
                hintText: "请选择性别", //提示语
                onSelected: (value) {
                  _dropdownSexValue = value!;
                  KTLog(_dropdownSexValue);
                },
                //选中回调
                dropdownMenuEntries: _buildSexMenuList(sexData), //菜单内容
              ),

              SizedBox(
                height: ScreenAdapter.height(30),
              ),
              Container(
                width: ScreenAdapter.height(300),
                alignment: Alignment.center,
                // color: Colors.orange,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "请选择生日",
                    style: TextStyle(
                      fontSize: ScreenAdapter.fontSize(16),
                    ),
                  ),
                ),
              ),

              Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    width: ScreenAdapter.height(300),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // color: Colors.orange,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      // enabled: false,
                      controller: _birthdayController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.grey,
                        //   ),
                        // ),
                        //点击的时候边框颜色改变
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black54,
                          ),
                        ),

                        hintText: "请选择日期", //提示文字
                        border: OutlineInputBorder(), //去掉下划线
                      ),
                    ),
                  ),
                  Positioned(
                    right: ScreenAdapter.width(10),
                    child: InkWell(
                      onTap: () async {
                        KTLog("点击了");
                        DateTime? ddd = await showDatePicker(
                          context: context,
                          initialDate: _dateTime,
                          firstDate: DateTime(1990, 1, 1),
                          lastDate: DateTime(2035, 1, 1),
                        );
                        if (ddd != null) {
                          setState(() {
                            _dateTime = ddd;
                            var str = "${ddd.year}-${ddd.month}-${ddd.day}";
                            KTLog(str);
                            //赋值时间
                            _birthdayController.text = str;
                          });
                        }
                      },
                      child: Icon(Icons.calendar_month_outlined),
                    ),
                  )
                ],
              ),

              SizedBox(
                height: ScreenAdapter.height(30),
              ),

              ///5.性别选择
              Container(
                width: ScreenAdapter.height(300),
                alignment: Alignment.center,
                // color: Colors.orange,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "请选择所在国家",
                    style: TextStyle(
                      fontSize: ScreenAdapter.fontSize(16),
                    ),
                  ),
                ),
              ),
              DropdownMenu(
                width: ScreenAdapter.height(300),
                menuHeight: ScreenAdapter.height(200), //下拉菜单高度
                // initialSelection: sexData.first, //设置默认选中值
                hintText: "请选择国家", //提示语
                onSelected: (value) {
                  _dropdownCountryValue = value!;
                  KTLog(_dropdownCountryValue);
                },
                //选中回调
                dropdownMenuEntries: _buildSexMenuList(countryData), //菜单内容
              ),
              SizedBox(
                height: ScreenAdapter.height(100),
              ),

              Container(
                color: Colors.white,
                width: ScreenAdapter.width(360),
                height: ScreenAdapter.height(45),
                child: ElevatedButton(
                  onPressed: () {
                    KTLog("下一步");
                    editUserInfo();
                  },
                  child: Text("下一步"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///编辑用户信息
  editUserInfo() {
    //
    if (usernameController.text.isEmpty) {
      showToast("请输入昵称!");
      return;
    }

    if (_dropdownSexValue.isEmpty) {
      showToast("请选择性别!");
      return;
    }

    if (_birthdayController.text.isEmpty) {
      showToast("请选择生日!");
      return;
    }
    if (_dropdownCountryValue.isEmpty) {
      showToast("请选择国家!");
      return;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return NetLoadingDialog(
            //dismissDialog: _disMissCallBack,
            outsideDismiss: false,
          );
        });

    _loginProvider.editUserInfo(
      usernameController.text,
      _birthdayController.text,
      _dropdownSexValue,
      _dropdownCountryValue,
      onSuccess: (data) {
        Navigator.of(context).pop();

        if (data["code"] == 200) {
          showToast("设置完成");

          NavigationUtil.getInstance()
              .pushNamed(RouterName.logoFavoriteChoicesPage);
        }
      },
      onFailure: (error) {
        Navigator.of(context).pop();
      },
    );
  }

  List<DropdownMenuEntry<String>> _buildSexMenuList(List<String> data) {
    return data.map((String value) {
      return DropdownMenuEntry(value: value, label: value);
    }).toList();
  }

  IconButton _showDatePicker(context) {
    return IconButton(
      icon: Icon(Icons.access_alarm_outlined),
      onPressed: () {
        showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1990, 1, 1),
            lastDate: DateTime(2035, 1, 1));
        /*
        showDatePicker(
          context: context,
          initialDate: DateTime.now(), // 初始化选中日期
          firstDate: DateTime(2020, 6), // 开始日期
          lastDate: DateTime(2024, 6), // 结束日期
          // initialEntryMode: DatePickerEntryMode.input,  // 日历弹框样式

          textDirection: TextDirection.ltr, // 文字方向

          currentDate: DateTime.now(), // 当前日期
          helpText: "helpText", // 左上方提示
          cancelText: "cancelText", // 取消按钮文案
          confirmText: "confirmText", // 确认按钮文案

          errorFormatText: "errorFormatText", // 格式错误提示
          errorInvalidText: "errorInvalidText", // 输入不在 first 与 last 之间日期提示

          fieldLabelText: "fieldLabelText", // 输入框上方提示
          fieldHintText: "fieldHintText", // 输入框为空时内部提示

          initialDatePickerMode: DatePickerMode.day, // 日期选择模式，默认为天数选择
          useRootNavigator: true, // 是否为根导航器
          // 设置不可选日期，这里将 2020-10-15，2020-10-16，2020-10-17 三天设置不可选
          // selectableDayPredicate: (dayTime) {
          //   if (dayTime == DateTime(2020, 10, 15) ||
          //       dayTime == DateTime(2020, 10, 16) ||
          //       dayTime == DateTime(2020, 10, 17)) {
          //     return false;
          //   }
          //   return true;
          // },
        );
        */
      },
    );
  }
}
