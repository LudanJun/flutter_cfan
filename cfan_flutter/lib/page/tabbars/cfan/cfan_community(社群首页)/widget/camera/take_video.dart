import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/widget/camera/countdown.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class TakeVideoPage extends StatefulWidget {
  /// 相机状态
  final CameraState cameraState;

  /// 最大录制时间
  final Duration? maxVideoDuration;
  const TakeVideoPage({
    super.key,
    required this.cameraState,
    this.maxVideoDuration,
  });

  @override
  State<TakeVideoPage> createState() => _TakeVideoPageState();
}

class _TakeVideoPageState extends State<TakeVideoPage> {
  @override
  void initState() {
    super.initState();

    widget.cameraState.captureState$.listen((event) async {
      if (event != null && event.status == MediaCaptureStatus.success) {
        String filePath = event.filePath;
        String fileTitle = filePath.split("/").last;
        File file = File(filePath);

        //1.转换AssetEntity
        final AssetEntity? asset = await PhotoManager.editor.saveVideo(
          file,
          title: fileTitle,
        );

        //2.删除临时文件
        await file.delete();

        // ignore: use_build_context_synchronously
        Navigator.of(context).pop<AssetEntity?>(asset);
      }
    });
  }

  Widget _mainView() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.black54,
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //切换摄像头
            AwesomeCameraSwitchButton(state: widget.cameraState),
            //拍照按钮
            AwesomeCaptureButton(state: widget.cameraState),
            //倒计时
            if (widget.cameraState is VideoRecordingCameraState &&
                widget.maxVideoDuration != null)
              Countdown(
                time: widget.maxVideoDuration!,
                callback: () {
                  (widget.cameraState as VideoRecordingCameraState)
                      .stopRecording();
                },
              )
            else
              const SizedBox(
                width: 32 + 20 * 2,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }
}
