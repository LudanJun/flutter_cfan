import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_home_page.dart';
import 'package:cfan_flutter/page/tabbars/%E6%9A%82%E4%B8%94%E5%BA%9F%E5%BC%83/cfan_page.dart';
import 'package:cfan_flutter/page/tabbars/message/message_page.dart';
import 'package:cfan_flutter/page/tabbars/my/my_page.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/tools/asset_utils/asset_utils.dart';
import 'package:cfan_flutter/routers/navigation/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 主页面 底部tabbar
class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<Widget> tabbarlist = const [
    // DiscoverPage(),
    // CommunityPage(),
    // CfanPage(),
    CfanHomePage(),
    MessagePage(),
    MyPage(),
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: tabbarlist,
      ),
      backgroundColor: KTColor.white,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: KTColor.colord3cdcd,
              width: 0.3,
            ),
          ),
        ),
        child: BottomNavigationBar(
          items: [
            // _initTabItem('tabbar_discovery_normal', 'tabbar_discovery_select',
            //     CfanLocalizations.of(context)?.discoverTitle),
            _initTabItem(
                'tabbar_community_normal', 'tabbar_community_select', "cfan"),
            _initTabItem(
                'tabbar_message_normal', 'tabbar_message_select', "消息"),
            _initTabItem('tabbar_my_normal', 'tabbar_my_select', "个人"),
          ],
          // selectedFontSize: 12.0, //选中时的大小
          // unselectedFontSize: 12.0, //未选中时的大小
          backgroundColor: KTColor.white,
          unselectedItemColor: KTColor.tabbar_noselect,
          selectedItemColor: KTColor.tabbar_select,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              if (_currentIndex != index) {
                _currentIndex = index;
                if (index == 2) {
                  // if (index == 2 || index == 3 || index == 4) {
                  // if (Global.isLogin != true) {
                  _currentIndex = 0;
                  NavigationUtil.getInstance().pushNamed(RouterName.loginPage);
                  // }
                }
              }
            });
          },
        ),
      ),
    );
  }

  // 初始化baritem
  BottomNavigationBarItem _initTabItem(
          String iconName, String activeIconName, String title) =>
      BottomNavigationBarItem(
          icon: tabbarItemImage(iconName),
          activeIcon: tabbarItemImage(activeIconName),
          label: title);
}

/// 抽离底部tabbar
Widget tabbarItemImage(String iconName,
    {bool isPNG = true,
    double width = 22,
    double height = 22,
    Color? color,
    Color? iconColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration}) {
  return Container(
    padding: padding ?? const EdgeInsets.all(5),
    margin: margin,
    color: color,
    decoration: decoration,
    child: Image.asset(
      isPNG
          ? AssetUtils.getAssetImagePNG(iconName)
          : AssetUtils.getAssetImage(iconName),
      width: width,
      height: height,
      color: iconColor,
    ),
  );
}
