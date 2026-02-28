import 'package:flutter/material.dart';

class CustomBrainImage extends StatelessWidget {
  const CustomBrainImage({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 152, 96, 189),
            Color(0xffc8e4fe),
            Color.fromARGB(255, 255, 255, 255),
            Color(0xff549de3),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ).createShader(bounds);
      },
      blendMode: BlendMode.modulate,
      child: Opacity(
        opacity: 0.9,
        child: Image.asset(
          'assets/images/brain_splash.png',
          height: h * 0.5,
          width: w * 0.6,
        ),
      ),
    );
  }
}
