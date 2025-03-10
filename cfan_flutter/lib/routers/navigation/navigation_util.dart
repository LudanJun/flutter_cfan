import 'dart:async';

import 'package:cfan_flutter/main/index_page.dart';
import 'package:cfan_flutter/main/splash_page.dart';
import 'package:cfan_flutter/page/login/login_favorite_choices.dart';
import 'package:cfan_flutter/page/login/login_page.dart';
import 'package:cfan_flutter/page/login/login_set_info_page.dart';
import 'package:cfan_flutter/page/login/login_set_nike_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_detail_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_expinfo_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_fans_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_follow_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_guanzhu_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_home_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_ontherHomeInfo.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_publish_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/cfan_community_userInfo_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_detail(%E5%B8%96%E5%AD%90%E8%AF%A6%E6%83%85)/cfan_post_detail_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_detail(%E5%B8%96%E5%AD%90%E8%AF%A6%E6%83%85)/cfan_post_nes_detail_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_search_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_test(%E6%B5%8B%E9%AA%8C)/cfan_test_detail_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_test(%E6%B5%8B%E9%AA%8C)/cfan_test_record_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_test(%E6%B5%8B%E9%AA%8C)/cfan_test_result_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_test(%E6%B5%8B%E9%AA%8C)/cfan_test_paper_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_topic_details_list.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_vote(%E6%8A%95%E7%A5%A8)/cfan_vote_detail_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_vote(%E6%8A%95%E7%A5%A8)/cfan_vote_rank_page.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_vote(%E6%8A%95%E7%A5%A8)/cfan_vote_record_page.dart';
import 'package:cfan_flutter/routers/router_name.dart';
import 'package:cfan_flutter/routers/navigation/navigation_anim.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteInfo {
  Route? currentRoute;
  List<Route> routes;

  RouteInfo(this.currentRoute, this.routes);

  @override
  String toString() {
    return 'RouteInfo{currentRoute: $currentRoute, routes: $routes}';
  }
}

class NavigationUtil extends NavigatorObserver {
  static NavigationUtil? _instance;

  //每添加页面 都要在这里配置
  static Map<String, WidgetBuilder> configRoutes = {
    RouterName.splash: (context) => const SplashPage(),
    RouterName.indexPage: (context) => const IndexPage(),
    RouterName.loginPage: (context) => const LoginPage(),
    RouterName.loginSetInfoPage: (context) => const LoginSetInfoPage(),
    RouterName.logoFavoriteChoicesPage: (context) =>
        const LoginFavoriteChoicesPage(),
    RouterName.logoSetNikePage: (context) => const LoginSetNikePage(),
    //首页搜索页
    RouterName.cfanSearchPage: (context) => const CfanSearchPage(),
    RouterName.cfanCommunityFollowPage: (context) =>
        const CfanCommunityFollowPage(),
    //帖子详情页
    RouterName.cfanPostDetailPage: (context) => const CfanPostDetailPage(
          postsId: '',
          cellHeight: 0.0,
        ),
    RouterName.cfanPostNesDetailPage: (context) => const CfanPostNesDetailPage(
          postsId: '',
          cellHeight: 0.0,
        ),

    //社群首页
    RouterName.cfanCommunityHomePage: (context) => const CfanCommunityHomePage(
          communityId: '',
        ),
    //社群详情页
    RouterName.cfanCommunityDetailPage: (context) =>
        const CfanCommunityDetailPage(
          communityId: '',
        ),
    //社群发帖
    RouterName.cfanCommunityPublishPage: (context) =>
        const CfanCommunityPublishPage(
          communityId: 0,
        ),

    //社群用户信息
    RouterName.cfanCommunityUserinfoPage: (context) =>
        const CfanCommunityUserinfoPage(
          communityId: 0,
        ),

    //社群我关注的人
    RouterName.cfanCommunityGuanzhuPage: (context) =>
        const CfanCommunityGuanzhuPage(
          community_id: 0,
        ),
    //社群我的粉丝
    RouterName.cfanCommunityFansPage: (context) => const CfanCommunityFansPage(
          community_id: 0,
        ),

    //社群我的经验明细
    RouterName.cfanCommunityExpinfoPage: (context) =>
        const CfanCommunityExpinfoPage(
          community_id: 0,
        ),

    //获取他人在社群中的主页信息
    RouterName.cfanCommunityOntherhomeinfoPage: (context) =>
        const CfanCommunityOntherhomeinfoPage(
          community_id: 0,
          user_id: 0,
        ),
    //获取他人在社群中的主页信息
    RouterName.cfanTopicListPage: (context) => const CfanTopicDetailsListPage(
          topicStr: '', //传入id
        ),

    //投票 - 投票主页
    RouterName.cfanVoteDetailPage: (context) => const CfanVoteDetailPage(
          voteId: 0, //传入id
        ),
    //投票 - 投票榜单
    RouterName.cfanVoteListPage: (context) => const CfanVoteRankPage(
          voteId: 0, //传入id
        ),
    //投票 - 投票记录
    RouterName.cfanVoteRecordPage: (context) => const CfanVoteRecordPage(
          voteId: 0, //传入id
        ),
    //投票 - 测验首页
    RouterName.cfanTestDetailPage: (context) => const CfanTestDetailPage(
          examId: 0, //传入id
        ),

    //投票 - 测验记录
    RouterName.cfanTestRecordPage: (context) => const CfanTestRecordPage(
          examId: 0, //传入id
        ),

    //投票 - 测验结果
    RouterName.cfanTestResultPage: (context) => const CfanTestResultPage(
        answerId: 0, //传入测验id
        ),
    //投票 - 开始测验
    RouterName.cfanTestPaperPage: (context) => const CfanTestPaperPage(
          examId: 0, //传入id
        ),
  };

  ///路由信息
  RouteInfo? _routeInfo;
  RouteInfo? get routeInfo => _routeInfo;

  ///存储当前路由页面名字
  final List<String> _routeNames = [];
  List<String> get routeNames => _routeNames;

  ///stream相关
  static late StreamController<RouteInfo> _streamController;
  StreamController<RouteInfo> get streamController => _streamController;

  ///用来路由跳转
  static NavigatorState? navigatorState;

  static NavigationUtil getInstance() {
    if (_instance == null) {
      _instance = NavigationUtil();
      _streamController = StreamController<RouteInfo>.broadcast();
    }
    return _instance!;
  }

  pushPage(BuildContext context, String routeName,
      {required Widget widget, bool fullscreenDialog = false, Function? func}) {
    return Navigator.of(context)
        .push(CupertinoPageRoute(
      builder: (context) => widget,
      settings: RouteSettings(name: routeName),
      fullscreenDialog: fullscreenDialog,
    ))
        .then((value) {
      func?.call(value);
    });
  }

  pushPageFromLeft(BuildContext context, String routeName,
      {required Widget widget, bool fullscreenDialog = false}) {
    return Navigator.of(context).push(Left2RightRouter(
      child: widget,
      settings: RouteSettings(name: routeName),
      fullscreenDialog: fullscreenDialog,
    ));
  }

  pushReplacementPage(BuildContext context, String routeName,
      {required Widget widget, bool fullscreenDialog = false}) {
    return Navigator.of(context).pushReplacement(CupertinoPageRoute(
      builder: (context) => widget,
      settings: RouteSettings(name: routeName),
      fullscreenDialog: fullscreenDialog,
    ));
  }

  pushAndRemoveUtil(BuildContext context, String routeName,
      {required Widget widget, bool fullscreenDialog = false}) async {
    return Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
            builder: (context) => widget,
            settings: RouteSettings(name: routeName),
            fullscreenDialog: fullscreenDialog),
        // ignore: unnecessary_null_comparison
        (route) => route == null);
  }

  /// you could also specify the route predicate that will tell you when you need to stop popping your stack before pushing your next route
  pushAndRemoveUtilPage(
      BuildContext context, String routeName, String predicateRouteName,
      {required Widget widget, bool fullscreenDialog = false, Function? func}) {
    return Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
                builder: (context) => widget,
                settings: RouteSettings(name: routeName),
                fullscreenDialog: fullscreenDialog),
            ModalRoute.withName(predicateRouteName))
        .then((value) => func?.call());
  }

  popUtilPage(BuildContext context, String routeName) {
    return Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  ///Push the given route onto the navigator.
  push(BuildContext context, String routeName,
      {required Widget Function(BuildContext) builder,
      bool fullscreenDialog = false}) {
    return Navigator.of(context).push(CupertinoPageRoute(
      builder: builder,
      settings: RouteSettings(name: routeName),
      fullscreenDialog: fullscreenDialog,
    ));
  }

  pushReplacement(BuildContext context, String routeName,
      {required Widget Function(BuildContext) builder,
      Function? func,
      bool fullscreenDialog = false}) {
    return Navigator.of(context)
        .pushReplacement(CupertinoPageRoute(
          builder: builder,
          settings: RouteSettings(name: routeName),
          fullscreenDialog: fullscreenDialog,
        ))
        .then((value) => func?.call);
  }

  popPage(BuildContext context) {
    Navigator.of(context).pop();
  }

  ///push页面
  Future<T?>? pushNamed<T>(String routeName,
      {WidgetBuilder? builder, bool? fullscreenDialog}) {
    return navigatorState?.push<T>(
      CupertinoPageRoute(
        builder: (builder ?? configRoutes[routeName])!,
        settings: RouteSettings(name: routeName),
        fullscreenDialog: fullscreenDialog ?? false,
      ),
    );
  }

  ///replace页面
  Future<T?>? pushReplacementNamed<T, R>(String routeName,
      {WidgetBuilder? builder, bool? fullscreenDialog}) {
    return navigatorState?.pushReplacement<T, R>(
      CupertinoPageRoute(
        builder: (builder ?? configRoutes[routeName])!,
        settings: RouteSettings(name: routeName),
        fullscreenDialog: fullscreenDialog ?? false,
      ),
    );
  }

  // pop 页面
  pop<T>([T? result]) {
    navigatorState?.pop<T>(result);
  }

  //poputil返回到指定页面
  popUntil(String newRouteName) {
    return navigatorState?.popUntil(ModalRoute.withName(newRouteName));
  }

  pushNamedAndRemoveUntil(String newRouteName, {arguments}) {
    return navigatorState?.pushNamedAndRemoveUntil(
        newRouteName, (Route<dynamic> route) => false,
        arguments: arguments);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _routeInfo ??= RouteInfo(null, <Route>[]);

    ///这里过滤调push的是dialog的情况
    if (route is CupertinoPageRoute ||
        route is MaterialPageRoute ||
        route is Left2RightRouter) {
      _routeInfo?.routes.add(route);

      var name = route.settings.name;
      debugPrint('routeName==============push===$name');
      if (name != null) {
        _routeNames.add(name);
      }
      routeObserver();
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace();
    if (newRoute is CupertinoPageRoute ||
        newRoute is MaterialPageRoute ||
        newRoute is Left2RightRouter) {
      _routeInfo?.routes.remove(oldRoute);
      _routeInfo?.routes.add(newRoute!);

      var oldName = oldRoute!.settings.name;
      var newName = newRoute!.settings.name;
      debugPrint('routeName==============didReplace===$oldName,,,,$newName');
      if (_routeNames.contains(oldName)) {
        _routeNames.remove(oldName);
      }
      if (newName != null) {
        _routeNames.add(newName);
      }
      routeObserver();
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (route is CupertinoPageRoute ||
        route is MaterialPageRoute ||
        route is Left2RightRouter) {
      _routeInfo?.routes.remove(route);

      var name = route.settings.name;
      debugPrint('routeName==============didPop===$name');
      if (_routeNames.contains(name)) {
        _routeNames.remove(name);
      }
      routeObserver();
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    if (route is CupertinoPageRoute ||
        route is MaterialPageRoute ||
        route is Left2RightRouter) {
      _routeInfo?.routes.remove(route);

      var name = route.settings.name;
      debugPrint('routeName==============didRemove===$name');
      if (_routeNames.contains(name)) {
        _routeNames.remove(name);
      }
      routeObserver();
    }
  }

  void routeObserver() {
    if (_routeInfo != null) {
      _routeInfo!.currentRoute = _routeInfo!.routes.last;
      navigatorState = _routeInfo!.currentRoute?.navigator;
      debugPrint(
          "NavigationUtil: $navigatorState, currentRoute: ${_routeInfo!.currentRoute?.settings.name}");
      _streamController.sink.add(_routeInfo!);
    }
  }
}
