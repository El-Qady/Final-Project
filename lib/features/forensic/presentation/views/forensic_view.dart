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
                    color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.primary,
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
                          onPressed: () => _submitData(context.read<ForensicCubit>()),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
