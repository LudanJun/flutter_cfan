import 'dart:io';
import 'package:cfan_flutter/tools/config/config.dart';
import 'package:yaml/yaml.dart' as yaml;
import 'package:intl/intl.dart';

import 'pgy_tool.dart';

void main(List<String> args) async {
  //是否使用 debug 模式
  bool isDebug = false;
  //是否上传蒲公英
  bool uploadPGY = true;

  //设置app环境
  // EnvironmentConfig environmentConfig =
  //     EnvironmentConfig(EnvironmentConfig.test);
  // stdout.write(
  //     '设置环境变量: ${EnvironmentConfig.currentEnvironment}-----$environmentConfig\n');
  stdout.write('设置环境变量: ${EnvironmentConfig.currentEnvironment}\n');

  //获取项目目录
  final _projectPath = await Process.run(
    'pwd',
    [],
  );

  final projectPath = (_projectPath.stdout as String).replaceAll(
    '\n',
    '',
  );

  //控制台打印项目目录
  stdout.write('项目目录: $projectPath 开始编译\n');

  final process = await Process.start(
    'flutter',
    [
      'build',
      'apk',
      isDebug == true ? '--debug' : '--verbose',
    ],
    workingDirectory: projectPath,
    mode: ProcessStartMode.inheritStdio,
  );

  final buildResult = await process.exitCode;
  if (buildResult != 0) {
    stdout.write('打包失败，请查看日志');
    return;
  }
  process.kill();

  //开始重命名
  final file = File('$projectPath/pubspec.yaml');
  final fileContent = file.readAsStringSync();
  final yamlMap = yaml.loadYaml(fileContent) as yaml.YamlMap;
  stdout.write('yamlMap: $yamlMap ');
  //获取当前版本号
  final version = (yamlMap['version'].toString()).replaceAll('+', '-');
  stdout.write('version: $version ');
  //获取appname
  final appName = yamlMap['name'].toString();

  //apk 输出目录
  final apkDirectory = '$projectPath/build/app/outputs/flutter-apk/';
  final buildAppName = isDebug == true ? 'app-debug.apk' : 'app-release.apk';
  final timeStr = DateFormat('yyyyMMddHHmm').format(
    DateTime.now(),
  );

  final resultNameList = [
    appName,
    EnvironmentConfig.currentEnvironment,
    isDebug == true ? 'debug' : 'release',
    version,
    timeStr,
  ].where((element) => element.isNotEmpty).toList();

  final resultAppName = '${resultNameList.join('_')}.apk';
  final appPath = apkDirectory + resultAppName;

  //重命名apk文件
  stdout.write('apk path >>>>> $apkDirectory --- $buildAppName \n');
  final apkFile = File(apkDirectory + buildAppName);
  await apkFile.rename(appPath);
  stdout.write('apk 打包成功 >>>>> $appPath \n');

  // ignore: dead_code
  if (uploadPGY) {
    // 上传蒲公英
    final pgyPublisher = PGYTool(
      apiKey: 'e6a7220ca9983b1de96318e69dc9eb13',
      buildType: 'android',
    );
    final uploadSuccess = await pgyPublisher.publish(appPath);
    if (uploadSuccess) {
      File(appPath).delete();
    }
    // ignore: dead_code
  } else {
    // 直接打开文件
    await Process.run(
      'open',
      [apkDirectory],
    );
  }
}
