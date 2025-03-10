import 'package:cfan_flutter/tools/log/log_extern.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

/*
class Useragreement extends StatelessWidget {
  //回调勾选状态
  final void Function(bool?)? onChanged;
  const Useragreement({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    bool isSelect = false;

    return Container(
      margin: EdgeInsets.only(top: Screenadapter.height(5)),
      //协议比较多可能会换行所以用wrap组件
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Checkbox(
              activeColor: Colors.white,
              checkColor: Colors.red,
              value: isSelect,
              onChanged: (value) {
                isSelect = !value!;
              }),
          const Text(
            "已经阅读并同意",
            style: TextStyle(color: Colors.grey),
          ),
          const Text(
            "用户隐私协议",
            style: TextStyle(color: Colors.red),
          ),
          const Text(
            "账号隐私协议",
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
*/

class Useragreement extends StatefulWidget {
  //回调勾选状态
  final void Function(bool?)? onChanged;
  const Useragreement({super.key, this.onChanged});

  @override
  State<Useragreement> createState() => _UseragreementState();
}

class _UseragreementState extends State<Useragreement> {
  bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // margin: EdgeInsets.only(
        // top: Screenadapter.height(50), left: Screenadapter.width(15)),
        //协议比较多可能会换行所以用wrap组件
        child: Wrap(
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Checkbox(
            //     activeColor: Colors.white,
            //     checkColor: Colors.red,
            //     value: isSelect,
            //     onChanged: (value) {
            //       setState(() {
            //         print(value);
            //         isSelect = value!;
            //       });
            //     }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GFCheckbox(
                    size: 20,
                    activeBgColor: GFColors.DANGER,
                    type: GFCheckboxType.circle,
                    onChanged: (value) {
                      KTLog(value);
                      setState(() {
                        isSelect = value;
                      });
                    },
                    value: isSelect),
                SizedBox(
                  width: 5,
                ),
                const Text(
                  "已经阅读并同意",
                  style: TextStyle(color: Colors.grey),
                ),
                InkWell(
                  onTap: () {
                    KTLog("用户隐私");
                  },
                  child: const Text(
                    "用户隐私协议",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const Text(
                  "与",
                  style: TextStyle(color: Colors.grey),
                ),
                InkWell(
                  onTap: () {
                    KTLog("账号隐私协议");
                  },
                  child: const Text(
                    "账号隐私协议",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),

            // CustomCheckbox(
            //   value: isSelect,
            //   onChanged: (value) {
            //     setState(() {
            //       print(value);
            //       isSelect = value;
            //     });
            //   },
            //   customIcon: const Icon(
            //     Icons.check_circle, // 自定义图标
            //     color: Colors.red, // 自定义图标颜色
            //     size: 20.0, // 自定义图标大小
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
