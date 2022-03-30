import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CongratsMessage extends StatelessWidget {


  const CongratsMessage({Key? key, required this.totalTime, required this.totalMoves}) : super(key: key);

  final String totalTime;
  final int totalMoves;

  @override
  Widget build(BuildContext context) {
    return
      Center(
        child: Column(
          children: [
            Text('well_done'.tr,
              style: GoogleFonts.robotoMono(
                  textStyle: const TextStyle(
                      color: Colors.green,
                      fontSize: 26
                  )
              ),
            ),
            Text('mission_completed_in'.tr,
              style: GoogleFonts.robotoMono(
                  textStyle: const TextStyle(
                      color: Colors.green,
                      fontSize: 16
                  )
              ),
            ),
            Container(height: 8,),
            Text('time'.tr +  totalTime,
              style: GoogleFonts.robotoMono(
                  textStyle: const TextStyle(
                      color: Colors.green,
                      fontSize: 18
                  )
              ),
            ),
            Text('guesses'.tr + '$totalMoves',
              style: GoogleFonts.robotoMono(
                  textStyle: const TextStyle(
                      color: Colors.green,
                      fontSize: 18
                  )
              ),
            ),
          ],
        ),
      );
  }
}