import 'package:final_project/core/functions/show_toast.dart';
import 'package:final_project/core/utils/app_text_styles.dart';
import 'package:final_project/features/ct_diagnosis/presentation/cubits/ct_diagnosis_cubit/ct_diagnosis_cubit.dart';
import 'package:final_project/features/ct_diagnosis/presentation/cubits/ct_diagnosis_cubit/ct_diagnosis_state.dart';
import 'package:final_project/features/ct_diagnosis/presentation/widgets/ct_diagnosis_form.dart';
import 'package:final_project/features/ct_diagnosis/presentation/widgets/ct_diagnosis_result_widget.dart';
import 'package:final_project/features/ct_diagnosis/presentation/widgets/ct_symptom_sheet.dart';
import 'package:final_project/features/home/presentation/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CtDiagnosisView extends StatelessWidget {
  const CtDiagnosisView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CtDiagnosisCubit(),
      child: const _CtDiagnosisViewBody(),
    );
  }
}

class _CtDiagnosisViewBody extends StatefulWidget {
  const _CtDiagnosisViewBody();

  @override
  State<_CtDiagnosisViewBody> createState() => _CtDiagnosisViewBodyState();
}

class _CtDiagnosisViewBodyState extends State<_CtDiagnosisViewBody> {
  bool _isSheetOpen = false;

  void _showSymptomSheet(BuildContext context) {
    if (_isSheetOpen) return;
    _isSheetOpen = true;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: context.read<CtDiagnosisCubit>(),
          child: const CtSymptomSheet(),
        );
      },
    ).then((_) {
      _isSheetOpen = false;
      if (mounted) {
        final cubit = context.read<CtDiagnosisCubit>();
        if (cubit.state is CtDiagnosisShowQuestionsSheet ||
            cubit.state is CtDiagnosisVerifyLoading) {
          cubit.reset();
        }
      }
    });
  }

  void _dismissSymptomSheet() {
    if (_isSheetOpen) {
      Navigator.pop(context);
      _isSheetOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<CtDiagnosisCubit, CtDiagnosisState>(
      listener: (context, state) {
        if (state is CtDiagnosisAnalyzeFailure) {
          showToast(
            context,
            message: state.errorMessage,
            backgroundColor: theme.colorScheme.error,
            shadowColor: theme.colorScheme.error.withValues(alpha: 0.4),
            icon: Icons.error,
          );
        } else if (state is CtDiagnosisShowQuestionsSheet) {
          _showSymptomSheet(context);
        } else if (state is CtDiagnosisSuccessResult) {
          _dismissSymptomSheet();
          showToast(
            context,
            message: 'Diagnosis Completed Successfully!',
            backgroundColor: theme.colorScheme.primary,
            shadowColor: theme.colorScheme.primary.withValues(alpha: 0.4),
          );
        }
      },
      builder: (context, state) {
        Widget body;

        if (state is CtDiagnosisAnalyzeLoading) {
          body = Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Analyzing brain CT scan...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          );
        } else if (state is CtDiagnosisSuccessResult) {
          final analyze = state.analyzeResponse;
          final verify = state.verifyResponse;

          if (verify != null) {
            body = CtDiagnosisResultWidget(
              image: state.image,
              patientName: verify.patient.name,
              patientAge: verify.patient.age.toString(),
              patientGender: verify.patient.gender,
              diagnosisName: verify.displayName,
              severity: verify.severity,
              confidencePct: verify.confidencePct,
              initialConfidencePct: verify.initialConfidencePct,
              updatedConfidencePct: verify.updatedConfidencePct,
              requiredTests: verify.requiredTests,
              recommendations: verify.recommendations,
              explanation: verify.explanation,
            );
          } else if (analyze != null) {
            body = CtDiagnosisResultWidget(
              image: state.image,
              patientName: analyze.patient.name,
              patientAge: analyze.patient.age.toString(),
              patientGender: analyze.patient.gender,
              diagnosisName: analyze.displayName,
              severity: analyze.severity,
              confidencePct: analyze.confidencePct,
              requiredTests: analyze.requiredTests,
              recommendations: analyze.recommendations,
              explanation: analyze.explanation,
            );
          } else {
            body = const CtDiagnosisForm();
          }
        } else {
          // Defaults to form (for CtDiagnosisInitial, CtDiagnosisAnalyzeFailure, CtDiagnosisShowQuestionsSheet, CtDiagnosisVerifyLoading)
          body = const CtDiagnosisForm();
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.appBarTheme.backgroundColor,
            centerTitle: true,
            title: Text(
              'Diagnosis CT',
              style: AppTextStyles.inter700style20.copyWith(
                color: isDark
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.8)
                    : null,
              ),
            ),
          ),
          body: body,
        );
      },
    );
  }
}

