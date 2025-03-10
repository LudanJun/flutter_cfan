//帖子详情
class CfanPostDetailModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanPostDetailModel({this.success, this.code, this.message, this.data});

  CfanPostDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  get picList => null;

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
  int? postsId;
  int? userId;
  String? content;
  String? createAt;
  String? location;
  String? name;
  String? avatar;
  String? createTime;
  List<String>? picList;
  bool? isLike;

  Data(
      {this.postsId,
      this.userId,
      this.content,
      this.createAt,
      this.location,
      this.name,
      this.avatar,
      this.createTime,
      this.picList,
      this.isLike});

  Data.fromJson(Map<String, dynamic> json) {
    postsId = json['posts_id'];
    userId = json['user_id'];
    content = json['content'];
    createAt = json['created_at'];
    location = json['location'];
    name = json['name'];
    avatar = json['avatar'];
    createTime = json['created_time'];
    picList = json['pic_list'].cast<String>();
    isLike = json['is_like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posts_id'] = this.postsId;
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['created_at'] = this.createAt;
    data['location'] = this.location;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['created_time'] = this.createTime;
    data['pic_list'] = this.picList;
    data['is_like'] = this.isLike;
    return data;
  }
}
