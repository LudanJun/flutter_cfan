import 'package:cfan_flutter/tools/config/config_dev.dart' as config_dev;
import 'package:cfan_flutter/tools/config/config_test.dart' as config_test;
import 'package:cfan_flutter/tools/config/config_prod.dart' as config_prod;

/// 环境配置
class EnvironmentConfig {
  static const String dev = 'dev';
  static const String test = 'test';
  static const String production = 'production';

  // static const String currentEnvironment = production; //生产
  // static String currentEnvironment = test; //测试
  static const String currentEnvironment = dev; //开发

  static String get cjUrl {
    switch (currentEnvironment) {
      case dev:
        return config_dev.Config.cfUrl;
      case test:
        return config_test.Config.cfUrl;
      case production:
        return config_prod.Config.cfUrl;
      default:
        throw Exception('Invalid environment');
    }
  }
}
