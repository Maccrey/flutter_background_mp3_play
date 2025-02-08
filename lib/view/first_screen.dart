import 'package:flutter/material.dart';
import 'package:white_noise_backgraund_play_module/view/whitenoise_player_screen.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FirstScreen'),
      ),
      body: Center(
          child: ElevatedButton(
              //           Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => WhiteNoiseScreen()),
              // );
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WhiteNoiseScreen()),
                );
              },
              child: Text("Wite Noise"))),
    );
  }
}
