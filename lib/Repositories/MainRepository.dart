import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:game_app/Constants/AppConstants.dart';

class MainRepository{

  MainRepository._privateConstructor();

  static final MainRepository _instance =
  MainRepository._privateConstructor();

  static MainRepository get instance => _instance;

  late final Map<String, String> enDictionary;

  Future<void> initDictionary() async {
    try {
      final rawDictionaryEn = await rootBundle.loadString(AppConstants.englishDictionary).then(json.decode) as Map<String, dynamic>;
      enDictionary = rawDictionaryEn.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      print("Error initializing dictionary: $e");
      throw Exception("Failed to load dictionary");
    }
  }

  String generateSecretWord({required int levelNumber}) {
    try {
      int index;
      if (levelNumber == 0) {
        final now = DateTime.now().toUtc();
        final random = Random(now.year * 1000 + now.month * 100 + now.day);
        index = random.nextInt(enDictionary.length);
      } else {
        index = Random(levelNumber).nextInt(enDictionary.length);
      }
      final word = enDictionary.keys.elementAt(index);
      return word;
    } catch (e) {
      print("Error generating secret word: $e");
      throw Exception("Failed to generate secret word");
    }
  }

  String getDescription(String word) {
    try {
      return enDictionary[word]!;
    } catch (e) {
      print("Error getting description for word $word: $e");
      throw Exception("Failed to get description");
    }
  }

  bool isWordAvailable(String word) {
    try {
      return enDictionary.containsKey(word);
    } catch (e) {
      print("Error checking availability of word $word: $e");
      throw Exception("Failed to check word availability");
    }
  }
}
