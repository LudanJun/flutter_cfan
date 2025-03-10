//节目 分类标签  model
class CfanCommunityProgramCategoryModel {
  bool? success;
  int? code;
  String? message;
  List<CfanCommunityProgramCategoryItemModel>? data;

  CfanCommunityProgramCategoryModel(
      {this.success, this.code, this.message, this.data});

  CfanCommunityProgramCategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CfanCommunityProgramCategoryItemModel>[];
      json['data'].forEach((v) {
        data!.add(new CfanCommunityProgramCategoryItemModel.fromJson(v));
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

class CfanCommunityProgramCategoryItemModel {
  int? videoType;
  String? title;

  CfanCommunityProgramCategoryItemModel({this.videoType, this.title});

  CfanCommunityProgramCategoryItemModel.fromJson(Map<String, dynamic> json) {
    videoType = json['video_type'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_type'] = this.videoType;
    data['title'] = this.title;
    return data;
  }
}
