class CfanCommunityExpinfoRuleModel {
  bool? success;
  int? code;
  String? message;
  Data? data;

  CfanCommunityExpinfoRuleModel({this.success, this.code, this.message, this.data});

  CfanCommunityExpinfoRuleModel.fromJson(Map<String, dynamic> json) {
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
  int? levelMax;
  List<CfanCommunityExpinfoRuleLeveModel>? levelList;
  List<CfanCommunityExpinfoRuleDailyModel>? expRuleList;

  Data({this.levelMax, this.levelList, this.expRuleList});

  Data.fromJson(Map<String, dynamic> json) {
    levelMax = json['level_max'];
    if (json['level_list'] != null) {
      levelList = <CfanCommunityExpinfoRuleLeveModel>[];
      json['level_list'].forEach((v) {
        levelList!.add(new CfanCommunityExpinfoRuleLeveModel.fromJson(v));
      });
    }
    if (json['exp_rule_list'] != null) {
      expRuleList = <CfanCommunityExpinfoRuleDailyModel>[];
      json['exp_rule_list'].forEach((v) {
        expRuleList!.add(new CfanCommunityExpinfoRuleDailyModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level_max'] = this.levelMax;
    if (this.levelList != null) {
      data['level_list'] = this.levelList!.map((v) => v.toJson()).toList();
    }
    if (this.expRuleList != null) {
      data['exp_rule_list'] = this.expRuleList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CfanCommunityExpinfoRuleLeveModel {
  int? level;
  int? exp;

  CfanCommunityExpinfoRuleLeveModel({this.level, this.exp});

  CfanCommunityExpinfoRuleLeveModel.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    exp = json['exp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    data['exp'] = this.exp;
    return data;
  }
}

class CfanCommunityExpinfoRuleDailyModel {
  String? name;
  int? expValue;
  int? dailyMaxExp;

  CfanCommunityExpinfoRuleDailyModel({this.name, this.expValue, this.dailyMaxExp});

  CfanCommunityExpinfoRuleDailyModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    expValue = json['exp_value'];
    dailyMaxExp = json['daily_max_exp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['exp_value'] = this.expValue;
    data['daily_max_exp'] = this.dailyMaxExp;
    return data;
  }
}
