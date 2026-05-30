import 'dart:io';

import 'package:final_project/features/ct_diagnosis/presentation/cubits/ct_diagnosis_cubit/ct_diagnosis_cubit.dart';
import 'package:final_project/features/ct_diagnosis/presentation/cubits/ct_diagnosis_cubit/ct_diagnosis_state.dart';
import 'package:final_project/features/ct_diagnosis/presentation/widgets/ct_diagnosis_button.dart';
import 'package:final_project/features/ct_diagnosis/presentation/widgets/ct_patient_details_section.dart';
import 'package:final_project/features/ct_diagnosis/presentation/widgets/ct_upload_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CtDiagnosisForm extends StatelessWidget {
  const CtDiagnosisForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CtDiagnosisCubit>();

    return BlocBuilder<CtDiagnosisCubit, CtDiagnosisState>(
      builder: (context, state) {
        File? selectedImage;
        String gender = 'Male';

        if (state is CtDiagnosisInitial) {
          selectedImage = state.selectedImage;
          gender = state.gender;
        } else if (state is CtDiagnosisShowQuestionsSheet) {
          selectedImage = state.image;
          final apiGender = state.analyzeResponse.patient.gender.toLowerCase();
          gender = apiGender == 'female' ? 'Female' : 'Male';
        } else if (state is CtDiagnosisVerifyLoading) {
          selectedImage = state.image;
          final apiGender = state.analyzeResponse.patient.gender.toLowerCase();
          gender = apiGender == 'female' ? 'Female' : 'Male';
        }

        return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(12),
          children: [
            Form(
              key: cubit.formKey,
              child: Column(
                children: [
                  CtUploadCard(
                    selectedImage: selectedImage,
                    onPickImage: cubit.pickImage,
                  ),
                  const SizedBox(height: 12),
                  CtPatientDetailsSection(gender: gender),
                  const SizedBox(height: 24),
                  CtDiagnosisButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      cubit.performInitialAnalysis();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}


