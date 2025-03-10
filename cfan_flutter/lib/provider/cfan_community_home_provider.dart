import 'package:cfan_flutter/page/tabbars/cfan/cfan_test(%E6%B5%8B%E9%AA%8C)/model/cfan_test_paper_model.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_userPosts_list_model.dart';
import 'package:cfan_flutter/tools/http/api/cfan_community_api.dart';
import 'package:cfan_flutter/tools/http/https_callback.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';

//社群主页状态管理
class CfanCommunityHomeProvider extends ChangeNotifier {
// ScrollController创建滚动控制器才能用来监听滚动视图滚动的状态
  final ScrollController scrollController = ScrollController();
  final CfanCommunityApi _cfanCommunityApi = CfanCommunityApi();

  //存放已经点的赞
  List _zanList = [];
  List get zanList => _zanList;

  //添加点赞的信息
  addLike(CfanUserpostsItemModel map) {
    _zanList.add(map);
    KTLog(_zanList);
    notifyListeners();
  }

  //移除点过赞的信息
  remove(CfanUserpostsItemModel map) {
    _zanList.remove(map);
    KTLog(_zanList);
    notifyListeners();
  }

  //存放已经点的选项
  List _optionList = [];
  List get optionList => _optionList;
  // int? _currentPageIndex;
  List _tempList = [];
  List get tempList => _tempList;

  //这样定义在后面是单选 根据当前页只能添加一个选项
  Map<int, Map<int, dynamic>> _selectedOptions = {};
  Map<int, Map<int, dynamic>> get selectedOptions => _selectedOptions;

  Map<int, int> _selectedOptionsNew = {};
  Map<int, int> get selectedOptionsNew => _selectedOptionsNew;

  ///1.定义键值  这样定义是多选
  ///键:存放页面索引
  ///值:存放选项索引
  // Map<Map<int, int>, CfanTestPaperItemOptionModel> _selectedOptions = {};
  // Map<Map<int, int>, CfanTestPaperItemOptionModel> get selectedOptions =>
  //     _selectedOptions;
  //传入界面索引 和选项索引
  addOption(
    int questionId,
    int optionId,
    int currentPage,
    int optionIndex,
    CfanTestPaperItemModel questionModel,
    CfanTestPaperItemOptionModel optionModel,
    bool isSelected,
  ) {
    /*
  用户答案，格式
  [
  {"question_id":1,"option_id:2"},
  {"question_id":2,"option_id:4"},
  {"question_id":3,"option_id:1"}
  ]
     */
    KTLog("当前第$currentPage页--第$optionIndex选项");

    // //创建一个内部字典作为值
    // Map<int, int> key = {};

    // if (value[optionIndex] == model) {
    // } else {
    //   value[optionIndex] = model;
    //   _selectedOptions[currentPage] = value;
    // }
    // KTLog(_selectedOptions);

    ///创建一个内部字典作为值
    ///

    Map<int, dynamic> value = {};
    value[currentPage] = questionModel;
    KTLog(questionModel);
    KTLog(currentPage);
    value[optionIndex] = optionModel;
    _selectedOptions[currentPage] = value;
    KTLog(_selectedOptions.length);
    KTLog(_selectedOptions);

    _selectedOptionsNew[questionId] = optionId;
    KTLog(_selectedOptionsNew);
    /*
    Map<String, int> result = {};
    result["question_id"] = questionModel.questionId ?? 0;
    result["option_id"] = optionModel.optionId ?? 0;
    // if _optionList
    // bool isss = result.every((key, value) {
    //   return true;
    // });
    bool isIn = false;
    if (_optionList.isEmpty) {
      KTLog("执行了一次");
      _optionList.add(result);
      KTLog(_optionList);
    } else {
      /*
      //在这里判断 如果 数组里的内容和传进来的相同就不添加 否则就根据question_id进行覆盖
      // bool isIn = _optionList.any((map) => map == result);
      _optionList.any((map) {
        KTLog(map);
        KTLog(result);
        isIn = DeepCollectionEquality().equals(map, result);
        KTLog(isIn);
        if (isIn == true) {
          return true;
        } else {
          //否则就根据question_id进行覆盖 遍历map
          map.forEach((key, value) {
            KTLog(key);
            //map[key] = question_id
            //如果key 和传进来的相同,就把map覆盖
            if (map[key] == currentPage) {
              map = result;
            }
          });

          return false;
        }
      });
      */

      _optionList.any((map) {
        //可以判断数组里的map是否相等
        isIn = DeepCollectionEquality().equals(map, result);
        if (isIn == true) {
          KTLog("相等");
          return true;
        } else {
          KTLog("不相等 就要根据question_id替换");
          if (map["question_id"] == result["question_id"]) {
            map["question_id"] = result["question_id"] ?? 0;
            map["option_id"] = result["option_id"] ?? 0;
          } else {
            _tempList.add(result);
          }
          return false;
        }
      });

      // KTLog(result);
      // for (Map<String, int> map in _optionList) {
      //   if (map["question_id"] == result["question_id"]) {
      //     map["question_id"] = result["question_id"] ?? 0;
      //     map["option_id"] = result["option_id"] ?? 0;
      //     KTLog("修改");
      //     break; //假设每个id都是唯一的，覆盖后退出循环
      //   } else {
      //     KTLog("添加");
      //     _tempList.add(result);
      //   }
      // }
      KTLog("_tempList$_tempList");
      // _optionList.addAll(arr);

      KTLog(_optionList);

      // KTLog(isIn);
      // if (_optionList.contains(result)) {
      //   KTLog("相同");
      // } else {
      //   _optionList.add(result);
      //   KTLog(_optionList);
      // }
    }
    */
    // KTLog(_optionList);
    // KTLog(result);

    /*
    else {
      result.forEach((key, value) {
        KTLog("key:$key - value:$value");

        // bool isIn = _optionList.any((map) => map[key] && map[value] == value);

        isIn = _optionList.any((map) {
          KTLog(map);
          //map[key]的值分别是question_id 和 option_id map[value]是null
          KTLog("map[key]:${map[key]}   map[value]:${map[value]} ");
          //如果数组里的map跟传进来的map相同就不添
          // if (map == result) {
          //   _optionList.contains(result);
          // }
          //如果传进来的数据包含在数组里就不添加进去
          if (_optionList.contains(result)) {
            KTLog("数组里包含传进来的数据");

            return false;
          } else {
            KTLog("数组里不包含传进来的数据");
            //否则就是包含了 返回true
            return true;
          }
        });
        KTLog("isIn $isIn");
        if (isIn == true) {
        } else {
          _optionList.add(result);
        }
      });
    }
*/

    //这种的是多选
    // key[currentPage] = optionIndex;
    // _selectedOptions[key] = optionModel;
    // KTLog(_selectedOptions);
    // KTLog(_selectedOptions[key]!.content!);
    // _optionList.add();
    // _selectedOptions[currentPage[optionIndex]] = model;

    // //如果当前的模型和传过来的模型不一样
    // if (map[currentPage] != model) {
    //   KTLog("不一样");
    //   if (_optionList.isNotEmpty) {
    //     KTLog("移除之前的${_optionList.length}");
    //     map.remove(currentPage);
    //     KTLog("移除之后${_optionList.length}");
    //   } else {
    //     //根据页数存入选项模型
    //     map[currentPage] = model;

    //     _optionList.add(map[currentPage]);
    //   }
    // }

    // KTLog(map[currentPage]!.content!);
    // KTLog(model.content!);
    // KTLog(_optionList.length);
    notifyListeners();
  }

  removeAll() {
    _optionList.clear();
    _selectedOptions.clear();
    _selectedOptionsNew.clear();
    notifyListeners();
  }

  // removeOption(int currentPage, index, CfanTestPaperItemOptionModel model) {
  //   _optionList.remove(model);
  //   KTLog(_optionList.length);
  //   notifyListeners();
  // }

  // removeOption(int currentPage, CfanTestPaperItemOptionModel model) {
  //   _optionList.remove(model);
  //   KTLog(_optionList.length);
  //   notifyListeners();
  // }

/*
  //存入当前试题页和选择的选项模型
  addOption(int currentPage, int optionIndex,
      Map<int, CfanTestPaperItemOptionModel> map) {
    // if (_optionList.contains(map) == true) {
    //   KTLog("包含");
    // } else {
    //   _optionList.add(map);
    //   KTLog(_optionList.length);
    // }
    if (_optionList.isEmpty) {
      _optionList.add(map);
    } else {
      _optionList[currentPage] = map;
    }
    KTLog(_optionList.length);
    notifyListeners();
  }
  */

  ///社群 - 帖子详情
  ///postsId:帖子ID
  userPostsDetail(
    String postsId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsDetail(
      postsId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///社群 - 帖子评论信息列表
  ///postsId:帖子ID
  userPostsDetailcomment(
    String postsId,
    int page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsDetailcomment(
      postsId,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///社群 - 发布帖子
  ///communityId:社群ID
  ///content:发布的内容
  ///picture_ids:图片数组
  userPostsRelease(
    int communityId,
    String content,
    String pictureIds, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsRelease(
      communityId,
      content,
      pictureIds,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///社群 - 上传帖子图片
  ///image:图片 单张上传
  userPostsUploadPostsImage(
    dynamic image, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsUploadPostsImage(
      image,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///社群 - 帖子发送评论
  ///postsId:帖子ID
  userPostsDetailSendComment(
    String postsId,
    String content,
    String pictureIds, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsDetailSendComment(
      postsId,
      content,
      pictureIds,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///社群 - 发送帖子评论回复
  ///comment_id:帖子评论回复ID
  userPostsDetailSendCommentReply(
    int commentId,
    String content,
    String pictureIds, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsDetailSendCommentReply(
      commentId,
      content,
      pictureIds,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///社群 - 获取帖子评论回复列表
  ///comment_id:帖子评论回复ID
  userPostsDetailGetCommentReply(
    int commentId,
    int page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsDetailGetCommentReply(
      commentId,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///社群 - 帖子点赞列表
  ///posts_id:帖子点赞列表
  userPostsDetailZanList(
    int postsId,
    int page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsDetailZanList(
      postsId,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///社群 - 帖子点赞 / 取消点赞
  ///postsId:帖子ID
  userPostsLike(
    String postsId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsLike(
      postsId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///社群 - 帖子评论的点赞 / 取消点赞
  ///postsId:帖子ID
  userPostsCommentLike(
    int commentId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommentLike(
      commentId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  //社群 - 社群主页详情
  userPostsCommunitdetail(
    String communityId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommunitdetail(
      communityId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  //社群 - 社群详情管理员 userPostsCommunitymanager
  /// communityId: 社群id
  /// page:分页
  userPostsCommunitymanager(
    String communityId,
    int page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommunitymanager(
      communityId,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  //社群 - 主页帖子 userPostsCommunitposts
  /// communityId: 社群id
  /// page:分页
  userPostsCommunitposts(
    String communityId,
    String page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommunitposts(
      communityId,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  //社群 - 主页明星动态 userPostsCommunitposts
  /// communityId: 社群id
  /// page:分页
  userPostsArtistposts(
    String communityId,
    String artistId,
    String page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsArtisposts(
      communityId,
      artistId,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  //社群 - 主页节目分类
  userPostsProgramCategory({
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsProgramCategory(
      success: onSuccess,
      failure: onFailure,
    );
  }

  //社群 - 主页节目分类列表
  userPostsProgramCategoryList(
    String communityId,
    String videoType,
    String page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsProgramCategoryList(
      communityId,
      videoType,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  //社群 - 主页节目分类详情
  userPostsProgramCategoryDetail(
    String communityId,
    String videoType, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsProgramCategoryDetail(
      communityId,
      videoType,
      success: onSuccess,
      failure: onFailure,
    );
  }

  //社群 - 社群个人信息
  userPostsCommunityUserInfoDetail(
    String communityId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommunityUserInfoDetail(
      communityId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  //社群 - 社群签到
  userPostsCommunityQiandao(
    String communityId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommunityQiandao(
      communityId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  // //社群 - 自己在社群中的经验明细
  // userPostsCommunityExpInfo(
  //   String communityId, {
  //   Success? onSuccess,
  //   Failure? onFailure,
  // }) async {
  //   await _cfanCommunityApi.userPostsCommunityExpInfo(
  //     communityId,
  //     success: onSuccess,
  //     failure: onFailure,
  //   );
  // }

  //社群 - 修改在社群中的昵称
  userPostsCommunityEditnickname(
    String communityId,
    String nickname, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommunityEditnickname(
      communityId,
      nickname,
      success: onSuccess,
      failure: onFailure,
    );
  }

  //社群 - 退出社群
  userPostsCommunityQuitcommunity(
    String communityId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommunityQuitcommunity(
      communityId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  //社群 - 获取自己在社群中的关注信息
  userPostsCommunityMyGuanzhu(
    int communityId,
    int page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommunityMyGuanzhu(
      communityId,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  //社群 - 获取自己在社群中的粉丝信息
  userPostsCommunityMyFans(
    int communityId,
    int page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommunityMyFans(
      communityId,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  //社群 - 获取自己在社群中的经验明细
  userPostsCommunityExpinfo(
    int communityId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommunityExpinfo(
      communityId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  //社群 - 获取经验等级规则
  userPostsCommunityExpinfoRule(
    int communityId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommunityExpinfoRule(
      communityId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///社群 - 获取他人在社群中的主页信息
  userPostsCommunityOtherHomeInfo(
    int communityId,
    int userId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommunityOtherHomeInfo(
      communityId,
      userId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///社群 - 获取社群某个用户的帖子
  // /pro/user_posts/communityuserposts
  userPostsCommunityOtherposts(
    int communityId,
    int userId,
    int page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommunityOtherposts(
      communityId,
      userId,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///pro/user_posts/selfcommunityposts
  ///获取我在某个社群下的社群帖子
  userPostsCommunitySelfposts(
    int communityId,
    int page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommunitySelfposts(
      communityId,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///获取我在某个社群下的社群点赞帖子
  userPostsCommunitySelfLikeposts(
    int communityId,
    int page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsCommunitySelfLikeposts(
      communityId,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///获取翻译内容
  userPostsContenttrans(
    int postsId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsContenttrans(
      postsId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///获取帖子话题详情列表
  userPostsTagposts(
    String tagStr,
    int page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userPostsTagposts(
      tagStr,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  /// 投票 投票详情
  /// every_day_limit_num 每天限制投票次数
  /// today_allow_vote_num 今天还允许投票的次数
  /// time_status 0表示投票活动未开始，1进行中，2已结束
  /// is_multiple_choice 0表示单选，1表示多选
  userVoteDetail(
    int pollsId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userVoteDetail(
      pollsId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///投票 提交投票
  userSubmitVote(
    int pollsId,
    String optionId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userSubmitVote(
      pollsId,
      optionId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///投票 获取投票榜单排名
  userVoteRank(
    int pollsId,
    int page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userVoteRank(
      pollsId,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///投票 获取投票记录
  userVoteLog(
    int pollsId,
    int page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userVoteLog(
      pollsId,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///测验 获取首页测验数据列表
  userTestHomeList(
    String searchStr,
    int page, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userTestHomeList(
      searchStr,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///测验 获取测验详情
  userTestDetail(
    int examId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userTestDetail(
      examId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///测验 获取测验试题
  userTestPaper(
    int examId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userTestPaper(
      examId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///测验 提交测验结果
  ///examId: 测验id
  ///用户答案
  ///answer:[{"question_id":1,"option_id",2},{"question_id":2,"option_id",4},{"question_id":3,"option_id",1}]
  userTestUserAnswer(
    int examId,
    String answer, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userTestUserAnswer(
      examId,
      answer,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///测验 获取测验结果
  ///answer_id: 测验结果的id
  userTestAnswerresult(
    int answerId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userTestAnswerresult(
      answerId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///测验 获取测验记录
  ///answer_id: 测验id
  userTestExamlog(
    int examId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userTestExamlog(
      examId,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///测验 获取测验记录详情
  ///answer_id: 测验id
  userTestExamlogdetail(
    int examId,
    int answerId, {
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    await _cfanCommunityApi.userTestExamlogdetail(
      examId,
      answerId,
      success: onSuccess,
      failure: onFailure,
    );
  }
}
