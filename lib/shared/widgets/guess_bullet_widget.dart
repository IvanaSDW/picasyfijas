import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class GuessBulletWidget extends StatelessWidget {


  const GuessBulletWidget({
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
          color: originalColors.reverseTextColor,
          fontSize: textHeight*0.85,
        )
    );
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
              width:15,
              color:Colors.green,),),
        ]
    );
  }
}