import 'dart:io';

import 'package:final_project/core/functions/image_picker.dart';
import 'package:final_project/features/ct_diagnosis/data/models/ct_analyze_response.dart';
import 'package:final_project/features/ct_diagnosis/data/services/ct_api_service.dart';
import 'package:final_project/features/ct_diagnosis/presentation/cubits/ct_diagnosis_cubit/ct_diagnosis_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CtDiagnosisCubit extends Cubit<CtDiagnosisState> {
  CtDiagnosisCubit() : super(const CtDiagnosisInitial(gender: 'Male'));

  final CtApiService _apiService = CtApiService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  Future<void> pickImage(bool fromCamera) async {
    if (state is! CtDiagnosisInitial) return;
    final currentState = state as CtDiagnosisInitial;

    final imagePath = fromCamera
        ? await pickImageFromCamera()
        : await pickImageFromGallery();

    if (imagePath == null) return;

    emit(currentState.copyWith(selectedImage: File(imagePath)));
  }

  void changeGender(String gender) {
    if (state is! CtDiagnosisInitial) return;
    final currentState = state as CtDiagnosisInitial;
    emit(currentState.copyWith(gender: gender));
  }

  void changeAnswer(String symptom, bool answer) {
    if (state is! CtDiagnosisShowQuestionsSheet) return;
    final currentState = state as CtDiagnosisShowQuestionsSheet;

    final updatedAnswers = Map<String, bool>.from(currentState.answers);
    updatedAnswers[symptom] = answer;
    emit(currentState.copyWith(answers: updatedAnswers));
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the patient name';
    }
    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the age';
    }

    final age = int.tryParse(value);
    if (age == null || age <= 0 || age > 120) {
      return 'Enter a valid age';
    }

    return null;
  }

  Future<void> performInitialAnalysis() async {
    if (state is! CtDiagnosisInitial) return;
    final currentState = state as CtDiagnosisInitial;

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (currentState.selectedImage == null) {
      emit(const CtDiagnosisAnalyzeFailure(errorMessage: 'Please select a CT brain image first.'));
      // Emit the initial state again to restore form interactions
      emit(currentState);
      return;
    }

    final File image = currentState.selectedImage!;
    final String gender = currentState.gender;
    final String name = nameController.text.trim();
    final String age = ageController.text.trim();

    emit(const CtDiagnosisAnalyzeLoading());

    try {
      final response = await _apiService.analyzeImage(
        imageFile: image,
        name: name,
        age: age,
        gender: gender,
      );

      if (!response.success) {
        emit(const CtDiagnosisAnalyzeFailure(errorMessage: 'this image is not ct'));
        emit(currentState);
        return;
      }

      if (response.verificationRequired) {
        final Map<String, bool> initialAnswers = {};
        for (var q in response.questions) {
          initialAnswers[q.symptom] = false;
        }
        emit(CtDiagnosisShowQuestionsSheet(
          image: image,
          analyzeResponse: response,
          answers: initialAnswers,
        ));
      } else {
        emit(CtDiagnosisSuccessResult(
          image: image,
          analyzeResponse: response,
        ));
      }
    } catch (e) {
      emit(CtDiagnosisAnalyzeFailure(errorMessage: 'Analysis failed: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> submitVerification() async {
    final currentState = state;
    if (currentState is! CtDiagnosisShowQuestionsSheet) return;

    final File image = currentState.image;
    final CtAnalyzeResponse analyzeRes = currentState.analyzeResponse;
    final Map<String, bool> answers = currentState.answers;

    emit(CtDiagnosisVerifyLoading(
      image: image,
      analyzeResponse: analyzeRes,
      answers: answers,
    ));

    try {
      final verifyRes = await _apiService.verifySymptoms(
        resultId: analyzeRes.resultId,
        diagnosis: analyzeRes.diagnosis,
        patient: analyzeRes.patient,
        initialConfidencePct: analyzeRes.confidencePct,
        answers: answers,
      );

      emit(CtDiagnosisSuccessResult(
        image: image,
        verifyResponse: verifyRes,
      ));
    } catch (e) {
      emit(const CtDiagnosisAnalyzeFailure(errorMessage: 'Verification failed. Please try again.'));
      // Restore the question sheet state so the user can try again
      emit(currentState);
    }
  }

  void reset() {
    nameController.clear();
    ageController.clear();
    emit(const CtDiagnosisInitial(gender: 'Male'));
  }

  @override
  Future<void> close() {
    nameController.dispose();
    ageController.dispose();
    return super.close();
  }
}

