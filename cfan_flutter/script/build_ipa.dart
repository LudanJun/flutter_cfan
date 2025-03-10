import 'dart:io';
import 'package:cfan_flutter/tools/config/config.dart';
import 'package:yaml/yaml.dart' as yaml;
import 'package:intl/intl.dart';

import 'pgy_tool.dart';

void main() async {
  const originIpaName = 'Runner';
  //是否上传蒲公英
  bool uploadPGY = false;
  //设置app环境
  // EnvironmentConfig environmentConfig =
  //     EnvironmentConfig(EnvironmentConfig.dev);
  // stdout.write(
  //     '设置环境变量: ${EnvironmentConfig.currentEnvironment}-----$environmentConfig\n');
  stdout.write('设置环境变量: ${EnvironmentConfig.currentEnvironment}\n');
  // 获取项目根目录
  final _projectPath = await Process.run(
    'pwd',
    [],
  );
  final projectPath = (_projectPath.stdout as String).replaceAll(
    '\n',
    '',
  );
  // 控制台打印项目目录
  stdout.write('项目目录：$projectPath 开始编译\n');

  // 编译目录
  final buildPath = '$projectPath/build/ios';

  // 切换到项目目录
  Directory.current = projectPath;

  // 删除之前的构建文件
  if (Directory(buildPath).existsSync()) {
    Directory(buildPath).deleteSync(
      recursive: true,
    );
  }

  final process = await Process.start(
    'flutter',
    [
      'build',
      'ipa',
      '--target=$projectPath/lib/main.dart',
      '--verbose',
    ],
    workingDirectory: projectPath,
    mode: ProcessStartMode.inheritStdio,
  );

  final buildResult = await process.exitCode;
  if (buildResult != 0) {
    stdout.write('ipa 编译失败，请查看日志');
    return;
  }

  process.kill();
  stdout.write('ipa 编译成功！\n');

  //开始重命名
  final file = File('$projectPath/pubspec.yaml');
  final fileContent = file.readAsStringSync();
  final yamlMap = yaml.loadYaml(fileContent) as yaml.YamlMap;

  //获取当前版本号
  final version = (yamlMap['version'].toString()).replaceAll(
    '+',
    '_',
  );
  final appName = yamlMap['name'].toString();

  // ipa 的输出目录
  final ipaDirectory = '$projectPath/build/ios/ipa/';
  const buildAppName = '$originIpaName.ipa';
  final timeStr = DateFormat('yyyyMMddHHmm').format(
    DateTime.now(),
  );

  final resultNameList = [
    appName,
    EnvironmentConfig.currentEnvironment,
    version,
    timeStr,
  ].where((element) => element.isNotEmpty).toList();

  final resultAppName = '${resultNameList.join('_')}.ipa';
  final appPath = ipaDirectory + resultAppName;

  //重命名ipa文件
  final ipaFile = File(ipaDirectory + buildAppName);
  await ipaFile.rename(appPath);
  stdout.write('ipa 打包成功 >>>>> $appPath \n');

  // ignore: dead_code
  if (uploadPGY) {
    // 上传蒲公英
    final pgyPublisher = PGYTool(
      // b29cd1cafc37999252f60633b3cfe08c
      apiKey: 'e6a7220ca9983b1de96318e69dc9eb13',
      buildType: 'ios',
    );
    pgyPublisher.publish(appPath);
    // ignore: dead_code
  } else {
    // 直接打开文件
    await Process.run(
      'open',
      [ipaDirectory],
    );
  }
}
