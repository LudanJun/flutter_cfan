//首页社群列表模型
class CfanCommunityModel {
  bool? success;
  int? code;
  String? message;
  List<CfanCommunityItemModel>? data;

  CfanCommunityModel({this.success, this.code, this.message, this.data});

  CfanCommunityModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CfanCommunityItemModel>[];
      json['data'].forEach((v) {
        data!.add(new CfanCommunityItemModel.fromJson(v));
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
//社群单个模型
class CfanCommunityItemModel {
  int? communityId;
  String? title;
  String? avatar;

  CfanCommunityItemModel({this.communityId, this.title, this.avatar});

  CfanCommunityItemModel.fromJson(Map<String, dynamic> json) {
    communityId = json['community_id'];
    title = json['title'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['community_id'] = this.communityId;
    data['title'] = this.title;
    data['avatar'] = this.avatar;
    return data;
  }
}
