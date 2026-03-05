
import 'package:final_project/features/diagnosis/data/models/diagnosis_model.dart';

abstract class DiagnosisState {}

final class DiagnosisInitial extends DiagnosisState {}
final class DiagnosisLoading extends DiagnosisState {}

final class DiagnosisFailure extends DiagnosisState {
  final String message;
  DiagnosisFailure({required this.message});
}

final class DiagnosisSuccess extends DiagnosisState {
  final DiagnosisModel diagnosisModel;
  DiagnosisSuccess({required this.diagnosisModel});
}