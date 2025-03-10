/*
//帖子评论模型
class CfanPostsDetailCommentModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanPostsDetailCommentModel(
      {this.success, this.code, this.message, this.data});

  CfanPostsDetailCommentModel.fromJson(Map<String, dynamic> json) {
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
  List<CfanPostsDetailCommentItemModel>? list;

  Data({this.currentPage, this.lastPage, this.perPage, this.total, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['list'] != null) {
      list = <CfanPostsDetailCommentItemModel>[];
      json['list'].forEach((v) {
        list!.add(new CfanPostsDetailCommentItemModel.fromJson(v));
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
//帖子评论 单个模型
class CfanPostsDetailCommentItemModel {
  int? commentId;
  int? userId;
  String? content;
  String? createAt;
  String? ipAddr;
  String? name;
  int? likeCount;
  int? replyCount;
  String? avatar;
  List<String>? picList;
  bool? isLike;

  CfanPostsDetailCommentItemModel(
      {this.commentId,
      this.userId,
      this.content,
      this.createAt,
      this.ipAddr,
      this.name,
      this.likeCount,
      this.replyCount,
      this.avatar,
      this.picList,
      this.isLike});

  CfanPostsDetailCommentItemModel.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    userId = json['user_id'];
    content = json['content'];
    createAt = json['created_at'];
    ipAddr = json['ip_addr'];
    name = json['name'];
    likeCount = json['like_count'];
    replyCount = json['reply_count'];
    avatar = json['avatar'];
    picList = json['pic_list'].cast<String>();
    isLike = json['is_like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_id'] = this.commentId;
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['created_at'] = this.createAt;
    data['ip_addr'] = this.ipAddr;
    data['name'] = this.name;
    data['like_count'] = this.likeCount;
    data['reply_count'] = this.replyCount;
    data['avatar'] = this.avatar;
    data['pic_list'] = this.picList;
    data['is_like'] = this.isLike;
    return data;
  }
}
*/

//帖子评论模型 带回复评论数组
class CfanPostsDetailCommentModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanPostsDetailCommentModel(
      {this.success, this.code, this.message, this.data});

  CfanPostsDetailCommentModel.fromJson(Map<String, dynamic> json) {
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
  List<CfanPostsDetailCommentItemModel>? list;

  Data({this.currentPage, this.lastPage, this.perPage, this.total, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['list'] != null) {
      list = <CfanPostsDetailCommentItemModel>[];
      json['list'].forEach((v) {
        list!.add(new CfanPostsDetailCommentItemModel.fromJson(v));
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

class CfanPostsDetailCommentItemModel {
  int? commentId;
  int? userId;
  String? content;
  String? createdAt;
  String? ipAddr;
  String? name;
  int? likeCount;
  int? replyCount;
  String? avatar;
  List<String>? picList;
  bool? isLike;
  List<CfanPostsDetailCommentItemReplyListItemModel>? replyList;

  CfanPostsDetailCommentItemModel(
      {this.commentId,
      this.userId,
      this.content,
      this.createdAt,
      this.ipAddr,
      this.name,
      this.likeCount,
      this.replyCount,
      this.avatar,
      this.picList,
      this.isLike,
      this.replyList});

  CfanPostsDetailCommentItemModel.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    userId = json['user_id'];
    content = json['content'];
    createdAt = json['created_at'];
    ipAddr = json['ip_addr'];
    name = json['name'];
    likeCount = json['like_count'];
    replyCount = json['reply_count'];
    avatar = json['avatar'];
    picList = json['pic_list'].cast<String>();
    isLike = json['is_like'];
    if (json['reply_list'] != null) {
      replyList = <CfanPostsDetailCommentItemReplyListItemModel>[];
      json['reply_list'].forEach((v) {
        replyList!.add(new CfanPostsDetailCommentItemReplyListItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_id'] = this.commentId;
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['ip_addr'] = this.ipAddr;
    data['name'] = this.name;
    data['like_count'] = this.likeCount;
    data['reply_count'] = this.replyCount;
    data['avatar'] = this.avatar;
    data['pic_list'] = this.picList;
    data['is_like'] = this.isLike;
    if (this.replyList != null) {
      data['reply_list'] = this.replyList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CfanPostsDetailCommentItemReplyListItemModel {
  int? replyId;
  int? userId;
  String? content;
  String? createdAt;
  String? ipAddr;
  String? name;
  String? avatar;
  List<String>? picList;

  CfanPostsDetailCommentItemReplyListItemModel(
      {this.replyId,
      this.userId,
      this.content,
      this.createdAt,
      this.ipAddr,
      this.name,
      this.avatar,
      this.picList});

  CfanPostsDetailCommentItemReplyListItemModel.fromJson(Map<String, dynamic> json) {
    replyId = json['reply_id'];
    userId = json['user_id'];
    content = json['content'];
    createdAt = json['created_at'];
    ipAddr = json['ip_addr'];
    name = json['name'];
    avatar = json['avatar'];
    picList = json['pic_list'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reply_id'] = this.replyId;
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['ip_addr'] = this.ipAddr;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['pic_list'] = this.picList;
    return data;
  }
}
