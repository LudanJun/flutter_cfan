class CfanPostsContenttransModel {
  bool? success;
  int? code;
  String? message;
  CfanPostsContenttransDataModel? data;

  CfanPostsContenttransModel(
      {this.success, this.code, this.message, this.data});

  CfanPostsContenttransModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null
        ? new CfanPostsContenttransDataModel.fromJson(json['data'])
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

class CfanPostsContenttransDataModel {
  String? dstContent;

  CfanPostsContenttransDataModel({this.dstContent});

  CfanPostsContenttransDataModel.fromJson(Map<String, dynamic> json) {
    dstContent = json['dst_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dst_content'] = this.dstContent;
    return data;
  }
}
