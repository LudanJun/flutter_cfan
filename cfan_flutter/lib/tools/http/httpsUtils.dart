import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/http/dio_manager.dart';
import 'package:cfan_flutter/tools/http/https_callback.dart';
import 'package:cfan_flutter/tools/http/https_path.dart';
import 'package:cfan_flutter/tools/http/response_type.dart';

class HttpsUtils {
  HttpsUtils.internal();

  static HttpsUtils instance = HttpsUtils.internal();

  /// get 请求
  Future<dynamic> get(String url,
      {Map<String, dynamic>? params,
      dynamic body,
      Success? onSuccess,
      Failure? onFailure,
      QbResponseType? responseType}) async {
    return await DioManager.instance.request("GET", url,
        params: params,
        data: body,
        onSuccess: onSuccess,
        onFailure: onFailure,
        responseType: responseType);
  }

  Future<dynamic> post(String url,
      {String? baseUrl,
      Map<String, dynamic>? params,
      dynamic body,
      Success? onSuccess,
      Failure? onFailure,
      QbResponseType? responseType}) async {

    return await DioManager.instance.request("POST", url,
        baseUrl: baseUrl,
        params: params,
        data: body,
        onSuccess: onSuccess,
        onFailure: onFailure,
        responseType: responseType);
  }

  Future<dynamic> put(String url,
      {Map<String, dynamic>? params,
      dynamic body,
      Success? onSuccess,
      Failure? onFailure,
      QbResponseType? responseType}) async {
    return await DioManager.instance.request("PUT", url,
        params: params,
        data: body,
        onSuccess: onSuccess,
        onFailure: onFailure,
        responseType: responseType);
  }

  Future delete(String url,
      {Map<String, dynamic>? params,
      dynamic body,
      Success? onSuccess,
      Failure? onFailure,
      QbResponseType? responseType}) async {
    await DioManager.instance.request("DELETE", url,
        params: params,
        data: body,
        onSuccess: onSuccess,
        onFailure: onFailure,
        responseType: responseType);
  }
}
