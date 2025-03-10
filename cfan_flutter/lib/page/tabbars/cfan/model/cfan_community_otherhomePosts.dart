//获取社群某个用户的帖子
class CfanCommunityOtherhomepostsModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanCommunityOtherhomepostsModel({this.success, this.code, this.message, this.data});

  CfanCommunityOtherhomepostsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  List<CfanCommunityOtherhomepostsItemModel>? list;

  Data({this.currentPage, this.lastPage, this.perPage, this.total, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['list'] != null) {
      list = <CfanCommunityOtherhomepostsItemModel>[];
      json['list'].forEach((v) {
        list!.add(new CfanCommunityOtherhomepostsItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CfanCommunityOtherhomepostsItemModel {
  int? postsId;
  int? userId;
  String? content;
  String? createdAt;
  String? location;
  String? name;
  int? viewCount;
  int? likeCount;
  int? commentCount;
  String? avatar;
  List<String>? picList;
  bool? isLike;
  GradeInfo? gradeInfo;

  CfanCommunityOtherhomepostsItemModel(
      {this.postsId,
      this.userId,
      this.content,
      this.createdAt,
      this.location,
      this.name,
      this.viewCount,
      this.likeCount,
      this.commentCount,
      this.avatar,
      this.picList,
      this.isLike,
      this.gradeInfo});

  CfanCommunityOtherhomepostsItemModel.fromJson(Map<String, dynamic> json) {
    postsId = json['posts_id'];
    userId = json['user_id'];
    content = json['content'];
    createdAt = json['created_at'];
    location = json['location'];
    name = json['name'];
    viewCount = json['view_count'];
    likeCount = json['like_count'];
    commentCount = json['comment_count'];
    avatar = json['avatar'];
    picList = json['pic_list'].cast<String>();
    isLike = json['is_like'];
    gradeInfo = json['grade_info'] != null
        ? new GradeInfo.fromJson(json['grade_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posts_id'] = this.postsId;
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['location'] = this.location;
    data['name'] = this.name;
    data['view_count'] = this.viewCount;
    data['like_count'] = this.likeCount;
    data['comment_count'] = this.commentCount;
    data['avatar'] = this.avatar;
    data['pic_list'] = this.picList;
    data['is_like'] = this.isLike;
    if (this.gradeInfo != null) {
      data['grade_info'] = this.gradeInfo!.toJson();
    }
    return data;
  }
}

class GradeInfo {
  int? level;
  String? levelName;
  int? nextLevelExp;

  GradeInfo({this.level, this.levelName, this.nextLevelExp});

  GradeInfo.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    levelName = json['level_name'];
    nextLevelExp = json['next_level_exp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    data['level_name'] = this.levelName;
    data['next_level_exp'] = this.nextLevelExp;
    return data;
  }
}
