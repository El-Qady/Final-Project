import 'package:final_project/features/About/presentation/widgets/team_cards.dart';
import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 🔵 Gradient Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff4a78b8), Color(0xff2e4f9e)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.surface,
                    backgroundImage: Image.asset(
                      'assets/images/brain_splash.png',
                      height: 10,
                      width: 10,
                    ).image,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Mokhi App",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "AI-Powered Brain MRI Analysis",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// 🧠 About Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("About The App"),
                  const SizedBox(height: 8),
                  const Text(
                    "Mokhi is an AI-powered app that analyzes MRI brain images using deep learning "
                    "to assist doctors in detecting and treating diseases efficiently.",
                  ),

                  const SizedBox(height: 25),

                  sectionTitle("Graduation Project"),
                  const SizedBox(height: 8),
                  const Text("Supervisor: Dr. Nahla Fathy"),
                  const Text("Assistant: Dr. Randa Mohamed"),
                  const Text("University: South Valley National University"),
                  const Text("Year: 2026"),

                  const SizedBox(height: 25),

                  sectionTitle("Our Team"),
                  const SizedBox(height: 10),

                  TeamCards(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
