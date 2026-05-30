import 'dart:io';
import '../../../data/models/ct_analyze_response.dart';
import '../../../data/models/ct_verify_response.dart';

abstract class CtDiagnosisState {
  const CtDiagnosisState();
}

class CtDiagnosisInitial extends CtDiagnosisState {
  final File? selectedImage;
  final String gender;

  const CtDiagnosisInitial({this.selectedImage, this.gender = 'Male'});

  CtDiagnosisInitial copyWith({
    File? selectedImage,
    bool clearImage = false,
    String? gender,
  }) {
    return CtDiagnosisInitial(
      selectedImage: clearImage ? null : selectedImage ?? this.selectedImage,
      gender: gender ?? this.gender,
    );
  }
}

class CtDiagnosisAnalyzeLoading extends CtDiagnosisState {
  const CtDiagnosisAnalyzeLoading();
}

class CtDiagnosisAnalyzeFailure extends CtDiagnosisState {
  final String errorMessage;
  const CtDiagnosisAnalyzeFailure({required this.errorMessage});
}

class CtDiagnosisShowQuestionsSheet extends CtDiagnosisState {
  final File image;
  final CtAnalyzeResponse analyzeResponse;
  final Map<String, bool> answers;

  const CtDiagnosisShowQuestionsSheet({
    required this.image,
    required this.analyzeResponse,
    required this.answers,
  });

  CtDiagnosisShowQuestionsSheet copyWith({
    File? image,
    CtAnalyzeResponse? analyzeResponse,
    Map<String, bool>? answers,
  }) {
    return CtDiagnosisShowQuestionsSheet(
      image: image ?? this.image,
      analyzeResponse: analyzeResponse ?? this.analyzeResponse,
      answers: answers ?? this.answers,
    );
  }
}

class CtDiagnosisVerifyLoading extends CtDiagnosisState {
  final File image;
  final CtAnalyzeResponse analyzeResponse;
  final Map<String, bool> answers;

  const CtDiagnosisVerifyLoading({
    required this.image,
    required this.analyzeResponse,
    required this.answers,
  });
}

class CtDiagnosisSuccessResult extends CtDiagnosisState {
  final File image;
  final CtAnalyzeResponse? analyzeResponse;
  final CtVerifyResponse? verifyResponse;

  const CtDiagnosisSuccessResult({
    required this.image,
    this.analyzeResponse,
    this.verifyResponse,
  });
}


