import 'package:cfan_flutter/tools/http/https_callback.dart';
import 'package:cfan_flutter/tools/http/httpsUtils.dart';
import 'package:cfan_flutter/tools/http/https_path.dart';

class LoginApi {
  //第三方登录
  threeLogin(String loginMethod, String userID, String email, String name,
      String tokenString, String givenName, String familyName, String headimg,
      {Success? success, Failure? failure}) async {
    var param = {
      "login_method": loginMethod,
      "userID": userID,
      "email": email,
      "name": name,
      "tokenString": tokenString,
      "givenName": givenName,
      "familyName": familyName,
      "headimg": headimg,
    };
    await HttpsUtils.instance.post(HttpsPath.loginUrl,
        body: param, onSuccess: success, onFailure: failure);
  }

  //退出登录
  logout({Success? success, Failure? failure}) async {
    var param = {};
    await HttpsUtils.instance.post(HttpsPath.logout,
        body: param, onSuccess: success, onFailure: failure);
  }

  //上传用户头像
  uploadImage(dynamic image, {Success? success, Failure? failure}) async {
    // var param = {"image": image};
    //上传头像这个直接传入字典
    await HttpsUtils.instance.post(HttpsPath.uploadImage,
        body: image, onSuccess: success, onFailure: failure);
  }

  ///编辑用户信息
  ///nickname 昵称
  ///birth 生日 (格式示例：2010-02-01)
  ///gender 性别
  ///country 国家
  userEdit(String nickname, String birth, String gender, String country,
      {Success? success, Failure? failure}) async {
    var param = {
      "nickname": nickname,
      "birth": birth,
      "gender": gender,
      "country": country,
    };
    //上传头像这个直接传入字典
    await HttpsUtils.instance.post(HttpsPath.useredit,
        body: param, onSuccess: success, onFailure: failure);
  }

  ///分类(0全部,1男明星，2女明星，3艺人组合，4节目官方)
  communityList(String categoryId, String page,
      {Success? success, Failure? failure}) async {
    var param = {
      "category_id": categoryId,
      "page": page,
    };
    await HttpsUtils.instance.get(HttpsPath.communityList,
        body: param, onSuccess: success, onFailure: failure);
  }

  //加入社群
  addCommunity(String ids, {Success? success, Failure? failure}) async {
    var param = {
      "ids": ids,
    };
    await HttpsUtils.instance.post(HttpsPath.addCommunity,
        body: param, onSuccess: success, onFailure: failure);
  }
}

// class LoginApi {
  // ///token登录
  // tokenLogin({Success? success, Failure? failure}) async {
  //   var param = {};
  //   await HttpsUtils.instance.post(HttpsPath.userLoginBytokenUrl,
  //       body: param, onSuccess: success, onFailure: failure);
  // }

  // //忘记密码
  // resetPwd(String phone, String smsCode, String newPwd,
  //     {Success? success, Failure? failure}) async {
  //   String encodePwd = "";
  //   if (newPwd.isNotEmpty) {
  //     encodePwd = await EncryptUtils().encodeString(newPwd);
  //   }
  //   var param = {
  //     "phone": phone,
  //     "smsCode": smsCode,
  //     "newPwd": encodePwd,
  //   };
  //   await HttpUtils.instance.post(HttpPath.resetPwdUrl,
  //       body: param, onSuccess: success, onFailure: failure);
  // }

  // ///注册
  // sysUserRegister(String account, String chkCode, String pwd,
  //     {Success? success, Failure? failure}) async {
  //   String encodePwd = "";
  //   if (pwd.isNotEmpty) {
  //     encodePwd = await EncryptUtils().encodeString(pwd);
  //   }
  //   var param = {
  //     "account": account,
  //     "chkCode": chkCode,
  //     "pwd": encodePwd,
  //   };
  //   await HttpUtils.instance.post(HttpPath.sysUserRegister,
  //       body: param, onSuccess: success, onFailure: failure);
  // }
// }
