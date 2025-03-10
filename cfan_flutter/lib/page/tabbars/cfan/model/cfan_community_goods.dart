class CfanCommunityGoodsModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanCommunityGoodsModel({this.success, this.code, this.message, this.data});

  CfanCommunityGoodsModel.fromJson(Map<String, dynamic> json) {
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
  List<CfanCommunityGoodsItemModel>? list;

  Data({this.currentPage, this.lastPage, this.perPage, this.total, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['list'] != null) {
      list = <CfanCommunityGoodsItemModel>[];
      json['list'].forEach((v) {
        list!.add(new CfanCommunityGoodsItemModel.fromJson(v));
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

class CfanCommunityGoodsItemModel {
  int? goodsId;
  int? communitysId;
  String? name;
  String? price;
  int? totalSales;
  String? linkUrl;
  String? image;

  CfanCommunityGoodsItemModel(
      {this.goodsId,
      this.communitysId,
      this.name,
      this.price,
      this.totalSales,
      this.linkUrl,
      this.image});

  CfanCommunityGoodsItemModel.fromJson(Map<String, dynamic> json) {
    goodsId = json['goods_id'];
    communitysId = json['communitys_id'];
    name = json['name'];
    price = json['price'];
    totalSales = json['total_sales'];
    linkUrl = json['link_url'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goods_id'] = this.goodsId;
    data['communitys_id'] = this.communitysId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['total_sales'] = this.totalSales;
    data['link_url'] = this.linkUrl;
    data['image'] = this.image;
    return data;
  }
}
