import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/base/cfan_localizations.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/base/kt_style.dart';
import 'package:cfan_flutter/provider/currentLocale_provider.dart';
import 'package:cfan_flutter/provider/login_provider.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/tools/storage/persistent_storage.dart';
import 'package:cfan_flutter/widget/toast_utils/toast_util.dart';
import 'package:cfan_flutter/widget/userAgreement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

//第三方登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginProvider _loginProvider = LoginProvider();

  //把选择的状态保存本地
  var ps = PersistentStorage();

  final List<String> data = [
    '中文',
    'english',
  ];
  late String _dropdownValue = data.first;

  /// 是否同意协议
  bool _isAgree = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly'
  ]);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //顶部导航
        elevation: 0,
        backgroundColor: KTColor.white,
        centerTitle: true,
        //标题
        // title: Text(CfanLocalizations.of(context)?.loginTitle,
        //     style: KTTextStyle.appBarTitleBStyle),
        title: Text(
          "登录",
          style: KTTextStyle.appBarTitleBStyle,
        ),

        // surfaceTintColor: LDXTColor.white,
      ),
      backgroundColor: KTColor.white, //整个页面背景颜色
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: ScreenAdapter.height(5),
            ),
            // Container(
            //   color: Colors.red,
            //   height: 150,
            //   child: const Center(
            //     child: Text("AppLOGO"),
            //   ),
            //   // child: Image.asset(
            //   //   AssetUtils.getAssetImage(
            //   //     'login_bg',
            //   //   ),
            //   //   fit: BoxFit.fill,
            //   //   width: ScreenUtil1.screenWidth,
            //   //   height: ,
            //   // ),
            // ),
            /// logo
            // GFIconButton(
            //   onPressed: () {},
            //   iconSize: 200,
            //   icon: Icon(Icons.facebook),
            //   size: GFSize.LARGE,
            // ),
            Container(
              width: ScreenAdapter.width(250),
              height: ScreenAdapter.width(250),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                Icons.facebook,
                size: ScreenAdapter.width(250),
                color: Colors.white,
              ),
            ),

            SizedBox(
              height: ScreenAdapter.height(50),
            ),
            Container(
              width: ScreenAdapter.height(300),
              alignment: Alignment.centerLeft,
              // color: Colors.orange,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "请选择语言",
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(16),
                  ),
                ),
              ),
            ),

            DropdownMenu(
              width: ScreenAdapter.height(300),
              menuHeight: ScreenAdapter.height(200), //下拉菜单高度
              initialSelection: data.first, //设置默认选中值
              // hintText: "请选择语言", //提示语
              onSelected: _onSelect, //选中回调
              dropdownMenuEntries: _buildMenuList(data), //菜单内容
            ),
            SizedBox(
              height: ScreenAdapter.height(50),
            ),

            Container(
              width: ScreenAdapter.height(300),
              alignment: Alignment.centerLeft,
              // color: Colors.orange,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "请选择登录方式",
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(16),
                  ),
                ),
              ),
            ),

            /// 第一行 大的登录
            InkWell(
              onTap: () async {
                KTLog("点击了第一行登录");
                KTLog(_isAgree);
                if (_isAgree == false) {
                  Fluttertoast.showToast(
                      msg: "请先同意相关协议",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  GoogleSignInAccount? googleUser =
                      await _googleSignIn.signIn();

                  final GoogleSignInAuthentication googleAuth =
                      await googleUser!.authentication;

                  // Create a new credential
                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                  );
                  // UserCredential userCredential =
                  //     await _auth.signInWithCredential(credential);
                  // Save the user's ID to SharedPreferences
                  // SharedPreferences prefs = await SharedPreferences.getInstance();
                  // await prefs.setString('userId', userCredential.user!.uid);
                  if (googleUser != null) {
                    KTLog("google第三方登录成功 $googleUser");
                    /*  
                      String loginMethod,
                      String id,
                      String email,
                      String name,
                      String photoUrl,
                    */
                    _loginProvider
                        .threeLogin(
                      "1",
                      googleUser.id,
                      googleUser.email,
                      googleUser.displayName!,
                      googleUser.photoUrl!,
                    )
                        .then((value) {
                      if (value == true) {
                        KTLog("接口登录成功");
                        showToast('登录成功');
                        NavigationUtil.getInstance()
                            .pushNamed(RouterName.loginSetInfoPage);
                      } else {
                        showToast('登录失败');
                        KTLog("接口登录失败");
                      }
                    });

                    // _loginProvider
                    //     .threeLogin("1", "104344564625965711444",
                    //         "ktkj0604@gmail.com", "科塔科技", "")
                    //     .then((value) {
                    //   if (value == true) {
                    //     KTLog("接口登录成功");
                    //     NavigationUtil.getInstance()
                    //         .pushNamed(RouterName.loginSetInfoPage);
                    //   } else {
                    //     KTLog("接口登录失败");
                    //   }
                    // });
                  } else {
                    print("登录失败");
                    showToast('登录失败');
                  }
                }
              },
              child: Container(
                width: ScreenAdapter.width(300),
                height: ScreenAdapter.height(80),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(
                    ScreenAdapter.width(5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.facebook,
                      color: Colors.white,
                      size: ScreenAdapter.height(75),
                    ),
                    Text(
                      "Google",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenAdapter.fontSize(16),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: ScreenAdapter.height(5),
            ),

            ///第二行 登录
            Container(
              alignment: Alignment.center,
              width: ScreenAdapter.width(300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      KTLog("苹果登录");

                      final credential =
                          await SignInWithApple.getAppleIDCredential(
                        scopes: [
                          AppleIDAuthorizationScopes.email,
                          AppleIDAuthorizationScopes.fullName,
                        ],
                      );
                      if (credential != null) {
                        print("苹果登录信息");
                        print(credential.toString());
                        print(credential.email);
                        print(credential.givenName);
                        print(credential.userIdentifier);
                      }
                    },
                    child: Container(
                      width: ScreenAdapter.width(145),
                      height: ScreenAdapter.height(80),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(
                          ScreenAdapter.width(5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.facebook,
                            color: Colors.white,
                            size: ScreenAdapter.height(75),
                          ),
                          Text(
                            "Apple",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenAdapter.fontSize(16),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      KTLog("第二行第二个登录");

                      // String loginMethod,
                      // String id,
                      // String email,
                      // String displayName,
                      // String photoUrl,

                      _loginProvider
                          .threeLogin("1", "104344564625965711444",
                              "ktkj0604@gmail.com", "科塔科技", "")
                          .then((value) {
                        if (value == true) {
                          KTLog("接口登录成功");
                          NavigationUtil.getInstance()
                              .pushNamed(RouterName.loginSetInfoPage);
                        } else {
                          KTLog("接口登录失败");
                        }
                      });

                      // _loginProvider.threeLoginIn();
                    },
                    child: Container(
                      width: ScreenAdapter.width(145),
                      height: ScreenAdapter.height(80),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(
                          ScreenAdapter.width(5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.facebook,
                            color: Colors.white,
                            size: ScreenAdapter.height(75),
                          ),
                          Text(
                            "G登录",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenAdapter.fontSize(16),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenAdapter.height(5),
            ),

            ///第三行登录
            Container(
              alignment: Alignment.center,
              width: ScreenAdapter.width(300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      KTLog("退出登录");
                      _loginProvider.logout().then((value) {
                        if (value == true) {
                          KTLog("退出登录成功");
                          //退出登录需要清除所有保存的数据 待实现
                        } else {
                          KTLog("退出登录失败");
                        }
                      });
                    },
                    child: Container(
                      width: ScreenAdapter.width(145),
                      height: ScreenAdapter.height(80),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(
                          ScreenAdapter.width(5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.facebook,
                            color: Colors.white,
                            size: ScreenAdapter.height(75),
                          ),
                          Text(
                            "G退出",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenAdapter.fontSize(16),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      NavigationUtil.getInstance()
                          .pushNamed(RouterName.loginSetInfoPage);
                    },
                    child: Container(
                      width: ScreenAdapter.width(145),
                      height: ScreenAdapter.height(80),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(
                          ScreenAdapter.width(5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.facebook,
                            color: Colors.white,
                            size: ScreenAdapter.height(75),
                          ),
                          Text(
                            "Google",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenAdapter.fontSize(16),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            // InkWell(
            //   onTap: () {
            //     KTLog("点击了youtobe");
            //   },
            //   child: GFButton(
            //     size: 55,
            //     onPressed: () {},
            //     text: "YouTube",
            //     textStyle: TextStyle(color: Colors.white, fontSize: 35),
            //     icon: Icon(
            //       Icons.facebook,
            //       size: 50,
            //     ),
            //   ),
            // child: Container(
            //   alignment: Alignment.center,
            //   margin: EdgeInsets.only(left: 50, right: 50),
            //   height: 100,
            //   color: Colors.blue,
            //   child: Text("YouTube账号登录"),
            // ),
            // ),
            SizedBox(
              height: ScreenAdapter.height(10),
            ),
            /*
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // SizedBox(
                  //   width: 50,
                  //   height: 50,
                  // ),
                  GFIconButton(
                    onPressed: () {},
                    icon: Icon(Icons.facebook),
                    size: GFSize.LARGE,
                  ),
                  GFIconButton(
                    onPressed: () {},
                    icon: Icon(Icons.facebook),
                    size: GFSize.LARGE,
                  ),
                  GFIconButton(
                    onPressed: () {},
                    icon: Icon(Icons.facebook),
                    size: GFSize.LARGE,
                  ),
                  GFIconButton(
                    onPressed: () {},
                    icon: Icon(Icons.facebook),
                    size: GFSize.LARGE,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              */
            //底部同意 协议
            Container(
              child: Center(
                child: Container(
                  child: Wrap(
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GFCheckbox(
                            size: 20,
                            activeBgColor: GFColors.DANGER,
                            type: GFCheckboxType.circle,
                            onChanged: (value) {
                              KTLog(value);
                              setState(() {
                                _isAgree = value;
                              });
                            },
                            value: _isAgree,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "已经阅读并同意",
                            style: TextStyle(color: Colors.grey),
                          ),
                          InkWell(
                            onTap: () {
                              KTLog("用户隐私");
                            },
                            child: const Text(
                              "用户隐私协议",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          const Text(
                            "与",
                            style: TextStyle(color: Colors.grey),
                          ),
                          InkWell(
                            onTap: () {
                              KTLog("账号隐私协议");
                            },
                            child: const Text(
                              "账号隐私协议",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )

            // Container(
            //     color: Colors.white,
            //     height: 50,
            //     child: Center(
            //       child: Useragreement(
            //         onChanged: (value) {
            //           setState(() {
            //             _isAgree = !value!;
            //             print(_isAgree);
            //           });
            //         },
            //       ),
            //     )),
          ],
        ),
      ),
    );
  }

  //下拉框选择的方法
  void _onSelect(String? value) {
    setState(() {
      // if (value == '中文') {
      //   Provider.of<CurrentlocaleProvider>(context, listen: false).setLocale(
      //     const Locale('zh', "CH"),
      //   );
      // } else if (value == 'english') {
      //   Provider.of<CurrentlocaleProvider>(context, listen: false).setLocale(
      //     const Locale('en', "US"),
      //   );
      // }
      KTLog(value as Object);
      _dropdownValue = value!;
    });
  }

  List<DropdownMenuEntry<String>> _buildMenuList(List<String> data) {
    return data.map((String value) {
      return DropdownMenuEntry(value: value, label: value);
    }).toList();
  }
}

//收起键盘
void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
