import 'dart:io';
import 'package:final_project/core/functions/image_picker.dart';
import 'package:final_project/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientDiagnosisForm extends StatefulWidget {
  const PatientDiagnosisForm({super.key});

  @override
  State<PatientDiagnosisForm> createState() => _PatientDiagnosisFormState();
}

class _PatientDiagnosisFormState extends State<PatientDiagnosisForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isMale = true; // true for Male, false for Female
  File? _selectedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

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

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select an MRI image first.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      // At this point form is valid and image is selected.
      // We trigger the cubit to get the prediction.
      // Note: The UI for Name, Age, Gender is captured but currently the prediction API
      // only takes the image. We can pass the patient data to the success screen later if requested.
      context.read<HomeCubit>().getPrediction(_selectedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        key: _formKey,
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

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest
                    .withOpacity(0.3),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the patient name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Age Field
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest
                    .withOpacity(0.3),
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
            ),
            const SizedBox(height: 20),

            // Gender Selection
            Text(
              'Gender',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? theme.colorScheme.onSurface.withOpacity(0.8)
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isMale = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isMale
                            ? theme.colorScheme.primary.withOpacity(0.1)
                            : Colors.transparent,
                        border: Border.all(
                          color: _isMale
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.male,
                            color: _isMale
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Male',
                            style: TextStyle(
                              color: _isMale
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                              fontWeight: _isMale
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isMale = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isMale
                            ? theme.colorScheme.primary.withOpacity(0.1)
                            : Colors.transparent,
                        border: Border.all(
                          color: !_isMale
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.female,
                            color: !_isMale
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Female',
                            style: TextStyle(
                              color: !_isMale
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                              fontWeight: !_isMale
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Divider(color: theme.colorScheme.outline.withOpacity(0.3)),
            const SizedBox(height: 16),

            // Image Selection Area
            Text(
              'MRI Image',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? theme.colorScheme.onSurface.withOpacity(0.8)
                    : null,
              ),
            ),
            const SizedBox(height: 12),

            if (_selectedImage != null)
              // Image Preview
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _selectedImage!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _pickImage(false),
                    onLongPress: () => _pickImage(true),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Change Image'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              )
            else
              // Upload Area
              GestureDetector(
                onTap: () => _pickImage(false),
                onLongPress: () => _pickImage(true),
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer.withOpacity(
                      0.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: theme.colorScheme.primary.withOpacity(
                          0.1,
                        ),
                        child: Icon(
                          Icons.cloud_upload_outlined,
                          size: 30,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tap to upload MRI Image',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Long press for Camera',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Start Diagnosis',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
