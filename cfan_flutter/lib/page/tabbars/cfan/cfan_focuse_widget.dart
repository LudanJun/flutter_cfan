import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfan_flutter/base/kt_color.dart';
import 'package:cfan_flutter/page/tabbars/cfan/model/cfan_home_banner.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:cfan_flutter/widget/image/default_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:url_launcher/url_launcher.dart';

//轮播图
class CfanFocuseWidget extends StatefulWidget {
  ///传入图片数组
  final List<CfanHomeBannerItemModel> imgList;
  const CfanFocuseWidget({
    super.key,
    required this.imgList,
  });

  @override
  State<CfanFocuseWidget> createState() => _CfanFocuseWidgetState();
}

class _CfanFocuseWidgetState extends State<CfanFocuseWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: KTColor.getRandomColor(),
      width: ScreenAdapter.getScreenWidth(),
      height: ScreenAdapter.height(340),
      child: Swiper(
        onTap: (index) async {
          /**
           * flutter: {"success":true,"code":200,"message":"success","data":[
           * {"type":1,"data_id":1,"link_url":"","image":"https://ocfan.tt90.cc/pro/uploadfile/20240612/659407435856883712.jpg"},
           * {"type":2,"data_id":5,"link_url":"","image":"https://ocfan.tt90.cc/pro/uploadfile/20240625/664092960555663360.jpg"}]}
           */
          //type 类型：(1社群,2商品,3投票,4活动,5外链)
          KTLog(
              "点击了第${widget.imgList[index].linkUrl}个(根据索引获得图片数组里的数据根据数据类型判断跳转到要去的地方)");
          //1.社群
          if (widget.imgList[index].type == 1) {}
          //2.商品
          if (widget.imgList[index].type == 2) {}
          //3.投票
          if (widget.imgList[index].type == 3) {}
          //4.活动
          if (widget.imgList[index].type == 4) {}
          //5.外链
          if (widget.imgList[index].type == 5) {
            // launchi
            Uri uri = Uri.parse(widget.imgList[index].linkUrl ?? "");
            try {
              if (Platform.isAndroid) {
                KTLog("Android");
                launchUrl(uri);
              } else {
                //iOS系统 内部外部跳转都没事
                KTLog("iOS");
                if (await canLaunchUrl(uri)) {
                  //打开浏览器
                  launchUrl(uri);
                } else {
                  throw 'Could not launch $uri';
                }
              }
            } catch (error) {
              KTLog(error);
            }
          }
        },
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl: widget.imgList[index].image ?? "",
            fit: BoxFit.fill,
            placeholder: (context, url) => defaultBannerImage(),
            errorWidget: (context, url, error) => defaultBannerImage(),
          );
        },
        itemCount: widget.imgList.length,
        // pagination:
        //     const SwiperPagination(builder: SwiperPagination.dots //可以不设置默认是圆点
        //         ),
        //自定义分页指示器
        pagination: SwiperPagination(
          margin: const EdgeInsets.all(0),
          builder: SwiperCustomPagination(
              builder: (BuildContext context, SwiperPluginConfig config) {
            return ConstrainedBox(
              constraints: BoxConstraints.expand(
                height: ScreenAdapter.height(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: const DotSwiperPaginationBuilder(
                        color: Colors.white,
                        activeColor: Colors.green,
                      ).build(context, config),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        autoplay: true, //自动轮播
        loop: true, //无限轮播
      ),
    );
  }
}
