import 'package:final_project/core/functions/show_toast.dart';
import 'package:final_project/core/utils/app_strings.dart';
import 'package:final_project/core/utils/app_text_styles.dart';
import 'package:final_project/features/diagnosis/presentation/cubits/diagnosis_cubit/diagnosis_cubit.dart';
import 'package:final_project/features/diagnosis/presentation/cubits/diagnosis_cubit/diagnosis_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';

class CustomButtons extends StatelessWidget {
  const CustomButtons({super.key, required this.onPress});
  final VoidCallback? onPress;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return BlocConsumer<DiagnosisCubit, DiagnosisState>(
      listener: (context, state) {
        if (state is DiagnosisDownloadFailure) {
          showToast(
            context,
            message: state.message,
            backgroundColor: Colors.red,
            shadowColor: Colors.red.shade200,
            icon: Icons.error,
          );
        }

        if (state is DiagnosisDownloadSuccess) {
          showToast(
            context,
            message: 'Report downloaded successfully',
            backgroundColor: Colors.green,
            shadowColor: Colors.green.shade200,
            icon: Icons.check,
          );

          OpenFilex.open(state.file.path);
        }
      },
      builder: (context, state) {
        if (state is DiagnosisDownloadLoading ||
            state is DiagnosisDownloadProgress) {
          final progress = state is DiagnosisDownloadProgress
              ? state.progress
              : 0.0;
          final theme = Theme.of(context);
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: h * 0.08,
              width: w * 0.9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress > 0 ? progress : null,
                      minHeight: h * 0.08,
                      backgroundColor: theme.colorScheme.primaryContainer
                          .withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary.withOpacity(0.4),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          value: progress > 0 ? progress : null,
                          strokeWidth: 3,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        progress > 0
                            ? 'Downloading... ${(progress * 100).toInt()}%'
                            : 'Preparing Download...',
                        style: AppTextStyles.inter800style40shadow.copyWith(
                          fontSize: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: onPress,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(w * 0.9, h * 0.05),
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.download, size: 27),
                const SizedBox(width: 12),
                Text(
                  AppStrings.downloadReport,
                  style: AppTextStyles.inter800style40shadow.copyWith(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
