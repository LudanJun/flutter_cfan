import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:cfan_flutter/base/config.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/widget/camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class DuPicker {
  /// 相册
  static Future<List<AssetEntity>?> assets({
    required BuildContext context,
    List<AssetEntity>? selectedAssets,
    int maxAssets = maxAssets,
    RequestType requestType = RequestType.image, //默认图片
  }) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        selectedAssets: selectedAssets,
        requestType: requestType,
        maxAssets: maxAssets,
      ),
    );
    return result;
  }

  ///拍摄照片
  static Future<AssetEntity?> takePhoto(BuildContext context) async {
    final result = await Navigator.of(context).push<AssetEntity?>(
      MaterialPageRoute(builder: (context) {
        return const CameraPage();
      }),
    );
    return result;
  }

  ///拍摄视频
  static Future<AssetEntity?> takeVideo(BuildContext context) async {
    final filePath = await Navigator.of(context).push<AssetEntity?>(
      MaterialPageRoute(builder: (context) {
        return const CameraPage(
          captureMode: CaptureMode.video,
          maxVideoDuration: Duration(seconds: 30),
        );
      }),
    );
    return filePath;
  }

  //底部弹出视图
  static Future showModalSheet(BuildContext context, {Widget? child}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.amber,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      isScrollControlled: true, //全屏显示
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: child,
        );
        // return Container(
        //   width: double.infinity,
        //   height: 200,
        //   child: Column(
        //     children: [
        //       Text("弹出"),
        //       Text("弹出"),
        //       Text("弹出"),
        //       Text("弹出"),
        //     ],
        //   ),
        // );
      },
    );
  }
}
