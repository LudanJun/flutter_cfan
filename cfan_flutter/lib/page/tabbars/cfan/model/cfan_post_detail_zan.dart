//点赞列表
class CfanPostDetailZanModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanPostDetailZanModel({this.success, this.code, this.message, this.data});

  CfanPostDetailZanModel.fromJson(Map<String, dynamic> json) {
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
  List<CfanPostDetailZanItemModel>? list;

  Data({this.currentPage, this.lastPage, this.perPage, this.total, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['list'] != null) {
      list = <CfanPostDetailZanItemModel>[];
      json['list'].forEach((v) {
        list!.add(new CfanPostDetailZanItemModel.fromJson(v));
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
//每个点赞模型
class CfanPostDetailZanItemModel {
  int? likeId;
  int? userId;
  String? name;
  String? avatar;

  CfanPostDetailZanItemModel(
      {this.likeId, this.userId, this.name, this.avatar});

  CfanPostDetailZanItemModel.fromJson(Map<String, dynamic> json) {
    likeId = json['like_id'];
    userId = json['user_id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['like_id'] = this.likeId;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    return data;
  }
}
