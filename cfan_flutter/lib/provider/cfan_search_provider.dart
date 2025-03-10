import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_community_guangchang.dart';
import 'package:cfan_flutter/tools/http/api/cfan_community_api.dart';
import 'package:cfan_flutter/tools/http/https_callback.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:flutter/material.dart';

class CfanSearchProvider extends ChangeNotifier {
  final CfanCommunityApi _cfanCommunityApi = CfanCommunityApi();
  //ScrollController创建滚动控制器才能用来监听滚动视图滚动的状态
  final ScrollController scrollController = ScrollController();
  //存放已经加入的社群
  List _joinList = [];
  List get joinList => _joinList;

  //添加加入的信息
  addJoin(int communityId) {
    _joinList.add(communityId);
    KTLog(_joinList);
    notifyListeners();
  }

  //移除点过赞的信息
  remove(int communityId) {
    _joinList.remove(communityId);
    KTLog(_joinList);
    notifyListeners();
  }

  // /社群 - 获取帖子评论回复列表
  // /comment_id:帖子评论回复ID
  // communitySquare(
  //   int categoryId,
  //   String search_title,
  //   int page, {
  //   Success? onSuccess,
  //   Failure? onFailure,
  // }) async {
  //   await _cfanCommunityApi.userPostsDetailGetCommentReply(
  //     commentId,
  //     page,
  //     success: onSuccess,
  //     failure: onFailure,
  //   );
  // }
}
