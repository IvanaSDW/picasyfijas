import 'package:auto_size_text/auto_size_text.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/theme.dart';
import 'intercom_box_logic.dart';

class IntercomBoxWidget extends StatelessWidget {
  final IntercomBoxLogic logic = Get.put(IntercomBoxLogic());
  final double textHeight;

  IntercomBoxWidget({Key? key, required this.textHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: originalColors.keyOffColor!, width: 0.5),
            top: BorderSide(color: originalColors.keyOffColor!, width: 0.5),
            right: BorderSide(color: originalColors.textColorLight!, width: 0.5),
            bottom: BorderSide(color: originalColors.textColorLight!, width: 0.5),
          )
        // border: Border.all(
        //   color: Colors.green,
        //   width: 0.5,
        // ),
      ),
      child: Column(
          children: [
            AutoSizeText('Intercom System',
              style: TextStyle(color: originalColors.textColor2, fontSize: textHeight*0.7, fontFamily: 'Digital'),
            ),
            Container(height: 8,),
            Flexible(
              child: ListView.builder(
                  controller: logic.scrollController,
                  itemCount: logic.messages.length,
                  itemBuilder: (context, index) {
                    WidgetsBinding.instance!
                        .addPostFrameCallback((timeStamp) {
                      logic.scrollToLastItem();
                    });
                    return Container(
                      child: index == (logic.messages.length -1) ?
                      BlinkText('> ${logic.messages[index]}',
                        endColor: originalColors.textColorLight,
                        style: TextStyle(color: originalColors.textColor3, height: 1, fontFamily: 'Digital'),)
                          : Text('> ${logic.messages[index]}',
                        style: TextStyle(color: originalColors.textColor3, height: 1, fontFamily: 'Digital'),),
                    );
                  }
              ),
            ),
          ]),
    );
  }
}
