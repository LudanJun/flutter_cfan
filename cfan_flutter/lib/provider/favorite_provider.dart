import 'package:cfan_flutter/page/login/model/login_community_list_model.dart';
import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:cfan_flutter/page/login/listData.dart';
import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  bool checkAllBox = false;

  //是否全选
  checkAllBoxFunc(bool value) {
    checkAllBox = value;
    notifyListeners();
  }

  List _list = [];
  List get list => _list;

  //添加单个数据
  // add(Map<String, dynamic> map) {
  //   _list.add(map);
  //   KTLog(_list);

  //   //当前数组数量和网络获取的总数量相同就全选
  //   if (_list.length == listData.length) {
  //     checkAllBox = true;
  //   }
  //   notifyListeners();
  // }
  add(int communityId) {
    _list.add(communityId);
    KTLog(_list);

    //当前数组数量和网络获取的总数量相同就全选
    if (_list.length == listData.length) {
      checkAllBox = true;
    }
    notifyListeners();
  }

  //添加所有
  addAll(List<LoginCommunityItemModel> listData) {
    for (var i = 0; i < listData.length; i++) {
      //如果当前数组已经保护要添加的数组就不添加
      if (!_list.contains(listData[i])) {
        _list.add(listData[i].communityId);
      }
    }
    KTLog(_list);
  }

  //移除单个
  // remove(Map<String, dynamic> map) {
  //   _list.remove(map);
  //   KTLog(_list);
  //   //当前数组数量和网络获取的总数量不相同就全选

  //   if (_list.length < listData.length) {
  //     checkAllBox = false;
  //   }
  //   notifyListeners();
  // }
  remove(int communityId) {
    _list.remove(communityId);
    KTLog(_list);
    //当前数组数量和网络获取的总数量不相同就全选

    if (_list.length < listData.length) {
      checkAllBox = false;
    }
    notifyListeners();
  }

  //移除所有
  removeAll(List list) {
    _list.clear();
    KTLog(_list);

    notifyListeners();
  }
}
