import 'package:firstapp/roll_dice_app/gradient_container.dart';
import 'package:flutter/material.dart';

class RollDiceApp extends StatelessWidget {
  const RollDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: GradientContainer(
          colors: [Colors.red, Colors.orange],
        ),
      ),
    );
  }
}
