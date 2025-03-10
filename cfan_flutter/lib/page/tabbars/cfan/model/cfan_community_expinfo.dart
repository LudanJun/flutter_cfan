//获取自己在社群中的经验明细
class CfanCommunityExpinfoModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanCommunityExpinfoModel({this.success, this.code, this.message, this.data});

  CfanCommunityExpinfoModel.fromJson(Map<String, dynamic> json) {
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
  List<CfanCommunityExpinfoItemModel>? list;
  int? level;
  int? userExp;

  Data(
      {this.currentPage,
      this.lastPage,
      this.perPage,
      this.total,
      this.list,
      this.level,
      this.userExp});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['list'] != null) {
      list = <CfanCommunityExpinfoItemModel>[];
      json['list'].forEach((v) {
        list!.add(new CfanCommunityExpinfoItemModel.fromJson(v));
      });
    }
    level = json['level'];
    userExp = json['user_exp'];
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
    data['level'] = this.level;
    data['user_exp'] = this.userExp;
    return data;
  }
}

class CfanCommunityExpinfoItemModel {
  String? remark;
  int? exp;
  String? time;

  CfanCommunityExpinfoItemModel({this.remark, this.exp, this.time});

  CfanCommunityExpinfoItemModel.fromJson(Map<String, dynamic> json) {
    remark = json['remark'];
    exp = json['exp'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['remark'] = this.remark;
    data['exp'] = this.exp;
    data['time'] = this.time;
    return data;
  }
}
