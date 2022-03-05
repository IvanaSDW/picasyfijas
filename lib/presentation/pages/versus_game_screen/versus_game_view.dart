import 'dart:math';
import 'package:blinking_text/blinking_text.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/guess_bullet_widget_versus.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/move_widget_versus.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/versus_game_final_result_widget.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/versus_game_header_widget.dart';
import 'package:bulls_n_cows_reloaded/presentation/pages/versus_game_screen/versus_game_logic.dart';
import 'package:bulls_n_cows_reloaded/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../presentation/widgets/intercom_box/intercom_box_view.dart';
import '../../../presentation/widgets/numeric_keyboard/numeric_keyboard_view.dart';
import '../../../presentation/widgets/system_status_widget.dart';
import '../../../shared/constants.dart';
import '../../../shared/text_styles.dart';
import '../../widgets/continue_button.dart';

class VersusGamePage extends StatelessWidget {
  final VersusGameLogic logic = Get.find();

  VersusGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => logic.onBackPressed(),
      child: Material(
        color: Colors.black,
        child: SizedBox(
            child:
            Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 8, // Header
                    child: VersusGameHeaderWidget(),
                  ),
                  const Spacer(flex: 1),
                  Expanded(flex: 51, //Playing body
                    child: (logic.gameStatus == VersusGameStatus.unknown) ||
                        (logic.gameStatus == VersusGameStatus.created)
                        ? const SpinKitDancingSquare(color: Colors.white,)
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container( // Player 1 game
                          padding: const EdgeInsets.all(6),
                          width: Get.width*0.44,
                          decoration: BoxDecoration(
                            // color: Colors.white.withOpacity(0.3),
                            // color: originalColors.playerOneBackground,
                            border: Border.all(
                              color: logic.iAmPlayerOne ? Colors.white : originalColors.accentColor2!,
                              width: 0.5,
                            ),
                          ),
                          child: ListView.builder(
                            controller: logic.myScrollController,
                            itemCount: logic.playerOneGame!.moves.length,
                            itemBuilder: (context, index) {
                              WidgetsBinding.instance!
                                  .addPostFrameCallback((timeStamp) {
                                if (logic.needsScrollToLast) {
                                  logic.scrollToLastItem();
                                }
                              });
                              return MoveItemWidget(
                                moveItem: logic.playerOneGame!.moves[index] ,
                                textHeight: logic.textHeight,
                                side: logic.iAmPlayerOne ? PlayerSide.self : PlayerSide.opponent,
                                playerShift: VersusPlayer.player1,
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10.0),
                          width: Get.width*0.12,
                          child: ListView.builder(
                              controller: logic.bulletScrollController,
                              itemCount: max(logic.playerOneGame!.moves.length, logic.playerTwoGame!.moves.length),
                              itemBuilder: (context, index) {
                                WidgetsBinding.instance!
                                    .addPostFrameCallback((timeStamp) {
                                  if (logic.needsScrollToLast) {
                                    logic.scrollToLastItem();
                                  }
                                });
                                return GuessBulletWidgetVersus(textHeight: logic.textHeight, index: index,);
                              }
                          ),
                        ),
                        Container( // Player 2 game
                          padding: const EdgeInsets.all(6.0),
                          width: Get.width*0.44,
                          decoration: BoxDecoration(
                            // color: Color(0xff4e804a),
                            border: Border.all(
                              color: logic.iAmPlayerOne ? originalColors.accentColor2! : Colors.white,
                              width: 0.5,
                            ),
                          ),
                          child: ListView.builder(
                            controller: logic.oppScrollController,
                            itemCount: logic.playerTwoGame!.moves.length,
                            itemBuilder: (context, index) {
                              WidgetsBinding.instance!
                                  .addPostFrameCallback((timeStamp) {
                                if (logic.needsScrollToLast) {
                                  logic.scrollToLastItem();
                                }
                              });
                              return MoveItemWidget(
                                moveItem: logic.playerTwoGame!.moves[index],
                                textHeight: logic.textHeight,
                                side: logic.iAmPlayerOne ? PlayerSide.opponent : PlayerSide.self,
                                playerShift: VersusPlayer.player2,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1,),
                  Expanded(flex: 26,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 1,),
                        Expanded(flex: 40, //Intercom box
                          child: IntercomBoxPage(textHeight: logic.textHeight),
                        ),
                        const Spacer(flex: 1),
                        Expanded(flex: 59, //Keyboard area
                          child: Obx(() {
                            return AspectRatio(
                                aspectRatio: 1,
                                child: (logic.gameStatus == VersusGameStatus.unknown ||
                                    logic.gameStatus == VersusGameStatus.created)
                                    ? Center(
                                    child: BlinkText(
                                      'Waiting opponent to be ready...',
                                      style: defaultTextStyle,
                                    )
                                )
                                    : logic.showFinalResult
                                    ? Column(
                                  children: [
                                    Expanded(
                                      flex: 65,
                                      child: Center(
                                        child: VersusGameResultWidget(),
                                      ),
                                    ),
                                    Expanded(flex: 35,
                                        child: Center(
                                            child: ContinueButton(
                                              onTapAction: () => logic.onContinuePressed(),
                                            )
                                        )
                                    ),
                                  ],
                                )
                                    : logic.showKeyboard
                                    ? const NumericKeyboardWidget()
                                    : Center(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: BlinkText(
                                        'Waiting opponent to move...',
                                        style: defaultTextStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                )
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(flex: 13,
                    child: Hero(
                        tag: 'system_status',
                        child: SystemStatusView()
                    ),
                  ) //
                ],
              );
            })
        ),
      ),
    );
  }
}

