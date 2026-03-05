import 'package:final_project/core/utils/app_strings.dart';
import 'package:final_project/core/utils/app_text_styles.dart';
import 'package:final_project/features/diagnosis/presentation/widgets/custom_buttons.dart';
import 'package:final_project/features/diagnosis/presentation/widgets/custom_diagnosis_result.dart';
import 'package:final_project/features/diagnosis/presentation/widgets/custom_image_display.dart';
import 'package:final_project/features/diagnosis/presentation/widgets/important_notes.dart';
import 'package:final_project/features/home/data/models/diagnosis_model.dart';
import 'package:flutter/material.dart';

class DiagnosisView extends StatelessWidget {
  const DiagnosisView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    Map<String, dynamic> modelResult =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    DiagnosisModel result = modelResult['diagnosis'];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        child: Icon(Icons.refresh, size: 30, color: theme.colorScheme.primary),
      ),

      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.mriDiagnosis,
              style: AppTextStyles.inter700style20.copyWith(
                color: isDark
                    ? theme.colorScheme.onSurface.withOpacity(0.7)
                    : null,
              ),
            ),
            Text(
              AppStrings.aiPowered,
              style: AppTextStyles.interRegularstyle12.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),

      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          CustomDisplayImage(
            image: result.image,
            name: result.imagename,
            imageUrl: result.imageurl,
          ),
          CustomDiagnosisResult(result: result),
          SizedBox(height: 24),
          CustomImportantNotes(),
          SizedBox(height: 24),
          CustomButtons(),
        ],
      ),
    );
  }
}
