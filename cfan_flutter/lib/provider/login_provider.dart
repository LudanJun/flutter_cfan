import 'package:cfan_flutter/page/login/model/login_community_list_model.dart';
import 'package:cfan_flutter/tools/http/https_callback.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/http/api/login_api.dart';
import 'package:cfan_flutter/widget/toast_utils/toast_util.dart';
import 'package:flutter/material.dart';

/// 登录页状态管理
class LoginProvider extends ChangeNotifier {
  LoginApi api = LoginApi();

/*flutter: 登录成功 GoogleSignInAccount:
{
displayName: 科塔科技, 
email: ktkj0604@gmail.com, 
id: 104344564625965711444, 
photoUrl: https://lh3.googleusercontent.com/a/ACg8ocKYU2QVqdIN-3VaS3a9czcutD7oPpePaixePzdX3HAC0bhZZg=s1337, 
serverAuthCode: null
}
*/
/*
 threeLogin(
 String loginMethod, 
 String userID, 
 String email,
 String name,
 String tokenString, 
 String givenName, 
 String familyName, 
 String headimg,
      {Success? success, Failure? failure}) async {
        */
  /////////////////////// request ////////////////////
  ///第三方google登录
  ///loginMethod:登录类型 google;1
  ///id:用户id
  ///email:邮箱
  ///displayName
  Future<bool> threeLogin(
    String loginMethod,
    String id,
    String email,
    String name,
    String photoUrl,
  ) async {
    bool suc = false;
    await api.threeLogin(
      loginMethod,
      id,
      email,
      name,
      "", //tokenString
      "", //givenName
      "", //familyName
      photoUrl, //headimg
      success: (data) {
        KTLog("请求结果 --- $data");

        suc = true;
        showToast("登录成功");
      },
      failure: (error) {
        showToast(error ?? "");
      },
    );
    return suc;
  }

  //退出登录
  Future<bool> logout() async {
    bool suc = false;
    await api.logout(
      success: (data) {
        KTLog("请求结果 --- $data");
        //{"success":true,"code":200,"message":"success","data":[]}
        showToast("退出登录");
        suc = true;
      },
      failure: (error) {
        showToast(error ?? "");
      },
    );
    return suc;
  }

  //上传头像图片
  uplodHeadImage(dynamic image,
      {Success? onSuccess, Failure? onFailure}) async {
    await api.uploadImage(
      image,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///编辑用户信息
  ///nickname 昵称
  ///birth 生日 (格式示例：2010-02-01)
  ///gender 性别
  ///country 国家
  editUserInfo(String nickname, String birth, String gender, String country,
      {Success? onSuccess, Failure? onFailure}) async {
    await api.userEdit(
      nickname,
      birth,
      gender,
      country,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///分类(0全部,1男明星，2女明星，3艺人组合，4节目官方)
  communityList(String categoryId, String page,
      {Success? onSuccess, Failure? onFailure}) async {
    await api.communityList(
      categoryId,
      page,
      success: onSuccess,
      failure: onFailure,
    );
  }

  ///加入社群
  ///ids:传入id数组字符串
  addCommunity(String ids, {Success? onSuccess, Failure? onFailure}) async {
    await api.addCommunity(ids, success: onSuccess, failure: onFailure);
  }
}
