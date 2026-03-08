import 'package:final_project/core/utils/app_text_styles.dart';
import 'package:final_project/features/home/data/models/doctors_model.dart';
import 'package:final_project/features/home/presentation/widgets/custom_doctor_card.dart';
import 'package:flutter/material.dart';

class DoctorsView extends StatelessWidget {
  const DoctorsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Doctors",
          style: AppTextStyles.inter700style20.copyWith(
            color: isDark ? theme.colorScheme.onSurface.withOpacity(0.7) : null,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: DoctorsModel.doctors.length,
        itemBuilder: (context, index) {
          final doctor = DoctorsModel.doctors[index];
          return CustomDoctorCard(doctor: doctor);
        },
      ),
    );
  }
}
