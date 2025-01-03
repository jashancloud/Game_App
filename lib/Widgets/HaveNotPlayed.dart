import 'package:flutter/material.dart';

class HaveNotPlayed extends StatelessWidget {
  const HaveNotPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 36),
        child: Text(
          "You haven\'t played a single game",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
