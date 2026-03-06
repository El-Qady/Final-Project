import 'dart:io';

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

final class DiangonosisHistoryLoading extends DiagnosisState {}

final class DiangonosisHistorySuccess extends DiagnosisState {}

final class DiagonosisHistoryFailure extends DiagnosisState {
  final String message;
  DiagonosisHistoryFailure(this.message);
}

final class DiagnosisDownloadLoading extends DiagnosisState {}

final class DiagnosisDownloadProgress extends DiagnosisState {
  final double progress;
  DiagnosisDownloadProgress(this.progress);
}

final class DiagnosisDownloadSuccess extends DiagnosisState {
  final File file;
  DiagnosisDownloadSuccess(this.file);
}

final class DiagnosisDownloadFailure extends DiagnosisState {
  final String message;
  DiagnosisDownloadFailure({required this.message});
}
