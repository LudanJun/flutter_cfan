class CfanTestResultModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanTestResultModel({this.success, this.code, this.message, this.data});

  CfanTestResultModel.fromJson(Map<String, dynamic> json) {
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
  int? rightNum;
  int? errorNum;
  List<CfanTestResultItemModel>? list;

  Data({this.rightNum, this.errorNum, this.list});

  Data.fromJson(Map<String, dynamic> json) {
    rightNum = json['right_num'];
    errorNum = json['error_num'];
    if (json['list'] != null) {
      list = <CfanTestResultItemModel>[];
      json['list'].forEach((v) {
        list!.add(new CfanTestResultItemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['right_num'] = this.rightNum;
    data['error_num'] = this.errorNum;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CfanTestResultItemModel {
  int? num;
  int? examId;
  int? questionId;
  String? rightOption;
  String? userOption;
  bool? isRight;

  CfanTestResultItemModel(
      {this.num,
      this.examId,
      this.questionId,
      this.rightOption,
      this.userOption,
      this.isRight});

  CfanTestResultItemModel.fromJson(Map<String, dynamic> json) {
    num = json['num'];
    examId = json['exam_id'];
    questionId = json['question_id'];
    rightOption = json['right_option'];
    userOption = json['user_option'];
    isRight = json['is_right'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num'] = this.num;
    data['exam_id'] = this.examId;
    data['question_id'] = this.questionId;
    data['right_option'] = this.rightOption;
    data['user_option'] = this.userOption;
    data['is_right'] = this.isRight;
    return data;
  }
}
