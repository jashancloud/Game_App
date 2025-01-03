import 'package:flutter/material.dart';
import 'package:game_app/Constants/AppConstants.dart';
import 'package:game_app/Constants/MyColors.dart';
import 'package:game_app/Constants/MyTheme.dart';
import 'package:get/get.dart';

class LetterInfo {
  final String letter;
  final LetterStatus status;

  const LetterInfo({required this.letter, this.status = LetterStatus.unknown});

  factory LetterInfo.fromJson(Map<String, dynamic> json) => LetterInfo(
        letter: json['letter'] as String,
        status: LetterStatus.values[json['status'] as int],
      );

  Map<String, Object?> toJson() => <String, Object?>{
        'letter': letter,
        'status': status.index,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LetterInfo &&
          runtimeType == other.runtimeType &&
          letter == other.letter &&
          status == other.status;

  @override
  int get hashCode => letter.hashCode ^ status.hashCode;

  @override
  String toString() => '($letter ${status.emoji})';
}

enum LetterStatus {
  correctSpot,
  wrongSpot,
  notInWord,
  unknown;

  bool operator <(LetterStatus other) => other.index < index;

  Color cellColor(ThemeMode mode, BuildContext context) {
    return switch (this) {
      LetterStatus.correctSpot => MyTheme.correctColor(),
      LetterStatus.wrongSpot => MyTheme.wrongSpotColor(),
      LetterStatus.notInWord => MyTheme.notInWordColor(mode, context),
      LetterStatus.unknown => MyTheme.unknownColor(mode, context)
    };
  }

  Color? textColor(ThemeMode mode, BuildContext context) {
    final color = cellColor(mode, context);

    if (this == LetterStatus.notInWord || this == LetterStatus.unknown) {

      //In Dark Mode, I need Primary in notInWord and secondary in unknown

      if ((mode == ThemeMode.light &&
              MediaQuery.of(context).platformBrightness == Brightness.dark) &&
          this == LetterStatus.notInWord) {
        return AppColors.secondary;
      } else if ((mode == ThemeMode.light &&
              MediaQuery.of(context).platformBrightness == Brightness.dark) &&
          this == LetterStatus.unknown) {
        return AppColors.primary;
      } else if (((mode == ThemeMode.dark ||
              MediaQuery.of(context).platformBrightness == Brightness.dark) &&
          this == LetterStatus.notInWord)) {
        return AppColors.primary;
      } else if (((mode == ThemeMode.dark ||
              MediaQuery.of(context).platformBrightness == Brightness.dark) &&
          this == LetterStatus.unknown)) {
        return AppColors.secondary;
      } else if (((mode == ThemeMode.light ||
              MediaQuery.of(context).platformBrightness == Brightness.light) &&
          this == LetterStatus.notInWord)) {
        return AppColors.secondary;
      } else {
        return AppColors.primary;
      }
    }

    return AppConstants.darken(color, 0.3);
  }

  String get emoji => switch (this) {
        LetterStatus.correctSpot => '🟩',
        LetterStatus.wrongSpot => '🟨',
        LetterStatus.notInWord => '⬛',
        LetterStatus.unknown => ''
      };
}
