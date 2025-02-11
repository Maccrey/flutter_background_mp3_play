import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_noise_backgraund_play_module/view/whitenoise_player_screen.dart';
import 'drawer_white_noise_controller.dart';

class FirstScreen extends ConsumerWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('FirstScreen'), automaticallyImplyLeading: false),
      drawer: DrewerWhiteNoiseController(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WhiteNoiseScreen()),
            );
          },
          child: const Text("White Noise"),
        ),
      ),
    );
  }
}
