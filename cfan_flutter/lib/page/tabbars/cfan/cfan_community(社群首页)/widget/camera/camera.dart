import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/widget/camera/take_photo.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/widget/camera/take_video.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// 相机界面
class CameraPage extends StatelessWidget {
  const CameraPage({
    super.key,
    this.captureMode = CaptureMode.photo,
    this.maxVideoDuration,
  });

  /// 拍照,拍视频
  final CaptureMode captureMode;

  /// 视频最大时长 妙
  final Duration? maxVideoDuration;

  /// 生成文件路径
  Future<String> _buildFilePath() async {
    final extDir = await getTemporaryDirectory();

    // 扩展名
    final extenName = captureMode == CaptureMode.photo ? 'jpg' : 'mp4';
    return '${extDir.path}/${const Uuid().v4()}.$extenName';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraAwesomeBuilder.custom(
        saveConfig: captureMode == CaptureMode.photo
            ? SaveConfig.photo(pathBuilder: _buildFilePath)
            : SaveConfig.video(pathBuilder: _buildFilePath),
        builder: (cameraState, previewSize, size) {
          return cameraState.when(
            //根据状态切换节目
            //拍照
            onPhotoMode: (state) => TakePhotoPage(
              cameraState: cameraState,
            ),

            //拍视频
            onVideoMode: (state) => TakeVideoPage(
              cameraState: cameraState,
              maxVideoDuration: maxVideoDuration,
            ),

            //拍摄中
            onVideoRecordingMode: (state) => TakeVideoPage(
              cameraState: cameraState,
              maxVideoDuration: maxVideoDuration,
            ),
            //启动摄像头
            onPreparingCamera: (state) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        //生成规则
        imageAnalysisConfig: AnalysisConfig(
          androidOptions: AndroidAnalysisOptions.jpeg(
            width: 500,
          ),
          cupertinoOptions: CupertinoAnalysisOptions.bgra8888(),
        ),
      ),
    );
  }
}
