class CfanTestRecordModel {
  bool? success;
  int? code;
  String? message;
  List<CfanTestRecordItemModel>? data;

  CfanTestRecordModel({this.success, this.code, this.message, this.data});

  CfanTestRecordModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CfanTestRecordItemModel>[];
      json['data'].forEach((v) {
        data!.add(new CfanTestRecordItemModel.fromJson(v));
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

class CfanTestRecordItemModel {
  int? answerId;
  int? examId;
  int? rightNum;
  int? errorNum;
  String? time;

  CfanTestRecordItemModel({this.answerId, this.examId, this.rightNum, this.errorNum, this.time});

  CfanTestRecordItemModel.fromJson(Map<String, dynamic> json) {
    answerId = json['answer_id'];
    examId = json['exam_id'];
    rightNum = json['right_num'];
    errorNum = json['error_num'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer_id'] = this.answerId;
    data['exam_id'] = this.examId;
    data['right_num'] = this.rightNum;
    data['error_num'] = this.errorNum;
    data['time'] = this.time;
    return data;
  }
}
