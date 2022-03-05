// import 'dart:math';
//
// import 'package:blinking_text/blinking_text.dart';
// import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/guess_bullet_widget_versus.dart';
// import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/move_widget_versus.dart';
// import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/versus_game_header_widget.dart';
// import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/versus_game_logic.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:get/get.dart';
// import '../../../data/models/versus_game.dart';
// import '../../../presentation/widgets/congrats_message.dart';
// import '../../../presentation/widgets/intercom_box/intercom_box_view.dart';
// import '../../../presentation/widgets/numeric_keyboard/numeric_keyboard_view.dart';
// import '../../../presentation/widgets/system_status_widget.dart';
// import '../../../shared/constants.dart';
// import '../../../shared/text_styles.dart';
// import '../../widgets/continue_button.dart';

// class VersusGamePage extends StatelessWidget {
//   final VersusGameLogic logic = Get.find();
//
//   VersusGamePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => logic.onBackPressed(),
//       child: Material(
//         color: Colors.black,
//         child: SizedBox(
//             child:
//             Obx(() {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Expanded(flex: 8, // Header
//                     child: VersusGameHeaderWidget(),
//                   ),
//                   const Spacer(flex: 1),
//                   Expanded(flex: 51, //Playing body
//                       child: logic.gameState != VersusGameState.started
//                           ? const SpinKitDancingSquare(color: Colors.white,)
//                           : StreamBuilder<DocumentSnapshot<VersusGame>>(
//                           stream: logic.gameStateStream,
//                           builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<VersusGame>> snapshot){
//                             logger.i('Received snapshot: $snapshot');
//                             if (snapshot.connectionState == ConnectionState.waiting) return const SpinKitPouringHourGlass(color: Colors.white,);
//                             // if (!snapshot.hasData) return const SpinKitPouringHourGlass(color: Colors.white,);
//                             VersusGame gameNow =  snapshot.data!.data()!;
//                             logger.i('Received game update: ${gameNow.toJson()}');
//                             if (logic.iAmPlayerOne) {
//                               logic.isMyMove = gameNow.whoIsToMove == PlayerToMove.player1
//                                   ? true : false;
//                               logic.myGame = gameNow.playerOneGame;
//                               logic.opponentGame = gameNow.playerTwoGame;
//                             } else {
//                               logic.isMyMove = gameNow.whoIsToMove == PlayerToMove.player2
//                                   ? true : false;
//                               logic.myGame = gameNow.playerTwoGame;
//                               logic.opponentGame = gameNow.playerOneGame;
//                             }
//                             logic.addFakeMoveToPlayer(gameNow.whoIsToMove);
//                             return Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container( // MyGame
//                                   padding: const EdgeInsets.all(6),
//                                   width: Get.width*0.43,
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: Colors.green,
//                                       width: 0.5,
//                                     ),
//                                   ),
//                                   child: ListView.builder(
//                                     controller: logic.myScrollController,
//                                     itemCount: logic.myGame!.moves.length,
//                                     itemBuilder: (context, index) {
//                                       WidgetsBinding.instance!
//                                           .addPostFrameCallback((timeStamp) {
//                                         if (logic.needsScrollToLast) {
//                                           logic.scrollToLastItem();
//                                         }
//                                       });
//                                       var thisMove = logic.myGame!.moves[index];
//                                       var lastIndex = logic.myGame!.moves.length - 1;
//                                       if (index != lastIndex) {
//                                         return NormalGuessDisplayVersus(
//                                           index: index,
//                                           textHeight: logic.textHeight,
//                                           move: thisMove,
//                                         );
//                                       } else {
//                                         return logic.numberFound
//                                             ? CorrectGuessDisplayVersus(
//                                           index: index,
//                                           textHeight: logic.textHeight,
//                                           item: thisMove,
//                                         )
//                                             : PendingGuessDisplayVersus(
//                                           index: index,
//                                           textHeight: logic.textHeight,
//                                           item: thisMove,
//                                         );
//                                       }
//                                     },
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.only(top: 10.0),
//                                   width: Get.width*0.14,
//                                   child: ListView.builder(
//                                       controller: logic.bulletScrollController,
//                                       itemCount: max(logic.myGame!.moves.length, logic.opponentGame!.moves.length),
//                                       itemBuilder: (context, index) {
//                                         WidgetsBinding.instance!
//                                             .addPostFrameCallback((timeStamp) {
//                                           if (logic.needsScrollToLast) {
//                                             logic.scrollToLastItem();
//                                           }
//                                         });
//                                         return GuessBulletWidgetVersus(textHeight: logic.textHeight, index: index,);
//                                       }
//                                   ),
//                                 ),
//                                 Container( // OpponentGame
//                                   padding: const EdgeInsets.all(6),
//                                   width: Get.width*0.43,
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: Colors.green,
//                                       width: 0.5,
//                                     ),
//                                   ),
//                                   child: ListView.builder(
//                                     controller: logic.oppScrollController,
//                                     itemCount: logic.opponentGame!.moves.length,
//                                     itemBuilder: (context, index) {
//                                       WidgetsBinding.instance!
//                                           .addPostFrameCallback((timeStamp) {
//                                         if (logic.needsScrollToLast) {
//                                           logic.scrollToLastItem();
//                                         }
//                                       });
//                                       var thisMove = logic.opponentGame!.moves[index];
//                                       var lastIndex = logic.opponentGame!.moves.length - 1;
//                                       if (index != lastIndex) {
//                                         return NormalGuessDisplayVersus(
//                                           index: index,
//                                           textHeight: logic.textHeight,
//                                           move: thisMove,
//                                         );
//                                       } else {
//                                         return logic.numberFound
//                                             ? CorrectGuessDisplayVersus(
//                                           index: index,
//                                           textHeight: logic.textHeight,
//                                           item: thisMove,
//                                         )
//                                             : PendingGuessDisplayVersus(
//                                           index: index,
//                                           textHeight: logic.textHeight,
//                                           item: thisMove,
//                                         );
//                                       }
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             );
//                           })
//                   ),
//                   const Spacer(flex: 1,),
//                   Expanded(flex: 26,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Spacer(flex: 1,),
//                         Expanded(flex: 40, //Intercom box
//                           child: IntercomBoxPage(textHeight: logic.textHeight),
//                         ),
//                         const Spacer(flex: 1),
//                         Expanded(flex: 59, //Keyboard area
//                           child: Obx(() {
//                             return AspectRatio(
//                                 aspectRatio: 1,
//                                 child: (logic.gameState == VersusGameState.unknown ||
//                                     logic.gameState == VersusGameState.created)
//                                     ? Center(
//                                     child: BlinkText(
//                                       'Waiting opponent to be ready...',
//                                       style: defaultTextStyle,
//                                     )
//                                 )
//                                     : logic.gameState ==
//                                     VersusGameState.finished
//                                     ? Column(
//                                   children: [
//                                     Expanded(
//                                       flex: 65,
//                                       child: Center(
//                                         child: CongratsMessage(
//                                             totalTime: logic.myTimer.convertToDisplayTime(logic
//                                                 .myGame!.moves.last
//                                                 .timeStampMillis
//                                             ),
//                                             totalMoves: logic.myGame!.moves.length
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(flex: 35,
//                                         child: Center(
//                                             child: ContinueButton(
//                                               onTapAction: () => logic.onContinuePressed(),
//                                             )
//                                         )
//                                     ),
//                                   ],
//                                 )
//                                     : logic.isMyMove
//                                     ? const NumericKeyboardWidget()
//                                     : Center(
//                                   child: BlinkText(
//                                     'Waiting opponent to move...',
//                                     style: defaultTextStyle,
//                                   ),
//                                 )
//                             );
//                           }),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Expanded(flex: 13,
//                     child: Hero(
//                         tag: 'system_status',
//                         child: SystemStatusView()
//                     ),
//                   ) //
//                 ],
//               );
//             })
//         ),
//       ),
//     );
//   }
// }
