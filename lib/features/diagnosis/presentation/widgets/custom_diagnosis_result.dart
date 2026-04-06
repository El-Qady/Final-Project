import 'package:final_project/core/utils/app_colors.dart';
import 'package:final_project/core/utils/app_strings.dart';
import 'package:final_project/core/utils/app_text_styles.dart';
import 'package:final_project/features/diagnosis/data/models/diagnosis_model.dart';
import 'package:flutter/material.dart';

class CustomDiagnosisResult extends StatelessWidget {
  const CustomDiagnosisResult({super.key, required this.result});

  final DiagnosisModel result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              AppStrings.diagnosisResults,
              style: AppTextStyles.inter700style20.copyWith(
                fontSize: 18,
                color: isDark ? theme.colorScheme.onSurface : null,
              ),
            ),
          ),
          SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              AppStrings.aiModelPrediction,
              style: AppTextStyles.interRegularstyle12.copyWith(
                fontSize: 14,
                color: isDark
                    ? theme.colorScheme.onSurface.withOpacity(0.6)
                    : null,
              ),
            ),
          ),
          SizedBox(height: 16),
          Divider(
            color: isDark
                ? theme.colorScheme.outlineVariant
                : const Color(0xffE5E7EB),
          ),
          SizedBox(height: 6),
          Container(
            padding: EdgeInsets.all(17),
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: isDark
                  ? AppColors.findDoctorContainerDarkColor
                  : AppColors.findDoctorContainerColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: AppColors.primaryColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Primary Diagnosis',
                      style: AppTextStyles.interMediumstyle16.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        '${(result.confidence)} %',
                        style: AppTextStyles.interMediumstyle16.copyWith(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  result.diagnosis,
                  style: AppTextStyles.inter700style20.copyWith(
                    fontSize: 20,
                    color: isDark ? theme.colorScheme.onSurface : null,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  result.returnDescription(result.diagnosis),
                  style: AppTextStyles.inter400style16.copyWith(
                    fontSize: 14,
                    color: isDark
                        ? theme.colorScheme.onSurface.withOpacity(0.7)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
