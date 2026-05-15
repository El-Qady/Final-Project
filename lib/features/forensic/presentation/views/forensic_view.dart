import 'dart:io';
import 'package:final_project/core/functions/image_picker.dart';
import 'package:final_project/core/functions/show_toast.dart';
import 'package:final_project/core/utils/app_text_styles.dart';
import 'package:final_project/features/forensic/presentation/cubits/forensic_cubit/forensic_cubit.dart';
import 'package:final_project/features/forensic/presentation/cubits/forensic_cubit/forensic_state.dart';
import 'package:final_project/features/home/presentation/widgets/patient_image_selection.dart';
import 'package:final_project/features/home/presentation/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForensicView extends StatefulWidget {
  const ForensicView({super.key});

  @override
  State<ForensicView> createState() => _ForensicViewState();
}

class _ForensicViewState extends State<ForensicView> {
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    context.read<ForensicCubit>().reset();
  }

  void _pickImage(bool fromCamera) async {
    String? imagePath = fromCamera
        ? await pickImageFromCamera()
        : await pickImageFromGallery();

    if (imagePath != null) {
      setState(() {
        _selectedImage = File(imagePath);
      });
      // Reset cubit state when a new image is picked
      if (mounted) {
        context.read<ForensicCubit>().reset();
      }
    }
  }

  void _submitData(ForensicCubit cubit) {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select an image first.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    cubit.getForensicPrediction(_selectedImage!);
  }

  Widget _buildReportSection(String report, ThemeData theme, bool isDark) {
    if (report.trim().isEmpty) return const SizedBox.shrink();

    List<String> blocks = report.trim().split('\n\n');
    
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Detailed Report',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...blocks.map((block) {
            String trimmedBlock = block.trim();
            if (trimmedBlock.isEmpty) return const SizedBox.shrink();

            bool isHeading = !trimmedBlock.contains('\n') && trimmedBlock.length < 60;
            
            if (isHeading) {
              return Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                child: Text(
                  trimmedBlock,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              );
            } else {
              List<String> sentences = trimmedBlock.split('\n');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sentences.map((sentence) {
                  if (sentence.trim().isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary.withOpacity(0.7),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            sentence.trim(),
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white70 : Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          'Forensic Diagnosis',
          style: AppTextStyles.inter700style20.copyWith(
            color: isDark ? theme.colorScheme.onSurface.withOpacity(0.9) : null,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ForensicCubit, ForensicState>(
        listener: (context, state) {
          if (state is ForensicFailure) {
            showToast(
              context,
              message: state.message,
              backgroundColor: theme.colorScheme.error,
              shadowColor: theme.colorScheme.error.withOpacity(0.4),
              icon: Icons.error,
            );
          } else if (state is ForensicSuccess) {
            showToast(
              context,
              message: "Diagnosis Completed Successfully 😊",
              backgroundColor: theme.colorScheme.primary,
              shadowColor: theme.colorScheme.primary.withOpacity(0.4),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Upload Evidence Image',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Please provide a clear image for forensic analysis.',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Image Selection Area
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black26 : Colors.black12,
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      PatientImageSelection(
                        selectedImage: _selectedImage,
                        onPickImage: _pickImage,
                      ),
                      const SizedBox(height: 32),
                      if (state is ForensicLoading)
                        Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                          ),
                        )
                      else
                        SubmitButton(
                          onPressed: () =>
                              _submitData(context.read<ForensicCubit>()),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Result Area
                if (state is ForensicSuccess)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.1),
                          theme.colorScheme.primary.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Diagnosis Result',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.forensicModel.diagnosis,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Confidence: ${state.forensicModel.confidence.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (state.forensicModel.report != null && state.forensicModel.report!.isNotEmpty)
                          _buildReportSection(state.forensicModel.report!, theme, isDark),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
