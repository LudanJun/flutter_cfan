class CfanVoteRankModel {
  bool? success;
  int? code;
  String? message;
  List<CfanVoteRankItemModel>? data;

  CfanVoteRankModel({this.success, this.code, this.message, this.data});

  CfanVoteRankModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CfanVoteRankItemModel>[];
      json['data'].forEach((v) {
        data!.add(new CfanVoteRankItemModel.fromJson(v));
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

class CfanVoteRankItemModel {
  int? optionId;
  String? content;
  int? voteNum;

  CfanVoteRankItemModel({this.optionId, this.content, this.voteNum});

  CfanVoteRankItemModel.fromJson(Map<String, dynamic> json) {
    optionId = json['option_id'];
    content = json['content'];
    voteNum = json['vote_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option_id'] = this.optionId;
    data['content'] = this.content;
    data['vote_num'] = this.voteNum;
    return data;
  }
}
