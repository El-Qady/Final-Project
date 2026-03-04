import 'package:final_project/features/home/data/models/diagnosis_model.dart';

abstract class HomeState {}

final class HomeInitial extends HomeState {}

final class DiagnosisLoading extends HomeState {}

final class DiagnosisFailure extends HomeState {
  final String message;
  DiagnosisFailure({required this.message});
}

final class DiagnosisSuccess extends HomeState {
  final DiagnosisModel diagnosisModel;
  DiagnosisSuccess({required this.diagnosisModel});
}
