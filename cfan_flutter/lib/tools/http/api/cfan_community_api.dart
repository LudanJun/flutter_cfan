import 'package:cfan_flutter/tools/http/httpsUtils.dart';
import 'package:cfan_flutter/tools/http/https_callback.dart';
import 'package:cfan_flutter/tools/http/https_path.dart';

/// 首页 社群 api
class CfanCommunityApi {
  ///我的社群
  myCommunity({Success? success, Failure? failure}) async {
    var param = {};
    await HttpsUtils.instance.get(HttpsPath.myCommunity,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///社群 - 明星动态
  userPosts(String searchStr, String page,
      {Success? success, Failure? failure}) async {
    var param = {
      'search_str': searchStr,
      'page': page,
    };
    await HttpsUtils.instance.get(HttpsPath.userPosts,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///社群广场信息
  ///categoryId: 类型：0全部，1男明星，2女明星，3艺人组合，4节目官方
  ///search_title: 搜索社群名称
  ///page: 分页
  communityGuangchang(int categoryId, String searchTitle, String page,
      {Success? success, Failure? failure}) async {
    var param = {
      'category_id': categoryId,
      'search_title': searchTitle,
      'page': page,
    };
    await HttpsUtils.instance.get(HttpsPath.communityGuangchang,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///社群 - 帖子点赞
  userPostsDetail(
    String postsId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "posts_id": postsId,
    };
    await HttpsUtils.instance.post(HttpsPath.userPostsDetail,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///社群 - 帖子评论信息列表
  userPostsDetailcomment(
    String postsId,
    int page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "posts_id": postsId,
      "page": page,
    };
    await HttpsUtils.instance.get(HttpsPath.userPostsDetailcomment,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///社群 - 发布帖子
  userPostsRelease(
    int communityId,
    String content,
    String pictureIds, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
      "content": content,
      "picture_ids": pictureIds,
    };
    await HttpsUtils.instance.post(HttpsPath.userPostsRelease,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///社群 - 上传帖子图片
  ///image:图片 单张上传
  userPostsUploadPostsImage(
    dynamic image, {
    Success? success,
    Failure? failure,
  }) async {
    await HttpsUtils.instance.post(HttpsPath.userPostsUploadPostsImage,
        body: image, onSuccess: success, onFailure: failure);
  }

  // userPostsDetailSendComment
  ///社群 - 帖子发送评论
  userPostsDetailSendComment(
    String postsId,
    String content,
    String pictureIds, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "posts_id": postsId,
      "content": content,
      "picture_ids": pictureIds,
    };
    await HttpsUtils.instance.post(HttpsPath.userPostsDetailSendComment,
        body: param, onSuccess: success, onFailure: failure);
  }

  // userPostsDetailSendComment
  ///社群 - 发送帖子评论回复
  userPostsDetailSendCommentReply(
    int commentId,
    String content,
    String pictureIds, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "comment_id": commentId,
      "content": content,
      "picture_ids": pictureIds,
    };
    await HttpsUtils.instance.post(HttpsPath.userPostsDetailSendCommentReply,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///社群 - 获取帖子评论回复列表
  ///comment_id:帖子评论回复ID
  userPostsDetailGetCommentReply(
    int commentId,
    int page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "comment_id": commentId,
      "page": page,
    };
    await HttpsUtils.instance.get(
      HttpsPath.userPostsDetailGetCommentReply,
      body: param,
      onSuccess: success,
      onFailure: failure,
    );
  }

  ///社群 - 帖子点赞列表
  ///posts_id:帖子点赞列表
  userPostsDetailZanList(
    int postsId,
    int page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "posts_id": postsId,
      "page": page,
    };
    await HttpsUtils.instance.get(HttpsPath.userPostsDetailZanList,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///社群 - 帖子点赞
  userPostsLike(
    String postsId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "posts_id": postsId,
    };
    await HttpsUtils.instance.post(HttpsPath.userPostsLike,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///社群 - 帖子评论的点赞 / 取消点赞
  ///postsId:帖子ID
  userPostsCommentLike(
    int commentId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "posts_id": commentId,
    };
    await HttpsUtils.instance.post(HttpsPath.userPostsCommentLike,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///社群 - 社群详情
  userPostsCommunitdetail(
    String communityId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
    };
    await HttpsUtils.instance.get(HttpsPath.userPostsCommunitdetail,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///社群 - 社群管理员
  userPostsCommunitymanager(
    String communityId,
    int page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
    };
    await HttpsUtils.instance.get(HttpsPath.userPostsCommunitymanager,
        body: param, onSuccess: success, onFailure: failure);
  }

  //社群 - 主页帖子 userPostsCommunitposts
  /// community_id: 社群id
  /// page:分页
  userPostsCommunitposts(
    String communityId,
    String page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
      'page': page,
    };
    await HttpsUtils.instance.get(HttpsPath.userPostsCommunitposts,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///社群 - 艺人动态获取
  ///communityId: 社群ID
  /// page:分页
  ///artistId:艺人ID点击指定艺人头像时，获取指定艺人的动态信息
  userPostsArtisposts(
    String communityId,
    String artistId,
    String page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
      "artist_id": artistId,
      'page': page,
    };
    await HttpsUtils.instance.get(HttpsPath.userPostsArtistposts,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///社群 - 节目
  userPostsProgramCategory({
    Success? success,
    Failure? failure,
  }) async {
    var param = {};
    await HttpsUtils.instance.get(HttpsPath.userPostsProgramCategory,
        body: param, onSuccess: success, onFailure: failure);
  }

  //社群 - 主页节目分类列表
  userPostsProgramCategoryList(
    String communityId,
    String videoType,
    String page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
      "video_type": videoType,
      'page': page,
    };
    await HttpsUtils.instance.get(HttpsPath.userPostsProgramList,
        body: param, onSuccess: success, onFailure: failure);
  }

  //社群 - 主页节目分类列表
  userPostsProgramCategoryDetail(
    String communityId,
    String videoType, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
      "video_type": videoType,
    };
    await HttpsUtils.instance.get(HttpsPath.userPostsProgramDetail,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///获取首页的商品推荐信息
  ///community_id int 社群ID
  communityGoods(
    String communityId,
    int page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
      "page": page,
    };
    await HttpsUtils.instance.get(HttpsPath.communityGoods,
        body: param, onSuccess: success, onFailure: failure);
  }

  //社群 - 社群个人信息
  userPostsCommunityUserInfoDetail(
    String communityId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
    };
    await HttpsUtils.instance.get(HttpsPath.userPostsCommunityUserInfoDetail,
        body: param, onSuccess: success, onFailure: failure);
  }

  //社群 - 社群签到
  userPostsCommunityQiandao(
    String communityId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
    };
    await HttpsUtils.instance.post(HttpsPath.userPostsCommunityQiandao,
        body: param, onSuccess: success, onFailure: failure);
  }

  // //社群 - 自己在社群中的经验明细
  // userPostsCommunityExpInfo(
  //   String communityId, {
  //   Success? success,
  //   Failure? failure,
  // }) async {
  //   var param = {
  //     "community_id": communityId,
  //   };
  //   await HttpsUtils.instance.get(HttpsPath.userPostsCommunityExpInfo,
  //       body: param, onSuccess: success, onFailure: failure);
  // }

  //社群 - 修改在社群中的昵称
  userPostsCommunityEditnickname(
    String communityId,
    String nickname, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
      "nickname": nickname,
    };
    await HttpsUtils.instance.post(HttpsPath.userPostsCommunityEditnickname,
        body: param, onSuccess: success, onFailure: failure);
  }

  //社群 - 退出社群
  userPostsCommunityQuitcommunity(
    String communityId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
    };
    await HttpsUtils.instance.post(HttpsPath.userPostsCommunityQuitcommunity,
        body: param, onSuccess: success, onFailure: failure);
  }

  //社群 - 获取自己在社群中的关注信息
  userPostsCommunityMyGuanzhu(
    int communityId,
    int page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
      "page": page,
    };
    await HttpsUtils.instance.get(HttpsPath.userPostsCommunityMyGuanzhu,
        body: param, onSuccess: success, onFailure: failure);
  }

  //社群 - 获取自己在社群中的粉丝信息
  userPostsCommunityMyFans(
    int communityId,
    int page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
      "page": page,
    };
    await HttpsUtils.instance.get(HttpsPath.userPostsCommunityMyFans,
        body: param, onSuccess: success, onFailure: failure);
  }

  //社群 - 获取自己在社群中的经验明细
  userPostsCommunityExpinfo(
    int communityId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
    };
    await HttpsUtils.instance.get(HttpsPath.userPostsCommunityExpinfo,
        body: param, onSuccess: success, onFailure: failure);
  }

  //社群 - 获取经验等级规则
  userPostsCommunityExpinfoRule(
    int communityId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
    };
    await HttpsUtils.instance.get(HttpsPath.userPostsCommunityExpinfoRule,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///获取首页的banner图
  homeBanner({
    Success? success,
    Failure? failure,
  }) async {
    var param = {};

    await HttpsUtils.instance.get(HttpsPath.homeBanner,
        body: param, onSuccess: success, onFailure: failure);
  }

  // /pro/user/communityuserinfo
  //社群 - 获取他人在社群中的主页信息
  userPostsCommunityOtherHomeInfo(
    int communityId,
    int userId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
      "user_id": userId,
    };

    await HttpsUtils.instance.get(HttpsPath.userPostsCommunityOtherHomeInfo,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///社群 - 获取社群某个用户的帖子
  // /pro/user_posts/communityuserposts
  userPostsCommunityOtherposts(
    int communityId,
    int userId,
    int page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
      "user_id": userId,
      "page": page,
    };

    await HttpsUtils.instance.get(HttpsPath.userPostsCommunityOtherposts,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///pro/user_posts/selfcommunityposts
  ///获取我在某个社群下的社群帖子
  userPostsCommunitySelfposts(
    int communityId,
    int page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
      "page": page,
    };

    await HttpsUtils.instance.get(HttpsPath.userPostsCommunitySelfposts,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///获取我在某个社群下的社群点赞帖子
  userPostsCommunitySelfLikeposts(
    int communityId,
    int page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "community_id": communityId,
      "page": page,
    };

    await HttpsUtils.instance.get(HttpsPath.userPostsCommunitySelfLikeposts,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///获取翻译内容
  userPostsContenttrans(
    int postsId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "posts_id": postsId,
    };
    await HttpsUtils.instance.get(HttpsPath.userPostsContenttrans,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///获取帖子标签详情列表
  userPostsTagposts(
    String tagStr,
    int page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "tag_str": tagStr,
      "page": page,
    };
    await HttpsUtils.instance.get(HttpsPath.userPostsTagposts,
        body: param, onSuccess: success, onFailure: failure);
  }

  /// 投票 - 投票列表
  userVoteList(
    String searchStr,
    String page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "search_str": searchStr,
      "page": page,
    };
    await HttpsUtils.instance.get(HttpsPath.userVoteList,
        body: param, onSuccess: success, onFailure: failure);
  }

  /// 投票 投票详情
  /// pollsId:投票id
  /// every_day_limit_num 每天限制投票次数
  /// today_allow_vote_num 今天还允许投票的次数
  /// time_status 0表示投票活动未开始，1进行中，2已结束
  /// is_multiple_choice 0表示单选，1表示多选
  userVoteDetail(
    int pollsId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "polls_id": pollsId,
    };
    await HttpsUtils.instance.get(
      HttpsPath.userVoteDetail,
      body: param,
      onSuccess: success,
      onFailure: failure,
    );
  }

  /// 投票 提交投票
  userSubmitVote(
    int pollsId,
    String optionId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "polls_id": pollsId,
      "option_id": optionId,
    };
    await HttpsUtils.instance.post(
      HttpsPath.userSubmitVote,
      body: param,
      onSuccess: success,
      onFailure: failure,
    );
  }

  /// 投票 获取投票榜单排名
  userVoteRank(
    int pollsId,
    int page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "polls_id": pollsId,
      "page": page,
    };
    await HttpsUtils.instance.get(
      HttpsPath.userVoteRank,
      body: param,
      onSuccess: success,
      onFailure: failure,
    );
  }

  /// 投票 获取投票记录
  userVoteLog(
    int pollsId,
    int page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "polls_id": pollsId,
      "page": page,
    };
    await HttpsUtils.instance.get(
      HttpsPath.userVoteLog,
      body: param,
      onSuccess: success,
      onFailure: failure,
    );
  }

  ///测验 获取首页测验数据列表
  userTestHomeList(
    String searchStr,
    int page, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "search_str": searchStr,
      "page": page,
    };
    await HttpsUtils.instance.get(
      HttpsPath.userTestHomeList,
      body: param,
      onSuccess: success,
      onFailure: failure,
    );
  }

  ///测验 获取测验详情
  userTestDetail(
    int examId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "exam_id": examId,
    };
    await HttpsUtils.instance.get(
      HttpsPath.userTestDetail,
      body: param,
      onSuccess: success,
      onFailure: failure,
    );
  }

  ///测验 获取测验试题
  userTestPaper(
    int examId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "exam_id": examId,
    };
    await HttpsUtils.instance.get(
      HttpsPath.userTestPaper,
      body: param,
      onSuccess: success,
      onFailure: failure,
    );
  }

  ///测验 提交测验结果
  ///examId: 测验id
  ///用户答案
  ///answer:[{"question_id":1,"option_id",2},{"question_id":2,"option_id",4},{"question_id":3,"option_id",1}]
  userTestUserAnswer(
    int examId,
    String answer, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "exam_id": examId,
      "answer": answer,
    };
    await HttpsUtils.instance.get(
      HttpsPath.userTestUserAnswer,
      body: param,
      onSuccess: success,
      onFailure: failure,
    );
  }

  ///测验 获取测验结果
  ///answer_id: 测验结果的id
  userTestAnswerresult(
    int answerId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "answer_id": answerId,
    };
    await HttpsUtils.instance.post(
      HttpsPath.userTestAnswerresult,
      body: param,
      onSuccess: success,
      onFailure: failure,
    );
  }

  ///测验 获取测验记录
  ///answer_id: 测验id
  userTestExamlog(
    int examId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "exam_id": examId,
    };
    await HttpsUtils.instance.get(
      HttpsPath.userTestExamlog,
      body: param,
      onSuccess: success,
      onFailure: failure,
    );
  }

  ///测验 获取测验记录详情
  ///examId: 测验id
  ///answer_id: 测验记录id
  userTestExamlogdetail(
    int examId,
    int answerId, {
    Success? success,
    Failure? failure,
  }) async {
    var param = {
      "exam_id": examId,
      "answer_id": answerId,
    };
    await HttpsUtils.instance.get(
      HttpsPath.userTestExamlogdetail,
      body: param,
      onSuccess: success,
      onFailure: failure,
    );
  }
}
