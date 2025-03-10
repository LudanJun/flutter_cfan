class CfanTestDetailModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanTestDetailModel({this.success, this.code, this.message, this.data});

  CfanTestDetailModel.fromJson(Map<String, dynamic> json) {
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
  int? examId;
  String? title;
  String? logo;
  String? introImage;
  List<CfanTestDetaiCommunityitemModel>? communityList;

  Data(
      {this.examId,
      this.title,
      this.logo,
      this.introImage,
      this.communityList});

  Data.fromJson(Map<String, dynamic> json) {
    examId = json['exam_id'];
    title = json['title'];
    logo = json['logo'];
    introImage = json['intro_image'];
    if (json['community_list'] != null) {
      communityList = <CfanTestDetaiCommunityitemModel>[];
      json['community_list'].forEach((v) {
        communityList!.add(new CfanTestDetaiCommunityitemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exam_id'] = this.examId;
    data['title'] = this.title;
    data['logo'] = this.logo;
    data['intro_image'] = this.introImage;
    if (this.communityList != null) {
      data['community_list'] =
          this.communityList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CfanTestDetaiCommunityitemModel {
  int? communitysId;
  String? title;

  CfanTestDetaiCommunityitemModel({this.communitysId, this.title});

  CfanTestDetaiCommunityitemModel.fromJson(Map<String, dynamic> json) {
    communitysId = json['communitys_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['communitys_id'] = this.communitysId;
    data['title'] = this.title;
    return data;
  }
}
