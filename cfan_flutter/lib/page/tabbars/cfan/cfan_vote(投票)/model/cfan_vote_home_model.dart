class CfanVoteHomeModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanVoteHomeModel({this.success, this.code, this.message, this.data});

  CfanVoteHomeModel.fromJson(Map<String, dynamic> json) {
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
  List<CfanVoteHomeItemModel>? list;

  Data({this.currentPage, this.lastPage, this.perPage, this.total, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['list'] != null) {
      list = <CfanVoteHomeItemModel>[];
      json['list'].forEach((v) {
        list!.add(new CfanVoteHomeItemModel.fromJson(v));
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

class CfanVoteHomeItemModel {
  int? pollsId;
  String? title;
  String? startTime;
  String? endTime;
  int? isLimitCommunity;
  String? logo;
  List<CommunityList>? communityList;

  CfanVoteHomeItemModel(
      {this.pollsId,
      this.title,
      this.startTime,
      this.endTime,
      this.isLimitCommunity,
      this.logo,
      this.communityList});

  CfanVoteHomeItemModel.fromJson(Map<String, dynamic> json) {
    pollsId = json['polls_id'];
    title = json['title'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    isLimitCommunity = json['is_limit_community'];
    logo = json['logo'];
    if (json['community_list'] != null) {
      communityList = <CommunityList>[];
      json['community_list'].forEach((v) {
        communityList!.add(new CommunityList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['polls_id'] = this.pollsId;
    data['title'] = this.title;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['is_limit_community'] = this.isLimitCommunity;
    data['logo'] = this.logo;
    if (this.communityList != null) {
      data['community_list'] =
          this.communityList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommunityList {
  int? communitysId;
  String? title;

  CommunityList({this.communitysId, this.title});

  CommunityList.fromJson(Map<String, dynamic> json) {
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
