import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/ct_diagnosis_cubit/ct_diagnosis_cubit.dart';
import '../../../../core/utils/app_colors.dart';

class CtDiagnosisResultWidget extends StatelessWidget {
  final File image;
  final String patientName;
  final String patientAge;
  final String patientGender;
  final String diagnosisName;
  final String severity;
  final double confidencePct;
  final double? initialConfidencePct;
  final double? updatedConfidencePct;
  final List<String> requiredTests;
  final List<String> recommendations;
  final String explanation;

  const CtDiagnosisResultWidget({
    super.key,
    required this.image,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.diagnosisName,
    required this.severity,
    required this.confidencePct,
    this.initialConfidencePct,
    this.updatedConfidencePct,
    required this.requiredTests,
    required this.recommendations,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color severityColor;
    Color severityBgColor;
    switch (severity.toLowerCase()) {
      case 'high':
        severityColor = const Color(0xffDC2626);
        severityBgColor = const Color(0xffFEE2E2);
        break;
      case 'medium':
        severityColor = const Color(0xffD97706);
        severityBgColor = const Color(0xffFEF3C7);
        break;
      default:
        severityColor = const Color(0xff0D9488);
        severityBgColor = const Color(0xffCCFBF1);
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // Image Display
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black45 : Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(image, fit: BoxFit.cover),
                // Premium Gradient overlay
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black26,
                        Colors.black87,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: Colors.white.withValues(alpha: 0.8)),
                          const SizedBox(width: 4),
                          Text(
                            '$patientAge Yrs',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.transgender, size: 14, color: Colors.white.withValues(alpha: 0.8)),
                          const SizedBox(width: 4),
                          Text(
                            patientGender,
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Diagnosis Summary Card
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          color: isDark ? theme.colorScheme.surface : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Primary Diagnosis',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: severityBgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$severity Severity',
                        style: TextStyle(
                          color: severityColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  diagnosisName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),

                // Confidence adjustment / gauge
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            initialConfidencePct != null ? 'Confidence Adjustment' : 'Model Confidence',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (initialConfidencePct != null && updatedConfidencePct != null)
                            Row(
                              children: [
                                Text(
                                  '${initialConfidencePct!.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${updatedConfidencePct!.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              '${confidencePct.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 22,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Circular progress representation
                    SizedBox(
                      height: 54,
                      width: 54,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: (updatedConfidencePct ?? confidencePct) / 100,
                            backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.15),
                            color: theme.colorScheme.primary,
                            strokeWidth: 6,
                          ),
                          Center(
                            child: Icon(
                              Icons.psychology,
                              color: theme.colorScheme.primary,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Explanation Card
        if (explanation.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.findDoctorContainerDarkColor : AppColors.findDoctorContainerColor,
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 4,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Clinical Explanation',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  explanation,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Required Tests Section
        if (requiredTests.isNotEmpty) ...[
          _buildDetailList(
            context,
            title: 'Suggested Diagnostic Tests',
            items: requiredTests,
            icon: Icons.science,
            accentColor: Colors.deepPurple,
          ),
          const SizedBox(height: 16),
        ],

        // Recommendations Section
        if (recommendations.isNotEmpty) ...[
          _buildDetailList(
            context,
            title: 'Medical Recommendations',
            items: recommendations,
            icon: Icons.medical_services,
            accentColor: Colors.teal.shade700,
          ),
          const SizedBox(height: 16),
        ],

        // New diagnosis button
        ElevatedButton.icon(
          onPressed: () => context.read<CtDiagnosisCubit>().reset(),
          icon: const Icon(Icons.refresh),
          label: const Text('Perform New Diagnosis'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDetailList(
    BuildContext context, {
    required String title,
    required List<String> items,
    required IconData icon,
    required Color accentColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      color: isDark ? theme.colorScheme.surface : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
