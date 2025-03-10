
class CfanCommuityUserinfoModel {
  bool? success;
  int? code;
  String? message;
  CfanCommuityUserinfoItemModel? data;

  CfanCommuityUserinfoModel({this.success, this.code, this.message, this.data});

  CfanCommuityUserinfoModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null
        ? new CfanCommuityUserinfoItemModel.fromJson(json['data'])
        : null;
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

class CfanCommuityUserinfoItemModel {
  int? userId;
  String? avatar;
  String? name;
  int? fansNum;
  int? watchNum;
  String? joinTime;
  int? joinDay;
  int? level;
  String? levelName;
  int? nextLevelExp;
  int? userExp;

  CfanCommuityUserinfoItemModel(
      {this.userId,
      this.avatar,
      this.name,
      this.fansNum,
      this.watchNum,
      this.joinTime,
      this.joinDay,
      this.level,
      this.levelName,
      this.nextLevelExp,
      this.userExp});

  CfanCommuityUserinfoItemModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    avatar = json['avatar'];
    name = json['name'];
    fansNum = json['fans_num'];
    watchNum = json['watch_num'];
    joinTime = json['join_time'];
    joinDay = json['join_day'];
    level = json['level'];
    levelName = json['level_name'];
    nextLevelExp = json['next_level_exp'];
    userExp = json['user_exp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['fans_num'] = this.fansNum;
    data['watch_num'] = this.watchNum;
    data['join_time'] = this.joinTime;
    data['join_day'] = this.joinDay;
    data['level'] = this.level;
    data['level_name'] = this.levelName;
    data['next_level_exp'] = this.nextLevelExp;
    data['user_exp'] = this.userExp;
    return data;
  }
}
