class CfanHomeBannerModel {
  bool? success;
  int? code;
  String? message;
  List<CfanHomeBannerItemModel>? data;

  CfanHomeBannerModel({this.success, this.code, this.message, this.data});

  CfanHomeBannerModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CfanHomeBannerItemModel>[];
      json['data'].forEach((v) {
        data!.add(new CfanHomeBannerItemModel.fromJson(v));
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

class CfanHomeBannerItemModel {
  int? type;
  int? dataId;
  String? linkUrl;
  String? image;

  CfanHomeBannerItemModel({this.type, this.dataId, this.linkUrl, this.image});

  CfanHomeBannerItemModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    dataId = json['data_id'];
    linkUrl = json['link_url'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['data_id'] = this.dataId;
    data['link_url'] = this.linkUrl;
    data['image'] = this.image;
    return data;
  }
}
