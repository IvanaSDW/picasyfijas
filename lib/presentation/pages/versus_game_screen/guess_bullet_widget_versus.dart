import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/theme.dart';


class GuessBulletWidgetVersus extends StatelessWidget {


  const GuessBulletWidgetVersus({
    Key? key,
    required this.textHeight,
    required this.index,
  }) : super(key: key);

  final double textHeight;
  final int index;

  @override
  Widget build(BuildContext context) {
    final indexBulletStyle = GoogleFonts.vt323(
        textStyle: TextStyle(
          color: Colors.white.withOpacity(0.8),
          // color: originalColors.reverseTextColor,
          fontSize: textHeight*0.85,
        )
    );
    return SizedBox(
      height: textHeight*1.4,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height:1.0,
              width:13,
              color:Colors.green,
            ),
            CircleAvatar(
              backgroundColor: originalColors.reverseTextBg,
              radius: textHeight*0.5,
              child: Center(
                child: Text('${index+1}',
                  style: indexBulletStyle,
                ),
              ),
            ),
            Padding(
              padding:const EdgeInsets.symmetric(horizontal:0),
              child:Container(
                height:1.0,
                width:13,
                color:Colors.green,),
            ),
          ]
      ),
    );
  }
}