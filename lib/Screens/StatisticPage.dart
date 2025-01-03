import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_app/Constants/MyColors.dart';
import 'package:game_app/Controllers/MainController.dart';
import 'package:get/get.dart';

import '../Widgets/HaveNotPlayed.dart';

class StatisticPage extends GetView<MainController> {
  const StatisticPage({super.key});

  @override
  Widget build(BuildContext context) {
    var statisticModel = controller.getStatistic();
    int played=0, streak=0;
    num winRate=0;
    if (statisticModel != null) {
      played = statisticModel.wins + statisticModel.loses;
      winRate = played != 0 ? statisticModel.wins * 100 / played : 0;
      streak = statisticModel.streak;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Statistic",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800.0),
            child:
            (statisticModel == null)
                ? const HaveNotPlayed()
                : Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _StatText(
                            value: played,
                            title: "Played",
                          ),
                          _StatText(
                            value: winRate,
                            title: "Win Rate",
                            percent: true,
                          ),
                          _StatText(
                            value: streak,
                            title: "Current Streak",
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: FittedBox(
                          child: Text(
                            "GUESS DISTRIBUTION",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      _AttemptContent(attempts: statisticModel.attempts),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _StatText extends StatelessWidget {
  const _StatText({
    required this.value,
    required this.title,
    this.percent = false,
    // ignore: unused_element
    super.key,
  });

  final num value;
  final String title;
  final bool percent;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            percent ? '${value.toStringAsFixed(1)}%' : value.toString(),
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      );
}

class _AttemptContent extends StatelessWidget {
  const _AttemptContent({required this.attempts});

  final List<int> attempts;

  @override
  Widget build(BuildContext context) {
    final maxValue = attempts.reduce(max) + 1;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shrinkWrap: true,
      itemCount: attempts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (context, index) => FractionallySizedBox(
        alignment: Alignment.topLeft,
        widthFactor: (attempts[index] + 1) / maxValue,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          height: 20,
          child: Text(
            ' ${attempts[index]}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
