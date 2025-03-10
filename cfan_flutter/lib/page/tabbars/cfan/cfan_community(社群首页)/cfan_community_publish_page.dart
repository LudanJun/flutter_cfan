import 'dart:convert';
import 'dart:io';

import 'package:cfan_flutter/base/config.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/widget/camera/picker.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/widget/wb_fu_wen_ben/my_extended_text_selection_controls.dart';
import 'package:cfan_flutter/page/tabbars/cfan/cfan_community(%E7%A4%BE%E7%BE%A4%E9%A6%96%E9%A1%B5)/widget/wb_fu_wen_ben/my_special_text_span_builder.dart';
import 'package:cfan_flutter/provider/cfan_community_home_provider.dart';
import 'package:cfan_flutter/tools/asset_utils/asset_utils.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/widget/toast_utils/toast_util.dart';
import 'package:dio/dio.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

//发布帖子
class CfanCommunityPublishPage extends StatefulWidget {
  ///传入 社群id
  final int communityId;
  const CfanCommunityPublishPage({super.key, required this.communityId});

  @override
  State<CfanCommunityPublishPage> createState() =>
      _CfanCommunityPublishPageState();
}

class _CfanCommunityPublishPageState extends State<CfanCommunityPublishPage> {
  final CfanCommunityHomeProvider _cfanCommunityHomeProvider =
      CfanCommunityHomeProvider();
  //添加支持@ # 富文本
  final MySpecialTextSpanBuilder _mySpecialTextSpanBuilder =
      MySpecialTextSpanBuilder();

  FocusNode focusNode = FocusNode();

  //记录上传次数
  int uploadCount = 0;

  //已选中图片列表
  List<AssetEntity> _selectAssets = [];

  //是否开始拖拽
  bool isDragNow = false;

  //是否将要删除
  bool isWillRemove = false;

  //是否将要排序
  bool isWillOrder = false;

  //被拖拽到的 target id
  String targetAssetId = "";

  final MyTextSelectionControls _myExtendedMaterialTextSelectionControls =
      MyTextSelectionControls();
  TextEditingController editController = TextEditingController();
  // ..text =
  //     '[33]Extended text field help you to build rich text quickly. any special text you will have with extended text. this is demo to show how to create custom toolbar and handles.'
  //         '\n\nIt\'s my pleasure to invite you to join \$FlutterCandies\$ if you want to improve flutter .[36]'
  //         '\n\nif you meet any problem, please let me konw @zmtzawqlp .[44]';

  @override
  void initState() {
    super.initState();
  }

  ///发布帖子
  void releasePostData(imgIdArr) {
    _cfanCommunityHomeProvider.userPostsRelease(
      widget.communityId,
      editController.text,
      imgIdArr,
      onSuccess: (data) {
        if (data['code'] == 200) {
          showToast("发布成功!");
        }
      },
      onFailure: (error) {},
    );
  }

  Future<List> _uploadImages(List<AssetEntity> entitys) async {
    List<int> imageIds = [];
    List<Future> futures = [];
    for (AssetEntity entity in entitys) {
      //originFile:原图巨大
      //file:压缩图
      String? imagePath = await getImagePath(entity.originFile);
      KTLog('图片路径是: $imagePath');

      var formData = FormData.fromMap(
        {
          'image': await MultipartFile.fromFile(imagePath!,
              filename: '${DateTime.now()}.jpg'),
        },
      );
      futures.add(
        _cfanCommunityHomeProvider.userPostsUploadPostsImage(
          formData,
          onSuccess: (data) {
            if (data['code'] == 200) {
              KTLog("手上少时诵诗书");
              var pictureId = data['data']['picture_id'];
              imageIds.add(pictureId);
            }
          },
          onFailure: (error) {},
        ),
      );
    }
    await Future.wait(futures);
    KTLog("imageIds $imageIds");
    return imageIds;
  }

/*
  ///上传帖子图片
  void uploadPostsImage(AssetEntity entity) async {
    //originFile:原图巨大
    //file:压缩图
    String? imagePath = await getImagePath(entity.originFile);
    if (imagePath != null) {
      KTLog('图片路径是: $imagePath');
      var formData = FormData.fromMap(
        {
          // 'image': await MultipartFile.fromFile(imagePath,
          //     filename: '${DateTime.now()}.jpg'),
          'image': await MultipartFile.fromFile(imagePath,
              filename: '${DateTime.now()}.jpg'),
        },
      );
      KTLog(formData);
      _cfanCommunityHomeProvider.userPostsUploadPostsImage(
        formData,
        onSuccess: (data) {
          setState(() {
            uploadCount++;
            KTLog("uploadCount - $uploadCount");
          });
        },
        onFailure: (error) {},
      );
    } else {
      KTLog('获取图片路径失败或图片不存在');
    }
  }
*/
  // 使用 originFile 方法获取 File 对象，并获取它的路径
  Future<String?> getImagePath(originFile) async {
    File? file = await originFile; // 等待异步操作完成
    if (file != null) {
      return file.path; // 返回文件路径
    } else {
      return null; // 如果 File 对象为 null，则返回 null
    }
  }

  // 使用 getImagePath 方法
  void someFunction(originFile) async {
    String? imagePath = await getImagePath(originFile);
    if (imagePath != null) {
      KTLog('图片路径是: $imagePath');
    } else {
      KTLog('获取图片路径失败或图片不存在');
    }
  }

  Future<MultipartFile> multipartFileFromAssetEntity(AssetEntity entity) async {
    MultipartFile mf;
    // Using the file path.
    final file = await entity.file;
    if (file == null) {
      throw StateError('Unable to obtain file of the entity ${entity.id}.');
    }
    mf = await MultipartFile.fromFile(file.path);
    // Using the bytes.
    final bytes = await entity.originBytes;
    if (bytes == null) {
      throw StateError('Unable to obtain bytes of the entity ${entity.id}.');
    }
    mf = MultipartFile.fromBytes(bytes);
    KTLog("mf --- $mf");
    return mf;
  }

  // Future<String> getImagePath(AssetEntity assetEntity) async {

  //   // ignore: unrelated_type_equality_checks
  //   if (PhotoManager.requestPermissionExtend() == PermissionState.restricted) {

  //     String? path = await assetEntity.file.path;
  //     return path;
  //   } else {
  //     throw Exception('Permission denied');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("发帖"),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: ScreenAdapter.width(10),
            ),
            child: ElevatedButton(
              onPressed: () async {
                KTLog("发微博");
                if (editController.text.isEmpty) {
                  showToast("请输入内容");
                  return;
                }
                //上传多张图片
                List imgIdArr = await _uploadImages(_selectAssets);
                KTLog(imgIdArr);
                //数组转json字符串
                String ids = jsonEncode(imgIdArr);
                //发帖请求
                releasePostData(ids);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.amber),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ScreenAdapter.width(10),
                    ),
                  ),
                ),
              ),
              child: Text(
                "发送",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenAdapter.fontSize(14),
                ),
              ),
            ),
          ),
        ],
      ),
      //如果屏幕上方显示一个屏幕键盘 脚手架，机身可以调整大小以避免与键盘重叠，这 防止键盘遮挡主体内部的小部件。
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          //添加内容
          _contentWidget(),
          //添加底部工具条
          // _buildBottom(),
        ],
      ),
    );
  }

  //发帖内容
  Widget _contentWidget() {
    return Expanded(
        child: ListView(
      children: [
        //1.添加文本框
        Container(
          color: Colors.amber,
          padding:
              EdgeInsets.only(top: 10.0, left: 10.0, right: 10, bottom: 20),
          // constraints: BoxConstraints(minHeight: 50.0),
          child: ExtendedTextField(
            // selectionControls: _myExtendedMaterialTextSelectionControls,

            specialTextSpanBuilder: _mySpecialTextSpanBuilder, //使用@和#需要打开
            // extendedContextMenuBuilder:
            //     MyTextSelectionControls.defaultContextMenuBuilder,

            controller: editController,
            maxLines: null,
            // focusNode: focusNode,
            // style: TextStyle(color: Colors.black, fontSize: 15),
            strutStyle: const StrutStyle(),
            onTap: () {
              KTLog("sssss");
            },
            //输出的文本改变
            onChanged: (value) {
              KTLog(value);
            },

            decoration: const InputDecoration.collapsed(
              hintText: "分享新鲜事",
              hintStyle: TextStyle(color: Color(0xff919191), fontSize: 15),
            ),
          ),
        ),
        //2.添加图片
        _buildPhotoList(),
      ],
    ));
  }

  //添加图片九宫格布局
  Widget _buildPhotoList() {
    return Padding(
      padding: EdgeInsets.all(spacing),
      child: LayoutBuilder(builder: (context, constraints) {
        //设置每行显示3个
        final double width =
            (constraints.maxWidth - spacing * 2 - imagePadding * 2 * 3) / 3;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            //图片
            //第一种循环写法
            for (final asset in _selectAssets)
              _buildPhotoItem(
                asset,
                width,
              ),
            //第二种循环写法
            // for (var i = 0; i < _selectAssets.length; i++)
            //   _buildPhotoItem(
            //     _selectAssets[i],
            //     width,
            //     i,
            //   ),
            //加入按钮
            if (_selectAssets.length < maxAssets) _buildAddBtn(context, width),
          ],
        );
      }),
    );
  }

  //图片项
  Widget _buildPhotoItem(
    asset,
    double width,
    // int index,
  ) {
    //拖拽控件
    return Draggable<AssetEntity>(
      //此可拖动对象将删除的数据。x
      data: asset,
      //当可拖动对象开始被拖动时调用。
      onDragStarted: () {
        setState(() {
          isDragNow = true;
        });
      },
      //当可拖动对象被放下时调用。
      onDragEnd: (details) {
        setState(() {
          isDragNow = false;
          isWillOrder = false;
        });
      },
      //当可拖动对象被放置并被 [DragTarget] 接受时调用。
      onDragCompleted: () {},
      //当可拖动对象未被 [DragTarget] 接受而被放置时调用。
      onDraggableCanceled: (velocity, offset) {
        setState(() {
          isDragNow = false;
          isWillOrder = false;
        });
      },
      //feedback:进行拖动时在指针下方显示的小部件。
      feedback: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
        ),
        //显示跟手飘动的图片
        child: AssetEntityImage(
          asset,
          width: width,
          height: width,
          fit: BoxFit.cover,
          isOriginal: false,
        ),
      ),
      //当进行一次或多次拖动时要显示的小部件而不是 [child]。
      childWhenDragging: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
        ),
        //默认的图片 为半透明
        child: AssetEntityImage(
          asset,
          width: width,
          height: width,
          fit: BoxFit.cover,
          isOriginal: false,
          //动画区间的一个透明度
          opacity: const AlwaysStoppedAnimation(0.3),
        ),
      ),

      child: DragTarget<AssetEntity>(
        builder: (context, candidateData, rejectedData) {
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   //直接调用控制器push
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return GalleryWidget(
              //         //indexOf:找到数组相应的值 返回对应的index
              //         initialIndex: _selectAssets.indexOf(asset),
              //         items: _selectAssets,
              //       );
              //     },
              //   ),
              // );
            },
            child: Container(
              //设置裁切属性
              clipBehavior: Clip.antiAlias,
              padding: (isWillOrder && targetAssetId == asset.id)
                  ? EdgeInsets.zero
                  : EdgeInsets.all(imagePadding),
              decoration: BoxDecoration(
                //设置完圆角度数后,需要设置裁切属性
                borderRadius: BorderRadius.circular(10),
                border: (isWillOrder && targetAssetId == asset.id)
                    ? Border.all(
                        color: accentColor,
                        width: imagePadding,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  AssetEntityImage(
                    asset,
                    width: width,
                    height: width,
                    //设置了宽高显示还是不整齐 需要设置fit属性根据宽高裁切
                    fit: BoxFit.cover,
                    //是否显示原图
                    isOriginal: false,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.grey[200],
                        ),
                      ),
                      onPressed: () {
                        print("点击了");
                        setState(() {
                          //如果点击的在数组有就移除
                          _selectAssets.removeWhere((item) {
                            return item == asset;
                          });
                          print(_selectAssets.length);
                        });
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        size: ScreenAdapter.width(25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        //将要拖拽到
        onWillAcceptWithDetails: (data) {
          setState(() {
            isWillOrder = true;
            targetAssetId = asset.id;
          });
          return true;
        },
        //接收
        onAcceptWithDetails: (details) {
          //从队列中删除拖拽对象
          final int index = _selectAssets.indexOf(details.data);
          _selectAssets.removeAt(index);
          //将拖拽对象插入到目标对象之前
          final int targetIndex = _selectAssets.indexOf(asset);
          _selectAssets.insert(targetIndex, details.data);
          setState(() {
            isWillOrder = false;
            targetAssetId = '';
          });
        },
        onLeave: (data) {
          setState(() {
            isWillOrder = false;
            targetAssetId = "";
          });
        },
      ),
    );
  }

  //添加按钮
  Widget _buildAddBtn(BuildContext context, double width) {
    return InkWell(
      onTap: () async {
        KTLog("+++");
        //  相册
        var result = await DuPicker.assets(context: context);
        if (result == null) {
          return;
        }
        setState(() {
          // postType = PostType.image;
          //把拍摄图片加入到当前列表
          // _selectAssets = result;
          _selectAssets.addAll(result);
          KTLog("选择的图片数量:${_selectAssets.length}");
          // 资产的相对路径抽象。
          // 安卓10及以上：MediaStore.MediaColumns.RELATIVE_PATH.
          // Android 9及以下： 的父路径MediaStore.MediaColumns.DATA.
          KTLog(_selectAssets[0].file);

          // if (Platform.isIOS) {}
        });

        // ///拍摄
        // var result = await DuPicker.takePhoto(context);
        // if (result == null) {
        //   return;
        // }
        // setState(() {
        // postType = PostType.image;
        //   //把拍摄图片加入到当前列表
        //   _selectAssets.add(result);
        // });
      },
      child: Container(
        color: Colors.black12,
        width: width,
        height: width,
        child: const Icon(
          Icons.add,
          size: 48,
          color: Colors.black38,
        ),
      ),
    );
  }

  //添加底部工具栏
  Widget _buildBottom() {
    return Column(
      children: [
        Container(
          color: Colors.grey[350],
          padding: EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  child: Image.asset(
                    AssetUtils.getAssetImage("icon_image"),
                    width: ScreenAdapter.width(25),
                    height: ScreenAdapter.width(25),
                  ),
                  onTap: () {
                    KTLog("选择图片");
                  },
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Image.asset(
                    AssetUtils.getAssetImage("icon_mention"),
                    width: ScreenAdapter.width(25),
                    height: ScreenAdapter.width(25),
                  ),
                  onTap: () {
                    KTLog("选择图片");
                  },
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Image.asset(
                    AssetUtils.getAssetImage("icon_topic"),
                    width: ScreenAdapter.width(25),
                    height: ScreenAdapter.width(25),
                  ),
                  onTap: () {
                    KTLog("选择图片");
                  },
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Image.asset(
                    AssetUtils.getAssetImage("icon_emotion"),
                    width: ScreenAdapter.width(25),
                    height: ScreenAdapter.width(25),
                  ),
                  onTap: () {
                    KTLog("选择图片");
                  },
                ),
              ),
            ],
          ),
        ),
        // Visibility(
        //   visible: mBottomLayoutShow,
        //   child: Container(
        //     key: globalKey,
        //     child: Visibility(
        //       visible: mEmojiLayoutShow,
        //       child: EmojiWidget(onEmojiClockBack: (value) {
        //         if (value == 0) {
        //           _mEtController.clear();
        //         } else {
        //           _mEtController.text =
        //               _mEtController.text + "[/" + value.toString() + "]";
        //         }
        //       }),
        //     ),
        //     height: _softKeyHeight,
        //   ),
        // ),
      ],
    );
  }
}
