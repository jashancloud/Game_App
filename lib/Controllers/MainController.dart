import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:game_app/Constants/AppConstants.dart';
import 'package:game_app/Models/GameModel.dart';
import 'package:game_app/Models/StatisticModel.dart';
import 'package:game_app/Models/WordModel.dart';
import 'package:game_app/Repositories/MainRepository.dart';
import 'package:game_app/Repositories/SharedPrefRepository.dart';
import 'package:get/get.dart';

import '../Models/letter_info.dart';

class MainController extends GetxController {
  var gameState = Rx<int>(AppConstants.dailyGame);
  var level = 1.obs;
  var enterWord = "".obs;
  var attempt = 0.obs;

  var gridItems = List<LetterInfo?>.generate(30, (index) => null).obs;
  var themeMode=ThemeMode.system.obs;

  var sharedPrefRepository = SharedPrefRepository.instance;
  var repository = MainRepository.instance;

  var currentWord = "";
  var currentWordMeaning = "";
  var currentGameModel = Rx<GameModel?>(null);

  @override
  void onInit() {
    getPrefValues();
    getTheme();
    super.onInit();
  }

  //Getting Saved Board from Shared Pref
  void getPrefValues() {
    // sharedPrefRepository.clearSharedPref();

    try{

      currentGameModel.value =
          sharedPrefRepository.getBoard(mode: gameState.value);

      if (currentGameModel.value != null) {
        var gameModel = currentGameModel.value;

        if ((gameModel!.isComplete)) {
          if (gameModel.mode == AppConstants.dailyGame) {
            var model = WordModel(
                secretWord: gameModel.secretWord,
                meaning: gameModel.meaning,
                isWin: gameModel.isWin);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppConstants.showGameResultDialog(
                model: model,
                mode: gameState.value,
              );
            });
            currentWord=model.secretWord;
            currentWordMeaning=model.meaning;
            changeGridListWithResultList(gameModel.board);
          } else {
            level.value = currentGameModel.value!.level;
            currentWord = repository.generateSecretWord(levelNumber: level.value);
            currentWordMeaning = repository.getDescription(currentWord);
          }
        } else {
          if (gameModel.mode == gameState.value) {
            currentWord = gameModel.secretWord;
            currentWordMeaning = gameModel.meaning;

            if (gameState.value == gameModel.mode) {
              level.value = gameModel.level;
            }

            changeGridListWithResultList(gameModel.board);
            attempt.value = gameModel.attempt;
          }
        }
      } else {
        if (gameState.value == AppConstants.dailyGame) {
          currentWord = repository.generateSecretWord(levelNumber: 0);
        } else {
          currentWord = repository.generateSecretWord(levelNumber: level.value);
        }
        currentWordMeaning = repository.getDescription(currentWord);
      }
      print(currentWord);
    }catch(e){
      print("Error in getPrefValues: $e");
      AppConstants.showSnackBar(message: "Error loading preferences");
    }
  }

  //Change Game Mode Daily or Level
  void changeGameMode() {
    try{
      if (gameState.value == AppConstants.dailyGame) {
        gameState.value = AppConstants.levelGame;
        level.value = 1;
      } else {
        gameState.value = AppConstants.dailyGame;
        level.value = 0;
      }
      enterWord.value = "";
      attempt.value = 0;

      // Replace null in gridItems
      for (int i = 0; i < gridItems.length; ++i) {
        gridItems[i] = null;
      }

      //For CLosing Drawer
      Get.back();

      getPrefValues();
    }catch (e) {
      print("Error in changeGameMode: $e");
      AppConstants.showSnackBar(message: "Error changing game mode");
    }
  }

  //Enter Word In Game
  void enterWordInGame(String word) {
    try{
      if (currentGameModel.value != null) {
        var gameModel = currentGameModel.value;
        if (gameState.value == AppConstants.dailyGame &&
            gameModel!.mode == AppConstants.dailyGame &&
            gameModel.isComplete) {
          return;
        }
      }
      if (enterWord.value.length <= 4 && attempt.value <= 5) {
        enterWord.value += word;
        var letterInfo = LetterInfo(letter: word);
        gridItems[(enterWord.value.length - 1) + (attempt.value * 5)] =
            letterInfo;
      }
    }catch (e) {
      print("Error in addEnterWord: $e");
      AppConstants.showSnackBar(message: "Error adding word");
    }

  }

  //For Resetting The Game
  void resetGame() {
    try{
      level.value = level.value + 1;
      currentWord = repository.generateSecretWord(levelNumber: level.value);
      currentWordMeaning = repository.getDescription(currentWord);
      enterWord.value = "";
      attempt.value = 0;
      for (int i = 0; i < gridItems.length; ++i) {
        gridItems[i] = null;
      }
    }catch (e) {
      print("Error in resetGame: $e");
      AppConstants.showSnackBar(message: "Error resetting game");
    }

  }

  //When Press Enter
  Future<void> pressEnter() async {
    try{
      if (enterWord.value.length == 5) {
        var word = enterWord.value;

        if (repository.isWordAvailable(enterWord.value)) {
          if (currentWord == enterWord.value) {
            final resultWord = <LetterInfo>[];
            for (var i = 0; i < word.length; i++) {
              resultWord.add(
                LetterInfo(letter: word[i], status: LetterStatus.correctSpot),
              );
            }
            changeGridListWithResultList(resultWord);
            var gameModel = GameModel(
                secretWord: currentWord,
                meaning: currentWordMeaning,
                board: getMainListWithoutNull(),
                isWin: true,
                isComplete: true,
                attempt: attempt.value,
                mode: gameState.value);

            if (gameState.value != AppConstants.dailyGame) {
              gameModel.level = level.value;
            }

            var model = WordModel(
                secretWord: currentWord,
                meaning: currentWordMeaning,
                isWin: true,level: level.value);

            if (gameState.value == AppConstants.dailyGame) {
              setStatistics(isWin: true, attempt: attempt.value);
            }else{
              unawaited(sharedPrefRepository.setLevels(model: model));
            }


            await AppConstants.showGameResultDialog(
                model: model,
                mode: gameState.value,
                nextLevelPressed: () {
                  gameModel.level = level.value + 1;
                  resetGame();
                  Get.back();
                });


            unawaited(sharedPrefRepository.setBoard(
                model: gameModel, mode: gameState.value));
          }
          else {
            final resultWord = <LetterInfo>[];
            final secretWordDictionary = <String, int>{};
            for (var i = 0; i < word.length; i++) {
              resultWord.add(
                LetterInfo(
                  letter: word[i],
                  status: currentWord[i] == word[i]
                      ? LetterStatus.correctSpot
                      : LetterStatus.notInWord,
                ),
              );
              if (currentWord[i] != word[i]) {
                if (secretWordDictionary.containsKey(currentWord[i])) {
                  secretWordDictionary[currentWord[i]] =
                      secretWordDictionary[currentWord[i]]! + 1;
                } else {
                  secretWordDictionary[currentWord[i]] = 1;
                }
              }
            }

            for (var i = 0; i < resultWord.length; i++) {
              if (resultWord[i].status == LetterStatus.correctSpot) {
                continue;
              }
              if (secretWordDictionary.containsKey(resultWord[i].letter) &&
                  secretWordDictionary[resultWord[i].letter]! > 0) {
                resultWord[i] = LetterInfo(
                    letter: resultWord[i].letter, status: LetterStatus.wrongSpot);
                secretWordDictionary[resultWord[i].letter] =
                    secretWordDictionary[resultWord[i].letter]! - 1;
              }
            }

            changeGridListWithResultList(resultWord);
            enterWord.value = "";
            attempt.value += 1;

            var gameModel = GameModel(
                secretWord: currentWord,
                meaning: currentWordMeaning,
                board: getMainListWithoutNull(),
                isWin: false,
                attempt: attempt.value,
                mode: gameState.value);

            if (gameState.value != AppConstants.dailyGame) {
              gameModel.level = level.value;
            }

            if (attempt.value > 5) {
              gameModel.isComplete = true;
              // You Lose
              var model = WordModel(
                  secretWord: currentWord,
                  meaning: currentWordMeaning,
                  isWin: false,level: level.value);

              if (gameState.value == AppConstants.dailyGame) {
                setStatistics(isWin: false, attempt: attempt.value);
              }else{
                unawaited(sharedPrefRepository.setLevels(model: model));
              }

              await AppConstants.showGameResultDialog(
                  model: model,
                  mode: gameState.value,
                  nextLevelPressed: () {
                    gameModel.isWin = true;
                    gameModel.level = level.value + 1;
                    gameModel.isComplete = true;
                    resetGame();
                    Get.back();
                  },
                  onEnd: () {
                    unawaited(sharedPrefRepository.clearBoard(
                        mode: AppConstants.dailyGame));
                    if (gameState.value == AppConstants.dailyGame) {
                      getPrefValues();
                    }
                  });
            }

            unawaited(sharedPrefRepository.setBoard(
                model: gameModel, mode: gameState.value));
          }
        } else {
          AppConstants.showSnackBar(message: "Word is not Available");
        }
      }
    }catch(e){
      print("Error in Press Enter: $e");
      AppConstants.showSnackBar(message: "Error press entering game");
    }
  }

  //Press Delete
  void pressDelete() {
    if (enterWord.isNotEmpty) {
      gridItems[(enterWord.value.length - 1) + (attempt.value * 5)] = null;
      enterWord.value = enterWord.substring(0, enterWord.value.length - 1);
    }
  }

  void changeGridListWithResultList(List<LetterInfo> resultWord) {
    int index2 = 0;
    for (int i = attempt.value * 5; i < gridItems.length; i++) {
      if (index2 < resultWord.length) {
        gridItems[i] = resultWord[index2];
        index2++;
      }
    }
  }

  List<LetterInfo> getMainListWithoutNull() {
    List<LetterInfo> temp = [];
    for (var info in gridItems) {
      if (info == null) {
        break;
      }
      temp.add(info);
    }
    return temp;
  }

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

  StatisticModel? getStatistic() {
    return sharedPrefRepository.getStatistic();
  }

  void changeTheme({required ThemeMode mode}){
    try{
      if(mode == ThemeMode.light){
        sharedPrefRepository.setTheme(theme: AppConstants.lightTheme);
      }else if(mode == ThemeMode.dark){
        sharedPrefRepository.setTheme(theme: AppConstants.darkTheme);
      }else{
        unawaited(sharedPrefRepository.removeTheme());
      }
      Get.changeThemeMode(mode);
      themeMode.value=mode;
    }catch(e){
      print("Error in ChangeTheme : $e");
      AppConstants.showSnackBar(message: "Error ChangeTheme");
    }
  }

  void getTheme(){
    var theme = sharedPrefRepository.getTheme();
    if(theme != null){
      if(theme == AppConstants.lightTheme){
        themeMode.value=ThemeMode.light;
      }else if(theme == AppConstants.darkTheme){
        themeMode.value=ThemeMode.dark;
      }
    }
  }

  List<WordModel> getLevels(){
    var levels = sharedPrefRepository.getLevels();
    if(levels != null){
      var list = levels.map((str){
        var decode = jsonDecode(str);
        return WordModel.fromMap(decode);
      }).toList();

      return list;
    }
    return [];
  }
}
