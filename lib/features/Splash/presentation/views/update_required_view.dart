import 'package:final_project/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UpdateRequiredView extends StatelessWidget {
  const UpdateRequiredView({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xffc8e4fe),
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
              Color(0xffc1e1fd),
            ],
            stops: [0.1, 0.22, 0.75, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 5, 2, 172),
                        Color.fromARGB(255, 85, 165, 241),
                      ],
                      stops: [0, 0.9],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcIn,
                  child: const Icon(Icons.system_update_rounded, size: 150),
                ),
                SizedBox(height: h * 0.05),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 5, 2, 172),
                        Color.fromARGB(255, 85, 165, 241),
                      ],
                      stops: [0, 0.9],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    "تحديث مطلوب",
                    style: AppTextStyles.inter800style40shadow.copyWith(
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: h * 0.02),
                Text(
                  "نسختك الحالية متوقفة. يرجى تحديث التطبيق إلى آخر إصدار لمتابعة استخدام Mokhi والاستفادة من أحدث الميزات والإصلاحات.",
                  style: AppTextStyles.inter400style16.copyWith(
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: h * 0.06),
                Container(
                  width: w * 0.7,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 5, 2, 172),
                        Color.fromARGB(255, 85, 165, 241),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Static button as requested for now
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "تحديث الآن",
                      style: AppTextStyles.inter700style20.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
