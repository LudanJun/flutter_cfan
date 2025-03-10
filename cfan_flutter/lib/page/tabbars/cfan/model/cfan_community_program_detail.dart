//分类详情数据
class CfanCommunityProgramDetailModel {
  bool? success;
  int? code;
  String? message;
  CfanCommunityProgramDetailDataModel? data;

  CfanCommunityProgramDetailModel(
      {this.success, this.code, this.message, this.data});

  CfanCommunityProgramDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null
        ? new CfanCommunityProgramDetailDataModel.fromJson(json['data'])
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
//分类详情数据
class CfanCommunityProgramDetailDataModel {
  int? videoId;
  String? title;
  String? createAt;
  String? location;
  String? name;
  String? avatar;
  String? logo;
  String? videoPath;

  CfanCommunityProgramDetailDataModel(
      {this.videoId,
      this.title,
      this.createAt,
      this.location,
      this.name,
      this.avatar,
      this.logo,
      this.videoPath});

  CfanCommunityProgramDetailDataModel.fromJson(Map<String, dynamic> json) {
    videoId = json['video_id'];
    title = json['title'];
    createAt = json['created_at'];
    location = json['location'];
    name = json['name'];
    avatar = json['avatar'];
    logo = json['logo'];
    videoPath = json['video_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_id'] = this.videoId;
    data['title'] = this.title;
    data['created_at'] = this.createAt;
    data['location'] = this.location;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['logo'] = this.logo;
    data['video_path'] = this.videoPath;
    return data;
  }
}
