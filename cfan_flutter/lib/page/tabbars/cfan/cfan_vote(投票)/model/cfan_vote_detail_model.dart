class CfanVoteDetailModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanVoteDetailModel({this.success, this.code, this.message, this.data});

  CfanVoteDetailModel.fromJson(Map<String, dynamic> json) {
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
  int? pollsId;
  String? title;
  String? startTime;
  String? endTime;
  int? everyDayLimitNum; //每天限制投票次数
  int? isMultipleChoice; // 0表示单选，1表示多选
  int? timeStatus; //0表示投票活动未开始，1进行中，2已结束
  int? todayAllowVoteNum; //今天还允许投票的次数
  String? logo;
  List<CfanVoteDetaiCommunityitemModel>? communityList;
  List<CfanVoteDetaiOptionitemModel>? optionList;

  Data(
      {this.pollsId,
      this.title,
      this.startTime,
      this.endTime,
      this.everyDayLimitNum,
      this.isMultipleChoice,
      this.timeStatus,
      this.todayAllowVoteNum,
      this.logo,
      this.communityList,
      this.optionList});

  Data.fromJson(Map<String, dynamic> json) {
    pollsId = json['polls_id'];
    title = json['title'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    everyDayLimitNum = json['every_day_limit_num'];
    isMultipleChoice = json['is_multiple_choice'];
    timeStatus = json['time_status'];
    todayAllowVoteNum = json['today_allow_vote_num'];
    logo = json['logo'];
    if (json['community_list'] != null) {
      communityList = <CfanVoteDetaiCommunityitemModel>[];
      json['community_list'].forEach((v) {
        communityList!.add(new CfanVoteDetaiCommunityitemModel.fromJson(v));
      });
    }
    if (json['option_list'] != null) {
      optionList = <CfanVoteDetaiOptionitemModel>[];
      json['option_list'].forEach((v) {
        optionList!.add(new CfanVoteDetaiOptionitemModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['polls_id'] = this.pollsId;
    data['title'] = this.title;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['every_day_limit_num'] = this.everyDayLimitNum;
    data['is_multiple_choice'] = this.isMultipleChoice;
    data['time_status'] = this.timeStatus;
    data['today_allow_vote_num'] = this.todayAllowVoteNum;
    data['logo'] = this.logo;
    if (this.communityList != null) {
      data['community_list'] =
          this.communityList!.map((v) => v.toJson()).toList();
    }
    if (this.optionList != null) {
      data['option_list'] = this.optionList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CfanVoteDetaiCommunityitemModel {
  int? communitysId;
  String? title;

  CfanVoteDetaiCommunityitemModel({this.communitysId, this.title});

  CfanVoteDetaiCommunityitemModel.fromJson(Map<String, dynamic> json) {
    communitysId = json['communitys_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['communitys_id'] = this.communitysId;
    data['title'] = this.title;
    return data;
  }
}

class CfanVoteDetaiOptionitemModel {
  int? optionId;
  String? content;
  int? voteNum;
  bool isSelected = false;

  CfanVoteDetaiOptionitemModel({this.optionId, this.content, this.voteNum});

  CfanVoteDetaiOptionitemModel.fromJson(Map<String, dynamic> json) {
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
