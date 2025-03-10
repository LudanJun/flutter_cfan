class CfanVoteRecordModel {
  bool? success;
  int? code;
  String? message;
  List<CfanVoteRecordItemModel>? data;

  CfanVoteRecordModel({this.success, this.code, this.message, this.data});

  CfanVoteRecordModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CfanVoteRecordItemModel>[];
      json['data'].forEach((v) {
        data!.add(new CfanVoteRecordItemModel.fromJson(v));
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

class CfanVoteRecordItemModel {
  String? pollsOptionId;
  String? time;
  String? optionContent;

  CfanVoteRecordItemModel({this.pollsOptionId, this.time, this.optionContent});

  CfanVoteRecordItemModel.fromJson(Map<String, dynamic> json) {
    pollsOptionId = json['polls_option_id'];
    time = json['time'];
    optionContent = json['option_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['polls_option_id'] = this.pollsOptionId;
    data['time'] = this.time;
    data['option_content'] = this.optionContent;
    return data;
  }
}
