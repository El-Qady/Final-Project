abstract class HistoryDiagnosisState {}

final class HistoryDiagnosisInitial extends HistoryDiagnosisState {}
final class DiangonosisHistoryLoading extends HistoryDiagnosisState {}

final class DiangonosisHistorySuccess extends HistoryDiagnosisState {}

final class DiagonosisHistoryFailure extends HistoryDiagnosisState {
  final String message;
  DiagonosisHistoryFailure(this.message);
}