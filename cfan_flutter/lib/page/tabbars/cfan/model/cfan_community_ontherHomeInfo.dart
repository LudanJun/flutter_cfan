///获取他人在社群中的主页头部信息
class CfanCommunityOntherhomeinfoModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanCommunityOntherhomeinfoModel(
      {this.success, this.code, this.message, this.data});

  CfanCommunityOntherhomeinfoModel.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  String? avatar;
  String? name;
  int? fansNum;
  int? watchNum;

  Data({this.userId, this.avatar, this.name, this.fansNum, this.watchNum});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    avatar = json['avatar'];
    name = json['name'];
    fansNum = json['fans_num'];
    watchNum = json['watch_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['fans_num'] = this.fansNum;
    data['watch_num'] = this.watchNum;
    return data;
  }
}
