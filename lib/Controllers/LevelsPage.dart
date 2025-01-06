import 'dart:convert';

import 'package:get/get.dart';

import '../Models/WordModel.dart';
import '../Repositories/SharedPrefRepository.dart';

class LevelsController extends GetxController {
  var sharedPrefRepository = SharedPrefRepository.instance;

  List<WordModel> getLevels() {
    var levels = sharedPrefRepository.getLevels();
    if (levels != null) {
      var list = levels.map((str) {
        var decode = jsonDecode(str);
        return WordModel.fromMap(decode);
      }).toList();

      return list;
    }
    return [];
  }

  Future<void> setLevel({required WordModel model}) async {
    await sharedPrefRepository.setLevels(model: model);
  }
}
