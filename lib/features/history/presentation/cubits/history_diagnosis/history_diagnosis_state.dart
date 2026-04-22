import 'package:final_project/features/diagnosis/data/models/diagnosis_model.dart';

abstract class HistoryDiagnosisState {}

final class HistoryDiagnosisInitial extends HistoryDiagnosisState {}

final class DiangonosisHistoryLoading extends HistoryDiagnosisState {}

final class DiangonosisHistorySuccess extends HistoryDiagnosisState {
  final DiagnosisModel diagnosisModel;

  DiangonosisHistorySuccess({required this.diagnosisModel});
}

final class DiagonosisHistoryFailure extends HistoryDiagnosisState {
  final String message;
  DiagonosisHistoryFailure(this.message);
}
