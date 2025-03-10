class CfanTestPaperModel {
  bool? success;
  int? code;
  String? message;
  List<CfanTestPaperItemModel>? data;

  CfanTestPaperModel({this.success, this.code, this.message, this.data});

  CfanTestPaperModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CfanTestPaperItemModel>[];
      json['data'].forEach((v) {
        data!.add(new CfanTestPaperItemModel.fromJson(v));
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

class CfanTestPaperItemModel {
  int? questionId;
  String? title;
  int? isMultipleChoice;
  String? introImage;
  List<CfanTestPaperItemOptionModel>? optionList;

  CfanTestPaperItemModel(
      {this.questionId,
      this.title,
      this.isMultipleChoice,
      this.introImage,
      this.optionList});

  CfanTestPaperItemModel.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    title = json['title'];
    isMultipleChoice = json['is_multiple_choice'];
    introImage = json['intro_image'];
    if (json['option_list'] != null) {
      optionList = <CfanTestPaperItemOptionModel>[];
      json['option_list'].forEach((v) {
        optionList!.add(new CfanTestPaperItemOptionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    data['title'] = this.title;
    data['is_multiple_choice'] = this.isMultipleChoice;
    data['intro_image'] = this.introImage;
    if (this.optionList != null) {
      data['option_list'] = this.optionList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CfanTestPaperItemOptionModel {
  int? optionId;
  String? content;
  String? optionChar;
  
  CfanTestPaperItemOptionModel({this.optionId, this.content});

  CfanTestPaperItemOptionModel.fromJson(Map<String, dynamic> json) {
    optionId = json['option_id'];
    content = json['content'];
    optionChar = json['option_char'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option_id'] = this.optionId;
    data['content'] = this.content;
    data['option_char'] = this.optionChar;
    return data;
  }
}
