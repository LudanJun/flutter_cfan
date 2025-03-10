class HttpsPath {
  //////////////// 登录 ////////////////
  ///登录
  static const String loginUrl = '/pro/login/login';
  // static const String loginUrl = '/login/login';

  //退出登录
  static const String logout = '/pro/login/logout';

  //上传头像
  static const String uploadImage = '/pro/upload/uploadImage';

  //上传头像
  static const String useredit = '/pro/user/useredit';

  //获取社群列表
  static const String communityList = '/pro/communitys/list';

  //加入社群
  static const String addCommunity = '/pro/communitys/joincommunity';

  //我的社群
  static const String myCommunity = '/pro/communitys/mycommunity';

  //社群 - 明星动态
  static const String userPosts = '/pro/user_posts/list';

  //社群 - 社群广场信息
  static const String communityGuangchang = '/pro/communitys/communitysquare';

  //社群 - 帖子详情
  static const String userPostsDetail = '/pro/user_posts/postsdetail';

  //社群 - 帖子评论数据
  static const String userPostsDetailcomment = '/pro/user_posts_comment/list';

  //社群 - 发布帖子
  static const String userPostsRelease = '/pro/user_posts/addposts';

  //社群 - 上传帖子图片
  static const String userPostsUploadPostsImage =
      '/pro/upload/uploadPostsImage';

  //社群 - 帖子发送评论
  static const String userPostsDetailSendComment =
      '/pro/user_posts_comment/addcomment';

  //社群 - 发送帖子评论回复
  static const String userPostsDetailSendCommentReply =
      '/pro/user_posts_reply/addreply';

  //社群 - 获取帖子评论回复
  static const String userPostsDetailGetCommentReply =
      '/pro/user_posts_reply/list';

  //社群 - 帖子点赞列表
  static const String userPostsDetailZanList = '/pro/posts_like/getlist';

  //社群 - 帖子点赞
  static const String userPostsLike = '/pro/posts_like/islike';

  //社群 - 帖子评论的点赞或取消点赞
  static const String userPostsCommentLike = '/pro/posts_comment_like/islike';

  //社群 - 社群主页详情
  static const String userPostsCommunitdetail =
      '/pro/communitys/communitydetail';

  //社群 - 社群管理员
  static const String userPostsCommunitymanager =
      '/pro/communitys/communitymanager';

  //社群 - 社群主页帖子
  static const String userPostsCommunitposts = '/pro/user_posts/communityposts';

  //社群 - 社群主页动态
  static const String userPostsArtistposts = '/pro/user_posts/artistposts';

  //社群 - 社群节目分类
  static const String userPostsProgramCategory = '/pro/video_category/list';

  //社群 - 社群节目列表信息
  static const String userPostsProgramList = '/pro/communitys_video/list';

  //社群 - 社群节目详情信息
  static const String userPostsProgramDetail =
      '/pro/communitys_video/videodetail';

  //社群 - 获取商品
  static const String communityGoods = '/pro/goods/list';

  //社群 - 社群个人信息
  static const String userPostsCommunityUserInfoDetail =
      '/pro/user/communityselfinfo';

  //社群 - 社群签到
  static const String userPostsCommunityQiandao = '/pro/communitys/qiandao';

  // //社群 - 自己在社群中的经验明细
  // static const String userPostsCommunityExpInfo = '/pro/user/communitysexpinfo';

  //社群 -  修改自己在社群中的昵称
  static const String userPostsCommunityEditnickname = '/pro/user/editnickname';

  //社群 -  退出社群
  static const String userPostsCommunityQuitcommunity =
      '/pro/user/quitcommunity';

  //社群 -  获取自己在社群中的关注信息
  static const String userPostsCommunityMyGuanzhu = '/pro/user/communitywatch';

  //社群 -  获取自己在社群中的粉丝信息
  static const String userPostsCommunityMyFans = '/pro/user/communityfans';

  //社群 -  获取自己在社群中的经验明细
  static const String userPostsCommunityExpinfo = '/pro/user/communitysexpinfo';

  //社群 -  获取经验等级规则
  static const String userPostsCommunityExpinfoRule = '/pro/expinfo/list';

  //首页 -  获取首页banner图
  static const String homeBanner = '/pro/banner/list';

  //首页 -  获取他人在社群中的主页信息
  static const String userPostsCommunityOtherHomeInfo =
      '/pro/user/communityuserinfo';

  //首页 -  获取他人在社群中的帖子数据
  static const String userPostsCommunityOtherposts =
      '/pro/user_posts/communityuserposts';

  //首页 -  获取自己在社群中的帖子
  static const String userPostsCommunitySelfposts =
      '/pro/user_posts/selfcommunityposts';

  //首页 -  获取我在某个社群赞过的帖子
  static const String userPostsCommunitySelfLikeposts =
      '/pro/user_posts/selfcommunitylikeposts';

  //首页 -  帖子内容翻译
  static const String userPostsContenttrans = '/pro/user_posts/contenttrans';

  //帖子 - 标签话题详情列表
  static const String userPostsTagposts = '/pro/hottags/tagposts';

  //投票 - 首页投票列表
  static const String userVoteList = '/pro/polls/list';

  //投票 - 投票详情
  static const String userVoteDetail = '/pro/polls/detail';

  //投票 - 提交投票
  static const String userSubmitVote = '/pro/polls/uservote';

  //投票 - 投票排行
  static const String userVoteRank = '/pro/polls/pollsrank';

  //投票 - 投票记录
  static const String userVoteLog = '/pro/polls/pollslog';

  //测验 获取首页测验数据列表
  static const String userTestHomeList = '/pro/exam/list';

  ///测验 获取测验详情
  static const String userTestDetail = '/pro/exam/detail';

  ///测验 获取测验试题
  static const String userTestPaper = '/pro/exam/exampaper';

  ///测验 提交测验结果
  static const String userTestUserAnswer = '/pro/exam/useranswer';

  ///测验 获取测验结果
  static const String userTestAnswerresult = '/pro/exam/answerresult';

  ///测验 获取测验记录
  static const String userTestExamlog = '/pro/exam/examlog';

  ///测验 获取测验记录详情
  static const String userTestExamlogdetail = '/pro/exam/examlogdetail';

}
