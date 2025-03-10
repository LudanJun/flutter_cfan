import 'package:cfan_flutter/base/kt_login_info.dart';
import 'package:cfan_flutter/tools/storage/persistent_storage.dart';
import 'package:dio/dio.dart';

//header请求头拦截 添加数据
class HeaderInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);

    //可以添加token  设备信息 等数据
    var token =
        await PersistentStorage().getStorage(LoginInfoStorage.token) ?? "";

    options.headers["Authorization"] = token;
    return handler.next(options);
  }
}
