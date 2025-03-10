import 'package:cfan_flutter/base/global.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/provider/cfan_details_provider.dart';
import 'package:cfan_flutter/provider/cfan_provider.dart';
import 'package:cfan_flutter/provider/cfan_search_provider.dart';
import 'package:cfan_flutter/provider/currentLocale_provider.dart';
import 'package:cfan_flutter/provider/favorite_provider.dart';
import 'package:cfan_flutter/provider/login_provider.dart';
import 'package:cfan_flutter/provider/message_provider.dart';
import 'package:cfan_flutter/provider/my_provider.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MainApp());
  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(statusBarColor: Colors.black),
  // );
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CfanProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CfanSearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CfanCommunityHomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CfanDetailsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MessageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MyProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CurrentlocaleProvider(), //语言状态注册
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(), //语言状态注册
        ),
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          //收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ScreenUtilInit(
          designSize: const Size(414, 896), //11promax 11
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return Consumer<CurrentlocaleProvider>(
              builder: (context, currentlocaleProvider, child) {
                return MaterialApp(
                  navigatorKey: Global.navigatorkey,
                  //监听路由变化
                  navigatorObservers: [NavigationUtil.getInstance()],
                  routes: NavigationUtil.configRoutes,
                  //去掉右上角debug角标
                  debugShowCheckedModeBanner: false,
                  title: "CFAN",
                  builder: (context, child) {
                    child = MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: const TextScaler.linear(1.0)),
                        child: child!);
                    return child;
                  },
                  theme: ThemeData(
                    fontFamily: 'Sumscope',
                    appBarTheme: const AppBarTheme(
                      systemOverlayStyle: SystemUiOverlayStyle(
                        systemNavigationBarColor: KTColor.white,
                        systemNavigationBarDividerColor: null,
                        statusBarColor: null,
                        systemNavigationBarIconBrightness: Brightness.light,
                        statusBarIconBrightness: Brightness.dark,
                        statusBarBrightness: Brightness.light,
                      ),
                    ),
                    brightness: Brightness.light,
                    hintColor: KTColor.black,
                    primaryColor: KTColor.black, //导航色
                    scaffoldBackgroundColor: KTColor.white,
                    dialogBackgroundColor: KTColor.white,
                    dialogTheme:
                        const DialogTheme(backgroundColor: KTColor.black),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    // useMaterial3: false,
                    // 去除TabBar底部线条
                    tabBarTheme:
                        const TabBarTheme(dividerColor: Colors.transparent),
                  ),
                  // localizationsDelegates: [
                  //   // 本地化应用的代理
                  //   GlobalMaterialLocalizations.delegate,
                  //   GlobalWidgetsLocalizations.delegate, // 全局材质组件的本地化代理
                  //   GlobalCupertinoLocalizations.delegate,
                  //   CfanLocalizationsDelegate.delegate, // 全局组件本地化代理
                  // ],
                  // locale: currentlocaleProvider.value,
                  // supportedLocales: const [
                  //   Locale(
                  //     'zh',
                  //     'CH',
                  //   ),
                  //   Locale(
                  //     'en',
                  //     'US',
                  //   ),
                  // ],
                  // onGenerateTitle: (context) {
                  //   return CfanLocalizations.of(context)?.cfanTitle;
                  // },
                  initialRoute: RouterName.splash, //开屏页
                  // initialRoute: RouterName.indexPage, //主页
                );
              },
            );
          },
        ),
      ),
    );
  }
}
