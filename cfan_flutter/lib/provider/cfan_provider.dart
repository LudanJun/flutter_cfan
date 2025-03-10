import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_posts_contenttrans.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_userPosts_list_model.dart';
import 'package:cfan_flutter/tools/http/api/cfan_community_api.dart';
import 'package:cfan_flutter/tools/http/https_callback.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:flutter/material.dart';

/// 社群状态管理
class CfanProvider extends ChangeNotifier {
  CfanCommunityApi _cfanCommunityApi = CfanCommunityApi();
  //ScrollController创建滚动控制器才能用来监听滚动视图滚动的状态
  final ScrollController scrollController = ScrollController();
  // //明星 ScrollController
  // final ScrollController startScrollController = ScrollController();
  // //视频 ScrollController
  // final ScrollController videoScrollController = ScrollController();
  // //投票 ScrollController
  // final ScrollController voteScrollController = ScrollController();
  // //活动 ScrollController
  // final ScrollController activeScrollController = ScrollController();

  List<ScrollController> scroList = [];

  late TabController tabController;

  int selectTabbasIndex = 0;

  //存放已经点的赞
  List<CfanUserpostsItemModel> _zanList = <CfanUserpostsItemModel>[];
  List<CfanUserpostsItemModel> get zanList => _zanList;

  // //图片数量
  // int _imageCount = 0;
  // int get imageCount => _imageCount;

  // int getImageCount() {
  //   notifyListeners();
  //   return ;
  // }

  //添加点赞的信息
  addLike(CfanUserpostsItemModel map) {
    _zanList.add(map);
    KTLog(zanList);
    notifyListeners();
  }

  //移除点过赞的信息
  remove(CfanUserpostsItemModel map) {
    _zanList.remove(map);
    KTLog(zanList);
    notifyListeners();
  }

  //存放翻译的模型
  // List<Map> _fanyiList = <Map>[];
  // List<Map> get fanyiList => _fanyiList;

  // //添加翻译的信息
  // addFanyi(CfanPostsContenttransDataModel map) {
  //   _fanyiList.add(map);
  //   KTLog(_fanyiList);
  //   notifyListeners();
  // }

  // //移除翻译的信息
  // removeFanyi(CfanPostsContenttransDataModel map) {
  //   _fanyiList.remove(map);
  //   KTLog(_fanyiList);
  //   notifyListeners();
  // }
  Map<String, String> _fanyiDic = {};
  Map<String, String> get fanyiDic => _fanyiDic;
  // //添加翻译的信息
  // //根据点击的索引添加数据模型
  addFanyi(String index, String fanyiStr) {
    // _fanyiList.add(map);
    _fanyiDic[index] = fanyiStr;
    KTLog(_fanyiDic);
    notifyListeners();
  }
  // var fanyiMap =

  // //移除翻译的信息
  // removeFanyi(int index, CfanPostsContenttransDataModel model) {
  //   _fanyiDic.remove(map);
  //   KTLog(_fanyiList);
  //   notifyListeners();
  // }

  //我的社群
  myCommunity({Success? onSuccess, Failure? onFailure}) async {
    await _cfanCommunityApi.myCommunity(
      success: onSuccess,
      failure: onFailure,
    );
  }

  //社群 - 明星动态
  userPosts(String searchStr, String page,
      {Success? onSuccess, Failure? onFailure}) async {
    await _cfanCommunityApi.userPosts(
      searchStr,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///社群 - 帖子点赞 / 取消点赞
  userPostsLike(String postsId,
      {Success? onSuccess, Failure? onFailure}) async {
    await _cfanCommunityApi.userPostsLike(
      postsId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///社群广场信息
  ///categoryId: 类型：0全部，1男明星，2女明星，3艺人组合，4节目官方
  ///search_title: 搜索社群名称
  ///page: 分页
  communityGuangchang(int categoryId, String searchTitle, String page,
      {Success? onSuccess, Failure? onFailure}) async {
    await _cfanCommunityApi.communityGuangchang(
      categoryId,
      searchTitle,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///获取首页的商品推荐信息
  ///community_id int 社群ID
  communityGoods(
    String communityId,
    int page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.communityGoods(
      communityId,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///获取首页的banner图
  homeBanner({
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.homeBanner(
      success: onSuccess,
      failure: onFailure,
    );
  }

  /// 投票 - 投票列表
  userVoteList(String searchStr, String page,
      {Success? onSuccess, Failure? onFailure}) async {
    await _cfanCommunityApi.userVoteList(
      searchStr,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }
}
