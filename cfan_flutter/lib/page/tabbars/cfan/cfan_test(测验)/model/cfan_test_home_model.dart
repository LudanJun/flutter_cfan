class CfanTestHomeModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanTestHomeModel({this.success, this.code, this.message, this.data});

  CfanTestHomeModel.fromJson(Map<String, dynamic> json) {
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
  List<CfanTestHomeItemModel>? list;

  Data({this.currentPage, this.lastPage, this.perPage, this.total, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['list'] != null) {
      list = <CfanTestHomeItemModel>[];
      json['list'].forEach((v) {
        list!.add(new CfanTestHomeItemModel.fromJson(v));
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

class CfanTestHomeItemModel {
  int? examId;
  String? title;
  String? logo;
  List<CfanTestHomeItemCommunityItemModel>? communityList;

  CfanTestHomeItemModel(
      {this.examId, this.title, this.logo, this.communityList});

  CfanTestHomeItemModel.fromJson(Map<String, dynamic> json) {
    examId = json['exam_id'];
    title = json['title'];
    logo = json['logo'];
    if (json['community_list'] != null) {
      communityList = <CfanTestHomeItemCommunityItemModel>[];
      json['community_list'].forEach((v) {
        communityList!.add(new CfanTestHomeItemCommunityItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exam_id'] = this.examId;
    data['title'] = this.title;
    data['logo'] = this.logo;
    if (this.communityList != null) {
      data['community_list'] =
          this.communityList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CfanTestHomeItemCommunityItemModel {
  int? communitysId;
  String? title;

  CfanTestHomeItemCommunityItemModel({this.communitysId, this.title});

  CfanTestHomeItemCommunityItemModel.fromJson(Map<String, dynamic> json) {
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
