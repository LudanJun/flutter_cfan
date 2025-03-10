import 'dart:io';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:cfan_flutter/tools/compress.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// 拍照页
class TakePhotoPage extends StatefulWidget {
  const TakePhotoPage({
    super.key,
    required this.cameraState,
  });

  final CameraState cameraState;

  @override
  State<TakePhotoPage> createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  @override
  void initState() {
    super.initState();
    widget.cameraState.captureState$.listen((event) async {
      if (event != null && event.status == MediaCaptureStatus.success) {
        String filePath = event.filePath;
        String fileTitle = filePath.split("/").last;
        File file = File(filePath);

        //1.压缩图片
        var newFile = await DuCompress.image(file);
        if (newFile == null) {
          return;
        }

        //2.转换AssetEntity
        final AssetEntity? asset = await PhotoManager.editor.saveImage(
          file.readAsBytesSync(),
          title: fileTitle,
          filename: '',
        );

        // //3.转完 删除临时文件
        // await file.delete();

        //3 删除临时文件
        await File(filePath).delete();
        // 获取文件路径
        String xfilePath = newFile.path;
        File xFile = File(xfilePath);
        await xFile.delete();

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
            // 切换摄像头
            AwesomeCameraSwitchButton(state: widget.cameraState),
            // 拍摄按钮
            AwesomeCaptureButton(state: widget.cameraState),
            // 右侧空间
            const SizedBox(
              width: 32 + 20 * 2,
            )
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
