//用户帖子模型
import 'package:flutter/material.dart';

class CfanUserpostsModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanUserpostsModel({this.success, this.code, this.message, this.data});

  CfanUserpostsModel.fromJson(Map<String, dynamic> json) {
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
  List<CfanUserpostsItemModel>? list;

  Data({this.currentPage, this.lastPage, this.perPage, this.total, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['list'] != null) {
      list = <CfanUserpostsItemModel>[];
      json['list'].forEach((v) {
        list!.add(new CfanUserpostsItemModel.fromJson(v));
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

class CfanUserpostsItemModel {
  ///帖子id

  int? postsId;

  ///用户id

  int? userId;

  ///帖子内容

  String? content;

  ///发布时间

  String? createTime;

  ///定位
  String? location;

  ///名字

  String? name;

  /// 浏览量
  int? viewCount;

  /// 点赞量
  int? likeCount;

  /// 评论量
  int? commentCount;

  ///头像地址
  String? avatar;

  ///是否点赞
  bool? isLike;

  /// 社群名字
  String? communityName;

  ///帖子图片
  List<String>? picList;

  GradeInfo? gradeInfo;

  CfanUserpostsItemModel(
      {this.postsId,
      this.userId,
      this.content,
      this.createTime,
      this.location,
      this.name,
      this.viewCount,
      this.likeCount,
      this.commentCount,
      this.avatar,
      this.isLike,
      this.communityName,
      this.picList,
      this.gradeInfo});

  CfanUserpostsItemModel.fromJson(Map<String, dynamic> json) {
    postsId = json['posts_id'];
    userId = json['user_id'];
    content = json['content'];
    createTime = json['created_at'];
    location = json['location'];
    name = json['name'];
    viewCount = json['view_count'];
    likeCount = json['like_count'];
    commentCount = json['comment_count'];
    avatar = json['avatar'];
    isLike = json['is_like'];
    communityName = json['community_name'];
    picList = json['pic_list'].cast<String>();
    gradeInfo = json['grade_info'] != null
        ? new GradeInfo.fromJson(json['grade_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posts_id'] = this.postsId;
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['created_at'] = this.createTime;
    data['location'] = this.location;
    data['name'] = this.name;
    data['view_count'] = this.viewCount;
    data['like_count'] = this.likeCount;
    data['comment_count'] = this.commentCount;
    data['avatar'] = this.avatar;
    data['is_like'] = this.isLike;
    data['community_name'] = this.communityName;
    data['pic_list'] = this.picList;
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
