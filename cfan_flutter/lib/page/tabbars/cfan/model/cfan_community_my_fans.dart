class CfanCommunityMyFansModel {
  bool? success;
  int? code;
  String? message;
  List<CfanCommunityMyFansItemModel>? data;

  CfanCommunityMyFansModel({this.success, this.code, this.message, this.data});

  CfanCommunityMyFansModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CfanCommunityMyFansItemModel>[];
      json['data'].forEach((v) {
        data!.add(new CfanCommunityMyFansItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CfanCommunityMyFansItemModel {
  String? name;
  String? avatar;
  int? level;
  String? levelName;
  int? fansStatus;
  String? time;

  CfanCommunityMyFansItemModel(
      {this.name,
      this.avatar,
      this.level,
      this.levelName,
      this.fansStatus,
      this.time});

  CfanCommunityMyFansItemModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    avatar = json['avatar'];
    level = json['level'];
    levelName = json['level_name'];
    fansStatus = json['fans_status'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['level'] = this.level;
    data['level_name'] = this.levelName;
    data['fans_status'] = this.fansStatus;
    data['time'] = this.time;
    return data;
  }
}
