import 'package:flutter/material.dart';
import 'package:game_app/Constants/AppConstants.dart';
import 'package:game_app/Models/letter_info.dart';
import 'package:game_app/Widgets/LetterTile.dart';
import '../Constants/MyColors.dart';
import 'package:get/get.dart';

class Tutorial extends StatelessWidget {
  const Tutorial({super.key});

  @override
  Widget build(BuildContext context) {
    var previousRoute = Get.previousRoute;
    return Scaffold(
      appBar: AppBar(
        title: (previousRoute.isEmpty)
            ? Stack(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "How to play",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      )
                    ],
                  ),
                  Positioned(
                      left: 0,
                      bottom: 0,
                      top: 0,
                      child: IconButton(onPressed: (){
                        Get.offAllNamed(AppConstants.homePage);
                      }, icon: const Icon(
                        Icons.close,
                        size: 30,
                      ))),
                ],
              )
            : const Text(
                "How to play",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Guess the WORD in 6 tries.",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '\u2022'),
                    WidgetSpan(child: SizedBox(width: 6)),
                    TextSpan(
                        text:
                            "Each guess must be a valid 5 letter word. Hit the enter button to submit."),
                  ],
                ),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '\u2022'),
                    WidgetSpan(child: SizedBox(width: 6)),
                    TextSpan(
                        text:
                            "After each guess, the color of the tiles will change to show how to close your guess was he word."),
                  ],
                ),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.secondary),
              const SizedBox(height: 16),
              const Text(
                "Examples",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              ListOfLetters(list: AppConstants.tutorialList.$1),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "The letter P in the word and in the correct spot.",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              ListOfLetters(list: AppConstants.tutorialList.$2),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "The letter A in the word but in the wrong spot.",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              ListOfLetters(list: AppConstants.tutorialList.$3),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "The letter E is not in the word in any spot.",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListOfLetters extends StatelessWidget {
  final List<LetterInfo> list;
  const ListOfLetters({super.key,required this.list});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 350, maxHeight: 60),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          var letter = list[index];
          return LetterTile(
            letter: letter,
            selected: (index == 0),
            color: AppColors.green,
          );
        },
      ),
    );
  }
}

