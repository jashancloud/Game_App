import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_app/Models/letter_info.dart';
import 'package:game_app/Widgets/CalculateTime.dart';
import 'package:get/get.dart';

import '../Models/WordModel.dart';
import 'MyColors.dart';

class AppConstants {
  static const String isFirstEnterKey = "Shared.Pref.IsFirstEnter";
  static const String setBoardInPref = "Shared.Pref.Board";
  static const String setStaticInPref = "Shared.Pref.Statistic";
  static const String setThemeInPref = "Shared.Pref.Theme";
  static const String setLevelsInPref = "Shared.Pref.Levels";

  static const int dailyGame = 0;
  static const int levelGame = 1;
  static const String setBackgroundTask = "clearSharedPreferencesTask";
  static const String lightTheme = "lightTheme";
  static const String darkTheme = "darkTheme";

  static const String englishDictionary = "assets/dictionary/en.json";

  static const String homePage = "/HomePage";
  static const String tutorialPage = "/TutorialPage";
  static const String statisticPage = "/StatisticPage";
  static const String settingPage = "/SettingPage";
  static const String levelsPage = "/LevelsPage";

  static const (List<String>, List<String>, List<String>) keyboardList = (
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
  );

  static const (List<LetterInfo>, List<LetterInfo>, List<LetterInfo>) tutorialList = (
    [
      LetterInfo(letter: "P",status: LetterStatus.correctSpot),
      LetterInfo(letter: "A"),
      LetterInfo(letter: "U"),
      LetterInfo(letter: "S"),
      LetterInfo(letter: "E"),
    ],

    [
      LetterInfo(letter: "C"),
      LetterInfo(letter: "R"),
      LetterInfo(letter: "A",status: LetterStatus.wrongSpot),
      LetterInfo(letter: "N"),
      LetterInfo(letter: "E"),
    ],
    [
      LetterInfo(letter: "S"),
      LetterInfo(letter: "P"),
      LetterInfo(letter: "O"),
      LetterInfo(letter: "R"),
      LetterInfo(letter: "E",status: LetterStatus.notInWord),
    ],
  );

  static double customWidth(BuildContext context) {
    final maxKeyboardLength = keyboardList.$1.length;
    var screenWidth = MediaQuery.of(context).size.width;
    return (min(screenWidth, 520) - (maxKeyboardLength + 4) * 6) /
        maxKeyboardLength;
  }

  static void showSnackBar({required String message}) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      duration: const Duration(seconds: 1),
    ));
  }

  static Future<void> showGameResultDialog({required WordModel model, required int mode, VoidCallback? nextLevelPressed,VoidCallback? onEnd}){
    final width = Get.size.width;
    final padding = width > 350 ? (width - 350) / 2 : 8;
    return Get.dialog(
        Dialog(
          backgroundColor: model.isWin ? AppColors.green : AppColors.red,
          insetAnimationDuration: const Duration(milliseconds: 800),
          insetPadding: EdgeInsets.symmetric(horizontal: padding.toDouble()),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (model.isWin ? "You Win" : "You Loose").toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Secret Word",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    model.secretWord.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    model.meaning,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  (mode == AppConstants.levelGame)
                      ? LevelContent(
                      isWin: model.isWin, nextLevelPressed: nextLevelPressed)
                      : DailyContent(
                    isWin: model.isWin,
                    onEnd: onEnd,
                  )
                ],
              ),
            ),
          ),
        ),barrierDismissible: mode != AppConstants.levelGame
    );
  }

  static Future<void> showLevelsDialog({required WordModel model}){
    final width = Get.size.width;
    final padding = width > 350 ? (width - 350) / 2 : 8;
    return Get.dialog(
        Dialog(
          backgroundColor: model.isWin ? AppColors.green : AppColors.red,
          insetAnimationDuration: const Duration(milliseconds: 800),
          insetPadding: EdgeInsets.symmetric(horizontal: padding.toDouble()),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SelectableText(
                  model.secretWord.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(height: 16),
                Text(
                  model.meaning,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
    );
  }

  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}

class DailyContent extends StatelessWidget {
  const DailyContent({super.key, required this.isWin,this.onEnd});

  final bool isWin;
  final VoidCallback? onEnd;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toUtc();
    final tomorrow = DateTime.utc(now.year, now.month, now.day + 1);
    final timeRemaining = tomorrow.difference(now);
    return Column(
      children: [
        const Text(
          "Next Word",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        CalculateTime(
          onEnd: onEnd,
          timeRemaining: timeRemaining,
        ),
      ],
    );
  }
}

class LevelContent extends StatelessWidget {
  const LevelContent({super.key, required this.isWin, required this.nextLevelPressed});

  final bool isWin;
  final VoidCallback? nextLevelPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
      onPressed: nextLevelPressed,
      child: Text(
        "Next Level",
        style: TextStyle(
          color: isWin ? AppColors.green : AppColors.red,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
