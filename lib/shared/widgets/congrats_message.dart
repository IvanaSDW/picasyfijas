import 'package:flutter/material.dart';
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
            Text('Well done!!',
              style: GoogleFonts.robotoMono(
                  textStyle: const TextStyle(
                      color: Colors.green,
                      fontSize: 26
                  )
              ),
            ),
            Text('Mission completed in:',
              style: GoogleFonts.robotoMono(
                  textStyle: const TextStyle(
                      color: Colors.green,
                      fontSize: 16
                  )
              ),
            ),
            Container(height: 8,),
            Text('Time: $totalTime',
              style: GoogleFonts.robotoMono(
                  textStyle: const TextStyle(
                      color: Colors.green,
                      fontSize: 18
                  )
              ),
            ),
            Text('Guesses: $totalMoves',
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