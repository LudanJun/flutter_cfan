import 'dart:convert';

import 'package:cfan_flutter/base/kt_login_info.dart';
import 'package:cfan_flutter/tools/http/header_interceptor.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/config/config.dart';
import 'package:cfan_flutter/tools/http/https_callback.dart';
import 'package:cfan_flutter/tools/http/https_path.dart';
import 'package:cfan_flutter/tools/http/response_type.dart';
import 'package:cfan_flutter/tools/storage/persistent_storage.dart';
import 'package:dio/dio.dart';

class DioManager {
  static DioManager instance = DioManager._internal();
  Dio? _dio;

  // final Map<String, dynamic> _headers = {
  //   /*"Content-Type": "application/x-www-form-urlencoded"*/
  // };
  // 单例 私有化构造初始化dio
  DioManager._internal() {
    if (_dio == null) {
      BaseOptions options = BaseOptions(
          baseUrl: EnvironmentConfig.cjUrl,
          // contentType: Headers.multipartFormDataContentType,
          // responseType: ResponseType.json,
          // receiveDataWhenStatusError: false,
          // headers: _headers,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30));
      _dio = Dio(options);
    }
    //拦截请求头
    _dio?.interceptors.add(HeaderInterceptor());

    // _dio?.interceptors.add(
    //   HttpLogInterceptor(
    //     requestHeader: true,
    //     dataEncode: true,
    //     logPrint: (log) => debugPrint(log),
    //   ),
    // );

    // setProxy("192.168.110.43", "8888");

    /// 正式环境拦截日志打印
    if (!const bool.fromEnvironment("dart.vm.product")) {
      _dio?.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  ///更新Header 登录后把token存放到header里使用
  // updateHeader(Map<String, dynamic> header) {
  //   _dio?.options.headers = header;
  // }

  /// 请求，返回的渲染数据 T
  /// method：请求方法，Method.GET等
  /// path：请求地址
  /// params：请求参数
  /// success：请求成功回调
  /// error：请求失败回调
  Future<dynamic> request(
    String method,
    String path, {
    String? baseUrl,
    Map<String, dynamic>? params,
    Map<String, dynamic>? header,
    data,
    ProgressCallback? onSendProgress, //上传数据进度
    ProgressCallback? onReceiveProgress, //接受数据进度
    QbResponseType? responseType,
    Success? onSuccess,
    Failure? onFailure,
  }) async {
    // KTLog("method - $method");

    // KTLog("path - $path");

    // KTLog("baseUrl - $baseUrl");
    // KTLog("params - $params");
    // KTLog("header - $header");
    // KTLog("data - $data");

    try {
      // KTLog("755555555");
      Response? response = await _dio?.request(
        path,
        queryParameters: params,
        data: data,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: Options(method: method),
      );

      if (response != null) {
        // KTLog("path ---- ${path}\n-response ------ $response");

        var _data;
        if (response.data.runtimeType == String) {
          _data = jsonDecode(response.data);
        } else {
          _data = response.data;
        }
        //可以在这里把data转成模型 返回出去
        
        if (_data != null) {
          //登录获取token保存  其他接口都用token请求数据
          if (path == HttpsPath.loginUrl) {
            // Map<String, dynamic> map = {};
            // map['Authorization'] = _data['token'];
            // DioManager.instance.updateHeader(map);
            KTLog("登录存token ${_data['data']['token']}");
            PersistentStorage()
                .setStorage(LoginInfoStorage.token, _data['data']['token']);
          }

          onSuccess?.call(_data);
          return {'type': 'success', 'content': _data};
        } else {
          onFailure?.call(_data);
          return {'type': 'failure', 'content': _data};
        }
      }
    } on DioException catch (e) {
      String errorData = "";
      KTLog("response========error:${e.type}=======path===${path}");
      switch (e.type) {
        case DioExceptionType.cancel:
          errorData = "请求取消";
          break;
        case DioExceptionType.connectionTimeout:
          errorData = "连接超时";
          break;
        case DioExceptionType.sendTimeout:
          errorData = "请求超时";
          break;
        case DioExceptionType.receiveTimeout:
          errorData = "响应超时";
          break;
        // errorData = e.response?.data;
        // break;
        case DioExceptionType.unknown:
          errorData = "请求异常，检查网络是否正常";
          break;
        case DioExceptionType.badResponse:
          errorData = "请求失败，请稍后重试";
          break;
        case DioExceptionType.connectionError:
          errorData = "网络异常，请检查网络";
          break;
        default:
          errorData = "请求失败，请稍后重试";
          break;
      }

      onFailure?.call(errorData);
      // errorData['type'] = 'failure';
      return errorData;
    }
  }
}
