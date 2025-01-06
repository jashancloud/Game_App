import 'package:get/get.dart';

import '../Controllers/LevelsPage.dart';
import '../Controllers/MainController.dart';
import '../Controllers/StatisticController.dart';
import '../Controllers/ThemeController.dart';

class AppBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(StatisticController());
    Get.put(LevelsController());
    Get.put(MainController());
    Get.put(ThemeController());
  }
}