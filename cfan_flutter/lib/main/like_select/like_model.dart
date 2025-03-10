import 'package:cfan_flutter/main/like_select/like_item.dart';

class LikeModel {
  List<LikeItem> list = <LikeItem>[];

  //初始化循环创建20个商品

  LikeModel.init() {
    for (var i = 0; i < 10; i++) {
      var product = LikeItem(
        id: i,
        imageUrl:
            "https://attachment4.jmw.com.cn/image/2019/03/01/15514261568182.jpg",
      );
      list.add(product);
    }
  }
}
