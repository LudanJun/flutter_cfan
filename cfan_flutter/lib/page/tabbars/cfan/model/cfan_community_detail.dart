//社群详情
class CfanCommunityDetailModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanCommunityDetailModel({this.success, this.code, this.message, this.data});

  CfanCommunityDetailModel.fromJson(Map<String, dynamic> json) {
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
  ///社群id
  int? communityId;

  ///标题
  String? title;

  ///简介
  String? intro;

  ///logo
  String? logo;

  ///头像
  String? avatar;

  ///粉丝数量
  int? fansTotal;

  ///帖子数量
  int? postsTotal;
  //多个艺人模型数组 (如果是组合会存在多个)
  List<CfanCommunityDetailArtistModel>? artist;

  Data(
      {this.communityId,
      this.title,
      this.intro,
      this.logo,
      this.avatar,
      this.fansTotal,
      this.postsTotal,
      this.artist});

  Data.fromJson(Map<String, dynamic> json) {
    communityId = json['community_id'];
    title = json['title'];
    intro = json['intro'];
    logo = json['logo'];
    avatar = json['avatar'];
    fansTotal = json['fans_total'];
    postsTotal = json['posts_total'];
    if (json['artist'] != null) {
      artist = <CfanCommunityDetailArtistModel>[];
      json['artist'].forEach((v) {
        artist!.add(new CfanCommunityDetailArtistModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['community_id'] = this.communityId;
    data['title'] = this.title;
    data['intro'] = this.intro;
    data['logo'] = this.logo;
    data['avatar'] = this.avatar;
    data['fans_total'] = this.fansTotal;
    data['posts_total'] = this.postsTotal;
    if (this.artist != null) {
      data['artist'] = this.artist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

//艺人模型
class CfanCommunityDetailArtistModel {
  int? id;
  String? name;
  String? avatar;

  CfanCommunityDetailArtistModel({this.id, this.name, this.avatar});

  CfanCommunityDetailArtistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    return data;
  }
}
