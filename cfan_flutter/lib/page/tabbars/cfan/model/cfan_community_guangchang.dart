class CfanCommunityGuangchangModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanCommunityGuangchangModel(
      {this.success, this.code, this.message, this.data});

  CfanCommunityGuangchangModel.fromJson(Map<String, dynamic> json) {
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
  List<CfanCommunityGuangchangItemModel>? list;

  Data({this.currentPage, this.lastPage, this.perPage, this.total, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['list'] != null) {
      list = <CfanCommunityGuangchangItemModel>[];
      json['list'].forEach((v) {
        list!.add(new CfanCommunityGuangchangItemModel.fromJson(v));
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

class CfanCommunityGuangchangItemModel {
  int? communityId;
  String? title;
  String? avatar;
  int? fansToal;

  CfanCommunityGuangchangItemModel(
      {this.communityId, this.title, this.avatar, this.fansToal});

  CfanCommunityGuangchangItemModel.fromJson(Map<String, dynamic> json) {
    communityId = json['community_id'];
    title = json['title'];
    avatar = json['avatar'];
    fansToal = json['fans_toal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['community_id'] = this.communityId;
    data['title'] = this.title;
    data['avatar'] = this.avatar;
    data['fans_toal'] = this.fansToal;
    return data;
  }
}
