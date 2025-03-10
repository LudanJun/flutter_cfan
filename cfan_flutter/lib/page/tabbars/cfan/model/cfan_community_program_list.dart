//分类列表数据
class CfanCommunityProgramListModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanCommunityProgramListModel(
      {this.success, this.code, this.message, this.data});

  CfanCommunityProgramListModel.fromJson(Map<String, dynamic> json) {
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
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  List<CfanCommunityProgramListItemModel>? list;

  Data({this.currentPage, this.lastPage, this.perPage, this.total, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['list'] != null) {
      list = <CfanCommunityProgramListItemModel>[];
      json['list'].forEach((v) {
        list!.add(new CfanCommunityProgramListItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

//分类列表单个数据
class CfanCommunityProgramListItemModel {
  int? videoId;
  String? title;
  String? logo;

  CfanCommunityProgramListItemModel({this.videoId, this.title, this.logo});

  CfanCommunityProgramListItemModel.fromJson(Map<String, dynamic> json) {
    videoId = json['video_id'];
    title = json['title'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_id'] = this.videoId;
    data['title'] = this.title;
    data['logo'] = this.logo;
    return data;
  }
}
