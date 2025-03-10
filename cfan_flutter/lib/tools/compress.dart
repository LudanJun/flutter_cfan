import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';

///压缩返回类型
class CompressMediaFile {
  ///三斜杠暴露给别人看的  //双斜杠自己看的
  ///缩略图
  final File? thumbnail;
  //媒体文件
  final MediaInfo? video;

  CompressMediaFile({
    required this.thumbnail,
    required this.video,
  });
}

///压缩类
class DuCompress {
  ///压缩图片
  static Future<XFile?> image(
    File file, {
    int minWidth = 1920,
    int minHeight = 1080,
  }) async {
    return await FlutterImageCompress.compressAndGetFile(
      //文件路径
      file.path,
      //目标路径
      '${file.path}_temp.jpg',
      keepExif: true,
      //图片质量
      quality: 80,
      //格式
      format: CompressFormat.jpeg,
      //旋转
      // rotate: 180,
      minWidth: minWidth,
      minHeight: minHeight,
    );
  }

  //压缩视频
  //传入一个视频文件对象
  static Future<CompressMediaFile> video(File file) async {
    ///处理多个异步wait数组类型,都完成再返回
    var result = await Future.wait([
      VideoCompress.compressVideo(
        file.path,
        //压缩的视频质量
        quality: VideoQuality.Res640x480Quality,
        //是否删除源文件  设置为否
        deleteOrigin: false,
        //包含音频
        includeAudio: true,
        //码率
        frameRate: 25,
      ),
      //文件缩略图
      VideoCompress.getFileThumbnail(
        file.path,
        //缩略图质量
        quality: 80,
        //从视频哪个位置开始截图
        position: -1000,
      ),
    ]);
    //返回类型
    return CompressMediaFile(
      //如上缩略图写在后面,所以取数组最后一个
      thumbnail: result.last as File,
      //如上视频压缩第一个配置,所以取数组第一个
      video: result.first as MediaInfo,
    );
  }

  /// 清理缓存
  static Future<bool?> clean() async {
    return await VideoCompress.deleteAllCache();
  }

  /// 取消压缩
  static Future<void> cancel() async {
    await VideoCompress.cancelCompression();
  }
}
