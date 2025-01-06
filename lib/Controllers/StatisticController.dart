import 'dart:async';

import 'package:get/get.dart';

import '../Constants/AppConstants.dart';
import '../Models/StatisticModel.dart';
import '../Repositories/SharedPrefRepository.dart';

class StatisticController extends GetxController{

  var sharedPrefRepository = SharedPrefRepository.instance;

  void setStatistics({required bool isWin, required int attempt,}) {
    try{
      final previousStatistic = getStatistic();
      final currentStatistic = StatisticModel(
        loses: _calculateLoses(isWin: isWin, previous: previousStatistic?.loses),
        wins: _calculateWins(isWin: isWin, previous: previousStatistic?.wins),
        streak:
        _calculateStreak(isWin: isWin, previous: previousStatistic?.streak),
        attempts: _calculateAttempts(
          attempt: isWin ? attempt - 1 : -2,
          previous: previousStatistic?.attempts,
        ),
      );
      unawaited(sharedPrefRepository.setStatistic(model: currentStatistic));
    }catch(e){
      print("Error in setStatistic : $e");
      AppConstants.showSnackBar(message: "Error setStatistic");
    }

  }

  StatisticModel? getStatistic() {
    return sharedPrefRepository.getStatistic();
  }

  int _calculateLoses({required bool isWin, required int? previous}) {
    if (isWin) {
      return previous ?? 0;
    }
    if (previous == null) {
      return 1;
    }
    return previous + 1;
  }

  int _calculateWins({required bool isWin, required int? previous}) {
    if (!isWin) {
      return previous ?? 0;
    }
    if (previous == null) {
      return 1;
    }
    return previous + 1;
  }

  int _calculateStreak({required bool isWin, required int? previous}) {
    if (!isWin) {
      return 0;
    }
    if (previous == null) {
      return 1;
    }
    return previous + 1;
  }

  List<int> _calculateAttempts({required int attempt, required List<int>? previous,}) {
    if (attempt == -2) {
      return previous ?? StatisticModel.zeroAttempts;
    }
    if (previous == null) {
      final currentAttempts = List<int>.of(StatisticModel.zeroAttempts);
      currentAttempts[attempt+1] += 1;
      return currentAttempts;
    }
    final currentAttempts = List<int>.of(previous);
    currentAttempts[attempt+1] += 1;
    return currentAttempts;
  }
}