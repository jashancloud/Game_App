import 'package:game_app/Constants/AppConstants.dart';
import 'package:game_app/Controllers/LevelsPage.dart';
import 'package:game_app/Models/WordModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constants/MyColors.dart';

class LevelsPage extends GetView<LevelsController> {
  const LevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var levels = controller.getLevels();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Levels",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
        ),
        centerTitle: true,
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800.0),
        child:  GridView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: levels.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) => _LevelItem(
            model: levels[index],
          ),
        ),
      ),
    );
  }
}

class _LevelItem extends StatelessWidget {
  const _LevelItem({required this.model});

  final WordModel model;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(8),
        color: model.isWin
            ? AppColors.green
            : AppColors.red,
        child: InkWell(
          onTap: () async {
            await AppConstants.showLevelsDialog(
            model: model
            );
          },
          child: Center(
            child: Text(
              '${model.level}\n${model.secretWord.toUpperCase()}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
