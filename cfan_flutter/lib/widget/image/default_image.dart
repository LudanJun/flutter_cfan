import 'package:cfan_flutter/tools/asset_utils/asset_utils.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:flutter/material.dart';

///默认轮播图
defaultBannerImage() {
  return Image.asset(
    AssetUtils.getAssetImage(
      'launch_image',
    ),
    fit: BoxFit.cover,
    width: ScreenAdapter.getScreenWidth(),
    height: ScreenAdapter.height(340),
  );
}

defaultCommunityDetailImage() {
  return Image.asset(
    AssetUtils.getAssetImage(
      'default_zjl',
    ),
    fit: BoxFit.cover,
    // width: ScreenAdapter.getScreenWidth(),
    // height: ScreenAdapter.height(255),
  );
}

defaultHeadImage() {
  return Image.asset(
    AssetUtils.getAssetImage(
      'default_zjl',
    ),
    fit: BoxFit.cover,
    // width: ScreenAdapter.getScreenWidth(),
    // height: ScreenAdapter.height(255),
  );
}
