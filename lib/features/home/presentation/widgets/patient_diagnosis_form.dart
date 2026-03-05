import 'dart:io';
import 'package:final_project/core/functions/image_picker.dart';
import 'package:final_project/features/diagnosis/presentation/cubits/diagnosis_cubit/diagnosis_cubit.dart';
import 'package:final_project/features/home/presentation/widgets/patient_gender_selection.dart';
import 'package:final_project/features/home/presentation/widgets/patient_image_selection.dart';
import 'package:final_project/features/home/presentation/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientDiagnosisForm extends StatefulWidget {
  const PatientDiagnosisForm({super.key});

  @override
  State<PatientDiagnosisForm> createState() => _PatientDiagnosisFormState();
}

class _PatientDiagnosisFormState extends State<PatientDiagnosisForm> {
  bool _isMale = true; // true for Male, false for Female
  File? _selectedImage;



  void _pickImage(bool fromCamera) async {
    String? imagePath = fromCamera
        ? await pickImageFromCamera()
        : await pickImageFromGallery();

    if (imagePath != null) {
      setState(() {
        _selectedImage = File(imagePath);
      });
    }
  }

  void _submitData(DiagnosisCubit diagnosisCubit) {
    if (diagnosisCubit.formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select an MRI image first.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      diagnosisCubit.getPrediction(
        _selectedImage!,
        diagnosisCubit.nameController.text,
        int.parse(diagnosisCubit.ageController.text),
        _isMale ? "Male" : "Female",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final diagnosisCubit = context.read<DiagnosisCubit>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: diagnosisCubit.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient & Diagnosis Detail',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? theme.colorScheme.onSurface.withOpacity(0.9)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            _PatientNameField(controller: diagnosisCubit.nameController),
            const SizedBox(height: 16),
            _PatientAgeField(controller: diagnosisCubit.ageController),
            const SizedBox(height: 20),
            PatientGenderSelection(
              isMale: _isMale,
              onChanged: (value) => setState(() => _isMale = value),
            ),
            const SizedBox(height: 24),
            Divider(color: theme.colorScheme.outline.withOpacity(0.3)),
            const SizedBox(height: 16),
            PatientImageSelection(
              selectedImage: _selectedImage,
              onPickImage: _pickImage,
            ),
            const SizedBox(height: 32),
            SubmitButton(onPressed: () => _submitData(diagnosisCubit)),
          ],
        ),
      ),
    );
  }
}

class _PatientNameField extends StatelessWidget {
  final TextEditingController controller;

  const _PatientNameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Full Name',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.person_outline),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter the patient name';
        }
        return null;
      },
    );
  }
}

class _PatientAgeField extends StatelessWidget {
  final TextEditingController controller;

  const _PatientAgeField({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Age',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.calendar_today_outlined),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter the age';
        }
        if (int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }
}
