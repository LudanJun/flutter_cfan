//社群详情 管理员
class CfanCommunityManagerModel {
  bool? success;
  int? code;
  String? message;
  List<CfanCommunityManagerItemModel>? data;

  CfanCommunityManagerModel({this.success, this.code, this.message, this.data});

  CfanCommunityManagerModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CfanCommunityManagerItemModel>[];
      json['data'].forEach((v) {
        data!.add(new CfanCommunityManagerItemModel.fromJson(v));
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

class CfanCommunityManagerItemModel {
  String? name;
  String? avatar;

  CfanCommunityManagerItemModel({this.name, this.avatar});

  CfanCommunityManagerItemModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    return data;
  }
}