import 'package:cfan_flutter/tools/asset_utils/asset_utils.dart';
import 'package:cfan_flutter/tools/screen/screenAdapter.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Map<String, dynamic>> tabListData = [
    {
      'id': 1,
      'name': '全部',
      'items': [
        {
          "id": 1,
          "title": 'Tony shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/1.png',
          "checked": false,
        },
        {
          "id": 2,
          "title": 'Candy shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/2.png',
          "checked": false,
        },
        {
          "id": 3,
          "title": 'Jeffy shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/3.png',
          "checked": false,
        },
        {
          "id": 4,
          "title": 'Money shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/4.png',
          "checked": false,
        },
        {
          "id": 5,
          "title": 'Thank shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/5.png',
          "checked": false,
        },
        {
          "id": 6,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 7,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 8,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 9,
          "title": 'Shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
      ],
    },
    {
      'id': 2,
      'name': '男明星',
      'items': [
        {
          "id": 1,
          "title": '撒上的',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/1.png',
          "checked": false,
        },
        {
          "id": 2,
          "title": '去外地',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/2.png',
          "checked": false,
        },
        {
          "id": 3,
          "title": 'Jeffy shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/3.png',
          "checked": false,
        },
        {
          "id": 4,
          "title": 'Money shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/4.png',
          "checked": false,
        },
        {
          "id": 5,
          "title": 'Thank shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/5.png',
          "checked": false,
        },
        {
          "id": 6,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 7,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 8,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 9,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
      ],
    },
    {
      'id': 3,
      'name': '女明星',
      'items': [
        {
          "id": 1,
          "title": '给钱啊',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/1.png',
          "checked": false,
        },
        {
          "id": 2,
          "title": 'Tony shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/2.png',
          "checked": false,
        },
        {
          "id": 3,
          "title": 'Jeffy shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/3.png',
          "checked": false,
        },
        {
          "id": 4,
          "title": 'Money shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/4.png',
          "checked": false,
        },
        {
          "id": 5,
          "title": 'Thank shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/5.png',
          "checked": false,
        },
        {
          "id": 6,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 7,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 8,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 9,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
      ],
    },
    {
      'id': 4,
      'name': '组合',
      'items': [
        {
          "id": 1,
          "title": '擦饿啊去污粉',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/1.png',
          "checked": false,
        },
        {
          "id": 2,
          "title": 'Tony shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/2.png',
          "checked": false,
        },
        {
          "id": 3,
          "title": 'Jeffy shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/3.png',
          "checked": false,
        },
        {
          "id": 4,
          "title": 'Money shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/4.png',
          "checked": false,
        },
        {
          "id": 5,
          "title": 'Thank shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/5.png',
          "checked": false,
        },
        {
          "id": 6,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 7,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 8,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 9,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
      ],
    },
    {
      'id': 5,
      'name': '官方',
      'items': [
        {
          "id": 1,
          "title": '废弃物',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/1.png',
          "checked": false,
        },
        {
          "id": 2,
          "title": 'Tony shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/2.png',
          "checked": false,
        },
        {
          "id": 3,
          "title": 'Jeffy shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/3.png',
          "checked": false,
        },
        {
          "id": 4,
          "title": 'Money shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/4.png',
          "checked": false,
        },
        {
          "id": 5,
          "title": 'Thank shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/5.png',
          "checked": false,
        },
        {
          "id": 6,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 7,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 8,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
        {
          "id": 9,
          "title": 'Bye shop',
          "author": 'Mohamed Chahin',
          "imageUrl": 'https://www.itying.com/images/flutter/6.png',
          "checked": false,
        },
      ],
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: tabListData.map((value) {
          return SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 2, //横轴水平间距
              crossAxisCount: 3, //配置一行有几个
              mainAxisSpacing: 5, //垂直间距
              childAspectRatio: 1 / 2, //宽高比
            ),
            itemCount: value['items'].length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ScreenAdapter.width(10)),
                  border: Border.all(
                    color: Colors.black87,
                  ),
                ),
                child: Column(
                  children: [
                    /*
                    Container(
                      margin: EdgeInsets.only(top: ScreenAdapter.height(5)),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            ScreenAdapter.width(10),
                          ),
                        ),
                        image: DecorationImage(
                            image: NetworkImage(
                              value['items'][index]["imageUrl"],
                            ),
                            fit: BoxFit.cover),
                      ),
                    ),
                    */

                    Container(
                      margin: EdgeInsets.only(
                        top: ScreenAdapter.height(5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ScreenAdapter.width(5),
                        ),
                        child: CachedNetworkImage(
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          imageUrl: value['items'][index]["imageUrl"],
                          placeholder: (context, url) => defaultImage(),
                          errorWidget: (context, url, error) => defaultImage(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      value['items'][index]["title"],
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print("关注第$index个");
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: Text("关注"),
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  defaultImage() {
    return Image.asset(
      AssetUtils.getAssetImage(
        'launch_image',
      ),
      fit: BoxFit.cover,
      width: 90.0,
      height: 58.0,
    );
  }
}
