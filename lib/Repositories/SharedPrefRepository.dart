import 'dart:convert';

import 'package:game_app/Constants/AppConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/GameModel.dart';
import '../Models/StatisticModel.dart';
import '../Models/WordModel.dart';

class SharedPrefRepository {
  SharedPrefRepository._privateConstructor();

  static final SharedPrefRepository _instance =
  SharedPrefRepository._privateConstructor();

  static SharedPrefRepository get instance => _instance;

  SharedPreferences? sharedPreferences;

  Future<void> init() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
    } catch (e) {
      print("Error initializing shared preferences: $e");
      throw Exception("Failed to initialize shared preferences");
    }
  }

  bool isFirstEnter() {
    try {
      var bool = sharedPreferences?.getBool(AppConstants.isFirstEnterKey);
      return bool == null || !bool;
    } catch (e) {
      print("Error checking first enter: $e");
      return true;
    }
  }

  Future<void> setFirstEnter() async {
    try {
      await sharedPreferences?.setBool(AppConstants.isFirstEnterKey, true);
    } catch (e) {
      print("Error setting first enter: $e");
      throw Exception("Failed to set first enter");
    }
  }

  Future<void> clearFirstEnter() async {
    try {
      await sharedPreferences?.remove(AppConstants.isFirstEnterKey);
    } catch (e) {
      print("Error clearing first enter: $e");
      throw Exception("Failed to clear first enter");
    }
  }

  Future<void> setBackgroundSharedPrefTask({required bool value}) async {
    try {
      await sharedPreferences?.setBool(AppConstants.setBackgroundTask, value);
    } catch (e) {
      print("Error setting background task: $e");
      throw Exception("Failed to set background task");
    }
  }

  bool? getBackgroundSharedPrefTask() {
    try {
      return sharedPreferences?.getBool(AppConstants.setBackgroundTask);
    } catch (e) {
      print("Error getting background task: $e");
      return null;
    }
  }

  GameModel? getBoard({required int mode}) {
    try {
      String key = "${AppConstants.setBoardInPref}$mode";
      var string = sharedPreferences?.getString(key);
      if (string != null) {
        var jsonDecode1 = jsonDecode(string);
        return GameModel.fromMap(jsonDecode1);
      }
      return null;
    } catch (e) {
      print("Error getting board: $e");
      return null;
    }
  }

  Future<void> clearBoard({required int mode}) async {
    try {
      String key = "${AppConstants.setBoardInPref}$mode";
      await sharedPreferences?.remove(key);
    } catch (e) {
      print("Error clearing board: $e");
      throw Exception("Failed to clear board");
    }
  }

  Future<void> setBoard({required GameModel model, required int mode}) async {
    try {
      String key = "${AppConstants.setBoardInPref}$mode";
      await sharedPreferences?.setString(key, jsonEncode(model.toMap()));
    } catch (e) {
      print("Error setting board: $e");
      throw Exception("Failed to set board");
    }
  }

  Future<void> setStatistic({required StatisticModel model}) async {
    try {
      String key = AppConstants.setStaticInPref;
      await sharedPreferences?.setString(key, jsonEncode(model.toJson()));
    } catch (e) {
      print("Error setting statistic: $e");
      throw Exception("Failed to set statistic");
    }
  }

  StatisticModel? getStatistic() {
    try {
      var string = sharedPreferences?.getString(AppConstants.setStaticInPref);
      if (string != null) {
        return StatisticModel.fromJson(jsonDecode(string));
      }
      return null;
    } catch (e) {
      print("Error getting statistic: $e");
      return null;
    }
  }

  Future<void> clearStatistic() async {
    try {
      String key = AppConstants.setStaticInPref;
      await sharedPreferences?.remove(key);
    } catch (e) {
      print("Error clearing statistic: $e");
      throw Exception("Failed to clear statistic");
    }
  }

  Future<void> setTheme({required String theme}) async {
    try {
      await sharedPreferences?.setString(AppConstants.setThemeInPref, theme);
    } catch (e) {
      print("Error setting theme: $e");
      throw Exception("Failed to set theme");
    }
  }

  String? getTheme() {
    try {
      return sharedPreferences?.getString(AppConstants.setThemeInPref);
    } catch (e) {
      print("Error getting theme: $e");
      return null;
    }
  }

  Future<void> removeTheme() async {
    try {
      await sharedPreferences?.remove(AppConstants.setThemeInPref);
    } catch (e) {
      print("Error removing theme: $e");
      throw Exception("Failed to remove theme");
    }
  }

  Future<void> setLevels({required WordModel model}) async {
    try {
      var levels = getLevels();
      List<String> list = [];
      if (levels != null) {
        list.addAll(levels);
      }
      list.add(jsonEncode(model.toMap()));
      await sharedPreferences?.setStringList(AppConstants.setLevelsInPref, list);
    } catch (e) {
      print("Error setting levels: $e");
      throw Exception("Failed to set levels");
    }
  }

  List<String>? getLevels() {
    try {
      return sharedPreferences?.getStringList(AppConstants.setLevelsInPref);
    } catch (e) {
      print("Error getting levels: $e");
      return null;
    }
  }

  Future<void> clearLevels() async {
    try {
      await sharedPreferences?.remove(AppConstants.setLevelsInPref);
    } catch (e) {
      print("Error clearing levels: $e");
      throw Exception("Failed to clear levels");
    }
  }

  Future<void> clearSharedPref() async {
    try {
      await sharedPreferences?.clear();
    } catch (e) {
      print("Error clearing shared preferences: $e");
      throw Exception("Failed to clear shared preferences");
    }
  }
}
