import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/theme.dart';
import 'intercom_box_logic.dart';

class IntercomBoxPage extends StatelessWidget {
  final IntercomBoxLogic logic = Get.put(IntercomBoxLogic());
  final double textHeight;

  IntercomBoxPage({Key? key, required this.textHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green,
          width: 0.5,
        ),
      ),
      child: Column(
          children: [
            Text('Intercom System',
              style: TextStyle(color: originalColors.textColor2, fontSize: textHeight*0.7, fontFamily: 'Digital'),
            ),
            Container(height: 16,),
            Flexible(
              child: ListView.builder(
                  itemCount: logic.messages.length,
                  itemBuilder: (context, index) {
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
