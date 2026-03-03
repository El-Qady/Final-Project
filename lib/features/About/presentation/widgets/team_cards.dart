import 'package:final_project/features/About/presentation/widgets/team_card.dart';
import 'package:flutter/material.dart';

class TeamCards extends StatelessWidget {
  const TeamCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TeamCard(
          name: "Ahmed Zakaria",
          position: "Flutter Developer",
          imagePath: "assets/images/avatar_boy.png",
        ),

        TeamCard(
          name: "Ehab Galal",
          position: "Flutter Developer",
          imagePath: "assets/images/avatar_boy.png",
        ),

        TeamCard(
          name: "Elsayed Mamdouh",
          position: "Backend Python Developer",
          imagePath: "assets/images/avatar_boy.png",
        ),
        TeamCard(
          name: "Antonious Malak",
          position: "AI Engineer",
          imagePath: "assets/images/avatar_boy.png",
        ),
        TeamCard(
          name: "Mariam Ramadan",
          position: "AI Engineer",
          imagePath: "assets/images/avatar_girl.png",
        ),
        TeamCard(
          name: "Nourhan Karam",
          position: "AI Engineer",
          imagePath: "assets/images/avatar_girl.png",
        ),
        TeamCard(
          name: "Mariam Ahmed",
          position: "AI Engineer",
          imagePath: "assets/images/avatar_girl.png",
        ),
        TeamCard(
          name: "Yasmen Darwish",
          position: "AI Engineer",
          imagePath: "assets/images/avatar_girl.png",
        ),
        TeamCard(
          name: "Esraa Eissawy",
          position: "AI Engineer",
          imagePath: "assets/images/avatar_girl.png",
        ),
      ],
    );
  }
}
